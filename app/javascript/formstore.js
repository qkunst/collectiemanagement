/** FormStore

The basic function of FormStore is to allow Forms to function, even when the
page serving it is offline. It stores FormData in good'ol localstorage (good
enough for this purpose), and tries to resubmit it when backonline.
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
  signInMatcher: /sign_in/,
  fireEvent: function(name, data) {
    var e = document.createEvent("Event");
    e.initEvent(name, true, true);
    e.data = data;
    window.dispatchEvent(e);
  },
  bodyElem: function() {
    return document.getElementsByTagName("body")[0];
  },
  setBodyTagOnline: function() {
    var classList = FormStore.bodyElem().classList;
    classList.remove("offline");
    classList.add("online");
  },
  setBodyTagOffline: function() {
    var classList = FormStore.bodyElem().classList;
    classList.remove("online");
    classList.add("offline");
  },
  checkOnlineStateTimer: null,
  checkOnlineState: function() {
    if (window.navigator.onLine) {
      if (!FormStore.online) {
        FormStore.fireEvent("connectionBackOnline");
      }
      FormStore.online = true;
    } else {
      if (FormStore.online !== false) {
        FormStore.fireEvent("connectionWentOffline");
      }
      FormStore.online = false;
    }
    if (!FormStore.checkOnlineStateTimer) {
      FormStore.checkOnlineStateTimer = setTimeout(function() {
        FormStore.checkOnlineStateTimer = null;
        FormStore.checkOnlineState();
      }, FormStore.heartBeatSpacing);
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
      const currentIndex = FormStore.Store.lastStoreIndex();
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
      const data = FormStore.Store.read(key);
      FormStore.Store.store(key,data,{"prefix":"private"});

      const private_data = FormStore.Store.read(key,{"prefix":"private"});

      const equaldata = JSON.stringify(data.data) === JSON.stringify(private_data.data)

      if (equaldata) {
        FormStore.Store.remove(key);
      }
    },
    markPublic: function(key) {
      const private_data = FormStore.Store.read(key,{"prefix":"private"}); //read private variant
      if (private_data) {

        FormStore.Store.store(key,private_data); //store it public

        const new_public_data = FormStore.Store.read(key);

        const equaldata = JSON.stringify(new_public_data.data) === JSON.stringify(private_data.data)
        if (equaldata) {
          FormStore.Store.remove(key,{"prefix":"private"});
        }
      }
    },
    generateInternalKey: function(name, options) {
      let int_key = FormStore.Store.name+name;
      if (options && typeof options['prefix'] === 'string') {
        int_key = options['prefix'] + int_key;
      }
      return int_key;
    },
    remove: function(key, options) {
      const int_key = FormStore.Store.generateInternalKey(key, options);
      localStorage.getItem(int_key);
      return localStorage.removeItem(int_key);
    },
    store: function(key, value, options){
      const skipIncrease = (options && options.skipIncrease) ? true : false;
      const int_key = FormStore.Store.generateInternalKey(key, options);

      if (!skipIncrease) {
        FormStore.Store.increaseLastStoreIndex();
      }

      var valueStore = {
        createdAt: Date(),
        value: value
      };

      var jsonifiedValueStore = JSON.stringify(valueStore);

      return localStorage.setItem(int_key, jsonifiedValueStore);
    },
    read: function(key,options){
      const int_key = FormStore.Store.generateInternalKey(key, options);
      const jsonifiedValueStore = localStorage.getItem(int_key);
      if (jsonifiedValueStore) {
        return JSON.parse(jsonifiedValueStore).value;
      } else {
        const valueStore = JSON.parse(localStorage.getItem(key));
        return (valueStore ? valueStore.value : null);
      }
    }
  },
  InstanceMethods: {
    toFormData: function() {
      var tmp = new FormData();
      for (let elem_key in this.data) {
        let elem_data = this.data[elem_key]
        if (elem_key === "authenticity_token") {
          const csrf_token = document.getElementsByName("csrf-token")[0].content
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
      return FormStore.Store.store(key,this);
    },

  },
  Form: {
    parseForm: function(form) {
      var oData = new FormData(form);
      var oDataParsed = {};
      var has_files = false
      for (let elem_key in form.elements) {
        const elem_i = parseInt(elem_key);
        if ((typeof elem_i === 'number') && !Number.isNaN(elem_i)  ) {
          var element = form.elements[elem_key];
          if (element.type === "checkbox" || element.type === "radio") {
            if (element.checked) {
              oDataParsed[element.name] = element.value;
            }
          } else if (element.multiple) {
            oDataParsed[element.name] = Array.prototype.filter.apply(
              element.options, [
                function(o) {
                  return o.selected;
                }
              ]
            ).map(function(a){return a.value});
          } else if (element.type === 'file') {
            if (element.value) {
              has_files = true;
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
  BackgroundSubmit: {
    submitHandler: function(e) {
      if (e.target.type == 'submit' && e.target.classList.contains("no-reload") && (e.type == 'click' || e.type == 'touchend' || e.key == 'Enter')) {
        var target = e.target
        e.preventDefault();
        const f = FormStore.Form.parseForm(target.form);
        f.submitForm({no_reload:true});
        document.location = (""+document.location).split("#")[0] + "#new_work"
        return false;
      }
    },
    init: function() {
      document.addEventListener('click', FormStore.BackgroundSubmit.submitHandler);
      document.addEventListener('keydown', FormStore.BackgroundSubmit.submitHandler);
      document.addEventListener('touchend', FormStore.BackgroundSubmit.submitHandler);
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
    const key = FormStore.Store.first();
    if (key){
      let storedform = FormStore.Store.read(key);
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
  EventHandlers: {
    connectionOfflineHandler: function(e) {
      console.log("triggered: connectionWentOffline");
      FormStore.setBodyTagOffline();
    },
    connectionOnlineHandler: function(e) {
      console.log("triggered: connectionBackOnline");
      FormStore.setBodyTagOnline();
      FormStore.retryStoredForms();
    },
    offlineFormSubmitHandler: function(e) {
      const form = e.target;
      if (!form.dataset.offline) return true;

      e.preventDefault();
      if (!e.target.checkValidity()) {
        alert(FormStore.translation.validationErrorsOccurred)
        return false;
      }

      const f = FormStore.Form.parseForm(form);
      if (FormStore.online) {
        form.submit();
      } else {
        if (f.has_files) alert(FormStore.translation.filesCannotBeStoredOffline);
        f.submitForm();
      }
      return false;
    }
  },
  addListeners: function() {
    window.addEventListener("connectionWentOffline", FormStore.EventHandlers.connectionOfflineHandler );
    window.addEventListener("connectionBackOnline", FormStore.EventHandlers.connectionOnlineHandler );
    document.addEventListener("submit", FormStore.EventHandlers.offlineFormSubmitHandler);
  },
  supportedBrowser: function() {
    return !(navigator.userAgent.search(/Trident/) > 0 && navigator.userAgent.search(/rv:11/) > 0)
  },

  init: function() {
    if (!FormStore.supportedBrowser()) {
      return false;
    }
    FormStore.addListeners();
    FormStore.checkOnlineState();
    FormStore.BackgroundSubmit.init();
  }
};
export default FormStore;