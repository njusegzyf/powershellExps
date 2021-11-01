
$scriptFileDirPath = if ($PSScriptRoot) { $PSScriptRoot } else { 'C:/Tools/PS/Android' }
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



function Get-CacheFolderSubfolders($dataFolder, $subfolders) {
  $subfolders | ForEach-Object { "$dataFolder/cache/$_" }
}

function Get-FilesFolderSubfolders($dataFolder, $subfolders) {
  $subfolders | ForEach-Object { "$dataFolder/files/$_" }
}



# Functions for common Ali and Tecent items

function Get-AliLogFolderPaths($dirPath) {
  [String[]]$aliLogFolderNames = @('logs', 'tnetlogs', 'tlog_v9')
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

function Get-JdAppCommonUselessFolderPaths($folder) {
  @("$folder/files/backup", "$folder/files/log", "$folder/files/logs", "$folder/files/VideoCache") +
    (Get-TencentCommonLogFolderPaths "$folder/files")
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

function Add-FakeFile($filePath) { $Global:fakeFiles += $filePath }
function Add-FakeNonEmptyFile($filePath) { $Global:fakeNonEmptyFiles += $filePath }
function Add-FakeDirectory($dirPath) { $Global:fakeDirectories += $dirPath }
function Add-FakeNonEmptyDirectory($dirPath) { $Global:fakeNonEmptyDirectories += $dirPath }

function Clear-AllFakeItem() {
  $Global:fakeFiles = @()
  $Global:fakeNonEmptyFiles = @()
  $Global:fakeDirectories = @()
  $Global:fakeNonEmptyDirectories = @()
}

function Get-AllFakeItems() { 
  $Global:fakeFiles + $Global:fakeNonEmptyFiles + $Global:fakeDirectories + $Global:fakeNonEmptyDirectories 
}

function Log-NewFakeFile($fakeFile) { Write-Host "Make fake file: $fakeFile." }
function Log-NewFakeNonEmptyFile($fakeFile) { Write-Host "Make non-empty fake file: $fakeFile." }
function Log-NewFakeDirectory($fakeDirectory) { Write-Host "Make fake directory: $fakeDirectory." }
function Log-NewFakeNonEmptyDirectory($fakeDirectory) { Write-Host "Make non-empty fake directory: $fakeDirectory." }

function New-AllFakeItem() {
  foreach ($fakeFile in $Global:fakeFiles) {
    Log-NewFakeFile $fakeFile
    Remove-AndroidDirectoryOrFile $fakeFile
    New-AndroidEmptyFile $fakeFile
  }

  foreach ($fakeFile in $Global:fakeNonEmptyFiles) {
    Log-NewFakeNonEmptyFile $fakeFile
    Remove-AndroidDirectoryOrFile $fakeFile
    New-AndroidNonEmptyFile $fakeFile
  }

  foreach ($fakeDirectory in $Global:fakeDirectories) {
    Log-NewFakeDirectory $fakeDirectory 
    Remove-AndroidDirectoryOrFile $fakeDirectory
    New-AndroidDirectory $fakeDirectory
  }

  foreach ($fakeDirectory in $Global:fakeNonEmptyDirectories) {
    Log-NewFakeNonEmptyDirectory $fakeDirectory 
    Remove-AndroidDirectoryOrFile $fakeDirectory
    New-AndroidNonEmptyDirectory $fakeDirectory
  }
}



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

New-FakeItemsIfAppInstalled -appName 'taobao' -newFakeItemsScript { Param($taobaoPackageName) 
  $Global:fakeFiles += Get-AliLogFolderPaths "$internalStorageAndroidDataPath/$taobaoPackageName/files"
  $Global:fakeFiles += "$internalStorageAndroidDataPath/$taobaoPackageName/cache/apkupdate"
  $Global:fakeFiles += "$internalStorageAndroidDataPath/$taobaoPackageName/cache/video-cache"
  $Global:fakeFiles += "$internalStorageRootPath/.com.taobao.dp"
}

# 天猫
New-FakeItemsIfAppInstalled -appName 'tmall' -newFakeItemsScript { Param($tmallPackageName) 
  $Global:fakeFiles += Get-AliLogFolderPaths "$internalStorageAndroidDataPath/$tmallPackageName/files"
  $Global:fakeFiles += "$internalStorageAndroidDataPath/$tmallPackageName/files/ad"
  $Global:fakeFiles += "$internalStorageAndroidDataPath/$tmallPackageName/cache/video-cache"
}

# 一淘
$etaoPackageName = $appToPackageNameMap['etao']
$fakeFiles += Get-AliLogFolderPaths "$internalStorageAndroidDataPath/$etaoPackageName/files"
$fakeFiles += "$internalStorageAndroidDataPath/$etaoPackageName/files/WXOPENIM"

# 淘宝特价版
New-FakeItemsIfAppInstalled -appName 'litetao' -newFakeItemsScript { Param($litetaoPackageName) 
  $Global:fakeFiles += "$internalStorageAndroidDataPath/$litetaoPackageName/files/tlog_v9"
}

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

# 阿里云盘
New-FakeItemsIfAppInstalled -appName 'aliYunpan' -newFakeItemsScript { Param($aliYunpanPackageName) 
  $fakeFiles += "$internalStorageAndroidDataPath/$aliYunpanPackageName/files/logs"
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
New-FakeItemsIfAppInstalled -appName 'tencentNews' -newFakeItemsScript { Param($tencentNewsPackageName)
  $fakeFiles += Get-TencentNewsLogFolderPaths "$internalStorageAndroidDataPath/$tencentNewsPackageName/files"
  $fakeFiles += "$internalStorageAndroidDataPath/$tencentNewsPackageName/files/ad"
}

# 腾讯新闻lite
New-FakeItemsIfAppInstalled -appName 'tencentNewsLite' -newFakeItemsScript { Param($tencentNewsLitePackageName)
  $fakeFiles += Get-TencentNewsLogFolderPaths "$internalStorageAndroidDataPath/$tencentNewsLitePackageName/files"
  $fakeFiles += "$internalStorageAndroidDataPath/$tencentNewsLitePackageName/files/ad"
}



# JD

# 京东商城
New-FakeItemsIfAppInstalled -appName 'jdMall' -newFakeItemsScript { Param($jdMallPackageName)
  $jdMallDataFolder = "$internalStorageAndroidDataPath/$jdMallPackageName"
  $Global:fakeFiles += Get-JdAppCommonUselessFolderPaths($jdMallDataFolder)
  $Global:fakeFiles += "$jdMallDataFolder/files/wxa/xlog"
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
  $Global:fakeFiles += Get-JdAppCommonUselessFolderPaths($jdJrDataFolder)
}

# 京东阅读
New-FakeItemsIfAppInstalled -appName 'jdReader' -newFakeItemsScript { Param($jdReaderPackageName) 
  $jdReaderDataFolder = "$internalStorageAndroidDataPath/$jdReaderPackageName"
  $Global:fakeFiles += Get-JdAppCommonUselessFolderPaths($jdReaderDataFolder)
  $Global:fakeFiles += "$jdReaderDataFolder/cache/cache/apk"
  if ($isMiPhone) { $Global:fakeFiles += "$jdReaderDataFolder/files/MiPushLog" }
}

# 京喜（京东拼购）
New-FakeItemsIfAppInstalled -appName 'jdPingou' -newFakeItemsScript { Param($jdPingouPackageName)
  $jdPingouDataFolder = "$internalStorageAndroidDataPath/$jdPingouPackageName"
  $Global:fakeFiles += Get-JdAppCommonUselessFolderPaths($jdPingouDataFolder)
  $Global:fakeFiles += "$jdPingouDataFolder/cache" # 存放升级包
}

# 京东极速版
New-FakeItemsIfAppInstalled -appName 'jdLite' -newFakeItemsScript { Param($jdLitePackageName)
  $jdLiteDataFolder = "$internalStorageAndroidDataPath/$jdLitePackageName"
  $Global:fakeFiles += Get-JdAppCommonUselessFolderPaths($jdLiteDataFolder)
}



# Others

# 淘粉吧
New-FakeItemsIfAppInstalled -appName 'taofen8' -newFakeItemsScript { Param($packageName)
  $Global:fakeFiles += "$internalStorageRootPath/libs"
}

# 什么值得买
New-FakeItemsIfAppInstalled -appName 'smzdm' -newFakeItemsScript { Param($packageName)
  $smzdmRootFolderName = 'SMZDM'
  $newFakeFiles = 
    @("$internalStorageRootPath/.gs_file", 
      "$internalStorageRootPath/.gs_fs0",
      "$internalStorageAndroidDataPath/$packageName/cache/okhttp",
      "$internalStorageAndroidDataPath/$packageName/files/log",
      "$internalStorageAndroidDataPath/$packageName/files/tencent")
  Add-FakeFile $newFakeFiles
}

# 云闪付
New-FakeItemsIfAppInstalled -appName 'unionPay' -newFakeItemsScript { Param($packageName)
  Add-FakeFile (Get-TencentCommonLogFolderPaths "$internalStorageAndroidDataPath/$packageName/files")
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
  $Global:fakeFiles += "$internalStorageRootPath/netease/cloudmusic/Cache/NewApk"
}

# X浏览器
New-FakeItemsIfAppInstalled -appName 'xBrowser' -newFakeItemsScript { Param($xBrowserPackageName)
  $Global:fakeFiles += Get-TencentCommonLogFolderPaths "$internalStorageAndroidDataPath/$xBrowserPackageName/files"
}

# 抖音极速版
New-FakeItemsIfAppInstalled -appName 'tiktokLite' -newFakeItemsScript { Param($tiktokLitePackageName)
  $Global:fakeFiles += "$internalStorageAndroidDataPath/$tiktokLitePackageName/files/logs"
  $Global:fakeFiles += "$internalStorageAndroidDataPath/$tiktokLitePackageName/files/MiPushLog"
}

# 快手
New-FakeItemsIfAppInstalled -appName 'kaishou' -newFakeItemsScript { Param($kaishouPackageName)
  $kaishoDataFolder = "$internalStorageAndroidDataPath/$kaishouPackageName"
  $Global:fakeFiles += Get-CacheFolderSubfolders -dataFolder $kaishoDataFolder `
    -subfolders '.ad_apk_cache', '.ad_kuaixiang_cache', '.game_apk_cache', '.video_cache'  
  $Global:fakeFiles += Get-FilesFolderSubfolders -dataFolder $kaishoDataFolder `
    -subfolders '.hodor', '.t_log', '.game_apk_cache'
}

# 快手极速版
New-FakeItemsIfAppInstalled -appName 'kaishouNebula' -newFakeItemsScript { Param($kaishouNebulaPackageName)
  $kaishouNebulaDataFolder = "$internalStorageAndroidDataPath/$kaishouNebulaPackageName"
  $Global:fakeFiles += Get-CacheFolderSubfolders -dataFolder $kaishouNebulaDataFolder `
    -subfolders '.ad_apk_cache', '.ad_kuaixiang_cache', '.game_apk_cache', '.video_cache'  
  $Global:fakeFiles += Get-FilesFolderSubfolders -dataFolder $kaishouNebulaDataFolder `
    -subfolders '.hodor', '.t_log', '.game_apk_cache'
}

# 动漫之家
New-FakeItemsIfAppInstalled -appName 'dmzj' -newFakeItemsScript { Param($packageName)
  $Global:fakeFiles += "$internalStorageAndroidDataPath/$packageName/files/Log"
  $Global:fakeFiles += "$internalStorageAndroidDataPath/$packageName/cache"
}



# 小米内置应用
if ($isMiPhone) {
  
  # 小米健康
  $fakeFiles += "$internalStorageAndroidDataPath/$($appToPackageNameMap['miHealth'])/cache/log"

} 



New-AllFakeItem
Clear-AllFakeItem
