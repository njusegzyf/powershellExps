#@see [[https://blog.csdn.net/good123_2014/article/details/79107765 ]]

$psFolder = if ($PSScriptRoot) { "$PSScriptRoot/.." } else { 'C:/Tools/PS/Android' }

."$psFolder/Config-AdbEnvironment.ps1"
."$psFolder/AdbShellInput.ps1"

# $arguments = @('shell', 'input', 'keyevent', 'KEYCODE_POWER')
# adb @arguments
Start-AdbSehllInputKeyeventCommand 'KEYCODE_POWER'
