# @see 常用 adb 命令总结 https://www.cnblogs.com/bravesnail/articles/5850335.html
# @see https://github.com/Jiangyiqun/android_background_ignore

$adbPath = 'C:\Tools\adb'
$adbAppName = "$adbPath\adb.exe"

$ExecutionContext.SessionState.Applications.Add($adbAppName)

Set-Alias -Name adb -Value $adbAppName

[Boolean]$IS_DEBUG = $true

# 获取设备列表及设备状态 
adb devices

# 获取设备的状态 - device , offline or unknown
adb get-state

# adb start-server
# adb kill-server

# 卸载应用，后面跟的参数是应用的包名，  '-k' means keep the data and cache directories , -k 选项，卸载时保存数据和缓存目录
# adb uninstall

# adb 命令是 adb 这个程序自带的一些命令，而 adb shell 则是调用的 Android 系统中的命令

# Package Manager , 可以用获取到一些安装在 Android 设备上得应用信息
# 格式： adb shell pm list packages [options] <FILTER>
# @see https://blog.csdn.net/henni_719/article/details/62222439
# 不带任何选项：列出所有的应用的包名
# -s：列出系统应用
# -3：列出第三方应用
# -f：列出应用包名及对应的apk名及存放位置
# -i：列出应用包名及其安装来源
# 命令最后增加 FILTER：过滤关键字，可以很方便地查找自己想要的应用
# adb shell pm list packages -3
# adb shell pm list packages -3 -f 'taobao'  # 根据关键字“taobao”搜索第三方包

function Set-AndroidAppos([String]$appName, [String]$opName, [String]$value) {
  if ($IS_DEBUG) { Write-Host "Executes command: adb shell cmd appops set $appName $opName $value" }
  Invoke-Expression "adb shell cmd appops set $appName $opName $value"

  # Note: The following two have errors:
  # adb shell cmd appops set $appName $opName $value 
  # &$adbAppName shell cmd appops set $appName $opName $value
}

function Set-AndroidApposIgnore([String]$appName, [String]$opName) {
  Set-AndroidAppos($appName, $opName, 'ignore') 
}

function Set-AndroidApposAllow([String]$appName, [String]$opName) {
  Set-AndroidAppos($appName, $opName, 'allow')
}

function Set-AndroidAppRunInBackgroundIgnore([String]$appName) {
  Set-AndroidApposIgnore($appName, 'RUN_IN_BACKGROUND')
}

# package: 'com.tencent.mm', 'com.UCMobile'
$appsToDisableRunInBackground = 
  @('com.tencent.tws.gdevicemanager',
    'com.xiaomi.hm.health', 
    'com.eg.android.AlipayGphone',
    'com.taobao.taobao',
    'com.tmall.wireless',
    'com.taobao.etao'
    'com.leixun.taofen8',
    'com.android.stk', # sim卡应用
    'com.android.nfc',
    'com.wsloan',
    'com.leixun.taofen8',
    'com.ss.android.article.news', # 头条系app
    'com.ss.android.article.lite',
    'com.ss.android.ugc.aweme',    # 抖音
    'my.maya.android'              # 多闪
   )

foreach ($app in $appsToDisableRunInBackground) {
  Set-AndroidAppRunInBackgroundIgnore $app
}

# $appsToEnableRunInBackground = @('com.tencent.tws.gdevicemanager')
# foreach ($app in $appsToEnableRunInBackground) { Set-AndroidApposAllow($app, 'RUN_IN_BACKGROUND') }



adb shell pm disable-user com.android.nfc
adb shell pm enable com.android.nfc

$appsToDisable = 
  @('com.android.nfc', 
    'com.android.egg',
    'com.android.stk'
   )

foreach ($app in $appsToDisable) {
  adb shell pm disable-user $app
}
