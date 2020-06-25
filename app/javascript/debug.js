window.debug = (output) => {
  const debugTextArea = document.getElementById("debug-output");
  if (debugTextArea) {
    debugTextArea.value = debugTextArea.value + `${(new Date).toISOString()} ${output}\n`
  }
}