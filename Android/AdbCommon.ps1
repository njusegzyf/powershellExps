
function Start-AdbCommand([String[]]$arguments) {
  adb @arguments
}

function Start-AdbSehllCommand([String[]]$arguments) {
  Start-AdbCommand -arguments (@('shell') + $arguments)
}
