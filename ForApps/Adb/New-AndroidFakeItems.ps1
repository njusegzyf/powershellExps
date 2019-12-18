
# $configRes =  .'~/Desktop/PS/ForApps/Adb/Config-AdbEnvironment.ps1'
if (-not (."$PSScriptRoot/Config-AdbEnvironment.ps1")) {
  throw "Failed to start adb server or can not linke to device."
}
# Now defined in `Config-AdbEnvironment.ps1` as global variable
# $internalStorageRootPath = '/storage/emulated/0'
# $internalStorageAndroidDataPath = '/storage/emulated/0/Android/Data'

. "$PSScriptRoot/AdbFileManagement.ps1"

$appToPackageNameMap = ."$PSScriptRoot/Get-AndroidPackageNames.ps1"

$allInstallAppPackageNames = Get-InstalledAndroidAppPackageNames

function Test-AndroidAppInstalledPrivate([String]$appName) {
  return Test-AndroidAppInstalled -appName $appName -installedAppPackageNames $allInstallAppPackageNames
} 



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

[String[]]$tencentCommonLogFolderNames = @('tbslog', 'tencent/tbs_live_log')

function Get-TencentCommonLogFolderPaths($dirPath) {
  $tencentCommonLogFolderNames | ForEach-Object { "$dirPath/$_" }
}


# Ali

# 淘宝
$taobaoPackageName = $appToPackageNameMap['taobao']
$fakeFiles += Get-AliLogFolderPaths "$internalStorageAndroidDataPath/$taobaoPackageName/files"
$fakeFiles += "$internalStorageAndroidDataPath/$taobaoPackageName/cache/apkupdate"
$fakeFiles += "$internalStorageRootPath/.com.taobao.dp"

# 一淘
$etaoPackageName = $appToPackageNameMap['etao']
$fakeFiles += Get-AliLogFolderPaths "$internalStorageAndroidDataPath/$etaoPackageName/files"
$fakeFiles += "$internalStorageAndroidDataPath/$etaoPackageName/files/WXOPENIM"

# 闲鱼
if (Test-AndroidAppInstalledPrivate 'idleFish') {
  $idleFishPackageName = $appToPackageNameMap['idleFish']
  $idleFishAndroidDataPath = "$internalStorageAndroidDataPath/$idleFishPackageName"
  $fakeFiles += Get-AliLogFolderPaths "$idleFishAndroidDataPath/files"
  $fakeFiles += "$idleFishAndroidDataPath/files/ad"
}

# UC
if (Test-AndroidAppInstalledPrivate 'uc') {
  $fakeFiles += "$internalStorageRootPath/com.UCMobile/ulog"
  $fakeDirectories += "$internalStorageRootPath/UCDownloads/novels/novels.log"
}

# 高德地图
if (Test-AndroidAppInstalledPrivate 'autoNaviMap') {
  $fakeFiles += "$internalStorageRootPath/autonavi/log"
}

# 优酷
if (Test-AndroidAppInstalledPrivate 'youku') {
  $fakeFiles += Get-AliLogFolderPaths "$internalStorageAndroidDataPath/com.youku.phone/files"
  $fakeFiles += "$internalStorageRootPath/.im"
}

# 飞猪
if (Test-AndroidAppInstalledPrivate 'aliTrip') {
  $aliTripPackageName = 'com.taobao.trip'
  $fakeFiles += "$internalStorageRootPath/$aliTripPackageName/WXOPENIM"
}



# Tencent
$tencentRootFolderName = 'tencent'
$fakeFiles += "$internalStorageRootPath/$tencentRootFolderName/beacon"
$fakeFiles += "$internalStorageRootPath/$tencentRootFolderName/msflogs"
$fakeFiles += "$internalStorageRootPath/$tencentRootFolderName/mta"
# $fakeFiles += "$internalStorageRootPath/$tencentRootFolderName/tbs"
$fakeFiles += "$internalStorageRootPath/$tencentRootFolderName/tbs_live_log"
$fakeFiles += "$internalStorageRootPath/$tencentRootFolderName/tpush"
$fakeFiles += "$internalStorageRootPath/$tencentRootFolderName/wtlogin"
$fakeFiles += "$internalStorageRootPath/$tencentRootFolderName/XG"

# 微信
$microMsgFolderName = 'MicroMsg'
$microMsgFolder = "$internalStorageRootPath/$tencentRootFolderName/$microMsgFolderName"
$fakeFiles += "$microMsgFolder/CheckResUpdate"
$fakeFiles += "$microMsgFolder/wxanewfiles"
$fakeFiles += "$microMsgFolder/xlog"
$fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['microMsg'])/files/tbslog"

# 腾讯新闻
$fakeFiles += Get-TencentNewsLogFolderPaths "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNews'])/files"
$fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNews'])/files/ad"

# 腾讯新闻lite
$fakeFiles += Get-TencentNewsLogFolderPaths "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNewsLite'])/files"
$fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNewsLite'])/files/ad"


# JD

# 京东商城

# 京东金融
$fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['jdJr'])/files/logs"
$fakeFiles += Get-TencentCommonLogFolderPaths "$internalStorageAndroidDataPath/$($appToPackageNameMap['jdJr'])/files"
# $fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['jdJr'])/files/tbslog"
# $fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['jdJr'])/files/Tencent/tbs_live_log"

# 京东阅读
if (Test-AndroidAppInstalledPrivate 'jdReader') {
  $fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['jdReader'])/files/logs"
  $fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['jdReader'])/files/tbslog"
}

# 京喜（京东拼购）
if (Test-AndroidAppInstalledPrivate 'jdPingou') {
  $fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['jdPingou'])/files/tbslog"
}


# Others

# 淘粉吧
$fakeFiles += "$internalStorageRootPath/libs"

# 什么值得买
$smzdmRootFolderName = 'SMZDM'
$smadmPackageName = $appToPackageNameMap['smzdm']
$fakeFiles += "$internalStorageRootPath/.gs_file"
$fakeFiles += "$internalStorageRootPath/.gs_fs0"
$fakeFiles += "$internalStorageAndroidDataPath/$smadmPackageName/cache/okhttp"

# 云闪付
if (Test-AndroidAppInstalledPrivate 'unionPay') {
  $fakeFiles += Get-TencentCommonLogFolderPaths "$internalStorageAndroidDataPath/$($appToPackageNameMap['unionPay'])/files"
}



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
