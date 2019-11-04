
$Global:adbPath = 'C:\Tools\AndroidPlatformTools'

# enable `adb` command
$Global:adbAppName = "$adbPath\adb.exe"
$Global:ExecutionContext.SessionState.Applications.Add($adbAppName)
Set-Alias -Name adb -Value $adbAppName -Scope Global

# export android and adb environments
[String]$Global:internalStorageRootPath = '/storage/emulated/0'
[String]$Global:internalStorageAndroidDataPath = '/storage/emulated/0/Android/Data'
[String]$Global:externalMediaStorageRootPath = '/storage/emulated/1'
[Boolean]$Global:isDebug = $true

adb start-server

return (adb get-state) -eq 'device'
