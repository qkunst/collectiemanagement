/** FormStore

The basic function of FormStore is to allow Forms to function, even when the
page serving it is offline. It stores FormData in good'ol localstorage (good
enough for this purpose), and tries to resubmit it when backonline. It knows
when it is online when it get's a valid 200 OK response from /heartbeat.

When going online, it only removes the stored from from the local storage when
the form submit was successful.

FormStore can be initialized by running: FormStore.init(), and it will make add
offline fallbacks to all forms.

Rails users: When resubmitting it will rewrite the Rails authenticity_token when
present.

*/

var FormStore = {
  translation: {
    pressAgainToTryAgain: 'druk nogmaals om (toch) te bevestigen',
    filesCannotBeStoredOffline: "Bestanden kunnen niet offline worden opgeslagen, de data wordt wel verwerkt.",
    validationErrorsOccurred: "Niet alle velden zijn juist ingevuld, controleer de invoer."
  },
  heartBeatSpacing: 1000,
  heartBeatLastSentAt: null,
  signInMatcher: /sign_in/,
  fireEvent: function(name, data) {
    var e = document.createEvent("Event");
    e.initEvent(name, true, true);
    e.data = data;
    window.dispatchEvent(e);
  },
  setBodyTagOnline: function() {
    var elem = document.getElementsByTagName("body")[0]
    elem.classList.remove("offline");
    elem.classList.add("online");
  },
  setBodyTagOffline: function() {
    var elem = document.getElementsByTagName("body")[0]
    elem.classList.remove("online");
    elem.classList.add("offline");
  },
  checkOnlineState: function() {
    if (!FormStore.heartBeatLastSentAt || ((Date.now() - FormStore.heartBeatLastSentAt) > FormStore.heartBeatSpacing) ) {
      FormStore.heartBeatLastSentAt = Date.now();
      if (window.navigator.onLine) {
        if (FormStore.online !== true) {
          FormStore.fireEvent("connectionBackOnline");
        }
        FormStore.setBodyTagOnline();
        FormStore.online = true;
      } else {
        if (FormStore.online !== false) {
          FormStore.fireEvent("connectionWentOffline");
        }

        FormStore.setBodyTagOffline();

        FormStore.online = false;
      }
      setTimeout(function() {
        FormStore.checkOnlineState();
      }, 10000);
    }
  },
  online: null,

  Store: {
    name: "FormStore",
    forEach: function(callback) {
      var keys = Object.keys(localStorage);
      keys.forEach(function(key){
        if (key.search(FormStore.Store.name) === 0 && key.search("lastStoreIndex") === -1) {
          callback(key.replace("FormStore",""))
        }
      })
    },
    first: function() {
      var f = null;
      FormStore.Store.forEach(function(a){
        if (f === null ) f = a;
      });
      return f;
    },
    resetLastStoreIndex: function() {
      return localStorage.removeItem(FormStore.Store.name+"lastStoreIndex");
    },
    lastStoreIndex: function() {
      return FormStore.Store.read("lastStoreIndex") ? FormStore.Store.read("lastStoreIndex") : 0;
    },
    increaseLastStoreIndex: function() {
      currentIndex = FormStore.Store.lastStoreIndex();
      FormStore.Store.store("lastStoreIndex", currentIndex+1, {skipIncrease: true});
    },
    flushAll: function() {
      FormStore.Store.forEach(function(k){
        localStorage.removeItem(FormStore.Store.generateInternalKey(k));
      });
    },
    count_by_key_start: function(keystart) {
      var count = 0
      FormStore.Store.forEach(function(a) {
        if (a.match(new RegExp("^"+keystart))) {
          count++
        }
      });
      return count;
    },
    count: function() {
      var count = 0
      FormStore.Store.forEach(function() {
        count++
      });
      return count;
    },
    markPrivate: function(key) {
      data = FormStore.Store.read(key);
      FormStore.Store.store(key,data,{"prefix":"private"});
      private_data = FormStore.Store.read(key,{"prefix":"private"});
      equaldata = JSON.stringify(data.data)===JSON.stringify(private_data.data)

      if (equaldata) {
        FormStore.Store.remove(key);
      }
    },
    markPublic: function(key) {
      private_data = FormStore.Store.read(key,{"prefix":"private"}); //read private variant
      if (private_data) {

        FormStore.Store.store(key,private_data); //store it public

        new_public_data = FormStore.Store.read(key);

        equaldata = JSON.stringify(new_public_data.data)===JSON.stringify(private_data.data)
        if (equaldata) {
          FormStore.Store.remove(key,{"prefix":"private"});
        }
      }
    },
    generateInternalKey: function(name, options) {
      int_key = FormStore.Store.name+name;
      if (options && typeof options['prefix'] === 'string') {
        int_key = options['prefix'] + int_key;
      }
      return int_key;
    },
    remove: function(key, options) {
      int_key = FormStore.Store.generateInternalKey(key, options);
      jsonifiedValueStore = localStorage.getItem(int_key);
      return localStorage.removeItem(int_key);
    },
    store: function(key, value, options){
      skipIncrease = (options && options.skipIncrease) ? true : false;
      key = FormStore.Store.generateInternalKey(key, options);
      if (!skipIncrease) {
        FormStore.Store.increaseLastStoreIndex();
      }
      var valueStore = {
        createdAt: Date(),
        value: value
      };
      var jsonifiedValueStore = JSON.stringify(valueStore);
      return localStorage.setItem(key, jsonifiedValueStore);
    },
    read: function(key,options){
      int_key = FormStore.Store.generateInternalKey(key, options);
      jsonifiedValueStore = localStorage.getItem(int_key);
      if (jsonifiedValueStore) {
        valueStore = JSON.parse(jsonifiedValueStore);
        return valueStore.value;
      } else {
        valueStore = JSON.parse(localStorage.getItem(key));
        return (valueStore ? valueStore.value : null);
      }

    }
  },
  InstanceMethods: {
    toFormData: function() {
      var tmp = new FormData();
      for (elem_key in this.data) {
        elem_data = this.data[elem_key]
        if (elem_key === "authenticity_token") {
          csrf_token = document.getElementsByName("csrf-token")[0].content
          elem_data = csrf_token ? csrf_token : elem_data
        }
        if (typeof elem_data === 'object' && elem_data.forEach && elem_data.length > 0) {
          elem_data.forEach(function(value){
            tmp.append(elem_key,value);
          });
        } else {
          tmp.append(elem_key,elem_data);
        }
      }
      return tmp;
    },
    submitForm: function(options) {
      options = options ? options : {}
      options.background = options.background ? true : false;
      options.reload = options.no_reload ? false : true;
      var formAction = this.action;
      var formMethod = this.method;

      FormStore.send(formAction, {
        method: formMethod,
        timeout: 10000,
        source: this,
        data: this.toFormData(),
        redirectOnSuccess: options.reload,
        background: options.background,
        forceCheck: options.forceCheck,
        onSuccess: function(source) {
          if (options["storeKey"]) {
            FormStore.Store.remove(options["storeKey"]);
            FormStore.Store.remove(options["storeKey"],{"prefix":"private"});
          }
          if (options['onSuccess']) options['onSuccess']();
        },
        onFail: function(source){
          if (!options["storeKey"]) {
            // Submit unsuccesful, formdata wasn't in store, adding to store.
            source.storeForm();
            if (options["reload"]) document.location = formAction;
          }
          if (options['onFail']) options['onFail']();
        }
      });
    },
    storeForm: function() {
      var rest_method = this.data["_method"] ? this.data["_method"] : "new"
      var key = ""+this.url+"#"+rest_method+"@"+FormStore.Store.lastStoreIndex();
      // console.log("Storing form under "+key);
      return FormStore.Store.store(key,this);
    },

  },
  Form: {
    parseForm: function(form) {
      var oData = new FormData(form);
      var oDataParsed = {};
      var has_files = false
      for (elem_key in form.elements) {
        elem_i = parseInt(elem_key);
        if ((typeof elem_i === 'number') && elem_i != NaN ) {
          var element = form.elements[elem_key];
          if (element.type === "checkbox" || element.type === "radio") {
            if (element.checked) {
              oDataParsed[element.name] = element.value;
            }
          } else if (element.multiple) {
            selected = Array.prototype.filter.apply(
              element.options, [
                function(o) {
                  return o.selected;
                }
              ]
            );
            oDataParsed[element.name] = selected.map(function(a){return a.value});;
          } else if (element.type === 'file') {
            if (element.value) {
              has_files = true
              // TODO: store it as Base64? Not sure whether this is feasible due to size limits of local store (5MB)
              // var file_data;
              // reader.onload = (function(aImg) { return function(e) { aImg.src = e.target.result; }; })(img);
            }
          } else {
            oDataParsed[element.name] = element.value;
          }
        }
      }
      return (FormStore.DataContainer({
        url: form.baseURI,
        action: form.getAttribute("action"),
        method: form.getAttribute("method"),
        data: oDataParsed,
        has_files: has_files
      }));
    },
    parseStoredForm: function(untaggedObj) {
      return (FormStore.DataContainer(untaggedObj));
    }
  },


  DataContainer: function(options){
    this.method = options['method'];
    this.action = options['action'];
    this.url = options['url'];
    this.data = options['data'];
    this.has_files = options['has_files'];
    this.submitForm = FormStore.InstanceMethods.submitForm;
    this.toFormData = FormStore.InstanceMethods.toFormData;
    this.storeForm = FormStore.InstanceMethods.storeForm;
    return this;
  },

  send: function(loc, options) {
    options = options ? options : {}
    var source = options.source;
    var timeout = options.timeout ? options.timeout : 30000;
    var method = options.method ? options.method : "GET";
    var onFail = options.onFail;
    var onSuccess = options.onSuccess;
    var data = options.data;
    var redirectOnSuccess = options.redirectOnSuccess;
    var background = options.background;
    var forceCheck = options.forceCheck ? true : false

    if (FormStore.online || forceCheck) {
      var oReq = new XMLHttpRequest();
      var noResponseTimer = setTimeout(function() {
        oReq.abort();
        FormStore.fireEvent("connectionTimeout", {request: oReq, source: source});
        if (onFail) onFail(source);
        return;
      }, timeout);

      oReq.open(method, loc, true);
      oReq.onload = function(oEvent) {
        if (oReq.status === 200 && !FormStore.signInMatcher.exec(oReq.responseURL)) {
          clearTimeout(noResponseTimer);
          FormStore.fireEvent("connectionSuccess", {request: oReq, source: source});
          if (onSuccess) onSuccess(source);
          // fallback to loc is provided for browsers that do not support oReq.responseURL (looking at you IE11)
          if (redirectOnSuccess && !background) document.location = (oReq.responseURL || loc);
        } else {
          FormStore.fireEvent("connectionError", {request: oReq, source: source});
          if (onFail) onFail(source);
        }
      };
      oReq.send(data);
    } else {
      // Not attempting to send any data due to offline status of the app
      // (use forceCheck=true if you want to check), storing it to temp store");
      if (onFail) onFail(source);
    }

  },
  retryStoredForms: function() {
    key = FormStore.Store.first();
    if (key){
      storedform = FormStore.Store.read(key);
      FormStore.Store.markPrivate(key);
      storedform = FormStore.Form.parseStoredForm(storedform);
      storedform.submitForm({background:true, storeKey: key, forceCheck: true,
        onSuccess:function() {
          FormStore.retryStoredForms()
        },
        onFail: function() {
          console.log("markingpublic on fail")
          FormStore.Store.markPublic(key);
        }
      });
    }
  },
  addListeners: function() {
    document.addEventListener("ready", function(e) {
      FormStore.setBodyTagOnline();
    });
    // window.addEventListener("connectionError", function(e) {
    // });
    // window.addEventListener("connectionSuccess", function(e) {
    // });
    // window.addEventListener("connectionTimeout", function(e) {
    // });
    window.addEventListener("connectionWentOffline", function(e) {
      console.log("triggered: connectionWentOffline");
      FormStore.setBodyTagOffline();
    });
    window.addEventListener("connectionBackOnline", function(e) {
      FormStore.setBodyTagOnline();
      FormStore.retryStoredForms();
    });


  },
  init: function() {
    if (navigator.userAgent.search(/Trident/) > 0 && navigator.userAgent.search(/rv:11/) > 0) {
      // no support for IE 11
      return false;
    }

    FormStore.checkOnlineState();

    for (var i=0; i<document.forms.length; i++){
      var form = document.forms[i];
      for (var j=0; j<form.elements.length; j++){
        var element = form.elements[j];
        element.addEventListener('blur', function(e) {
          e.target.classList.add("blurred");
        })
      }

      var backgroundFormSubmit = function(e) {
        var target = e.target
        var continue_submit = true;
        if (target.dataset.skipConfirm !== "true" || target.dataset.skipConfirm !== true) {
           continue_submit = confirm(target.dataset.confirm);
        }
        e.preventDefault();
        if (continue_submit || target.dataset.skipConfirm === "true" || target.dataset.skipConfirm === true) {
          f = FormStore.Form.parseForm(target.form);
          f.submitForm({no_reload:true});
          document.location = (""+document.location).split("#")[0] + "#new_work"
        } else {
          old_value = target.value;
          target.dataset.skipConfirm = true;
          target.value = old_value + " ("+FormStore.translation.pressAgainToTryAgain+")"
          setTimeout(function(){
            target.value = old_value;
            target.dataset.skipConfirm = false;
          }, 3000)
        }
        return false;
      }

      $(form).find('[type=submit].no-reload').on("click keydown",backgroundFormSubmit);

      if (form && form.dataset && typeof form.dataset.offline !== 'undefined') {
        form.addEventListener("submit", function(e){
          e.preventDefault();
          if (e.target.checkValidity()) {
            f = FormStore.Form.parseForm(e.target);
            if (f.has_files && FormStore.online) {
              e.target.submit();
            } else if (f.has_files && !FormStore.online) {
              alert(FormStore.translation.filesCannotBeStoredOffline)
              f.submitForm();
            } else {
              f.submitForm();
            }
          } else {
            alert(FormStore.translation.validationErrorsOccurred)
          }
          return false;
        });
      }
    }
    FormStore.addListeners();

  }
};
