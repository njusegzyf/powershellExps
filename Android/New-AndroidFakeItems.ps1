
$scriptFileDirPath = if ($PSScriptRoot) { $PSScriptRoot } else { '~/Desktop/PS/Android' }
if (-not (."$scriptFileDirPath/Config-AdbEnvironment.ps1")) {
  throw "Failed to start adb server or can not linke to device."
}
# @note These variables are now defined in `Config-AdbEnvironment.ps1` as global variables.
# $internalStorageRootPath = '/storage/emulated/0'
# $internalStorageAndroidDataPath = '/storage/emulated/0/Android/Data'

# loads necessary scripts
. "$scriptFileDirPath/AdbFileManagement.ps1"
. "$scriptFileDirPath/AdbPhoneInfo.ps1"

$appToPackageNameMap = . "$scriptFileDirPath/Get-AndroidPackageNames.ps1"
$allInstallAppPackageNames = Get-InstalledAndroidAppPackageNames

function Test-AndroidAppInstalledPrivate([String]$appName) {
  return Test-AndroidAppInstalled -appName $appName -installedAppPackageNames $allInstallAppPackageNames
} 

function New-FakeItemsIfAppInstalled([String]$appName, [ScriptBlock]$newFakeItemsScript) {
  if (Test-AndroidAppInstalledPrivate $appName) {
    $appPackageName = $appToPackageNameMap[$appName]
    $newFakeItemsScript.Invoke($appPackageName)
  }
}



# Functions for common Ali and Tecent items

function Get-AliLogFolderPaths($dirPath) {
  [String[]]$aliLogFolderNames = @('logs', 'tnetlogs')
  $aliLogFolderNames | ForEach-Object { "$dirPath/$_" }
  # $aliLogFolderNames | Select-Object -Property @{ n = 'value'; e = { "$dirPath/$_" } } | Select-Object -ExpandProperty 'value'
}

function Get-TencentNewsLogFolderPaths($dirPath) {
  [String[]]$tencentNewsLogFolderNames = @('log', 'log4log', 'netlog', 'online',  'online_patch', 'onlinelog', 'runtimelog', 'gol4gol', 'online4Ad', 'online4Apm', 'online4Audio' 
    'onlinelog4Ad', 'online4Channel', 'onlinelog4Channel', 'online4video', 'onlinelog4video', 'online4JsApi', 'online_patch')
  $tencentNewsLogFolderNames | ForEach-Object { "$dirPath/$_" }
}


function Get-TencentCommonLogFolderPaths($dirPath) {
  [String[]]$tencentCommonLogFolderNames = @('tbslog', 'tencent') # 'tencent/tbs_live_log', 'tencent/tbs_common_log'
  $tencentCommonLogFolderNames | ForEach-Object { "$dirPath/$_" }
}

function Get-JdAppCommonFakeFolderPaths($folder) {
  "$folder/files/backup", "$folder/files/logs", (Get-TencentCommonLogFolderPaths "$folder/files")
  # $fakeFiles += "$jdJrDataFolder/files/tbslog", "$jdJrDataFolder/files/Tencent/tbs_live_log"
}



# Flags
$isMiPhone = $false
$isMeizuPhone = $false
$phoneBrad = Get-AndroidDeviceBrand
if ($phoneBrad -eq 'Redmi') {
  $isMiPhone = $true
} elseif ($phoneBrad -eq 'Meizu') {
  $isMeizuPhone = $true
}



[String[]]$fakeFiles = @()
[String[]]$fakeNonEmptyFiles = @()
[String[]]$fakeDirectories = @()
[String[]]$fakeNonEmptyDirectories = @()

# function Add-FakeFile($filePath) { $Global:fakeFiles += $filePath }
# function Add-FakeNonEmptyFile($filePath) { $Global:fakeNonEmptyFiles += $filePath }
# function Add-FakeDirectory($dirPath) { $Global:fakeDirectories += $dirPath }
# function Add-FakeNonEmptyDirectory($dirPath) { $Global:fakeNonEmptyDirectories += $dirPath }

function Clear-AllFakeItems() {
  $Global:fakeFiles = @()
  $Global:fakeNonEmptyFiles = @()
  $Global:fakeDirectories = @()
  $Global:fakeNonEmptyDirectories = @()
}

function Get-AllFakeItems() { $Global:fakeFiles + $Global:fakeNonEmptyFiles + $Global:fakeDirectories + $Global:fakeNonEmptyDirectories }



# common folders in internal storage root
$fakeFiles += "$internalStorageRootPath/backup"
$fakeFiles += "$internalStorageRootPath/debug"
$fakeFiles += "$internalStorageRootPath/ByteDownload"

if ($isMiPhone) {
  $fakeFiles += "$internalStorageRootPath/miad"
}


# Ali

# Alipay
$isDisableAlipayNebulaDownload = $true
$alipayPackageName = $appToPackageNameMap['alipay']
$alipayRootFolderPath = "$internalStorageRootPath/alipay/$alipayPackageName"

$fakeFiles += "$internalStorageAndroidDataPath/$alipayPackageName/files/com.alipay.android.phone.openplatform/downloads"
$fakeFiles += "$internalStorageAndroidDataPath/$alipayPackageName/files/emojiFiles/__MACOSX"
$fakeFiles += "$internalStorageAndroidDataPath/$alipayPackageName/files/lottie/__MACOSX"
$fakeFiles += "$internalStorageAndroidDataPath/$alipayPackageName/files/MobileAiX/log"

$fakeFiles += "$alipayRootFolderPath/applogic"
$fakeFiles += "$alipayRootFolderPath/trafficlogic"
$fakeFiles += "$alipayRootFolderPath/emojiFiles/emoji"

if ($isDisableAlipayNebulaDownload) {
  $fakeFiles += "$alipayRootFolderPath/nebulaDownload/downloads"
  $fakeFiles += "$internalStorageAndroidDataPath/$alipayPackageName/nebulaDownload/downloads"
}

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
New-FakeItemsIfAppInstalled -appName 'aliTrip' -newFakeItemsScript { Param($aliTripPackageName) 
  $Global:fakeFiles += "$internalStorageRootPath/$aliTripPackageName/WXOPENIM"
}
# if (Test-AndroidAppInstalledPrivate 'aliTrip') {
#   $aliTripPackageName = 'com.taobao.trip'
#   $fakeFiles += "$internalStorageRootPath/$aliTripPackageName/WXOPENIM"
# }

# 虾米
New-FakeItemsIfAppInstalled -appName 'xiami' -newFakeItemsScript { Param($xiamiPackageName) 
  $fakeFiles += "$internalStorageAndroidDataPath/$xiamiPackageName/files/ad"
  $fakeFiles += "$internalStorageAndroidDataPath/$xiamiPackageName/files/Download"
  $fakeFiles += "$internalStorageAndroidDataPath/$xiamiPackageName/files/logs"
  $fakeFiles += "$internalStorageAndroidDataPath/$xiamiPackageName/files/tnetlogs"
}



# Tencent
$tencentRootFolderName = 'tencent'
$tencentFolder = "$internalStorageRootPath/$tencentRootFolderName"
# $fakeFiles += "$tencentFolder/tbs"
$fakeFiles += 'beacon', 'msflogs', 'mta', 'tbs_live_log', 'tpush', 'wtlogin', 'XG', 'OpenSDK/Logs' | ForEach-Object { "$tencentFolder/$_" }

# 微信
New-FakeItemsIfAppInstalled -appName 'microMsg' -newFakeItemsScript { Param($microMsgPackageName)
  $microMsgFolderName = 'MicroMsg'
  $microMsgFolder = "$internalStorageRootPath/$tencentRootFolderName/$microMsgFolderName"
  $Global:fakeFiles += 'CheckResUpdate', 'wxanewfiles', 'xlog' | ForEach-Object { "$microMsgFolder/$_" }

  $microMsgDataFolder = "$internalStorageAndroidDataPath/$microMsgPackageName"
  $Global:fakeFiles += 'tbslog', 'onelog', 'VideoCache' | ForEach-Object { "$microMsgDataFolder/files/$_" }
  $Global:fakeFiles += 'CheckResUpdate', 'xlog', 'crash', 'wagamefiles', 'wxvideocache' | ForEach-Object { "$microMsgDataFolder/MicroMsg/$_" } # , 'wxanewfiles'

  $allWxanewfilesFolderNames = List-AllAndroidChildItem "$microMsgDataFolder/MicroMsg/wxanewfiles"
  foreach ($wxanewfilesFolderName in $allWxanewfilesFolderNames) {
    $wxanewfilesFolderPath = "$microMsgDataFolder/MicroMsg/wxanewfiles/$wxanewfilesFolderName"
    if (Test-AndroidItem -dirPath $wxanewfilesFolderPath -itemName 'miniprogramLog') {
      # Write-Host $wxanewfilesFolderPath
      $Global:fakeFiles += "$wxanewfilesFolderPath/miniprogramLog"
    }
  }
}

# 腾讯新闻
$fakeFiles += Get-TencentNewsLogFolderPaths "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNews'])/files"
$fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNews'])/files/ad"

# 腾讯新闻lite
$fakeFiles += Get-TencentNewsLogFolderPaths "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNewsLite'])/files"
$fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['tencentNewsLite'])/files/ad"



# JD

# 京东商城
New-FakeItemsIfAppInstalled -appName 'jdMall' -newFakeItemsScript { Param($jdMallPackageName)
  $jdMallDataFolder = "$internalStorageAndroidDataPath/$jdMallPackageName"
  $Global:fakeFiles += Get-JdAppCommonFakeFolderPaths($jdMallDataFolder)
  if ($isMiPhone) { $Global:fakeFiles += "$jdMallDataFolder/files/MiPushLog" }

  foreach ($armartLuaItemPath in List-AllAndroidChildItemOfFullPath "$jdMallDataFolder/files/armart/1/lua") {
    $Global:fakeFiles += "$armartLuaItemPath/bg_video.mp4"
    Remove-AndroidDirectoryOrFile "$armartLuaItemPath/__MACOSX" | Out-Null
  }

  foreach ($armartModelItemPath in List-AllAndroidChildItemOfFullPath "$jdMallDataFolder/files/armart/1/model") {
    Remove-AndroidDirectoryOrFile "$armartModelItemPath/__MACOSX" | Out-Null
  } 
}

# 京东金融
New-FakeItemsIfAppInstalled -appName 'jdJr' -newFakeItemsScript { Param($jdJrPackageName)
  $jdJrDataFolder = "$internalStorageAndroidDataPath/$jdJrPackageName"
  $Global:fakeFiles += Get-JdAppCommonFakeFolderPaths($jdJrDataFolder)
}

# 京东阅读
New-FakeItemsIfAppInstalled -appName 'jdReader' -newFakeItemsScript { Param($jdReaderPackageName) 
  $jdReaderDataFolder = "$internalStorageAndroidDataPath/$jdReaderPackageName"
  $Global:fakeFiles += Get-JdAppCommonFakeFolderPaths($jdReaderDataFolder)
  $Global:fakeFiles += "$jdReaderDataFolder/cache/cache/apk"
  if ($isMiPhone) { $Global:fakeFiles += "$jdReaderDataFolder/files/MiPushLog" }
}

# 京喜（京东拼购）
New-FakeItemsIfAppInstalled -appName 'jdPingou' -newFakeItemsScript { Param($jdPingouPackageName)
  $jdPingouDataFolder = "$internalStorageAndroidDataPath/$jdPingouPackageName"
  $Global:fakeFiles += Get-JdAppCommonFakeFolderPaths($jdPingouDataFolder)
  $Global:fakeFiles += "$jdPingouDataFolder/cache" # 存放升级包
}

# 京东极速版
New-FakeItemsIfAppInstalled -appName 'jdLite' -newFakeItemsScript { Param($jdLitePackageName)
  $jdLiteDataFolder = "$internalStorageAndroidDataPath/$jdLitePackageName"
  $Global:fakeFiles += Get-JdAppCommonFakeFolderPaths($jdLiteDataFolder)
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

# PP体育
New-FakeItemsIfAppInstalled -appName 'ppSports' -newFakeItemsScript { Param($ppSportsPackageName) 
  $ppSportsDataFolder = "$internalStorageAndroidDataPath/$ppSportsPackageName"
  $Global:fakeFiles += "$ppSportsDataFolder/cache/com.suning.ppsport.ads.image"
  $Global:fakeFiles += "$ppSportsDataFolder/files/preLoadCache"
}

# 网易云音乐
New-FakeItemsIfAppInstalled -appName 'neteaseCloudMusic' -newFakeItemsScript { Param($neteaseCloudMusicPackageName)
  $neteaseCloudMusicDataFolder = "$internalStorageAndroidDataPath/$neteaseCloudMusicPackageName"
  $Global:fakeFiles += "$internalStorageRootPath/netease/cloudmusic/Cache/Cache/NewApk"
}



# 小米内置应用
if ($isMiPhone) {
  
  # 小米健康
  $fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['miHealth'])/cache/log"

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

Clear-AllFakeItems
