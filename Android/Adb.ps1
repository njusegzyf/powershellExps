# @see [[https://www.cnblogs.com/bravesnail/articles/5850335.html 常用 adb 命令总结]]
# @see [[https://www.cnblogs.com/abeam/p/8908225.html Android adb shell 常用命令]]

# @see [[https://www.jianshu.com/p/fa0d80ce68e9 AppOps]]
# @see [[https://github.com/Jiangyiqun/android_background_ignore]]

. "$PSScriptRoot/Config-AdbEnvironment.ps1"
# $adbPath = 'C:\Tools\AndroidPlatformTools'
# $adbAppName = "$adbPath\adb.exe"
# $ExecutionContext.SessionState.Applications.Add($adbAppName)
# Set-Alias -Name adb -Value $adbAppName

$fastbootAppName = "$adbPath\fastboot.exe"
$ExecutionContext.SessionState.Applications.Add($fastbootAppName)
Set-Alias -Name fastboot -Value $fastbootAppName

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



# adb shell pm disable-user com.android.nfc
# adb shell pm enable com.android.nfc

$appsToDisable = 
  @('com.android.nfc', 
    'com.android.egg',
    'com.android.stk'
   )

foreach ($app in $appsToDisable) {
  adb shell pm disable-user $app
}



# For Zenfone2 刷机
adb reboot fastboot
fastboot flash recovery Z:/twrp-3.0.0-0-Z00A.img

# adb push MK71.2-z00a-190228-HISTORY.zip /sdcard
