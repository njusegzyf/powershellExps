
<# $ adb shell input --help

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

function Strat-AdbSehllInputCommand([String[]]$arguments) {
  Strat-AdbCommand -arguments (@('shell', 'input') + $arguments)
}

function Strat-AdbSehllInputKeyeventCommand([String]$argument) {
  Strat-AdbCommand -arguments (@('shell', 'input', 'keyevent') + @($arguments))
}

function Strat-AdbSehllInputTextCommand([String[]]$arguments) {
  Strat-AdbCommand -arguments (@('shell', 'input', 'text') + $arguments)
}

function Strat-AdbSehllInputTapCommand([String[]]$arguments) {
  Strat-AdbCommand -arguments (@('shell', 'input', 'tap') + $arguments)
}

function Strat-AdbSehllInputSwipeCommand([String[]]$arguments) {
  Strat-AdbCommand -arguments (@('shell', 'input', 'swipe') + $arguments)
}
