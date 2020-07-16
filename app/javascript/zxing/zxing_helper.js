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

// play a simple beep
let gain;
var audioContext;

const prepareAudioContext = function() {
  const AudioContext = window.AudioContext || window.webkitAudioContext;
  if (typeof AudioContext !== "undefined" && typeof audioContext === "undefined") {
    audioContext = new AudioContext();
    // create empty buffer
    let buffer = audioContext.createBuffer(1, 1, 22050);
    let source = audioContext.createBufferSource();
    source.buffer = buffer;

    // connect to output (your speakers)
    source.connect(audioContext.destination);

    audioContext.createOscillator();
    gain = audioContext.createGain();
    let oscillator = audioContext.createOscillator();

    oscillator.connect(gain);
    oscillator.frequency.value = 880;
    oscillator.type = 0; //sine
    gain.connect(audioContext.destination);
    gain.gain.value = 0;
    oscillator.start(audioContext.currentTime);
  }
}



function beep(vol, duration){
  prepareAudioContext(); // initializes if it hasn't already (as late as possible to circumvent blocking audio)

  gain.gain.value = vol;
  setTimeout(function() { gain.gain.value = 0 }, duration)
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
    if (sourceBuffer.byteLength <= imgWidth*imgHeight*4) {
      var buffer = zxing._malloc(sourceBuffer.byteLength);
      zxing.HEAPU8.set(sourceBuffer, buffer);
      var result = zxing.readBarcodeFromPixmap(buffer, imgWidth, imgHeight, true, format);
      window.debug(`${result.format} - ${result.text}`)
      zxing._free(buffer);
      sourceBuffer = null;
      buffer = null;
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
      beep(0.1, 150);
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
  document.getElementById("start-zxing-scanner-button").classList.add('hide');
  document.getElementById("zxing-canvas").classList.remove('hide');

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
          state.codeCallback(code)
        }
      }
      catch (error) {
      }
    }
    requestAnimationFrame(scanFrame);
  }

  // Use facingMode: environment to attemt to get the front camera on phones
  navigator.mediaDevices.getUserMedia({ audio: false, video: { facingMode: "environment" } }).then(function(stream) {
    video.srcObject = stream;
    video.setAttribute("playsinline", true); // required to tell iOS safari we don't want fullscreen
    video.play();
    requestAnimationFrame(scanFrame);
  });
}

let startScan = function(event) {
  event.preventDefault();
  event.stopPropagation();

  state.scanActive = true;
  state.targetElement = document.querySelector("*[data-zxing-output-target]");
  state.targetElement.blur();
  document.querySelector(".zxing-canvas-container").focus();
  document.querySelector(".zxing-canvas-container").classList.add("active");
}

let stopScan = function(event) {
  document.querySelector(".zxing-canvas-container").classList.remove("active")
  document.querySelector(".zxing-canvas-container").classList.remove("flash")
  state.scanActive = false;
}

document.addDelegatedEventListener("contextmenu", "#zxing-canvas", function(e) { console.log("contextmenu"); e.preventDefault(); e.stopPropagation(); return false; })

document.addDelegatedEventListener("touchstart", "[data-action='start-zxing-scanner']", initializeScanner)
document.addDelegatedEventListener("mousedown", "[data-action='start-zxing-scanner']", initializeScanner)

document.addDelegatedEventListener("touchstart", "#zxing-canvas", startScan)
document.addDelegatedEventListener("touchend", "#zxing-canvas", stopScan)
document.addDelegatedEventListener("mousedown", "#zxing-canvas", startScan)
document.addDelegatedEventListener("mouseup", "#zxing-canvas", stopScan)

let beepOnEnter = function(event) {
  if (`${event.code}`.match(/Enter/)) {
    beep(0.1, 150);
  }
}
document.addDelegatedEventListener("keyup", "*[data-zxing-output-target]", beepOnEnter)
