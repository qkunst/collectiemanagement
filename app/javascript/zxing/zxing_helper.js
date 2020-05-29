// source: https://github.com/murb/zxing-demo/blob/master/zxing_helper.js

// <!-- UTILS START

// https://gist.github.com/jonleighton/958841
// bytes: Uint8Array

var ZXing;

if (typeof require !== "undefined") {
  ZXing = require('zxing/zxing_reader');
}

function uint8ArrayToBase64(bytes) {
  var base64    = ''
  var encodings = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  var byteLength    = bytes.byteLength
  var byteRemainder = byteLength % 3
  var mainLength    = byteLength - byteRemainder
  var a, b, c, d
  var chunk
  for (var i = 0; i < mainLength; i = i + 3) {
    chunk = (bytes[i] << 16) | (bytes[i + 1] << 8) | bytes[i + 2]
    a = (chunk & 16515072) >> 18 // 16515072 = (2^6 - 1) << 18
    b = (chunk & 258048)   >> 12 // 258048   = (2^6 - 1) << 12
    c = (chunk & 4032)     >>  6 // 4032     = (2^6 - 1) << 6
    d = chunk & 63               // 63       = 2^6 - 1
    base64 += encodings[a] + encodings[b] + encodings[c] + encodings[d]
  }
  if (byteRemainder == 1) {
    chunk = bytes[mainLength]
    a = (chunk & 252) >> 2 // 252 = (2^6 - 1) << 2
    b = (chunk & 3)   << 4 // 3   = 2^2 - 1
    base64 += encodings[a] + encodings[b] + '=='
  } else if (byteRemainder == 2) {
    chunk = (bytes[mainLength] << 8) | bytes[mainLength + 1]
    a = (chunk & 64512) >> 10 // 64512 = (2^6 - 1) << 10
    b = (chunk & 1008)  >>  4 // 1008  = (2^6 - 1) << 4
    c = (chunk & 15)    <<  2 // 15    = 2^4 - 1
    base64 += encodings[a] + encodings[b] + encodings[c] + '='
  }
  return base64
}


// https://stackoverflow.com/a/21797381
// https://stackoverflow.com/a/7261048
function base64ToUint8Array(uri) { // i.e. base64.b64_decode() in python
    var binary_string =  window.atob(uri.split(",")[1]);
    var len = binary_string.length;
    var bytes = new Uint8Array( len );
    for (var i = 0; i < len; i++) {
        bytes[i] = binary_string.charCodeAt(i);
    }
    return bytes;
}

// https://gist.github.com/murb/a8823e7a2d6fc9613b3c5c00a0225809
if (!Element.prototype.matches) {
  Element.prototype.matches = Element.prototype.msMatchesSelector;
}

// https://gist.github.com/murb/a8823e7a2d6fc9613b3c5c00a0225809
if (!HTMLDocument.prototype.addDelegatedEventListener) {
  HTMLDocument.prototype.addDelegatedEventListener = function(event, matcher, cb) {
    var newCB;
    newCB = function(event) {
      if (event.target.matches && event.target.matches(matcher)) {
        return cb(event);
      }
    };
    return this.addEventListener(event, newCB);
  };
}

function beep() {
    var snd = new  Audio(
      "data:audio/wav;base64,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qJrx4KOQjahZxWbcZgztj2c49nKmkId44S71j0c8eV9yDK6uPRzx5X18eDvjvQ6yKo9ZSS6l//8elePK/Lf//IInrOF/FvDoADYAGBMGb7FtErm5MXMlmPAJQVgWta7Zx2go+8xJ0UiCb8LHHdftWyLJE0QIAIsI+UbXu67dZMjmgDGCGl1H+vpF4NSDckSIkk7Vd+sxEhBQMRU8j/12UIRhzSaUdQ+rQU5kGeFxm+hb1oh6pWWmv3uvmReDl0UnvtapVaIzo1jZbf/pD6ElLqSX+rUmOQNpJFa/r+sa4e/pBlAABoAAAAA3CUgShLdGIxsY7AUABPRrgCABdDuQ5GC7DqPQCgbbJUAoRSUj+NIEig0YfyWUho1VBBBA//uQZB4ABZx5zfMakeAAAAmwAAAAF5F3P0w9GtAAACfAAAAAwLhMDmAYWMgVEG1U0FIGCBgXBXAtfMH10000EEEEEECUBYln03TTTdNBDZopopYvrTTdNa325mImNg3TTPV9q3pmY0xoO6bv3r00y+IDGid/9aaaZTGMuj9mpu9Mpio1dXrr5HERTZSmqU36A3CumzN/9Robv/Xx4v9ijkSRSNLQhAWumap82WRSBUqXStV/YcS+XVLnSS+WLDroqArFkMEsAS+eWmrUzrO0oEmE40RlMZ5+ODIkAyKAGUwZ3mVKmcamcJnMW26MRPgUw6j+LkhyHGVGYjSUUKNpuJUQoOIAyDvEyG8S5yfK6dhZc0Tx1KI/gviKL6qvvFs1+bWtaz58uUNnryq6kt5RzOCkPWlVqVX2a/EEBUdU1KrXLf40GoiiFXK///qpoiDXrOgqDR38JB0bw7SoL+ZB9o1RCkQjQ2CBYZKd/+VJxZRRZlqSkKiws0WFxUyCwsKiMy7hUVFhIaCrNQsKkTIsLivwKKigsj8XYlwt/WKi2N4d//uQRCSAAjURNIHpMZBGYiaQPSYyAAABLAAAAAAAACWAAAAApUF/Mg+0aohSIRobBAsMlO//Kk4soosy1JSFRYWaLC4qZBYWFRGZdwqKiwkNBVmoWFSJkWFxX4FFRQWR+LsS4W/rFRb/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////VEFHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU291bmRib3kuZGUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMjAwNGh0dHA6Ly93d3cuc291bmRib3kuZGUAAAAAAAAAACU="
    );
    snd.play();
}


function delegatedBeep() {
  setTimeout(()=>{
    beep();
  }, 0.01);
}

// --> UTILS END


var zxing = ZXing();
var state = {
  scanActive: null,
  targetElement: null,
  codeCallback: renderCodeToTargetElement,
  values: []
}

function scanBarcode(canvasElement, format) {
    var imgWidth = canvasElement.width;
    var imgHeight = canvasElement.height;
    var imageData = canvasElement.getContext('2d').getImageData(0, 0, imgWidth, imgHeight);
    var sourceBuffer = imageData.data;
    if (sourceBuffer.byteLength < 1228800*4) {
      var buffer = zxing._malloc(sourceBuffer.byteLength);
      zxing.HEAPU8.set(sourceBuffer, buffer);
      var result = zxing.readBarcodeFromPixmap(buffer, imgWidth, imgHeight, true, format);
      zxing._free(buffer);
      return result;
    } else {
      console.log(sourceBuffer.byteLength)
    }
}

function flashBorder() {
  document.querySelector(".zxing-canvas-container").classList.add("flash");
  setTimeout(function() {
    document.querySelector(".zxing-canvas-container").classList.remove("flash")
  }, 500)
}


function renderCodeInOutputMessage(code) {
  var outputContainer = document.getElementById("output");
  var outputMessage = document.getElementById("outputMessage");
  var outputData = document.getElementById("outputData");

  outputContainer.hidden = false;

  if (code.error) {
    outputMessage.hidden = true;
    outputData.parentElement.hidden = false;
    outputData.innerText = code.error;
  } else if(code.format) {
    outputMessage.hidden = true;
    outputData.parentElement.hidden = false;
    outputData.innerText = code.text;
  } else {
    outputMessage.hidden = false;
    outputData.parentElement.hidden = true;
  }
}

function renderCodeToTargetTextArea(code) {
  if (code.format) {
    var currentValue = state.targetElement.value.trim();
    if (!currentValue.match(code.text)) { // tried escapeProblemFreeMatch() but too slow for Safari atm, out of scope anyhow
      currentValue = code.text + "\n" + currentValue;
      flashBorder();
      delegatedBeep();
    }
    state.targetElement.value = currentValue
  }
}

function renderCodeToTargetElement(code) {
  if (state.targetElement.localName == "textarea") {
    renderCodeToTargetTextArea(code);
  }
}

// too slow for safari (was a workaround for bad QR codes, but out of scope for now anyhow)
function escapeProblemFreeMatch(text, target) {
  return text.replaceAll(/[\"\:\?\.\/]/g,"").match(target.replaceAll(/[\"\:\?\.\/]/g,""))
}

function initializeScanner() {
  var video = document.createElement("video");

  video.width = 800;
  video.height = 800;

  var canvasElement = document.getElementById("zxing-canvas");
  var canvas = canvasElement.getContext("2d");
  var loadingMessage = document.getElementById("loadingMessage");

  function scanFrame() {
    if (video.readyState === video.HAVE_ENOUGH_DATA) {
      canvasElement.hidden = false;

      canvasElement.height = video.videoHeight;
      canvasElement.width = video.videoWidth;
      canvas.drawImage(video, 0, 0, canvasElement.width, canvasElement.height);

      var format = "";
      try {
        if (state.scanActive) {
          var code = scanBarcode(canvasElement, format);
          setTimeout(function(){
            state.codeCallback(code)
          },1);
        }
      }
      catch (error) {
        // state.scanActive = false;
        // requestAnimationFrame(scanFrame);
      }
    }
    requestAnimationFrame(scanFrame);
  }

  // Use facingMode: environment to attemt to get the front camera on phones
  navigator.mediaDevices.getUserMedia({ video: { facingMode: "environment" } }).then(function(stream) {
    video.srcObject = stream;
    video.setAttribute("playsinline", true); // required to tell iOS safari we don't want fullscreen
    video.play();
    requestAnimationFrame(scanFrame);
  });
}

let startScan = function(event) {
  state.scanActive = true;
  state.targetElement = document.querySelector("*[data-zxing-output-target]");
  document.querySelector(".zxing-canvas-container").classList.add("active");
  initializeScanner();
}
let stopScan = function(event) {
  document.querySelector(".zxing-canvas-container").classList.remove("active")
  document.querySelector(".zxing-canvas-container").classList.remove("flash")
  state.scanActive = false;
}

document.addDelegatedEventListener("touchstart", "#zxing-canvas", startScan)
document.addDelegatedEventListener("touchend", "#zxing-canvas", stopScan)
document.addDelegatedEventListener("mousedown", "#zxing-canvas", startScan)
document.addDelegatedEventListener("mouseup", "#zxing-canvas", stopScan)
// document.addDelegatedEventListener("focusin", "*[data-zxing-output-target]", startScan)
// document.addDelegatedEventListener("focusout", "*[data-zxing-output-target]", stopScan)

// document.

// autofocus workaround (no focusin event is fired)
function autoFocus() {
  var target = autoFocusElement = document.querySelector("[data-zxing-output-target][autofocus]");
  if(target) {
    var evt = new Event("focusin", {"bubbles":true, "cancelable":false});
    target.dispatchEvent(evt);
  }
}

// window.addEventListener("load", autoFocus)
// document.addEventListener("turbolinks:load", autoFocus)


