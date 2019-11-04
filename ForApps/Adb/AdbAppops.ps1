# define common functions for Android appops
# @see [[https://blog.csdn.net/metasearch/article/details/71487308 AppOps 命令大全]]

. "$PSScriptRoot/Config-AdbEnvironment.ps1"
$appToPackageNameMap = ."$PSScriptRoot/Get-AndroidPackageNames.ps1"


<#
usage: appops set [--user <USER_ID>] <PACKAGE> <OP> <MODE>
       appops get [--user <USER_ID>] <PACKAGE> [<OP>]
       appops reset [--user <USER_ID>] [<PACKAGE>]
  <PACKAGE> 指定的应用包名
  <OP>      指定一项 AppOps 操作权限.
  <USER_ID> 指定系统用户ID(5.0引入的多用户)，如果未指定则默认当前登录用户(可选)
  <allow|ignore|deny|default> allow 放行权限，ignore表示拒绝权限，但是应用不知道自己的权限被拒绝，
                              deny明确拒绝权限，并告知应用权限申请被拒绝，default恢复默认的设置
#>

function Get-AndroidAppos([String]$appName, [String]$opName) {
  Invoke-Expression "adb shell cmd appops get $appName $opName"
}

function Reset-AndroidAppos([String]$appName, [String]$opName) {
  Invoke-Expression "adb shell cmd appops reset $appName $opName"
}

function Set-AndroidAppos([String]$appName, [String]$opName, [String]$value) {
  if ($IS_DEBUG) { Write-Host "Executes command: adb shell cmd appops set $appName $opName $value" }
  Invoke-Expression "adb shell cmd appops set $appName $opName $value"

  # Note: The following two have errors:
  # adb shell cmd appops set $appName $opName $value 
  # &$adbAppName shell cmd appops set $appName $opName $value
}

function Set-AndroidApposAllow([String]$appName, [String]$opName) {
  Set-AndroidAppos($appName, $opName, 'allow')
}

function Set-AndroidApposIgnore([String]$appName, [String]$opName) {
  Set-AndroidAppos($appName, $opName, 'ignore') 
}

function Set-AndroidApposDeny([String]$appName, [String]$opName) {
  Set-AndroidAppos($appName, $opName, 'deny') 
}

function Set-AndroidApposDefault([String]$appName, [String]$opName) {
  Set-AndroidAppos($appName, $opName, 'default') 
}





# AppOps 权限名称
<# 

COARSE_LOCATION 低精度定位
FINE_LOCATION 高精度定位
GPS

OP_READ_PHONE_STATE 读取电话信息权限
GET_USAGE_STATS 获取应用使用情况权限
ACCESS_NOTIFICATIONS 读取通知
WRITE_SETTINGS 修改设置
GET_ACCOUNTS 获取系统账户列表

READ_EXTERNAL_STORAGE 读取外置存储权限
WRITE_EXTERNAL_STORAGE 写入外置存储权限

RUN_IN_BACKGROUND 后台运行服务权限，禁用后系统将在应用进入后台几分钟后将后台服务杀死

READ_CONTACTS 读取通讯录
WRITE_CONTACTS 写入通讯录

READ_CALL_LOG 读取通话记录
WRITE_CALL_LOG 写入通话记录
CALL_PHONE 拨打电话
PROCESS_OUTGOING_CALLS 处理(拦截)外拨号码

READ_SMS 读取短信
WRITE_SMS 写入短信
SEND_SMS 发送短信
RECEIVE_SMS 接收短信

RECEIVE_EMERGECY_SMS 接受紧急短信息
RECEIVE_MMS 接受彩信
RECEIVE_WAP_PUSH 接受 Wap Push 消息
READ_ICC_SMS 接收运营商短信息
WRITE_ICC_SMS 写入运营商短信息

READ_CALENDAR 读取日历
WRITE_CALENDAR 写入日历

CAMERA 摄像机权限
RECORD_AUDIO 录音
PLAY_AUDIO 播放音频

TURN_ON_SCREEN 关闭屏幕
VIBRATE 震动
POST_NOTIFICATION 发布通知
WAKE_LOCK 唤醒锁
SYSTEM_ALERT_WINDOW 悬浮窗口权限
WIFI_SCAN 扫描Wifi热点
USE_FINGERPRINT 使用指纹读取器
BODY_SENSORS 身体传感器
READ_CELL_BROADCASTS 读取移动蜂窝广播
MOCK_LOCATION 模拟位置

READ_CLIPBOARD 读取剪切板
WRITE_CLIPBOARD 写入修改剪切板

TAKE_MEDIA_BUTTONS 获取多媒体按钮权限
TAKE_AUDIO_FOCUS 获取声音焦点权限

...
#>



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
    # 'com.tencent.mm'             # 微信
    'com.tencent.tws.gdevicemanager',
    'com.tencent.news',            # 腾讯新闻
    'com.tencent.news.lite',

    'com.xiaomi.hm.health', 

    'com.manmanbuy.bijia',
    'com.leixun.taofen8',
    'com.wsloan',
    'com.wljr.wanglibao',

    'com.ss.android.article.news', # 头条系app
    'com.ss.android.article.lite',

    'com.ss.android.ugc.aweme',    # 抖音
    'my.maya.android',             # 多闪

    'com.UCMobile',                # 银联

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
