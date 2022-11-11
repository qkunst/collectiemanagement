var ZXing = (function() {
  var _scriptDir = typeof document !== 'undefined' && document.currentScript ? document.currentScript.src : undefined;
  if (typeof __filename !== 'undefined') _scriptDir = _scriptDir || __filename;
  var _scriptDir = '/';
  return (
    function(ZXing) {
      ZXing = ZXing || {};

      var Module = typeof ZXing !== "undefined" ? ZXing : {};
      var moduleOverrides = {};
      var key;
      for (key in Module) {
        if (Module.hasOwnProperty(key)) {
          moduleOverrides[key] = Module[key]
        }
      }
      var arguments_ = [];
      var thisProgram = "./this.program";
      var quit_ = function(status, toThrow) {
        throw toThrow
      };
      var ENVIRONMENT_IS_WEB = false;
      var ENVIRONMENT_IS_WORKER = false;
      var ENVIRONMENT_IS_NODE = false;
      var ENVIRONMENT_IS_SHELL = false;
      ENVIRONMENT_IS_WEB = true //typeof window === "object";
      var scriptDirectory = "";

      function locateFile(path) {
        if (Module["locateFile"]) {
          return Module["locateFile"](path, scriptDirectory)
        }
        return scriptDirectory + path
      }
      var read_, readAsync, readBinary, setWindowTitle;
      var nodeFS;
      var nodePath;
      if (ENVIRONMENT_IS_WORKER) {
        scriptDirectory = self.location.href
      } else if (document.currentScript) {
        scriptDirectory = document.currentScript.src
      }
      if (_scriptDir) {
        scriptDirectory = _scriptDir
      }
      if (scriptDirectory.indexOf("blob:") !== 0) {
        scriptDirectory = scriptDirectory.substr(0, scriptDirectory.lastIndexOf("/") + 1)
      } else {
        scriptDirectory = ""
      } {
        read_ = function shell_read(url) {
          var xhr = new XMLHttpRequest;
          xhr.open("GET", url, false);
          xhr.send(null);
          return xhr.responseText
        };
        if (ENVIRONMENT_IS_WORKER) {
          readBinary = function readBinary(url) {
            var xhr = new XMLHttpRequest;
            xhr.open("GET", url, false);
            xhr.responseType = "arraybuffer";
            xhr.send(null);
            return new Uint8Array(xhr.response)
          }
        }
        readAsync = function readAsync(url, onload, onerror) {
          var xhr = new XMLHttpRequest;
          xhr.open("GET", url, true);
          xhr.responseType = "arraybuffer";
          xhr.onload = function xhr_onload() {
            if (xhr.status == 200 || xhr.status == 0 && xhr.response) {
              onload(xhr.response);
              return
            }
            onerror()
          };
          xhr.onerror = onerror;
          xhr.send(null)
        }
      }
      setWindowTitle = function(title) {
        document.title = title
      }
      var out = Module["print"] || console.log.bind(console);
      var err = Module["printErr"] || console.warn.bind(console);
      for (key in moduleOverrides) {
        if (moduleOverrides.hasOwnProperty(key)) {
          Module[key] = moduleOverrides[key]
        }
      }
      moduleOverrides = null;
      if (Module["arguments"]) arguments_ = Module["arguments"];
      if (Module["thisProgram"]) thisProgram = Module["thisProgram"];
      if (Module["quit"]) quit_ = Module["quit"];
      var asm2wasmImports = {
        "f64-rem": function(x, y) {
          return x % y
        },
        "debugger": function() {}
      };
      var functionPointers = new Array(0);
      var tempRet0 = 0;
      var setTempRet0 = function(value) {
        tempRet0 = value
      };
      var getTempRet0 = function() {
        return tempRet0
      };
      var wasmBinary;
      if (Module["wasmBinary"]) wasmBinary = Module["wasmBinary"];
      var noExitRuntime;
      if (Module["noExitRuntime"]) noExitRuntime = Module["noExitRuntime"];
      if (typeof WebAssembly !== "object") {
        err("no native wasm support detected")
      }
      var wasmMemory;
      var wasmTable = new WebAssembly.Table({
        "initial": 1736,
        "maximum": 1736,
        "element": "anyfunc"
      });
      var ABORT = false;
      var EXITSTATUS = 0;

      function assert(condition, text) {
        if (!condition) {
          abort("Assertion failed: " + text)
        }
      }
      var UTF8Decoder = typeof TextDecoder !== "undefined" ? new TextDecoder("utf8") : undefined;

      function UTF8ArrayToString(heap, idx, maxBytesToRead) {
        var endIdx = idx + maxBytesToRead;
        var endPtr = idx;
        while (heap[endPtr] && !(endPtr >= endIdx)) ++endPtr;
        if (endPtr - idx > 16 && heap.subarray && UTF8Decoder) {
          return UTF8Decoder.decode(heap.subarray(idx, endPtr))
        } else {
          var str = "";
          while (idx < endPtr) {
            var u0 = heap[idx++];
            if (!(u0 & 128)) {
              str += String.fromCharCode(u0);
              continue
            }
            var u1 = heap[idx++] & 63;
            if ((u0 & 224) == 192) {
              str += String.fromCharCode((u0 & 31) << 6 | u1);
              continue
            }
            var u2 = heap[idx++] & 63;
            if ((u0 & 240) == 224) {
              u0 = (u0 & 15) << 12 | u1 << 6 | u2
            } else {
              u0 = (u0 & 7) << 18 | u1 << 12 | u2 << 6 | heap[idx++] & 63
            }
            if (u0 < 65536) {
              str += String.fromCharCode(u0)
            } else {
              var ch = u0 - 65536;
              str += String.fromCharCode(55296 | ch >> 10, 56320 | ch & 1023)
            }
          }
        }
        return str
      }

      function UTF8ToString(ptr, maxBytesToRead) {
        return ptr ? UTF8ArrayToString(HEAPU8, ptr, maxBytesToRead) : ""
      }

      function stringToUTF8Array(str, heap, outIdx, maxBytesToWrite) {
        if (!(maxBytesToWrite > 0)) return 0;
        var startIdx = outIdx;
        var endIdx = outIdx + maxBytesToWrite - 1;
        for (var i = 0; i < str.length; ++i) {
          var u = str.charCodeAt(i);
          if (u >= 55296 && u <= 57343) {
            var u1 = str.charCodeAt(++i);
            u = 65536 + ((u & 1023) << 10) | u1 & 1023
          }
          if (u <= 127) {
            if (outIdx >= endIdx) break;
            heap[outIdx++] = u
          } else if (u <= 2047) {
            if (outIdx + 1 >= endIdx) break;
            heap[outIdx++] = 192 | u >> 6;
            heap[outIdx++] = 128 | u & 63
          } else if (u <= 65535) {
            if (outIdx + 2 >= endIdx) break;
            heap[outIdx++] = 224 | u >> 12;
            heap[outIdx++] = 128 | u >> 6 & 63;
            heap[outIdx++] = 128 | u & 63
          } else {
            if (outIdx + 3 >= endIdx) break;
            heap[outIdx++] = 240 | u >> 18;
            heap[outIdx++] = 128 | u >> 12 & 63;
            heap[outIdx++] = 128 | u >> 6 & 63;
            heap[outIdx++] = 128 | u & 63
          }
        }
        heap[outIdx] = 0;
        return outIdx - startIdx
      }

      function stringToUTF8(str, outPtr, maxBytesToWrite) {
        return stringToUTF8Array(str, HEAPU8, outPtr, maxBytesToWrite)
      }

      function lengthBytesUTF8(str) {
        var len = 0;
        for (var i = 0; i < str.length; ++i) {
          var u = str.charCodeAt(i);
          if (u >= 55296 && u <= 57343) u = 65536 + ((u & 1023) << 10) | str.charCodeAt(++i) & 1023;
          if (u <= 127) ++len;
          else if (u <= 2047) len += 2;
          else if (u <= 65535) len += 3;
          else len += 4
        }
        return len
      }
      var UTF16Decoder = typeof TextDecoder !== "undefined" ? new TextDecoder("utf-16le") : undefined;

      function UTF16ToString(ptr) {
        var endPtr = ptr;
        var idx = endPtr >> 1;
        while (HEAP16[idx]) ++idx;
        endPtr = idx << 1;
        if (endPtr - ptr > 32 && UTF16Decoder) {
          return UTF16Decoder.decode(HEAPU8.subarray(ptr, endPtr))
        } else {
          var i = 0;
          var str = "";
          while (1) {
            var codeUnit = HEAP16[ptr + i * 2 >> 1];
            if (codeUnit == 0) return str;
            ++i;
            str += String.fromCharCode(codeUnit)
          }
        }
      }

      function stringToUTF16(str, outPtr, maxBytesToWrite) {
        if (maxBytesToWrite === undefined) {
          maxBytesToWrite = 2147483647
        }
        if (maxBytesToWrite < 2) return 0;
        maxBytesToWrite -= 2;
        var startPtr = outPtr;
        var numCharsToWrite = maxBytesToWrite < str.length * 2 ? maxBytesToWrite / 2 : str.length;
        for (var i = 0; i < numCharsToWrite; ++i) {
          var codeUnit = str.charCodeAt(i);
          HEAP16[outPtr >> 1] = codeUnit;
          outPtr += 2
        }
        HEAP16[outPtr >> 1] = 0;
        return outPtr - startPtr
      }

      function lengthBytesUTF16(str) {
        return str.length * 2
      }

      function UTF32ToString(ptr) {
        var i = 0;
        var str = "";
        while (1) {
          var utf32 = HEAP32[ptr + i * 4 >> 2];
          if (utf32 == 0) return str;
          ++i;
          if (utf32 >= 65536) {
            var ch = utf32 - 65536;
            str += String.fromCharCode(55296 | ch >> 10, 56320 | ch & 1023)
          } else {
            str += String.fromCharCode(utf32)
          }
        }
      }

      function stringToUTF32(str, outPtr, maxBytesToWrite) {
        if (maxBytesToWrite === undefined) {
          maxBytesToWrite = 2147483647
        }
        if (maxBytesToWrite < 4) return 0;
        var startPtr = outPtr;
        var endPtr = startPtr + maxBytesToWrite - 4;
        for (var i = 0; i < str.length; ++i) {
          var codeUnit = str.charCodeAt(i);
          if (codeUnit >= 55296 && codeUnit <= 57343) {
            var trailSurrogate = str.charCodeAt(++i);
            codeUnit = 65536 + ((codeUnit & 1023) << 10) | trailSurrogate & 1023
          }
          HEAP32[outPtr >> 2] = codeUnit;
          outPtr += 4;
          if (outPtr + 4 > endPtr) break
        }
        HEAP32[outPtr >> 2] = 0;
        return outPtr - startPtr
      }

      function lengthBytesUTF32(str) {
        var len = 0;
        for (var i = 0; i < str.length; ++i) {
          var codeUnit = str.charCodeAt(i);
          if (codeUnit >= 55296 && codeUnit <= 57343) ++i;
          len += 4
        }
        return len
      }

      function allocateUTF8(str) {
        var size = lengthBytesUTF8(str) + 1;
        var ret = _malloc(size);
        if (ret) stringToUTF8Array(str, HEAP8, ret, size);
        return ret
      }

      function writeArrayToMemory(array, buffer) {
        HEAP8.set(array, buffer)
      }
      var WASM_PAGE_SIZE = 65536;
      var buffer, HEAP8, HEAPU8, HEAP16, HEAPU16, HEAP32, HEAPU32, HEAPF32, HEAPF64;

      function updateGlobalBufferAndViews(buf) {
        buffer = buf;
        Module["HEAP8"] = HEAP8 = new Int8Array(buf);
        Module["HEAP16"] = HEAP16 = new Int16Array(buf);
        Module["HEAP32"] = HEAP32 = new Int32Array(buf);
        Module["HEAPU8"] = HEAPU8 = new Uint8Array(buf);
        Module["HEAPU16"] = HEAPU16 = new Uint16Array(buf);
        Module["HEAPU32"] = HEAPU32 = new Uint32Array(buf);
        Module["HEAPF32"] = HEAPF32 = new Float32Array(buf);
        Module["HEAPF64"] = HEAPF64 = new Float64Array(buf)
      }
      var DYNAMIC_BASE = 5837376,
        DYNAMICTOP_PTR = 594288;
      var INITIAL_INITIAL_MEMORY = Module["INITIAL_MEMORY"] || 134217728;
      if (Module["wasmMemory"]) {
        wasmMemory = Module["wasmMemory"]
      } else {
        wasmMemory = new WebAssembly.Memory({
          "initial": INITIAL_INITIAL_MEMORY / WASM_PAGE_SIZE,
          "maximum": INITIAL_INITIAL_MEMORY / WASM_PAGE_SIZE
        })
      }
      if (wasmMemory) {
        buffer = wasmMemory.buffer
      }
      INITIAL_INITIAL_MEMORY = buffer.byteLength;
      updateGlobalBufferAndViews(buffer);
      HEAP32[DYNAMICTOP_PTR >> 2] = DYNAMIC_BASE;

      function callRuntimeCallbacks(callbacks) {
        while (callbacks.length > 0) {
          var callback = callbacks.shift();
          if (typeof callback == "function") {
            callback(Module);
            continue
          }
          var func = callback.func;
          if (typeof func === "number") {
            if (callback.arg === undefined) {
              Module["dynCall_v"](func)
            } else {
              Module["dynCall_vi"](func, callback.arg)
            }
          } else {
            func(callback.arg === undefined ? null : callback.arg)
          }
        }
      }
      var __ATPRERUN__ = [];
      var __ATINIT__ = [];
      var __ATMAIN__ = [];
      var __ATPOSTRUN__ = [];
      var runtimeInitialized = false;

      function preRun() {
        if (Module["preRun"]) {
          if (typeof Module["preRun"] == "function") Module["preRun"] = [Module["preRun"]];
          while (Module["preRun"].length) {
            addOnPreRun(Module["preRun"].shift())
          }
        }
        callRuntimeCallbacks(__ATPRERUN__)
      }

      function initRuntime() {
        runtimeInitialized = true;
        callRuntimeCallbacks(__ATINIT__)
      }

      function preMain() {
        callRuntimeCallbacks(__ATMAIN__)
      }

      function postRun() {
        if (Module["postRun"]) {
          if (typeof Module["postRun"] == "function") Module["postRun"] = [Module["postRun"]];
          while (Module["postRun"].length) {
            addOnPostRun(Module["postRun"].shift())
          }
        }
        callRuntimeCallbacks(__ATPOSTRUN__)
      }

      function addOnPreRun(cb) {
        __ATPRERUN__.unshift(cb)
      }

      function addOnPostRun(cb) {
        __ATPOSTRUN__.unshift(cb)
      }
      var runDependencies = 0;
      var runDependencyWatcher = null;
      var dependenciesFulfilled = null;

      function addRunDependency(id) {
        runDependencies++;
        if (Module["monitorRunDependencies"]) {
          Module["monitorRunDependencies"](runDependencies)
        }
      }

      function removeRunDependency(id) {
        runDependencies--;
        if (Module["monitorRunDependencies"]) {
          Module["monitorRunDependencies"](runDependencies)
        }
        if (runDependencies == 0) {
          if (runDependencyWatcher !== null) {
            clearInterval(runDependencyWatcher);
            runDependencyWatcher = null
          }
          if (dependenciesFulfilled) {
            var callback = dependenciesFulfilled;
            dependenciesFulfilled = null;
            callback()
          }
        }
      }
      Module["preloadedImages"] = {};
      Module["preloadedAudios"] = {};

      function abort(what) {
        if (Module["onAbort"]) {
          Module["onAbort"](what)
        }
        what += "";
        out(what);
        err(what);
        ABORT = true;
        EXITSTATUS = 1;
        what = "abort(" + what + "). Build with -s ASSERTIONS=1 for more info.";
        throw new WebAssembly.RuntimeError(what)
      }
      var dataURIPrefix = "data:application/octet-stream;base64,";

      function isDataURI(filename) {
        return String.prototype.startsWith ? filename.startsWith(dataURIPrefix) : filename.indexOf(dataURIPrefix) === 0
      }
      var wasmBinaryFile = "zxing.wasm";
      if (!isDataURI(wasmBinaryFile)) {
        wasmBinaryFile = locateFile(wasmBinaryFile)
      }

      function getBinary() {
        try {
          if (wasmBinary) {
            return new Uint8Array(wasmBinary)
          }
          if (readBinary) {
            return readBinary(wasmBinaryFile)
          } else {
            throw "both async and sync fetching of the wasm failed"
          }
        } catch (err) {
          abort(err)
        }
      }

      function getBinaryPromise() {
        if (!wasmBinary && (ENVIRONMENT_IS_WEB || ENVIRONMENT_IS_WORKER) && typeof fetch === "function") {
          return fetch(wasmBinaryFile, {
            credentials: "same-origin"
          }).then(function(response) {
            if (!response["ok"]) {
              throw "failed to load wasm binary file at '" + wasmBinaryFile + "'"
            }
            return response["arrayBuffer"]()
          }).catch(function() {
            return getBinary()
          })
        }
        return new Promise(function(resolve, reject) {
          resolve(getBinary())
        })
      }

      function createWasm() {
        var info = {
          "env": asmLibraryArg,
          "wasi_snapshot_preview1": asmLibraryArg,
          "global": {
            "NaN": NaN,
            Infinity: Infinity
          },
          "global.Math": Math,
          "asm2wasm": asm2wasmImports
        };

        function receiveInstance(instance, module) {
          var exports = instance.exports;
          Module["asm"] = exports;
          removeRunDependency("wasm-instantiate")
        }
        addRunDependency("wasm-instantiate");

        function receiveInstantiatedSource(output) {
          receiveInstance(output["instance"])
        }

        function instantiateArrayBuffer(receiver) {
          return getBinaryPromise().then(function(binary) {
            return WebAssembly.instantiate(binary, info)
          }).then(receiver, function(reason) {
            err("failed to asynchronously prepare wasm: " + reason);
            abort(reason)
          })
        }

        function instantiateAsync() {
          if (!wasmBinary && typeof WebAssembly.instantiateStreaming === "function" && !isDataURI(wasmBinaryFile) && typeof fetch === "function") {
            fetch(wasmBinaryFile, {
              credentials: "same-origin"
            }).then(function(response) {
              var result = WebAssembly.instantiateStreaming(response, info);
              return result.then(receiveInstantiatedSource, function(reason) {
                err("wasm streaming compile failed: " + reason);
                err("falling back to ArrayBuffer instantiation");
                instantiateArrayBuffer(receiveInstantiatedSource)
              })
            })
          } else {
            return instantiateArrayBuffer(receiveInstantiatedSource)
          }
        }
        if (Module["instantiateWasm"]) {
          try {
            var exports = Module["instantiateWasm"](info, receiveInstance);
            return exports
          } catch (e) {
            err("Module.instantiateWasm callback failed with error: " + e);
            return false
          }
        }
        instantiateAsync();
        return {}
      }
      Module["asm"] = createWasm;
      __ATINIT__.push({
        func: function() {
          __GLOBAL__sub_I_BarcodeReader_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_BarcodeWriter_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_CharacterSetECI_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_ODRSSExpandedReader_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_AZHighLevelEncoder_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_DMECEncoder_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_DMHighLevelEncoder_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_ODCode128Patterns_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_PDFDetector_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_GridSampler_cpp()
        }
      }, {
        func: function() {
          __GLOBAL__sub_I_bind_cpp()
        }
      });

      function ___cxa_allocate_exception(size) {
        return _malloc(size)
      }
      var ___exception_infos = {};
      var ___exception_caught = [];

      function ___exception_addRef(ptr) {
        if (!ptr) return;
        var info = ___exception_infos[ptr];
        info.refcount++
      }

      function ___exception_deAdjust(adjusted) {
        if (!adjusted || ___exception_infos[adjusted]) return adjusted;
        for (var key in ___exception_infos) {
          var ptr = +key;
          var adj = ___exception_infos[ptr].adjusted;
          var len = adj.length;
          for (var i = 0; i < len; i++) {
            if (adj[i] === adjusted) {
              return ptr
            }
          }
        }
        return adjusted
      }

      function ___cxa_begin_catch(ptr) {
        var info = ___exception_infos[ptr];
        if (info && !info.caught) {
          info.caught = true;
          __ZSt18uncaught_exceptionv.uncaught_exceptions--
        }
        if (info) info.rethrown = false;
        ___exception_caught.push(ptr);
        ___exception_addRef(___exception_deAdjust(ptr));
        return ptr
      }
      var ___exception_last = 0;

      function ___cxa_free_exception(ptr) {
        try {
          return _free(ptr)
        } catch (e) {}
      }

      function ___exception_decRef(ptr) {
        if (!ptr) return;
        var info = ___exception_infos[ptr];
        info.refcount--;
        if (info.refcount === 0 && !info.rethrown) {
          if (info.destructor) {
            Module["dynCall_vi"](info.destructor, ptr)
          }
          delete ___exception_infos[ptr];
          ___cxa_free_exception(ptr)
        }
      }

      function ___cxa_end_catch() {
        _setThrew(0);
        var ptr = ___exception_caught.pop();
        if (ptr) {
          ___exception_decRef(___exception_deAdjust(ptr));
          ___exception_last = 0
        }
      }

      function ___cxa_find_matching_catch_2() {
        var thrown = ___exception_last;
        if (!thrown) {
          return (setTempRet0(0), 0) | 0
        }
        var info = ___exception_infos[thrown];
        var throwntype = info.type;
        if (!throwntype) {
          return (setTempRet0(0), thrown) | 0
        }
        var typeArray = Array.prototype.slice.call(arguments);
        var pointer = ___cxa_is_pointer_type(throwntype);
        var buffer = 594464;
        HEAP32[buffer >> 2] = thrown;
        thrown = buffer;
        for (var i = 0; i < typeArray.length; i++) {
          if (typeArray[i] && ___cxa_can_catch(typeArray[i], throwntype, thrown)) {
            thrown = HEAP32[thrown >> 2];
            info.adjusted.push(thrown);
            return (setTempRet0(typeArray[i]), thrown) | 0
          }
        }
        thrown = HEAP32[thrown >> 2];
        return (setTempRet0(throwntype), thrown) | 0
      }

      function ___cxa_find_matching_catch_3() {
        var thrown = ___exception_last;
        if (!thrown) {
          return (setTempRet0(0), 0) | 0
        }
        var info = ___exception_infos[thrown];
        var throwntype = info.type;
        if (!throwntype) {
          return (setTempRet0(0), thrown) | 0
        }
        var typeArray = Array.prototype.slice.call(arguments);
        var pointer = ___cxa_is_pointer_type(throwntype);
        var buffer = 594464;
        HEAP32[buffer >> 2] = thrown;
        thrown = buffer;
        for (var i = 0; i < typeArray.length; i++) {
          if (typeArray[i] && ___cxa_can_catch(typeArray[i], throwntype, thrown)) {
            thrown = HEAP32[thrown >> 2];
            info.adjusted.push(thrown);
            return (setTempRet0(typeArray[i]), thrown) | 0
          }
        }
        thrown = HEAP32[thrown >> 2];
        return (setTempRet0(throwntype), thrown) | 0
      }

      function ___cxa_find_matching_catch_4() {
        var thrown = ___exception_last;
        if (!thrown) {
          return (setTempRet0(0), 0) | 0
        }
        var info = ___exception_infos[thrown];
        var throwntype = info.type;
        if (!throwntype) {
          return (setTempRet0(0), thrown) | 0
        }
        var typeArray = Array.prototype.slice.call(arguments);
        var pointer = ___cxa_is_pointer_type(throwntype);
        var buffer = 594464;
        HEAP32[buffer >> 2] = thrown;
        thrown = buffer;
        for (var i = 0; i < typeArray.length; i++) {
          if (typeArray[i] && ___cxa_can_catch(typeArray[i], throwntype, thrown)) {
            thrown = HEAP32[thrown >> 2];
            info.adjusted.push(thrown);
            return (setTempRet0(typeArray[i]), thrown) | 0
          }
        }
        thrown = HEAP32[thrown >> 2];
        return (setTempRet0(throwntype), thrown) | 0
      }

      function ___cxa_rethrow() {
        var ptr = ___exception_caught.pop();
        ptr = ___exception_deAdjust(ptr);
        if (!___exception_infos[ptr].rethrown) {
          ___exception_caught.push(ptr);
          ___exception_infos[ptr].rethrown = true
        }
        ___exception_last = ptr;
        throw ptr
      }

      function ___cxa_throw(ptr, type, destructor) {
        ___exception_infos[ptr] = {
          ptr: ptr,
          adjusted: [ptr],
          type: type,
          destructor: destructor,
          refcount: 0,
          caught: false,
          rethrown: false
        };
        ___exception_last = ptr;
        if (!("uncaught_exception" in __ZSt18uncaught_exceptionv)) {
          __ZSt18uncaught_exceptionv.uncaught_exceptions = 1
        } else {
          __ZSt18uncaught_exceptionv.uncaught_exceptions++
        }
        throw ptr
      }

      function ___cxa_uncaught_exceptions() {
        return __ZSt18uncaught_exceptionv.uncaught_exceptions
      }

      function ___setErrNo(value) {
        if (Module["___errno_location"]) HEAP32[Module["___errno_location"]() >> 2] = value;
        return value
      }

      function ___map_file(pathname, size) {
        ___setErrNo(63);
        return -1
      }

      function ___resumeException(ptr) {
        if (!___exception_last) {
          ___exception_last = ptr
        }
        throw ptr
      }
      var PATH = {
        splitPath: function(filename) {
          var splitPathRe = /^(\/?|)([\s\S]*?)((?:\.{1,2}|[^\/]+?|)(\.[^.\/]*|))(?:[\/]*)$/;
          return splitPathRe.exec(filename).slice(1)
        },
        normalizeArray: function(parts, allowAboveRoot) {
          var up = 0;
          for (var i = parts.length - 1; i >= 0; i--) {
            var last = parts[i];
            if (last === ".") {
              parts.splice(i, 1)
            } else if (last === "..") {
              parts.splice(i, 1);
              up++
            } else if (up) {
              parts.splice(i, 1);
              up--
            }
          }
          if (allowAboveRoot) {
            for (; up; up--) {
              parts.unshift("..")
            }
          }
          return parts
        },
        normalize: function(path) {
          var isAbsolute = path.charAt(0) === "/",
            trailingSlash = path.substr(-1) === "/";
          path = PATH.normalizeArray(path.split("/").filter(function(p) {
            return !!p
          }), !isAbsolute).join("/");
          if (!path && !isAbsolute) {
            path = "."
          }
          if (path && trailingSlash) {
            path += "/"
          }
          return (isAbsolute ? "/" : "") + path
        },
        dirname: function(path) {
          var result = PATH.splitPath(path),
            root = result[0],
            dir = result[1];
          if (!root && !dir) {
            return "."
          }
          if (dir) {
            dir = dir.substr(0, dir.length - 1)
          }
          return root + dir
        },
        basename: function(path) {
          if (path === "/") return "/";
          var lastSlash = path.lastIndexOf("/");
          if (lastSlash === -1) return path;
          return path.substr(lastSlash + 1)
        },
        extname: function(path) {
          return PATH.splitPath(path)[3]
        },
        join: function() {
          var paths = Array.prototype.slice.call(arguments, 0);
          return PATH.normalize(paths.join("/"))
        },
        join2: function(l, r) {
          return PATH.normalize(l + "/" + r)
        }
      };
      var SYSCALLS = {
        mappings: {},
        buffers: [null, [],
          []
        ],
        printChar: function(stream, curr) {
          var buffer = SYSCALLS.buffers[stream];
          if (curr === 0 || curr === 10) {
            (stream === 1 ? out : err)(UTF8ArrayToString(buffer, 0));
            buffer.length = 0
          } else {
            buffer.push(curr)
          }
        },
        varargs: undefined,
        get: function() {
          SYSCALLS.varargs += 4;
          var ret = HEAP32[SYSCALLS.varargs - 4 >> 2];
          return ret
        },
        getStr: function(ptr) {
          var ret = UTF8ToString(ptr);
          return ret
        },
        get64: function(low, high) {
          return low
        }
      };

      function syscallMunmap(addr, len) {
        if ((addr | 0) === -1 || len === 0) {
          return -28
        }
        var info = SYSCALLS.mappings[addr];
        if (!info) return 0;
        if (len === info.len) {
          SYSCALLS.mappings[addr] = null;
          if (info.allocated) {
            _free(info.malloc)
          }
        }
        return 0
      }

      function ___sys_munmap(addr, len) {
        return syscallMunmap(addr, len)
      }

      function ___syscall91(a0, a1) {
        return ___sys_munmap(a0, a1)
      }

      function _fd_close(fd) {
        return 0
      }

      function ___wasi_fd_close(a0) {
        return _fd_close(a0)
      }

      function _fd_seek(fd, offset_low, offset_high, whence, newOffset) {}

      function ___wasi_fd_seek(a0, a1, a2, a3, a4) {
        return _fd_seek(a0, a1, a2, a3, a4)
      }

      function _fd_write(fd, iov, iovcnt, pnum) {
        var num = 0;
        for (var i = 0; i < iovcnt; i++) {
          var ptr = HEAP32[iov + i * 8 >> 2];
          var len = HEAP32[iov + (i * 8 + 4) >> 2];
          for (var j = 0; j < len; j++) {
            SYSCALLS.printChar(fd, HEAPU8[ptr + j])
          }
          num += len
        }
        HEAP32[pnum >> 2] = num;
        return 0
      }

      function ___wasi_fd_write(a0, a1, a2, a3) {
        return _fd_write(a0, a1, a2, a3)
      }
      var structRegistrations = {};

      function runDestructors(destructors) {
        while (destructors.length) {
          var ptr = destructors.pop();
          var del = destructors.pop();
          del(ptr)
        }
      }

      function simpleReadValueFromPointer(pointer) {
        return this["fromWireType"](HEAPU32[pointer >> 2])
      }
      var awaitingDependencies = {};
      var registeredTypes = {};
      var typeDependencies = {};
      var char_0 = 48;
      var char_9 = 57;

      function makeLegalFunctionName(name) {
        if (undefined === name) {
          return "_unknown"
        }
        name = name.replace(/[^a-zA-Z0-9_]/g, "$");
        var f = name.charCodeAt(0);
        if (f >= char_0 && f <= char_9) {
          return "_" + name
        } else {
          return name
        }
      }

      function createNamedFunction(name, body) {
        name = makeLegalFunctionName(name);
        return new Function("body", "return function " + name + "() {\n" + '    "use strict";' + "    return body.apply(this, arguments);\n" + "};\n")(body)
      }

      function extendError(baseErrorType, errorName) {
        var errorClass = createNamedFunction(errorName, function(message) {
          this.name = errorName;
          this.message = message;
          var stack = new Error(message).stack;
          if (stack !== undefined) {
            this.stack = this.toString() + "\n" + stack.replace(/^Error(:[^\n]*)?\n/, "")
          }
        });
        errorClass.prototype = Object.create(baseErrorType.prototype);
        errorClass.prototype.constructor = errorClass;
        errorClass.prototype.toString = function() {
          if (this.message === undefined) {
            return this.name
          } else {
            return this.name + ": " + this.message
          }
        };
        return errorClass
      }
      var InternalError = undefined;

      function throwInternalError(message) {
        throw new InternalError(message)
      }

      function whenDependentTypesAreResolved(myTypes, dependentTypes, getTypeConverters) {
        myTypes.forEach(function(type) {
          typeDependencies[type] = dependentTypes
        });

        function onComplete(typeConverters) {
          var myTypeConverters = getTypeConverters(typeConverters);
          if (myTypeConverters.length !== myTypes.length) {
            throwInternalError("Mismatched type converter count")
          }
          for (var i = 0; i < myTypes.length; ++i) {
            registerType(myTypes[i], myTypeConverters[i])
          }
        }
        var typeConverters = new Array(dependentTypes.length);
        var unregisteredTypes = [];
        var registered = 0;
        dependentTypes.forEach(function(dt, i) {
          if (registeredTypes.hasOwnProperty(dt)) {
            typeConverters[i] = registeredTypes[dt]
          } else {
            unregisteredTypes.push(dt);
            if (!awaitingDependencies.hasOwnProperty(dt)) {
              awaitingDependencies[dt] = []
            }
            awaitingDependencies[dt].push(function() {
              typeConverters[i] = registeredTypes[dt];
              ++registered;
              if (registered === unregisteredTypes.length) {
                onComplete(typeConverters)
              }
            })
          }
        });
        if (0 === unregisteredTypes.length) {
          onComplete(typeConverters)
        }
      }

      function __embind_finalize_value_object(structType) {
        var reg = structRegistrations[structType];
        delete structRegistrations[structType];
        var rawConstructor = reg.rawConstructor;
        var rawDestructor = reg.rawDestructor;
        var fieldRecords = reg.fields;
        var fieldTypes = fieldRecords.map(function(field) {
          return field.getterReturnType
        }).concat(fieldRecords.map(function(field) {
          return field.setterArgumentType
        }));
        whenDependentTypesAreResolved([structType], fieldTypes, function(fieldTypes) {
          var fields = {};
          fieldRecords.forEach(function(field, i) {
            var fieldName = field.fieldName;
            var getterReturnType = fieldTypes[i];
            var getter = field.getter;
            var getterContext = field.getterContext;
            var setterArgumentType = fieldTypes[i + fieldRecords.length];
            var setter = field.setter;
            var setterContext = field.setterContext;
            fields[fieldName] = {
              read: function(ptr) {
                return getterReturnType["fromWireType"](getter(getterContext, ptr))
              },
              write: function(ptr, o) {
                var destructors = [];
                setter(setterContext, ptr, setterArgumentType["toWireType"](destructors, o));
                runDestructors(destructors)
              }
            }
          });
          return [{
            name: reg.name,
            "fromWireType": function(ptr) {
              var rv = {};
              for (var i in fields) {
                rv[i] = fields[i].read(ptr)
              }
              rawDestructor(ptr);
              return rv
            },
            "toWireType": function(destructors, o) {
              for (var fieldName in fields) {
                if (!(fieldName in o)) {
                  throw new TypeError("Missing field")
                }
              }
              var ptr = rawConstructor();
              for (fieldName in fields) {
                fields[fieldName].write(ptr, o[fieldName])
              }
              if (destructors !== null) {
                destructors.push(rawDestructor, ptr)
              }
              return ptr
            },
            "argPackAdvance": 8,
            "readValueFromPointer": simpleReadValueFromPointer,
            destructorFunction: rawDestructor
          }]
        })
      }

      function getShiftFromSize(size) {
        switch (size) {
          case 1:
            return 0;
          case 2:
            return 1;
          case 4:
            return 2;
          case 8:
            return 3;
          default:
            throw new TypeError("Unknown type size: " + size)
        }
      }

      function embind_init_charCodes() {
        var codes = new Array(256);
        for (var i = 0; i < 256; ++i) {
          codes[i] = String.fromCharCode(i)
        }
        embind_charCodes = codes
      }
      var embind_charCodes = undefined;

      function readLatin1String(ptr) {
        var ret = "";
        var c = ptr;
        while (HEAPU8[c]) {
          ret += embind_charCodes[HEAPU8[c++]]
        }
        return ret
      }
      var BindingError = undefined;

      function throwBindingError(message) {
        throw new BindingError(message)
      }

      function registerType(rawType, registeredInstance, options) {
        options = options || {};
        if (!("argPackAdvance" in registeredInstance)) {
          throw new TypeError("registerType registeredInstance requires argPackAdvance")
        }
        var name = registeredInstance.name;
        if (!rawType) {
          throwBindingError('type "' + name + '" must have a positive integer typeid pointer')
        }
        if (registeredTypes.hasOwnProperty(rawType)) {
          if (options.ignoreDuplicateRegistrations) {
            return
          } else {
            throwBindingError("Cannot register type '" + name + "' twice")
          }
        }
        registeredTypes[rawType] = registeredInstance;
        delete typeDependencies[rawType];
        if (awaitingDependencies.hasOwnProperty(rawType)) {
          var callbacks = awaitingDependencies[rawType];
          delete awaitingDependencies[rawType];
          callbacks.forEach(function(cb) {
            cb()
          })
        }
      }

      function __embind_register_bool(rawType, name, size, trueValue, falseValue) {
        var shift = getShiftFromSize(size);
        name = readLatin1String(name);
        registerType(rawType, {
          name: name,
          "fromWireType": function(wt) {
            return !!wt
          },
          "toWireType": function(destructors, o) {
            return o ? trueValue : falseValue
          },
          "argPackAdvance": 8,
          "readValueFromPointer": function(pointer) {
            var heap;
            if (size === 1) {
              heap = HEAP8
            } else if (size === 2) {
              heap = HEAP16
            } else if (size === 4) {
              heap = HEAP32
            } else {
              throw new TypeError("Unknown boolean type size: " + name)
            }
            return this["fromWireType"](heap[pointer >> shift])
          },
          destructorFunction: null
        })
      }

      function ClassHandle_isAliasOf(other) {
        if (!(this instanceof ClassHandle)) {
          return false
        }
        if (!(other instanceof ClassHandle)) {
          return false
        }
        var leftClass = this.$$.ptrType.registeredClass;
        var left = this.$$.ptr;
        var rightClass = other.$$.ptrType.registeredClass;
        var right = other.$$.ptr;
        while (leftClass.baseClass) {
          left = leftClass.upcast(left);
          leftClass = leftClass.baseClass
        }
        while (rightClass.baseClass) {
          right = rightClass.upcast(right);
          rightClass = rightClass.baseClass
        }
        return leftClass === rightClass && left === right
      }

      function shallowCopyInternalPointer(o) {
        return {
          count: o.count,
          deleteScheduled: o.deleteScheduled,
          preservePointerOnDelete: o.preservePointerOnDelete,
          ptr: o.ptr,
          ptrType: o.ptrType,
          smartPtr: o.smartPtr,
          smartPtrType: o.smartPtrType
        }
      }

      function throwInstanceAlreadyDeleted(obj) {
        function getInstanceTypeName(handle) {
          return handle.$$.ptrType.registeredClass.name
        }
        throwBindingError(getInstanceTypeName(obj) + " instance already deleted")
      }
      var finalizationGroup = false;

      function detachFinalizer(handle) {}

      function runDestructor($$) {
        if ($$.smartPtr) {
          $$.smartPtrType.rawDestructor($$.smartPtr)
        } else {
          $$.ptrType.registeredClass.rawDestructor($$.ptr)
        }
      }

      function releaseClassHandle($$) {
        $$.count.value -= 1;
        var toDelete = 0 === $$.count.value;
        if (toDelete) {
          runDestructor($$)
        }
      }

      function attachFinalizer(handle) {
        if ("undefined" === typeof FinalizationGroup) {
          attachFinalizer = function(handle) {
            return handle
          };
          return handle
        }
        finalizationGroup = new FinalizationGroup(function(iter) {
          for (var result = iter.next(); !result.done; result = iter.next()) {
            var $$ = result.value;
            if (!$$.ptr) {
              console.warn("object already deleted: " + $$.ptr)
            } else {
              releaseClassHandle($$)
            }
          }
        });
        attachFinalizer = function(handle) {
          finalizationGroup.register(handle, handle.$$, handle.$$);
          return handle
        };
        detachFinalizer = function(handle) {
          finalizationGroup.unregister(handle.$$)
        };
        return attachFinalizer(handle)
      }

      function ClassHandle_clone() {
        if (!this.$$.ptr) {
          throwInstanceAlreadyDeleted(this)
        }
        if (this.$$.preservePointerOnDelete) {
          this.$$.count.value += 1;
          return this
        } else {
          var clone = attachFinalizer(Object.create(Object.getPrototypeOf(this), {
            $$: {
              value: shallowCopyInternalPointer(this.$$)
            }
          }));
          clone.$$.count.value += 1;
          clone.$$.deleteScheduled = false;
          return clone
        }
      }

      function ClassHandle_delete() {
        if (!this.$$.ptr) {
          throwInstanceAlreadyDeleted(this)
        }
        if (this.$$.deleteScheduled && !this.$$.preservePointerOnDelete) {
          throwBindingError("Object already scheduled for deletion")
        }
        detachFinalizer(this);
        releaseClassHandle(this.$$);
        if (!this.$$.preservePointerOnDelete) {
          this.$$.smartPtr = undefined;
          this.$$.ptr = undefined
        }
      }

      function ClassHandle_isDeleted() {
        return !this.$$.ptr
      }
      var delayFunction = undefined;
      var deletionQueue = [];

      function flushPendingDeletes() {
        while (deletionQueue.length) {
          var obj = deletionQueue.pop();
          obj.$$.deleteScheduled = false;
          obj["delete"]()
        }
      }

      function ClassHandle_deleteLater() {
        if (!this.$$.ptr) {
          throwInstanceAlreadyDeleted(this)
        }
        if (this.$$.deleteScheduled && !this.$$.preservePointerOnDelete) {
          throwBindingError("Object already scheduled for deletion")
        }
        deletionQueue.push(this);
        if (deletionQueue.length === 1 && delayFunction) {
          delayFunction(flushPendingDeletes)
        }
        this.$$.deleteScheduled = true;
        return this
      }

      function init_ClassHandle() {
        ClassHandle.prototype["isAliasOf"] = ClassHandle_isAliasOf;
        ClassHandle.prototype["clone"] = ClassHandle_clone;
        ClassHandle.prototype["delete"] = ClassHandle_delete;
        ClassHandle.prototype["isDeleted"] = ClassHandle_isDeleted;
        ClassHandle.prototype["deleteLater"] = ClassHandle_deleteLater
      }

      function ClassHandle() {}
      var registeredPointers = {};

      function ensureOverloadTable(proto, methodName, humanName) {
        if (undefined === proto[methodName].overloadTable) {
          var prevFunc = proto[methodName];
          proto[methodName] = function() {
            if (!proto[methodName].overloadTable.hasOwnProperty(arguments.length)) {
              throwBindingError("Function '" + humanName + "' called with an invalid number of arguments (" + arguments.length + ") - expects one of (" + proto[methodName].overloadTable + ")!")
            }
            return proto[methodName].overloadTable[arguments.length].apply(this, arguments)
          };
          proto[methodName].overloadTable = [];
          proto[methodName].overloadTable[prevFunc.argCount] = prevFunc
        }
      }

      function exposePublicSymbol(name, value, numArguments) {
        if (Module.hasOwnProperty(name)) {
          if (undefined === numArguments || undefined !== Module[name].overloadTable && undefined !== Module[name].overloadTable[numArguments]) {
            throwBindingError("Cannot register public name '" + name + "' twice")
          }
          ensureOverloadTable(Module, name, name);
          if (Module.hasOwnProperty(numArguments)) {
            throwBindingError("Cannot register multiple overloads of a function with the same number of arguments (" + numArguments + ")!")
          }
          Module[name].overloadTable[numArguments] = value
        } else {
          Module[name] = value;
          if (undefined !== numArguments) {
            Module[name].numArguments = numArguments
          }
        }
      }

      function RegisteredClass(name, constructor, instancePrototype, rawDestructor, baseClass, getActualType, upcast, downcast) {
        this.name = name;
        this.constructor = constructor;
        this.instancePrototype = instancePrototype;
        this.rawDestructor = rawDestructor;
        this.baseClass = baseClass;
        this.getActualType = getActualType;
        this.upcast = upcast;
        this.downcast = downcast;
        this.pureVirtualFunctions = []
      }

      function upcastPointer(ptr, ptrClass, desiredClass) {
        while (ptrClass !== desiredClass) {
          if (!ptrClass.upcast) {
            throwBindingError("Expected null or instance of " + desiredClass.name + ", got an instance of " + ptrClass.name)
          }
          ptr = ptrClass.upcast(ptr);
          ptrClass = ptrClass.baseClass
        }
        return ptr
      }

      function constNoSmartPtrRawPointerToWireType(destructors, handle) {
        if (handle === null) {
          if (this.isReference) {
            throwBindingError("null is not a valid " + this.name)
          }
          return 0
        }
        if (!handle.$$) {
          throwBindingError('Cannot pass "' + _embind_repr(handle) + '" as a ' + this.name)
        }
        if (!handle.$$.ptr) {
          throwBindingError("Cannot pass deleted object as a pointer of type " + this.name)
        }
        var handleClass = handle.$$.ptrType.registeredClass;
        var ptr = upcastPointer(handle.$$.ptr, handleClass, this.registeredClass);
        return ptr
      }

      function genericPointerToWireType(destructors, handle) {
        var ptr;
        if (handle === null) {
          if (this.isReference) {
            throwBindingError("null is not a valid " + this.name)
          }
          if (this.isSmartPointer) {
            ptr = this.rawConstructor();
            if (destructors !== null) {
              destructors.push(this.rawDestructor, ptr)
            }
            return ptr
          } else {
            return 0
          }
        }
        if (!handle.$$) {
          throwBindingError('Cannot pass "' + _embind_repr(handle) + '" as a ' + this.name)
        }
        if (!handle.$$.ptr) {
          throwBindingError("Cannot pass deleted object as a pointer of type " + this.name)
        }
        if (!this.isConst && handle.$$.ptrType.isConst) {
          throwBindingError("Cannot convert argument of type " + (handle.$$.smartPtrType ? handle.$$.smartPtrType.name : handle.$$.ptrType.name) + " to parameter type " + this.name)
        }
        var handleClass = handle.$$.ptrType.registeredClass;
        ptr = upcastPointer(handle.$$.ptr, handleClass, this.registeredClass);
        if (this.isSmartPointer) {
          if (undefined === handle.$$.smartPtr) {
            throwBindingError("Passing raw pointer to smart pointer is illegal")
          }
          switch (this.sharingPolicy) {
            case 0:
              if (handle.$$.smartPtrType === this) {
                ptr = handle.$$.smartPtr
              } else {
                throwBindingError("Cannot convert argument of type " + (handle.$$.smartPtrType ? handle.$$.smartPtrType.name : handle.$$.ptrType.name) + " to parameter type " + this.name)
              }
              break;
            case 1:
              ptr = handle.$$.smartPtr;
              break;
            case 2:
              if (handle.$$.smartPtrType === this) {
                ptr = handle.$$.smartPtr
              } else {
                var clonedHandle = handle["clone"]();
                ptr = this.rawShare(ptr, __emval_register(function() {
                  clonedHandle["delete"]()
                }));
                if (destructors !== null) {
                  destructors.push(this.rawDestructor, ptr)
                }
              }
              break;
            default:
              throwBindingError("Unsupporting sharing policy")
          }
        }
        return ptr
      }

      function nonConstNoSmartPtrRawPointerToWireType(destructors, handle) {
        if (handle === null) {
          if (this.isReference) {
            throwBindingError("null is not a valid " + this.name)
          }
          return 0
        }
        if (!handle.$$) {
          throwBindingError('Cannot pass "' + _embind_repr(handle) + '" as a ' + this.name)
        }
        if (!handle.$$.ptr) {
          throwBindingError("Cannot pass deleted object as a pointer of type " + this.name)
        }
        if (handle.$$.ptrType.isConst) {
          throwBindingError("Cannot convert argument of type " + handle.$$.ptrType.name + " to parameter type " + this.name)
        }
        var handleClass = handle.$$.ptrType.registeredClass;
        var ptr = upcastPointer(handle.$$.ptr, handleClass, this.registeredClass);
        return ptr
      }

      function RegisteredPointer_getPointee(ptr) {
        if (this.rawGetPointee) {
          ptr = this.rawGetPointee(ptr)
        }
        return ptr
      }

      function RegisteredPointer_destructor(ptr) {
        if (this.rawDestructor) {
          this.rawDestructor(ptr)
        }
      }

      function RegisteredPointer_deleteObject(handle) {
        if (handle !== null) {
          handle["delete"]()
        }
      }

      function downcastPointer(ptr, ptrClass, desiredClass) {
        if (ptrClass === desiredClass) {
          return ptr
        }
        if (undefined === desiredClass.baseClass) {
          return null
        }
        var rv = downcastPointer(ptr, ptrClass, desiredClass.baseClass);
        if (rv === null) {
          return null
        }
        return desiredClass.downcast(rv)
      }

      function getInheritedInstanceCount() {
        return Object.keys(registeredInstances).length
      }

      function getLiveInheritedInstances() {
        var rv = [];
        for (var k in registeredInstances) {
          if (registeredInstances.hasOwnProperty(k)) {
            rv.push(registeredInstances[k])
          }
        }
        return rv
      }

      function setDelayFunction(fn) {
        delayFunction = fn;
        if (deletionQueue.length && delayFunction) {
          delayFunction(flushPendingDeletes)
        }
      }

      function init_embind() {
        Module["getInheritedInstanceCount"] = getInheritedInstanceCount;
        Module["getLiveInheritedInstances"] = getLiveInheritedInstances;
        Module["flushPendingDeletes"] = flushPendingDeletes;
        Module["setDelayFunction"] = setDelayFunction
      }
      var registeredInstances = {};

      function getBasestPointer(class_, ptr) {
        if (ptr === undefined) {
          throwBindingError("ptr should not be undefined")
        }
        while (class_.baseClass) {
          ptr = class_.upcast(ptr);
          class_ = class_.baseClass
        }
        return ptr
      }

      function getInheritedInstance(class_, ptr) {
        ptr = getBasestPointer(class_, ptr);
        return registeredInstances[ptr]
      }

      function makeClassHandle(prototype, record) {
        if (!record.ptrType || !record.ptr) {
          throwInternalError("makeClassHandle requires ptr and ptrType")
        }
        var hasSmartPtrType = !!record.smartPtrType;
        var hasSmartPtr = !!record.smartPtr;
        if (hasSmartPtrType !== hasSmartPtr) {
          throwInternalError("Both smartPtrType and smartPtr must be specified")
        }
        record.count = {
          value: 1
        };
        return attachFinalizer(Object.create(prototype, {
          $$: {
            value: record
          }
        }))
      }

      function RegisteredPointer_fromWireType(ptr) {
        var rawPointer = this.getPointee(ptr);
        if (!rawPointer) {
          this.destructor(ptr);
          return null
        }
        var registeredInstance = getInheritedInstance(this.registeredClass, rawPointer);
        if (undefined !== registeredInstance) {
          if (0 === registeredInstance.$$.count.value) {
            registeredInstance.$$.ptr = rawPointer;
            registeredInstance.$$.smartPtr = ptr;
            return registeredInstance["clone"]()
          } else {
            var rv = registeredInstance["clone"]();
            this.destructor(ptr);
            return rv
          }
        }

        function makeDefaultHandle() {
          if (this.isSmartPointer) {
            return makeClassHandle(this.registeredClass.instancePrototype, {
              ptrType: this.pointeeType,
              ptr: rawPointer,
              smartPtrType: this,
              smartPtr: ptr
            })
          } else {
            return makeClassHandle(this.registeredClass.instancePrototype, {
              ptrType: this,
              ptr: ptr
            })
          }
        }
        var actualType = this.registeredClass.getActualType(rawPointer);
        var registeredPointerRecord = registeredPointers[actualType];
        if (!registeredPointerRecord) {
          return makeDefaultHandle.call(this)
        }
        var toType;
        if (this.isConst) {
          toType = registeredPointerRecord.constPointerType
        } else {
          toType = registeredPointerRecord.pointerType
        }
        var dp = downcastPointer(rawPointer, this.registeredClass, toType.registeredClass);
        if (dp === null) {
          return makeDefaultHandle.call(this)
        }
        if (this.isSmartPointer) {
          return makeClassHandle(toType.registeredClass.instancePrototype, {
            ptrType: toType,
            ptr: dp,
            smartPtrType: this,
            smartPtr: ptr
          })
        } else {
          return makeClassHandle(toType.registeredClass.instancePrototype, {
            ptrType: toType,
            ptr: dp
          })
        }
      }

      function init_RegisteredPointer() {
        RegisteredPointer.prototype.getPointee = RegisteredPointer_getPointee;
        RegisteredPointer.prototype.destructor = RegisteredPointer_destructor;
        RegisteredPointer.prototype["argPackAdvance"] = 8;
        RegisteredPointer.prototype["readValueFromPointer"] = simpleReadValueFromPointer;
        RegisteredPointer.prototype["deleteObject"] = RegisteredPointer_deleteObject;
        RegisteredPointer.prototype["fromWireType"] = RegisteredPointer_fromWireType
      }

      function RegisteredPointer(name, registeredClass, isReference, isConst, isSmartPointer, pointeeType, sharingPolicy, rawGetPointee, rawConstructor, rawShare, rawDestructor) {
        this.name = name;
        this.registeredClass = registeredClass;
        this.isReference = isReference;
        this.isConst = isConst;
        this.isSmartPointer = isSmartPointer;
        this.pointeeType = pointeeType;
        this.sharingPolicy = sharingPolicy;
        this.rawGetPointee = rawGetPointee;
        this.rawConstructor = rawConstructor;
        this.rawShare = rawShare;
        this.rawDestructor = rawDestructor;
        if (!isSmartPointer && registeredClass.baseClass === undefined) {
          if (isConst) {
            this["toWireType"] = constNoSmartPtrRawPointerToWireType;
            this.destructorFunction = null
          } else {
            this["toWireType"] = nonConstNoSmartPtrRawPointerToWireType;
            this.destructorFunction = null
          }
        } else {
          this["toWireType"] = genericPointerToWireType
        }
      }

      function replacePublicSymbol(name, value, numArguments) {
        if (!Module.hasOwnProperty(name)) {
          throwInternalError("Replacing nonexistant public symbol")
        }
        if (undefined !== Module[name].overloadTable && undefined !== numArguments) {
          Module[name].overloadTable[numArguments] = value
        } else {
          Module[name] = value;
          Module[name].argCount = numArguments
        }
      }

      function embind__requireFunction(signature, rawFunction) {
        signature = readLatin1String(signature);

        function makeDynCaller(dynCall) {
          var args = [];
          for (var i = 1; i < signature.length; ++i) {
            args.push("a" + i)
          }
          var name = "dynCall_" + signature + "_" + rawFunction;
          var body = "return function " + name + "(" + args.join(", ") + ") {\n";
          body += "    return dynCall(rawFunction" + (args.length ? ", " : "") + args.join(", ") + ");\n";
          body += "};\n";
          return new Function("dynCall", "rawFunction", body)(dynCall, rawFunction)
        }
        var dc = Module["dynCall_" + signature];
        var fp = makeDynCaller(dc);
        if (typeof fp !== "function") {
          throwBindingError("unknown function pointer with signature " + signature + ": " + rawFunction)
        }
        return fp
      }
      var UnboundTypeError = undefined;

      function getTypeName(type) {
        var ptr = ___getTypeName(type);
        var rv = readLatin1String(ptr);
        _free(ptr);
        return rv
      }

      function throwUnboundTypeError(message, types) {
        var unboundTypes = [];
        var seen = {};

        function visit(type) {
          if (seen[type]) {
            return
          }
          if (registeredTypes[type]) {
            return
          }
          if (typeDependencies[type]) {
            typeDependencies[type].forEach(visit);
            return
          }
          unboundTypes.push(type);
          seen[type] = true
        }
        types.forEach(visit);
        throw new UnboundTypeError(message + ": " + unboundTypes.map(getTypeName).join([", "]))
      }

      function __embind_register_class(rawType, rawPointerType, rawConstPointerType, baseClassRawType, getActualTypeSignature, getActualType, upcastSignature, upcast, downcastSignature, downcast, name, destructorSignature, rawDestructor) {
        name = readLatin1String(name);
        getActualType = embind__requireFunction(getActualTypeSignature, getActualType);
        if (upcast) {
          upcast = embind__requireFunction(upcastSignature, upcast)
        }
        if (downcast) {
          downcast = embind__requireFunction(downcastSignature, downcast)
        }
        rawDestructor = embind__requireFunction(destructorSignature, rawDestructor);
        var legalFunctionName = makeLegalFunctionName(name);
        exposePublicSymbol(legalFunctionName, function() {
          throwUnboundTypeError("Cannot construct " + name + " due to unbound types", [baseClassRawType])
        });
        whenDependentTypesAreResolved([rawType, rawPointerType, rawConstPointerType], baseClassRawType ? [baseClassRawType] : [], function(base) {
          base = base[0];
          var baseClass;
          var basePrototype;
          if (baseClassRawType) {
            baseClass = base.registeredClass;
            basePrototype = baseClass.instancePrototype
          } else {
            basePrototype = ClassHandle.prototype
          }
          var constructor = createNamedFunction(legalFunctionName, function() {
            if (Object.getPrototypeOf(this) !== instancePrototype) {
              throw new BindingError("Use 'new' to construct " + name)
            }
            if (undefined === registeredClass.constructor_body) {
              throw new BindingError(name + " has no accessible constructor")
            }
            var body = registeredClass.constructor_body[arguments.length];
            if (undefined === body) {
              throw new BindingError("Tried to invoke ctor of " + name + " with invalid number of parameters (" + arguments.length + ") - expected (" + Object.keys(registeredClass.constructor_body).toString() + ") parameters instead!")
            }
            return body.apply(this, arguments)
          });
          var instancePrototype = Object.create(basePrototype, {
            constructor: {
              value: constructor
            }
          });
          constructor.prototype = instancePrototype;
          var registeredClass = new RegisteredClass(name, constructor, instancePrototype, rawDestructor, baseClass, getActualType, upcast, downcast);
          var referenceConverter = new RegisteredPointer(name, registeredClass, true, false, false);
          var pointerConverter = new RegisteredPointer(name + "*", registeredClass, false, false, false);
          var constPointerConverter = new RegisteredPointer(name + " const*", registeredClass, false, true, false);
          registeredPointers[rawType] = {
            pointerType: pointerConverter,
            constPointerType: constPointerConverter
          };
          replacePublicSymbol(legalFunctionName, constructor);
          return [referenceConverter, pointerConverter, constPointerConverter]
        })
      }

      function validateThis(this_, classType, humanName) {
        if (!(this_ instanceof Object)) {
          throwBindingError(humanName + ' with invalid "this": ' + this_)
        }
        if (!(this_ instanceof classType.registeredClass.constructor)) {
          throwBindingError(humanName + ' incompatible with "this" of type ' + this_.constructor.name)
        }
        if (!this_.$$.ptr) {
          throwBindingError("cannot call emscripten binding method " + humanName + " on deleted object")
        }
        return upcastPointer(this_.$$.ptr, this_.$$.ptrType.registeredClass, classType.registeredClass)
      }

      function __embind_register_class_property(classType, fieldName, getterReturnType, getterSignature, getter, getterContext, setterArgumentType, setterSignature, setter, setterContext) {
        fieldName = readLatin1String(fieldName);
        getter = embind__requireFunction(getterSignature, getter);
        whenDependentTypesAreResolved([], [classType], function(classType) {
          classType = classType[0];
          var humanName = classType.name + "." + fieldName;
          var desc = {
            get: function() {
              throwUnboundTypeError("Cannot access " + humanName + " due to unbound types", [getterReturnType, setterArgumentType])
            },
            enumerable: true,
            configurable: true
          };
          if (setter) {
            desc.set = function() {
              throwUnboundTypeError("Cannot access " + humanName + " due to unbound types", [getterReturnType, setterArgumentType])
            }
          } else {
            desc.set = function(v) {
              throwBindingError(humanName + " is a read-only property")
            }
          }
          Object.defineProperty(classType.registeredClass.instancePrototype, fieldName, desc);
          whenDependentTypesAreResolved([], setter ? [getterReturnType, setterArgumentType] : [getterReturnType], function(types) {
            var getterReturnType = types[0];
            var desc = {
              get: function() {
                var ptr = validateThis(this, classType, humanName + " getter");
                return getterReturnType["fromWireType"](getter(getterContext, ptr))
              },
              enumerable: true
            };
            if (setter) {
              setter = embind__requireFunction(setterSignature, setter);
              var setterArgumentType = types[1];
              desc.set = function(v) {
                var ptr = validateThis(this, classType, humanName + " setter");
                var destructors = [];
                setter(setterContext, ptr, setterArgumentType["toWireType"](destructors, v));
                runDestructors(destructors)
              }
            }
            Object.defineProperty(classType.registeredClass.instancePrototype, fieldName, desc);
            return []
          });
          return []
        })
      }
      var emval_free_list = [];
      var emval_handle_array = [{}, {
        value: undefined
      }, {
        value: null
      }, {
        value: true
      }, {
        value: false
      }];

      function __emval_decref(handle) {
        if (handle > 4 && 0 === --emval_handle_array[handle].refcount) {
          emval_handle_array[handle] = undefined;
          emval_free_list.push(handle)
        }
      }

      function count_emval_handles() {
        var count = 0;
        for (var i = 5; i < emval_handle_array.length; ++i) {
          if (emval_handle_array[i] !== undefined) {
            ++count
          }
        }
        return count
      }

      function get_first_emval() {
        for (var i = 5; i < emval_handle_array.length; ++i) {
          if (emval_handle_array[i] !== undefined) {
            return emval_handle_array[i]
          }
        }
        return null
      }

      function init_emval() {
        Module["count_emval_handles"] = count_emval_handles;
        Module["get_first_emval"] = get_first_emval
      }

      function __emval_register(value) {
        switch (value) {
          case undefined:
            {
              return 1
            }
          case null:
            {
              return 2
            }
          case true:
            {
              return 3
            }
          case false:
            {
              return 4
            }
          default:
            {
              var handle = emval_free_list.length ? emval_free_list.pop() : emval_handle_array.length;emval_handle_array[handle] = {
                refcount: 1,
                value: value
              };
              return handle
            }
        }
      }

      function __embind_register_emval(rawType, name) {
        name = readLatin1String(name);
        registerType(rawType, {
          name: name,
          "fromWireType": function(handle) {
            var rv = emval_handle_array[handle].value;
            __emval_decref(handle);
            return rv
          },
          "toWireType": function(destructors, value) {
            return __emval_register(value)
          },
          "argPackAdvance": 8,
          "readValueFromPointer": simpleReadValueFromPointer,
          destructorFunction: null
        })
      }

      function _embind_repr(v) {
        if (v === null) {
          return "null"
        }
        var t = typeof v;
        if (t === "object" || t === "array" || t === "function") {
          return v.toString()
        } else {
          return "" + v
        }
      }

      function floatReadValueFromPointer(name, shift) {
        switch (shift) {
          case 2:
            return function(pointer) {
              return this["fromWireType"](HEAPF32[pointer >> 2])
            };
          case 3:
            return function(pointer) {
              return this["fromWireType"](HEAPF64[pointer >> 3])
            };
          default:
            throw new TypeError("Unknown float type: " + name)
        }
      }

      function __embind_register_float(rawType, name, size) {
        var shift = getShiftFromSize(size);
        name = readLatin1String(name);
        registerType(rawType, {
          name: name,
          "fromWireType": function(value) {
            return value
          },
          "toWireType": function(destructors, value) {
            if (typeof value !== "number" && typeof value !== "boolean") {
              throw new TypeError('Cannot convert "' + _embind_repr(value) + '" to ' + this.name)
            }
            return value
          },
          "argPackAdvance": 8,
          "readValueFromPointer": floatReadValueFromPointer(name, shift),
          destructorFunction: null
        })
      }

      function new_(constructor, argumentList) {
        if (!(constructor instanceof Function)) {
          throw new TypeError("new_ called with constructor type " + typeof constructor + " which is not a function")
        }
        var dummy = createNamedFunction(constructor.name || "unknownFunctionName", function() {});
        dummy.prototype = constructor.prototype;
        var obj = new dummy;
        var r = constructor.apply(obj, argumentList);
        return r instanceof Object ? r : obj
      }

      function craftInvokerFunction(humanName, argTypes, classType, cppInvokerFunc, cppTargetFunc) {
        var argCount = argTypes.length;
        if (argCount < 2) {
          throwBindingError("argTypes array size mismatch! Must at least get return value and 'this' types!")
        }
        var isClassMethodFunc = argTypes[1] !== null && classType !== null;
        var needsDestructorStack = false;
        for (var i = 1; i < argTypes.length; ++i) {
          if (argTypes[i] !== null && argTypes[i].destructorFunction === undefined) {
            needsDestructorStack = true;
            break
          }
        }
        var returns = argTypes[0].name !== "void";
        var argsList = "";
        var argsListWired = "";
        for (var i = 0; i < argCount - 2; ++i) {
          argsList += (i !== 0 ? ", " : "") + "arg" + i;
          argsListWired += (i !== 0 ? ", " : "") + "arg" + i + "Wired"
        }
        var invokerFnBody = "return function " + makeLegalFunctionName(humanName) + "(" + argsList + ") {\n" + "if (arguments.length !== " + (argCount - 2) + ") {\n" + "throwBindingError('function " + humanName + " called with ' + arguments.length + ' arguments, expected " + (argCount - 2) + " args!');\n" + "}\n";
        if (needsDestructorStack) {
          invokerFnBody += "var destructors = [];\n"
        }
        var dtorStack = needsDestructorStack ? "destructors" : "null";
        var args1 = ["throwBindingError", "invoker", "fn", "runDestructors", "retType", "classParam"];
        var args2 = [throwBindingError, cppInvokerFunc, cppTargetFunc, runDestructors, argTypes[0], argTypes[1]];
        if (isClassMethodFunc) {
          invokerFnBody += "var thisWired = classParam.toWireType(" + dtorStack + ", this);\n"
        }
        for (var i = 0; i < argCount - 2; ++i) {
          invokerFnBody += "var arg" + i + "Wired = argType" + i + ".toWireType(" + dtorStack + ", arg" + i + "); // " + argTypes[i + 2].name + "\n";
          args1.push("argType" + i);
          args2.push(argTypes[i + 2])
        }
        if (isClassMethodFunc) {
          argsListWired = "thisWired" + (argsListWired.length > 0 ? ", " : "") + argsListWired
        }
        invokerFnBody += (returns ? "var rv = " : "") + "invoker(fn" + (argsListWired.length > 0 ? ", " : "") + argsListWired + ");\n";
        if (needsDestructorStack) {
          invokerFnBody += "runDestructors(destructors);\n"
        } else {
          for (var i = isClassMethodFunc ? 1 : 2; i < argTypes.length; ++i) {
            var paramName = i === 1 ? "thisWired" : "arg" + (i - 2) + "Wired";
            if (argTypes[i].destructorFunction !== null) {
              invokerFnBody += paramName + "_dtor(" + paramName + "); // " + argTypes[i].name + "\n";
              args1.push(paramName + "_dtor");
              args2.push(argTypes[i].destructorFunction)
            }
          }
        }
        if (returns) {
          invokerFnBody += "var ret = retType.fromWireType(rv);\n" + "return ret;\n"
        } else {}
        invokerFnBody += "}\n";
        args1.push(invokerFnBody);
        var invokerFunction = new_(Function, args1).apply(null, args2);
        return invokerFunction
      }

      function heap32VectorToArray(count, firstElement) {
        var array = [];
        for (var i = 0; i < count; i++) {
          array.push(HEAP32[(firstElement >> 2) + i])
        }
        return array
      }

      function __embind_register_function(name, argCount, rawArgTypesAddr, signature, rawInvoker, fn) {
        var argTypes = heap32VectorToArray(argCount, rawArgTypesAddr);
        name = readLatin1String(name);
        rawInvoker = embind__requireFunction(signature, rawInvoker);
        exposePublicSymbol(name, function() {
          throwUnboundTypeError("Cannot call " + name + " due to unbound types", argTypes)
        }, argCount - 1);
        whenDependentTypesAreResolved([], argTypes, function(argTypes) {
          var invokerArgsArray = [argTypes[0], null].concat(argTypes.slice(1));
          replacePublicSymbol(name, craftInvokerFunction(name, invokerArgsArray, null, rawInvoker, fn), argCount - 1);
          return []
        })
      }

      function integerReadValueFromPointer(name, shift, signed) {
        switch (shift) {
          case 0:
            return signed ? function readS8FromPointer(pointer) {
              return HEAP8[pointer]
            } : function readU8FromPointer(pointer) {
              return HEAPU8[pointer]
            };
          case 1:
            return signed ? function readS16FromPointer(pointer) {
              return HEAP16[pointer >> 1]
            } : function readU16FromPointer(pointer) {
              return HEAPU16[pointer >> 1]
            };
          case 2:
            return signed ? function readS32FromPointer(pointer) {
              return HEAP32[pointer >> 2]
            } : function readU32FromPointer(pointer) {
              return HEAPU32[pointer >> 2]
            };
          default:
            throw new TypeError("Unknown integer type: " + name)
        }
      }

      function __embind_register_integer(primitiveType, name, size, minRange, maxRange) {
        name = readLatin1String(name);
        if (maxRange === -1) {
          maxRange = 4294967295
        }
        var shift = getShiftFromSize(size);
        var fromWireType = function(value) {
          return value
        };
        if (minRange === 0) {
          var bitshift = 32 - 8 * size;
          fromWireType = function(value) {
            return value << bitshift >>> bitshift
          }
        }
        var isUnsignedType = name.indexOf("unsigned") != -1;
        registerType(primitiveType, {
          name: name,
          "fromWireType": fromWireType,
          "toWireType": function(destructors, value) {
            if (typeof value !== "number" && typeof value !== "boolean") {
              throw new TypeError('Cannot convert "' + _embind_repr(value) + '" to ' + this.name)
            }
            if (value < minRange || value > maxRange) {
              throw new TypeError('Passing a number "' + _embind_repr(value) + '" from JS side to C/C++ side to an argument of type "' + name + '", which is outside the valid range [' + minRange + ", " + maxRange + "]!")
            }
            return isUnsignedType ? value >>> 0 : value | 0
          },
          "argPackAdvance": 8,
          "readValueFromPointer": integerReadValueFromPointer(name, shift, minRange !== 0),
          destructorFunction: null
        })
      }

      function __embind_register_memory_view(rawType, dataTypeIndex, name) {
        var typeMapping = [Int8Array, Uint8Array, Int16Array, Uint16Array, Int32Array, Uint32Array, Float32Array, Float64Array];
        var TA = typeMapping[dataTypeIndex];

        function decodeMemoryView(handle) {
          handle = handle >> 2;
          var heap = HEAPU32;
          var size = heap[handle];
          var data = heap[handle + 1];
          return new TA(buffer, data, size)
        }
        name = readLatin1String(name);
        registerType(rawType, {
          name: name,
          "fromWireType": decodeMemoryView,
          "argPackAdvance": 8,
          "readValueFromPointer": decodeMemoryView
        }, {
          ignoreDuplicateRegistrations: true
        })
      }

      function __embind_register_std_string(rawType, name) {
        name = readLatin1String(name);
        var stdStringIsUTF8 = name === "std::string";
        registerType(rawType, {
          name: name,
          "fromWireType": function(value) {
            var length = HEAPU32[value >> 2];
            var str;
            if (stdStringIsUTF8) {
              var endChar = HEAPU8[value + 4 + length];
              var endCharSwap = 0;
              if (endChar != 0) {
                endCharSwap = endChar;
                HEAPU8[value + 4 + length] = 0
              }
              var decodeStartPtr = value + 4;
              for (var i = 0; i <= length; ++i) {
                var currentBytePtr = value + 4 + i;
                if (HEAPU8[currentBytePtr] == 0) {
                  var stringSegment = UTF8ToString(decodeStartPtr);
                  if (str === undefined) {
                    str = stringSegment
                  } else {
                    str += String.fromCharCode(0);
                    str += stringSegment
                  }
                  decodeStartPtr = currentBytePtr + 1
                }
              }
              if (endCharSwap != 0) {
                HEAPU8[value + 4 + length] = endCharSwap
              }
            } else {
              var a = new Array(length);
              for (var i = 0; i < length; ++i) {
                a[i] = String.fromCharCode(HEAPU8[value + 4 + i])
              }
              str = a.join("")
            }
            _free(value);
            return str
          },
          "toWireType": function(destructors, value) {
            if (value instanceof ArrayBuffer) {
              value = new Uint8Array(value)
            }
            var getLength;
            var valueIsOfTypeString = typeof value === "string";
            if (!(valueIsOfTypeString || value instanceof Uint8Array || value instanceof Uint8ClampedArray || value instanceof Int8Array)) {
              throwBindingError("Cannot pass non-string to std::string")
            }
            if (stdStringIsUTF8 && valueIsOfTypeString) {
              getLength = function() {
                return lengthBytesUTF8(value)
              }
            } else {
              getLength = function() {
                return value.length
              }
            }
            var length = getLength();
            var ptr = _malloc(4 + length + 1);
            HEAPU32[ptr >> 2] = length;
            if (stdStringIsUTF8 && valueIsOfTypeString) {
              stringToUTF8(value, ptr + 4, length + 1)
            } else {
              if (valueIsOfTypeString) {
                for (var i = 0; i < length; ++i) {
                  var charCode = value.charCodeAt(i);
                  if (charCode > 255) {
                    _free(ptr);
                    throwBindingError("String has UTF-16 code units that do not fit in 8 bits")
                  }
                  HEAPU8[ptr + 4 + i] = charCode
                }
              } else {
                for (var i = 0; i < length; ++i) {
                  HEAPU8[ptr + 4 + i] = value[i]
                }
              }
            }
            if (destructors !== null) {
              destructors.push(_free, ptr)
            }
            return ptr
          },
          "argPackAdvance": 8,
          "readValueFromPointer": simpleReadValueFromPointer,
          destructorFunction: function(ptr) {
            _free(ptr)
          }
        })
      }

      function __embind_register_std_wstring(rawType, charSize, name) {
        name = readLatin1String(name);
        var decodeString, encodeString, getHeap, lengthBytesUTF, shift;
        if (charSize === 2) {
          decodeString = UTF16ToString;
          encodeString = stringToUTF16;
          lengthBytesUTF = lengthBytesUTF16;
          getHeap = function() {
            return HEAPU16
          };
          shift = 1
        } else if (charSize === 4) {
          decodeString = UTF32ToString;
          encodeString = stringToUTF32;
          lengthBytesUTF = lengthBytesUTF32;
          getHeap = function() {
            return HEAPU32
          };
          shift = 2
        }
        registerType(rawType, {
          name: name,
          "fromWireType": function(value) {
            var length = HEAPU32[value >> 2];
            var HEAP = getHeap();
            var str;
            var endChar = HEAP[value + 4 + length * charSize >> shift];
            var endCharSwap = 0;
            if (endChar != 0) {
              endCharSwap = endChar;
              HEAP[value + 4 + length * charSize >> shift] = 0
            }
            var decodeStartPtr = value + 4;
            for (var i = 0; i <= length; ++i) {
              var currentBytePtr = value + 4 + i * charSize;
              if (HEAP[currentBytePtr >> shift] == 0) {
                var stringSegment = decodeString(decodeStartPtr);
                if (str === undefined) {
                  str = stringSegment
                } else {
                  str += String.fromCharCode(0);
                  str += stringSegment
                }
                decodeStartPtr = currentBytePtr + charSize
              }
            }
            if (endCharSwap != 0) {
              HEAP[value + 4 + length * charSize >> shift] = endCharSwap
            }
            _free(value);
            return str
          },
          "toWireType": function(destructors, value) {
            if (!(typeof value === "string")) {
              throwBindingError("Cannot pass non-string to C++ string type " + name)
            }
            var length = lengthBytesUTF(value);
            var ptr = _malloc(4 + length + charSize);
            HEAPU32[ptr >> 2] = length >> shift;
            encodeString(value, ptr + 4, length + charSize);
            if (destructors !== null) {
              destructors.push(_free, ptr)
            }
            return ptr
          },
          "argPackAdvance": 8,
          "readValueFromPointer": simpleReadValueFromPointer,
          destructorFunction: function(ptr) {
            _free(ptr)
          }
        })
      }

      function __embind_register_value_object(rawType, name, constructorSignature, rawConstructor, destructorSignature, rawDestructor) {
        structRegistrations[rawType] = {
          name: readLatin1String(name),
          rawConstructor: embind__requireFunction(constructorSignature, rawConstructor),
          rawDestructor: embind__requireFunction(destructorSignature, rawDestructor),
          fields: []
        }
      }

      function __embind_register_value_object_field(structType, fieldName, getterReturnType, getterSignature, getter, getterContext, setterArgumentType, setterSignature, setter, setterContext) {
        structRegistrations[structType].fields.push({
          fieldName: readLatin1String(fieldName),
          getterReturnType: getterReturnType,
          getter: embind__requireFunction(getterSignature, getter),
          getterContext: getterContext,
          setterArgumentType: setterArgumentType,
          setter: embind__requireFunction(setterSignature, setter),
          setterContext: setterContext
        })
      }

      function __embind_register_void(rawType, name) {
        name = readLatin1String(name);
        registerType(rawType, {
          isVoid: true,
          name: name,
          "argPackAdvance": 0,
          "fromWireType": function() {
            return undefined
          },
          "toWireType": function(destructors, o) {
            return undefined
          }
        })
      }

      function __emval_incref(handle) {
        if (handle > 4) {
          emval_handle_array[handle].refcount += 1
        }
      }

      function requireRegisteredType(rawType, humanName) {
        var impl = registeredTypes[rawType];
        if (undefined === impl) {
          throwBindingError(humanName + " has unknown type " + getTypeName(rawType))
        }
        return impl
      }

      function __emval_take_value(type, argv) {
        type = requireRegisteredType(type, "_emval_take_value");
        var v = type["readValueFromPointer"](argv);
        return __emval_register(v)
      }

      function _abort() {
        abort()
      }

      function _emscripten_get_heap_size() {
        return HEAPU8.length
      }

      function abortOnCannotGrowMemory(requestedSize) {
        abort("OOM")
      }

      function _emscripten_resize_heap(requestedSize) {
        abortOnCannotGrowMemory(requestedSize)
      }
      var ENV = {};

      function _getenv(name) {
        if (name === 0) return 0;
        name = UTF8ToString(name);
        if (!ENV.hasOwnProperty(name)) return 0;
        if (_getenv.ret) _free(_getenv.ret);
        _getenv.ret = allocateUTF8(ENV[name]);
        return _getenv.ret
      }

      function _llvm_eh_typeid_for(type) {
        return type
      }

      function _llvm_stackrestore(p) {
        var self = _llvm_stacksave;
        var ret = self.LLVM_SAVEDSTACKS[p];
        self.LLVM_SAVEDSTACKS.splice(p, 1);
        stackRestore(ret)
      }

      function _llvm_stacksave() {
        var self = _llvm_stacksave;
        if (!self.LLVM_SAVEDSTACKS) {
          self.LLVM_SAVEDSTACKS = []
        }
        self.LLVM_SAVEDSTACKS.push(stackSave());
        return self.LLVM_SAVEDSTACKS.length - 1
      }

      function _llvm_trap() {
        abort("trap!")
      }

      function _emscripten_memcpy_big(dest, src, num) {
        HEAPU8.copyWithin(dest, src, src + num)
      }

      function __isLeapYear(year) {
        return year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)
      }

      function __arraySum(array, index) {
        var sum = 0;
        for (var i = 0; i <= index; sum += array[i++]) {}
        return sum
      }
      var __MONTH_DAYS_LEAP = [31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
      var __MONTH_DAYS_REGULAR = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

      function __addDays(date, days) {
        var newDate = new Date(date.getTime());
        while (days > 0) {
          var leap = __isLeapYear(newDate.getFullYear());
          var currentMonth = newDate.getMonth();
          var daysInCurrentMonth = (leap ? __MONTH_DAYS_LEAP : __MONTH_DAYS_REGULAR)[currentMonth];
          if (days > daysInCurrentMonth - newDate.getDate()) {
            days -= daysInCurrentMonth - newDate.getDate() + 1;
            newDate.setDate(1);
            if (currentMonth < 11) {
              newDate.setMonth(currentMonth + 1)
            } else {
              newDate.setMonth(0);
              newDate.setFullYear(newDate.getFullYear() + 1)
            }
          } else {
            newDate.setDate(newDate.getDate() + days);
            return newDate
          }
        }
        return newDate
      }

      function _strftime(s, maxsize, format, tm) {
        var tm_zone = HEAP32[tm + 40 >> 2];
        var date = {
          tm_sec: HEAP32[tm >> 2],
          tm_min: HEAP32[tm + 4 >> 2],
          tm_hour: HEAP32[tm + 8 >> 2],
          tm_mday: HEAP32[tm + 12 >> 2],
          tm_mon: HEAP32[tm + 16 >> 2],
          tm_year: HEAP32[tm + 20 >> 2],
          tm_wday: HEAP32[tm + 24 >> 2],
          tm_yday: HEAP32[tm + 28 >> 2],
          tm_isdst: HEAP32[tm + 32 >> 2],
          tm_gmtoff: HEAP32[tm + 36 >> 2],
          tm_zone: tm_zone ? UTF8ToString(tm_zone) : ""
        };
        var pattern = UTF8ToString(format);
        var EXPANSION_RULES_1 = {
          "%c": "%a %b %d %H:%M:%S %Y",
          "%D": "%m/%d/%y",
          "%F": "%Y-%m-%d",
          "%h": "%b",
          "%r": "%I:%M:%S %p",
          "%R": "%H:%M",
          "%T": "%H:%M:%S",
          "%x": "%m/%d/%y",
          "%X": "%H:%M:%S",
          "%Ec": "%c",
          "%EC": "%C",
          "%Ex": "%m/%d/%y",
          "%EX": "%H:%M:%S",
          "%Ey": "%y",
          "%EY": "%Y",
          "%Od": "%d",
          "%Oe": "%e",
          "%OH": "%H",
          "%OI": "%I",
          "%Om": "%m",
          "%OM": "%M",
          "%OS": "%S",
          "%Ou": "%u",
          "%OU": "%U",
          "%OV": "%V",
          "%Ow": "%w",
          "%OW": "%W",
          "%Oy": "%y"
        };
        for (var rule in EXPANSION_RULES_1) {
          pattern = pattern.replace(new RegExp(rule, "g"), EXPANSION_RULES_1[rule])
        }
        var WEEKDAYS = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
        var MONTHS = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        function leadingSomething(value, digits, character) {
          var str = typeof value === "number" ? value.toString() : value || "";
          while (str.length < digits) {
            str = character[0] + str
          }
          return str
        }

        function leadingNulls(value, digits) {
          return leadingSomething(value, digits, "0")
        }

        function compareByDay(date1, date2) {
          function sgn(value) {
            return value < 0 ? -1 : value > 0 ? 1 : 0
          }
          var compare;
          if ((compare = sgn(date1.getFullYear() - date2.getFullYear())) === 0) {
            if ((compare = sgn(date1.getMonth() - date2.getMonth())) === 0) {
              compare = sgn(date1.getDate() - date2.getDate())
            }
          }
          return compare
        }

        function getFirstWeekStartDate(janFourth) {
          switch (janFourth.getDay()) {
            case 0:
              return new Date(janFourth.getFullYear() - 1, 11, 29);
            case 1:
              return janFourth;
            case 2:
              return new Date(janFourth.getFullYear(), 0, 3);
            case 3:
              return new Date(janFourth.getFullYear(), 0, 2);
            case 4:
              return new Date(janFourth.getFullYear(), 0, 1);
            case 5:
              return new Date(janFourth.getFullYear() - 1, 11, 31);
            case 6:
              return new Date(janFourth.getFullYear() - 1, 11, 30)
          }
        }

        function getWeekBasedYear(date) {
          var thisDate = __addDays(new Date(date.tm_year + 1900, 0, 1), date.tm_yday);
          var janFourthThisYear = new Date(thisDate.getFullYear(), 0, 4);
          var janFourthNextYear = new Date(thisDate.getFullYear() + 1, 0, 4);
          var firstWeekStartThisYear = getFirstWeekStartDate(janFourthThisYear);
          var firstWeekStartNextYear = getFirstWeekStartDate(janFourthNextYear);
          if (compareByDay(firstWeekStartThisYear, thisDate) <= 0) {
            if (compareByDay(firstWeekStartNextYear, thisDate) <= 0) {
              return thisDate.getFullYear() + 1
            } else {
              return thisDate.getFullYear()
            }
          } else {
            return thisDate.getFullYear() - 1
          }
        }
        var EXPANSION_RULES_2 = {
          "%a": function(date) {
            return WEEKDAYS[date.tm_wday].substring(0, 3)
          },
          "%A": function(date) {
            return WEEKDAYS[date.tm_wday]
          },
          "%b": function(date) {
            return MONTHS[date.tm_mon].substring(0, 3)
          },
          "%B": function(date) {
            return MONTHS[date.tm_mon]
          },
          "%C": function(date) {
            var year = date.tm_year + 1900;
            return leadingNulls(year / 100 | 0, 2)
          },
          "%d": function(date) {
            return leadingNulls(date.tm_mday, 2)
          },
          "%e": function(date) {
            return leadingSomething(date.tm_mday, 2, " ")
          },
          "%g": function(date) {
            return getWeekBasedYear(date).toString().substring(2)
          },
          "%G": function(date) {
            return getWeekBasedYear(date)
          },
          "%H": function(date) {
            return leadingNulls(date.tm_hour, 2)
          },
          "%I": function(date) {
            var twelveHour = date.tm_hour;
            if (twelveHour == 0) twelveHour = 12;
            else if (twelveHour > 12) twelveHour -= 12;
            return leadingNulls(twelveHour, 2)
          },
          "%j": function(date) {
            return leadingNulls(date.tm_mday + __arraySum(__isLeapYear(date.tm_year + 1900) ? __MONTH_DAYS_LEAP : __MONTH_DAYS_REGULAR, date.tm_mon - 1), 3)
          },
          "%m": function(date) {
            return leadingNulls(date.tm_mon + 1, 2)
          },
          "%M": function(date) {
            return leadingNulls(date.tm_min, 2)
          },
          "%n": function() {
            return "\n"
          },
          "%p": function(date) {
            if (date.tm_hour >= 0 && date.tm_hour < 12) {
              return "AM"
            } else {
              return "PM"
            }
          },
          "%S": function(date) {
            return leadingNulls(date.tm_sec, 2)
          },
          "%t": function() {
            return "\t"
          },
          "%u": function(date) {
            return date.tm_wday || 7
          },
          "%U": function(date) {
            var janFirst = new Date(date.tm_year + 1900, 0, 1);
            var firstSunday = janFirst.getDay() === 0 ? janFirst : __addDays(janFirst, 7 - janFirst.getDay());
            var endDate = new Date(date.tm_year + 1900, date.tm_mon, date.tm_mday);
            if (compareByDay(firstSunday, endDate) < 0) {
              var februaryFirstUntilEndMonth = __arraySum(__isLeapYear(endDate.getFullYear()) ? __MONTH_DAYS_LEAP : __MONTH_DAYS_REGULAR, endDate.getMonth() - 1) - 31;
              var firstSundayUntilEndJanuary = 31 - firstSunday.getDate();
              var days = firstSundayUntilEndJanuary + februaryFirstUntilEndMonth + endDate.getDate();
              return leadingNulls(Math.ceil(days / 7), 2)
            }
            return compareByDay(firstSunday, janFirst) === 0 ? "01" : "00"
          },
          "%V": function(date) {
            var janFourthThisYear = new Date(date.tm_year + 1900, 0, 4);
            var janFourthNextYear = new Date(date.tm_year + 1901, 0, 4);
            var firstWeekStartThisYear = getFirstWeekStartDate(janFourthThisYear);
            var firstWeekStartNextYear = getFirstWeekStartDate(janFourthNextYear);
            var endDate = __addDays(new Date(date.tm_year + 1900, 0, 1), date.tm_yday);
            if (compareByDay(endDate, firstWeekStartThisYear) < 0) {
              return "53"
            }
            if (compareByDay(firstWeekStartNextYear, endDate) <= 0) {
              return "01"
            }
            var daysDifference;
            if (firstWeekStartThisYear.getFullYear() < date.tm_year + 1900) {
              daysDifference = date.tm_yday + 32 - firstWeekStartThisYear.getDate()
            } else {
              daysDifference = date.tm_yday + 1 - firstWeekStartThisYear.getDate()
            }
            return leadingNulls(Math.ceil(daysDifference / 7), 2)
          },
          "%w": function(date) {
            return date.tm_wday
          },
          "%W": function(date) {
            var janFirst = new Date(date.tm_year, 0, 1);
            var firstMonday = janFirst.getDay() === 1 ? janFirst : __addDays(janFirst, janFirst.getDay() === 0 ? 1 : 7 - janFirst.getDay() + 1);
            var endDate = new Date(date.tm_year + 1900, date.tm_mon, date.tm_mday);
            if (compareByDay(firstMonday, endDate) < 0) {
              var februaryFirstUntilEndMonth = __arraySum(__isLeapYear(endDate.getFullYear()) ? __MONTH_DAYS_LEAP : __MONTH_DAYS_REGULAR, endDate.getMonth() - 1) - 31;
              var firstMondayUntilEndJanuary = 31 - firstMonday.getDate();
              var days = firstMondayUntilEndJanuary + februaryFirstUntilEndMonth + endDate.getDate();
              return leadingNulls(Math.ceil(days / 7), 2)
            }
            return compareByDay(firstMonday, janFirst) === 0 ? "01" : "00"
          },
          "%y": function(date) {
            return (date.tm_year + 1900).toString().substring(2)
          },
          "%Y": function(date) {
            return date.tm_year + 1900
          },
          "%z": function(date) {
            var off = date.tm_gmtoff;
            var ahead = off >= 0;
            off = Math.abs(off) / 60;
            off = off / 60 * 100 + off % 60;
            return (ahead ? "+" : "-") + String("0000" + off).slice(-4)
          },
          "%Z": function(date) {
            return date.tm_zone
          },
          "%%": function() {
            return "%"
          }
        };
        for (var rule in EXPANSION_RULES_2) {
          if (pattern.indexOf(rule) >= 0) {
            pattern = pattern.replace(new RegExp(rule, "g"), EXPANSION_RULES_2[rule](date))
          }
        }
        var bytes = intArrayFromString(pattern, false);
        if (bytes.length > maxsize) {
          return 0
        }
        writeArrayToMemory(bytes, s);
        return bytes.length - 1
      }

      function _strftime_l(s, maxsize, format, tm) {
        return _strftime(s, maxsize, format, tm)
      }
      InternalError = Module["InternalError"] = extendError(Error, "InternalError");
      embind_init_charCodes();
      BindingError = Module["BindingError"] = extendError(Error, "BindingError");
      init_ClassHandle();
      init_RegisteredPointer();
      init_embind();
      UnboundTypeError = Module["UnboundTypeError"] = extendError(Error, "UnboundTypeError");
      init_emval();

      function intArrayFromString(stringy, dontAddNull, length) {
        var len = length > 0 ? length : lengthBytesUTF8(stringy) + 1;
        var u8array = new Array(len);
        var numBytesWritten = stringToUTF8Array(stringy, u8array, 0, u8array.length);
        if (dontAddNull) u8array.length = numBytesWritten;
        return u8array
      }

      function invoke_diii(index, a1, a2, a3) {
        var sp = stackSave();
        try {
          return dynCall_diii(index, a1, a2, a3)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_fiii(index, a1, a2, a3) {
        var sp = stackSave();
        try {
          return dynCall_fiii(index, a1, a2, a3)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_i(index) {
        var sp = stackSave();
        try {
          return dynCall_i(index)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_ii(index, a1) {
        var sp = stackSave();
        try {
          return dynCall_ii(index, a1)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iid(index, a1, a2) {
        var sp = stackSave();
        try {
          return dynCall_iid(index, a1, a2)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iif(index, a1, a2) {
        var sp = stackSave();
        try {
          return dynCall_iif(index, a1, a2)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iii(index, a1, a2) {
        var sp = stackSave();
        try {
          return dynCall_iii(index, a1, a2)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiffi(index, a1, a2, a3, a4, a5) {
        var sp = stackSave();
        try {
          return dynCall_iiiffi(index, a1, a2, a3, a4, a5)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiii(index, a1, a2, a3) {
        var sp = stackSave();
        try {
          return dynCall_iiii(index, a1, a2, a3)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiii(index, a1, a2, a3, a4) {
        var sp = stackSave();
        try {
          return dynCall_iiiii(index, a1, a2, a3, a4)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiiid(index, a1, a2, a3, a4, a5) {
        var sp = stackSave();
        try {
          return dynCall_iiiiid(index, a1, a2, a3, a4, a5)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiiii(index, a1, a2, a3, a4, a5) {
        var sp = stackSave();
        try {
          return dynCall_iiiiii(index, a1, a2, a3, a4, a5)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiiiii(index, a1, a2, a3, a4, a5, a6) {
        var sp = stackSave();
        try {
          return dynCall_iiiiiii(index, a1, a2, a3, a4, a5, a6)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiiiiii(index, a1, a2, a3, a4, a5, a6, a7) {
        var sp = stackSave();
        try {
          return dynCall_iiiiiiii(index, a1, a2, a3, a4, a5, a6, a7)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8) {
        var sp = stackSave();
        try {
          return dynCall_iiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) {
        var sp = stackSave();
        try {
          return dynCall_iiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11) {
        var sp = stackSave();
        try {
          return dynCall_iiiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12) {
        var sp = stackSave();
        try {
          return dynCall_iiiiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iiiiij(index, a1, a2, a3, a4, a5, a6) {
        var sp = stackSave();
        try {
          return dynCall_iiiiij(index, a1, a2, a3, a4, a5, a6)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_iij(index, a1, a2, a3) {
        var sp = stackSave();
        try {
          return dynCall_iij(index, a1, a2, a3)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_jiii(index, a1, a2, a3) {
        var sp = stackSave();
        try {
          return dynCall_jiii(index, a1, a2, a3)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_jiiii(index, a1, a2, a3, a4) {
        var sp = stackSave();
        try {
          return dynCall_jiiii(index, a1, a2, a3, a4)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_v(index) {
        var sp = stackSave();
        try {
          dynCall_v(index)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_vi(index, a1) {
        var sp = stackSave();
        try {
          dynCall_vi(index, a1)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_vii(index, a1, a2) {
        var sp = stackSave();
        try {
          dynCall_vii(index, a1, a2)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viii(index, a1, a2, a3) {
        var sp = stackSave();
        try {
          dynCall_viii(index, a1, a2, a3)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiii(index, a1, a2, a3, a4) {
        var sp = stackSave();
        try {
          dynCall_viiii(index, a1, a2, a3, a4)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiii(index, a1, a2, a3, a4, a5) {
        var sp = stackSave();
        try {
          dynCall_viiiii(index, a1, a2, a3, a4, a5)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiiiffffffffffffffff(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21) {
        var sp = stackSave();
        try {
          dynCall_viiiiiffffffffffffffff(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiiii(index, a1, a2, a3, a4, a5, a6) {
        var sp = stackSave();
        try {
          dynCall_viiiiii(index, a1, a2, a3, a4, a5, a6)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiiiii(index, a1, a2, a3, a4, a5, a6, a7) {
        var sp = stackSave();
        try {
          dynCall_viiiiiii(index, a1, a2, a3, a4, a5, a6, a7)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiiiiifi(index, a1, a2, a3, a4, a5, a6, a7, a8, a9) {
        var sp = stackSave();
        try {
          dynCall_viiiiiiifi(index, a1, a2, a3, a4, a5, a6, a7, a8, a9)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8) {
        var sp = stackSave();
        try {
          dynCall_viiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9) {
        var sp = stackSave();
        try {
          dynCall_viiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10) {
        var sp = stackSave();
        try {
          dynCall_viiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11) {
        var sp = stackSave();
        try {
          dynCall_viiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }

      function invoke_viiiiiiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15) {
        var sp = stackSave();
        try {
          dynCall_viiiiiiiiiiiiiii(index, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12, a13, a14, a15)
        } catch (e) {
          stackRestore(sp);
          if (e !== e + 0 && e !== "longjmp") throw e;
          _setThrew(1, 0)
        }
      }
      var asmGlobalArg = {};
      var asmLibraryArg = {
        "h": ___cxa_allocate_exception,
        "w": ___cxa_begin_catch,
        "x": ___cxa_end_catch,
        "b": ___cxa_find_matching_catch_2,
        "k": ___cxa_find_matching_catch_3,
        "v": ___cxa_find_matching_catch_4,
        "i": ___cxa_free_exception,
        "Z": ___cxa_rethrow,
        "m": ___cxa_throw,
        "Ba": ___cxa_uncaught_exceptions,
        "Aa": ___map_file,
        "d": ___resumeException,
        "za": ___syscall91,
        "ya": ___wasi_fd_close,
        "ca": ___wasi_fd_seek,
        "xa": ___wasi_fd_write,
        "wa": __embind_finalize_value_object,
        "va": __embind_register_bool,
        "ua": __embind_register_class,
        "Y": __embind_register_class_property,
        "ta": __embind_register_emval,
        "X": __embind_register_float,
        "J": __embind_register_function,
        "B": __embind_register_integer,
        "z": __embind_register_memory_view,
        "W": __embind_register_std_string,
        "S": __embind_register_std_wstring,
        "sa": __embind_register_value_object,
        "ra": __embind_register_value_object_field,
        "qa": __embind_register_void,
        "pa": __emval_decref,
        "oa": __emval_incref,
        "na": __emval_take_value,
        "__memory_base": 1024,
        "__table_base": 0,
        "V": _abort,
        "ma": _emscripten_get_heap_size,
        "la": _emscripten_memcpy_big,
        "ja": _emscripten_resize_heap,
        "M": _getenv,
        "F": _llvm_eh_typeid_for,
        "E": _llvm_stackrestore,
        "D": _llvm_stacksave,
        "ia": _llvm_trap,
        "ha": _strftime_l,
        "r": abort,
        "a": getTempRet0,
        "H": invoke_diii,
        "aa": invoke_fiii,
        "s": invoke_i,
        "c": invoke_ii,
        "N": invoke_iid,
        "ka": invoke_iif,
        "j": invoke_iii,
        "U": invoke_iiiffi,
        "l": invoke_iiii,
        "p": invoke_iiiii,
        "Ca": invoke_iiiiid,
        "t": invoke_iiiiii,
        "A": invoke_iiiiiii,
        "Q": invoke_iiiiiiii,
        "L": invoke_iiiiiiiii,
        "y": invoke_iiiiiiiiiii,
        "P": invoke_iiiiiiiiiiii,
        "I": invoke_iiiiiiiiiiiii,
        "ga": invoke_iiiiij,
        "fa": invoke_iij,
        "ea": invoke_jiii,
        "da": invoke_jiiii,
        "o": invoke_v,
        "g": invoke_vi,
        "e": invoke_vii,
        "f": invoke_viii,
        "n": invoke_viiii,
        "q": invoke_viiiii,
        "T": invoke_viiiiiffffffffffffffff,
        "G": invoke_viiiiii,
        "u": invoke_viiiiiii,
        "ba": invoke_viiiiiiifi,
        "$": invoke_viiiiiiii,
        "K": invoke_viiiiiiiii,
        "C": invoke_viiiiiiiiii,
        "_": invoke_viiiiiiiiiii,
        "O": invoke_viiiiiiiiiiiiiii,
        "memory": wasmMemory,
        "R": setTempRet0,
        "table": wasmTable
      };
      var asm = Module["asm"](asmGlobalArg, asmLibraryArg, buffer);
      Module["asm"] = asm;
      var __GLOBAL__sub_I_AZHighLevelEncoder_cpp = Module["__GLOBAL__sub_I_AZHighLevelEncoder_cpp"] = function() {
        return Module["asm"]["Da"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_BarcodeReader_cpp = Module["__GLOBAL__sub_I_BarcodeReader_cpp"] = function() {
        return Module["asm"]["Ea"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_BarcodeWriter_cpp = Module["__GLOBAL__sub_I_BarcodeWriter_cpp"] = function() {
        return Module["asm"]["Fa"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_CharacterSetECI_cpp = Module["__GLOBAL__sub_I_CharacterSetECI_cpp"] = function() {
        return Module["asm"]["Ga"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_DMECEncoder_cpp = Module["__GLOBAL__sub_I_DMECEncoder_cpp"] = function() {
        return Module["asm"]["Ha"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_DMHighLevelEncoder_cpp = Module["__GLOBAL__sub_I_DMHighLevelEncoder_cpp"] = function() {
        return Module["asm"]["Ia"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_GridSampler_cpp = Module["__GLOBAL__sub_I_GridSampler_cpp"] = function() {
        return Module["asm"]["Ja"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_ODCode128Patterns_cpp = Module["__GLOBAL__sub_I_ODCode128Patterns_cpp"] = function() {
        return Module["asm"]["Ka"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_ODRSSExpandedReader_cpp = Module["__GLOBAL__sub_I_ODRSSExpandedReader_cpp"] = function() {
        return Module["asm"]["La"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_PDFDetector_cpp = Module["__GLOBAL__sub_I_PDFDetector_cpp"] = function() {
        return Module["asm"]["Ma"].apply(null, arguments)
      };
      var __GLOBAL__sub_I_bind_cpp = Module["__GLOBAL__sub_I_bind_cpp"] = function() {
        return Module["asm"]["Na"].apply(null, arguments)
      };
      var __ZSt18uncaught_exceptionv = Module["__ZSt18uncaught_exceptionv"] = function() {
        return Module["asm"]["Oa"].apply(null, arguments)
      };
      var ___cxa_can_catch = Module["___cxa_can_catch"] = function() {
        return Module["asm"]["Pa"].apply(null, arguments)
      };
      var ___cxa_is_pointer_type = Module["___cxa_is_pointer_type"] = function() {
        return Module["asm"]["Qa"].apply(null, arguments)
      };
      var ___embind_register_native_and_builtin_types = Module["___embind_register_native_and_builtin_types"] = function() {
        return Module["asm"]["Ra"].apply(null, arguments)
      };
      var ___getTypeName = Module["___getTypeName"] = function() {
        return Module["asm"]["Sa"].apply(null, arguments)
      };
      var _free = Module["_free"] = function() {
        return Module["asm"]["Ta"].apply(null, arguments)
      };
      var _malloc = Module["_malloc"] = function() {
        return Module["asm"]["Ua"].apply(null, arguments)
      };
      var _setThrew = Module["_setThrew"] = function() {
        return Module["asm"]["Va"].apply(null, arguments)
      };
      var stackRestore = Module["stackRestore"] = function() {
        return Module["asm"]["Jb"].apply(null, arguments)
      };
      var stackSave = Module["stackSave"] = function() {
        return Module["asm"]["Kb"].apply(null, arguments)
      };
      var dynCall_diii = Module["dynCall_diii"] = function() {
        return Module["asm"]["Wa"].apply(null, arguments)
      };
      var dynCall_fiii = Module["dynCall_fiii"] = function() {
        return Module["asm"]["Xa"].apply(null, arguments)
      };
      var dynCall_i = Module["dynCall_i"] = function() {
        return Module["asm"]["Ya"].apply(null, arguments)
      };
      var dynCall_ii = Module["dynCall_ii"] = function() {
        return Module["asm"]["Za"].apply(null, arguments)
      };
      var dynCall_iid = Module["dynCall_iid"] = function() {
        return Module["asm"]["_a"].apply(null, arguments)
      };
      var dynCall_iidiiii = Module["dynCall_iidiiii"] = function() {
        return Module["asm"]["$a"].apply(null, arguments)
      };
      var dynCall_iif = Module["dynCall_iif"] = function() {
        return Module["asm"]["ab"].apply(null, arguments)
      };
      var dynCall_iii = Module["dynCall_iii"] = function() {
        return Module["asm"]["bb"].apply(null, arguments)
      };
      var dynCall_iiiffi = Module["dynCall_iiiffi"] = function() {
        return Module["asm"]["cb"].apply(null, arguments)
      };
      var dynCall_iiii = Module["dynCall_iiii"] = function() {
        return Module["asm"]["db"].apply(null, arguments)
      };
      var dynCall_iiiii = Module["dynCall_iiiii"] = function() {
        return Module["asm"]["eb"].apply(null, arguments)
      };
      var dynCall_iiiiid = Module["dynCall_iiiiid"] = function() {
        return Module["asm"]["fb"].apply(null, arguments)
      };
      var dynCall_iiiiii = Module["dynCall_iiiiii"] = function() {
        return Module["asm"]["gb"].apply(null, arguments)
      };
      var dynCall_iiiiiid = Module["dynCall_iiiiiid"] = function() {
        return Module["asm"]["hb"].apply(null, arguments)
      };
      var dynCall_iiiiiii = Module["dynCall_iiiiiii"] = function() {
        return Module["asm"]["ib"].apply(null, arguments)
      };
      var dynCall_iiiiiiii = Module["dynCall_iiiiiiii"] = function() {
        return Module["asm"]["jb"].apply(null, arguments)
      };
      var dynCall_iiiiiiiii = Module["dynCall_iiiiiiiii"] = function() {
        return Module["asm"]["kb"].apply(null, arguments)
      };
      var dynCall_iiiiiiiiiii = Module["dynCall_iiiiiiiiiii"] = function() {
        return Module["asm"]["lb"].apply(null, arguments)
      };
      var dynCall_iiiiiiiiiiii = Module["dynCall_iiiiiiiiiiii"] = function() {
        return Module["asm"]["mb"].apply(null, arguments)
      };
      var dynCall_iiiiiiiiiiiii = Module["dynCall_iiiiiiiiiiiii"] = function() {
        return Module["asm"]["nb"].apply(null, arguments)
      };
      var dynCall_iiiiij = Module["dynCall_iiiiij"] = function() {
        return Module["asm"]["ob"].apply(null, arguments)
      };
      var dynCall_iij = Module["dynCall_iij"] = function() {
        return Module["asm"]["pb"].apply(null, arguments)
      };
      var dynCall_jiii = Module["dynCall_jiii"] = function() {
        return Module["asm"]["qb"].apply(null, arguments)
      };
      var dynCall_jiiii = Module["dynCall_jiiii"] = function() {
        return Module["asm"]["rb"].apply(null, arguments)
      };
      var dynCall_jiji = Module["dynCall_jiji"] = function() {
        return Module["asm"]["sb"].apply(null, arguments)
      };
      var dynCall_v = Module["dynCall_v"] = function() {
        return Module["asm"]["tb"].apply(null, arguments)
      };
      var dynCall_vi = Module["dynCall_vi"] = function() {
        return Module["asm"]["ub"].apply(null, arguments)
      };
      var dynCall_vii = Module["dynCall_vii"] = function() {
        return Module["asm"]["vb"].apply(null, arguments)
      };
      var dynCall_viii = Module["dynCall_viii"] = function() {
        return Module["asm"]["wb"].apply(null, arguments)
      };
      var dynCall_viiii = Module["dynCall_viiii"] = function() {
        return Module["asm"]["xb"].apply(null, arguments)
      };
      var dynCall_viiiii = Module["dynCall_viiiii"] = function() {
        return Module["asm"]["yb"].apply(null, arguments)
      };
      var dynCall_viiiiiffffffffffffffff = Module["dynCall_viiiiiffffffffffffffff"] = function() {
        return Module["asm"]["zb"].apply(null, arguments)
      };
      var dynCall_viiiiii = Module["dynCall_viiiiii"] = function() {
        return Module["asm"]["Ab"].apply(null, arguments)
      };
      var dynCall_viiiiiii = Module["dynCall_viiiiiii"] = function() {
        return Module["asm"]["Bb"].apply(null, arguments)
      };
      var dynCall_viiiiiiifi = Module["dynCall_viiiiiiifi"] = function() {
        return Module["asm"]["Cb"].apply(null, arguments)
      };
      var dynCall_viiiiiiii = Module["dynCall_viiiiiiii"] = function() {
        return Module["asm"]["Db"].apply(null, arguments)
      };
      var dynCall_viiiiiiiii = Module["dynCall_viiiiiiiii"] = function() {
        return Module["asm"]["Eb"].apply(null, arguments)
      };
      var dynCall_viiiiiiiiii = Module["dynCall_viiiiiiiiii"] = function() {
        return Module["asm"]["Fb"].apply(null, arguments)
      };
      var dynCall_viiiiiiiiiii = Module["dynCall_viiiiiiiiiii"] = function() {
        return Module["asm"]["Gb"].apply(null, arguments)
      };
      var dynCall_viiiiiiiiiiiiiii = Module["dynCall_viiiiiiiiiiiiiii"] = function() {
        return Module["asm"]["Hb"].apply(null, arguments)
      };
      var dynCall_viijii = Module["dynCall_viijii"] = function() {
        return Module["asm"]["Ib"].apply(null, arguments)
      };
      Module["asm"] = asm;
      var calledRun;
      Module["then"] = function(func) {
        if (calledRun) {
          func(Module)
        } else {
          var old = Module["onRuntimeInitialized"];
          Module["onRuntimeInitialized"] = function() {
            if (old) old();
            func(Module)
          }
        }
        return Module
      };

      function ExitStatus(status) {
        this.name = "ExitStatus";
        this.message = "Program terminated with exit(" + status + ")";
        this.status = status
      }
      dependenciesFulfilled = function runCaller() {
        if (!calledRun) run();
        if (!calledRun) dependenciesFulfilled = runCaller
      };

      function run(args) {
        args = args || arguments_;
        if (runDependencies > 0) {
          return
        }
        preRun();
        if (runDependencies > 0) return;

        function doRun() {
          if (calledRun) return;
          calledRun = true;
          Module["calledRun"] = true;
          if (ABORT) return;
          initRuntime();
          preMain();
          if (Module["onRuntimeInitialized"]) Module["onRuntimeInitialized"]();
          postRun()
        }
        if (Module["setStatus"]) {
          Module["setStatus"]("Running...");
          setTimeout(function() {
            setTimeout(function() {
              Module["setStatus"]("")
            }, 1);
            doRun()
          }, 1)
        } else {
          doRun()
        }
      }
      Module["run"] = run;
      if (Module["preInit"]) {
        if (typeof Module["preInit"] == "function") Module["preInit"] = [Module["preInit"]];
        while (Module["preInit"].length > 0) {
          Module["preInit"].pop()()
        }
      }
      noExitRuntime = true;
      run();


      return ZXing
    }
  );
})();
if (typeof exports === 'object' && typeof module === 'object')
  module.exports = ZXing;
else if (typeof define === 'function' && define['amd'])
  define([], function() {
    return ZXing;
  });
else if (typeof exports === 'object')
  exports["ZXing"] = ZXing;
