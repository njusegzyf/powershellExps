# @see [[https://alliancex.org/shield/apps.html]]

$scriptFileDirPath = if ($PSScriptRoot) { $PSScriptRoot } else { 'C:/Tools/PS/Android' }
if (-not (."$scriptFileDirPath/Config-AdbEnvironment.ps1")) {
  throw "Failed to start adb server or can not linke to device."
}

. "$scriptFileDirPath/AdbFileManagement.ps1"
. "$scriptFileDirPath/AdbPackageManagement.ps1"

$appToPackageNameMap = ."$scriptFileDirPath/Get-AndroidPackageNames.ps1"
