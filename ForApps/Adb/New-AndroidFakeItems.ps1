
# $configRes =  .'~/Desktop/PS/ForApps/Adb/Config-AdbEnvironment.ps1'
if (-not (."$PSScriptRoot/Config-AdbEnvironment.ps1")) {
  throw "Failed to start adb server or can not linke to device."
}
# Now defined in `Config-AdbEnvironment.ps1` as global variable
# $internalStorageRootPath = '/storage/emulated/0'
# $internalStorageAndroidDataPath = '/storage/emulated/0/Android/Data'

. "$PSScriptRoot/AdbFileManagement.ps1"

$appToPackageNameMap = ."$PSScriptRoot/Get-AndroidPackageNames.ps1"



[String[]]$fakeFiles = @()
[String[]]$fakeNonEmptyFiles = @()
[String[]]$fakeDirectories = @()
[String[]]$fakeNonEmptyDirectories = @()

# function Add-FakeFile($filePath) { $Global:fakeFiles += $filePath }
# function Add-FakeNonEmptyFile($filePath) { $Global:fakeNonEmptyFiles += $filePath }
# function Add-FakeDirectory($dirPath) { $Global:fakeDirectories += $dirPath }
# function Add-FakeNonEmptyDirectory($dirPath) { $Global:fakeNonEmptyDirectories += $dirPath }

function Get-AllFakeItems() { $Global:fakeFiles + $Global:fakeNonEmptyFiles + $Global:fakeDirectories + $Global:fakeNonEmptyDirectories }


[String[]]$aliLogFolderNames = @('logs', 'tnetlogs')

function Get-AliLogFolderPaths($dirPath) {
  $aliLogFolderNames | ForEach-Object { "$dirPath/$_" }
  # $aliLogFolderNames | Select-Object -Property @{ n = 'value'; e = { "$dirPath/$_" } } | Select-Object -ExpandProperty 'value'
}

[String[]]$tencentNewsLogFolderNames = @('log4log', 'netlog', 'onlinelog', 'onlinelog4Ad', 'onlinelog4Channel', 'onlinelog4video', 'runtimelog')

function Get-TencentNewsLogFolderPaths($dirPath) {
  $tencentNewsLogFolderNames | ForEach-Object { "$dirPath/$_" }
}



# Ali

# 一淘
$etaoPackageName = $appToPackageNameMap['etao']
$fakeFiles += Get-AliLogFolderPaths "$internalStorageAndroidDataPath/$etaoPackageName/files"
$fakeFiles += "$internalStorageAndroidDataPath/$etaoPackageName/files/WXOPENIM"

# 闲鱼
$idleFishPackageName = $appToPackageNameMap['idleFish']
$idleFishAndroidDataPath = "$internalStorageAndroidDataPath/$idleFishPackageName"
$fakeFiles += Get-AliLogFolderPaths "$idleFishAndroidDataPath/files"
$fakeFiles += "$idleFishAndroidDataPath/ad"

# UC
$fakeFiles += "$internalStorageRootPath/com.UCMobile/ulog"
$fakeDirectories += "$internalStorageRootPath/UCDownloads/novels/novels.log"

# 高德地图
$fakeFiles += "$internalStorageRootPath/autonavi/log"

# 优酷
$fakeFiles += Get-AliLogFolderPaths "$internalStorageAndroidDataPath/com.youku.phone/files"

# 飞猪
$aliTripPackageName = 'com.taobao.trip'
$fakeFiles += "$internalStorageRootPath/$aliTripPackageName/WXOPENIM"


# Tencent

# 腾讯新闻
$fakeFiles += Get-TencentNewsLogFolderPaths "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNews'])/files"

# 腾讯新闻lite
$fakeFiles += Get-TencentNewsLogFolderPaths "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNewsLite'])/files"


# Others

# 淘粉吧
$fakeFiles += "$internalStorageRootPath/libs"

# 什么值得买
$smzdmRootFolderName = 'SMZDM'
$smadmPackageName = $appToPackageNameMap['smzdm']
$fakeFiles += "$internalStorageRootPath/.gs_file"
$fakeFiles += "$internalStorageRootPath/.gs_fs0"
$fakeFiles += "$internalStorageAndroidDataPath/$smadmPackageName/cache/okhttp"



function Log-NewFakeFile($fakeFile) { Write-Host "Make fake file: $fakeFile." }
function Log-NewFakeNonEmptyFile($fakeFile) { Write-Host "Make non-empty fake file: $fakeFile." }
function Log-NewFakeDirectory($fakeDirectory) { Write-Host "Make fake directory: $fakeDirectory." }
function Log-NewFakeNonEmptyDirectory($fakeDirectory) { Write-Host "Make non-empty fake directory: $fakeDirectory." }

foreach ($fakeFile in $fakeFiles) {
  Log-NewFakeFile $fakeFile
  Remove-AndroidDirectoryOrFile $fakeFile
  New-AndroidEmptyFile $fakeFile
}

foreach ($fakeFile in $fakeNonEmptyFiles) {
  Log-NewFakeNonEmptyFile $fakeFile
  Remove-AndroidDirectoryOrFile $fakeFile
  New-AndroidNonEmptyFile $fakeFile
}

foreach ($fakeDirectory in $fakeDirectories) {
  Log-NewFakeDirectory $fakeDirectory 
  Remove-AndroidDirectoryOrFile $fakeDirectory
  New-AndroidDirectory $fakeDirectory
}

foreach ($fakeDirectory in $fakeNonEmptyDirectories) {
  Log-NewFakeNonEmptyDirectory $fakeDirectory 
  Remove-AndroidDirectoryOrFile $fakeDirectory
  New-AndroidNonEmptyDirectory $fakeDirectory
}
