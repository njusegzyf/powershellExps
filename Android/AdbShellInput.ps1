
<# adb shell input
Usage: input [<source>] <command> [<arg>...]

The sources are:
      trackball
      joystick
      touchnavigation
      mouse
      keyboard
      gamepad
      touchpad
      dpad
      stylus
      touchscreen

The commands and default sources are:
      text <string> (Default: touchscreen)
      keyevent [--longpress] <key code number or name> ... (Default: keyboard)
      tap <x> <y> (Default: touchscreen)
      swipe <x1> <y1> <x2> <y2> [duration(ms)] (Default: touchscreen)
      press (Default: trackball)
      roll <dx> <dy> (Default: trackball)
#>

$psFolder = if ($PSScriptRoot) { $PSScriptRoot } else { 'C:/Tools/PS/Android' }
."$psFolder/AdbCommon.ps1"

function Start-AdbSehllInputCommand([String[]]$arguments) {
  Start-AdbCommand -arguments (@('shell', 'input') + $arguments)
}

function Start-AdbSehllInputKeyeventCommand([String]$argument) {
  Start-AdbCommand -arguments 'shell', 'input', 'keyevent', $arguments
}

function Start-AdbSehllInputTapCommand([String]$x, [String]$y) {
  Strat-AdbCommand -arguments 'shell', 'input', 'keyevent', $x, $y
}

function Start-AdbSehllInputSwipeCommand([String[]]$arguments) {
  Start-AdbCommand -arguments (@('shell', 'input', 'swipe') + $arguments)
  # Start-AdbSehllInputCommand -arguments (@('swipe') + $arguments)
}
