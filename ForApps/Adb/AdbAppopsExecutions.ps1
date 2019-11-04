
$psFolder = if ($PSScriptRoot) { $PSScriptRoot } else { '~/Desktop/PS/ForApps/Adb' }

."$psFolder/Config-AdbEnvironment.ps1"
$appToPackageNameMap = ."$psFolder/Get-AndroidPackageNames.ps1"
."$psFolder/AdbAppops.ps1"

$IS_DEBUG = $true


# For RUN_IN_BACKGROUND (后台运行服务权限)

function Set-AndroidAppRunInBackgroundIgnore([String]$appName) {
  Set-AndroidApposIgnore $appName 'RUN_IN_BACKGROUND'
}

$appsToDisableRunInBackground = 
  @('com.android.stk', # sim卡应用
    'com.android.nfc',
    'com.android.printspooler',

    # 阿里系app
    'com.taobao.taobao',
    'com.tmall.wireless',
    'com.taobao.etao',
    'com.eg.android.AlipayGphone',
    'com.taobao.trip',             # 飞猪
    'com.autonavi.minimap',        # 高德地图
    'com.UCMobile',
    'com.taobao.mobile.dipei',     # 口碑
    'com.youku.phone',

    # 腾讯系app
    # 'com.tencent.mm'                # 微信
    'com.tencent.tws.gdevicemanager', # 真时运动 
    'com.tencent.news',               # 腾讯新闻
    'com.tencent.news.lite',

    'com.xiaomi.hm.health', 

    'com.manmanbuy.bijia',
    'com.leixun.taofen8',
    'com.wsloan',
    'com.wljr.wanglibao',

    # 头条系app
    'com.ss.android.article.news', # 今日头条
    'com.ss.android.article.lite', 
    'com.ss.android.ugc.aweme',    # 抖音
    'my.maya.android',             # 多闪

    'com.unionpay',                # 银联云闪付

    # HTC
    'com.nero.android.htc.sync',
    'com.htc.android.htcsetupwizard',
    'com.htc.feedback',
    'com.htc.sense.weiboplugin',
    'com.htc.updater')

foreach ($app in $appsToDisableRunInBackground) {
  Set-AndroidAppRunInBackgroundIgnore $app
}

# $appsToEnableRunInBackground = @('com.tencent.tws.gdevicemanager')
# foreach ($app in $appsToEnableRunInBackground) { 
#   Set-AndroidApposAllow($app, 'RUN_IN_BACKGROUND') 
# }



# For LOCATION (定位权限)

$allLocationOps = @('COARSE_LOCATION', 'FINE_LOCATION', 'GPS')

$appsToDisableLocationOps = 
  @($appToPackageNameMap['taobao'],
    $appToPackageNameMap['etao'])

foreach ($app in $appsToDisableLocationOps) {
  foreach ($op in $allLocationOps) {
    Set-AndroidApposIgnore $app $op
  }
}
