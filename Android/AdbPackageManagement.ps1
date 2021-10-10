
function Remove-Apk([String]$packageName, [String]$user = '0') {
  adb shell pm uninstall --user $user $packageName
  # `-k` flag keeps the data and cache directories after the package is removed
}

function Disable-Apk([String]$packageName, [String]$user = '0') {
  adb shell pm disable-user --user $user $packageName
}
