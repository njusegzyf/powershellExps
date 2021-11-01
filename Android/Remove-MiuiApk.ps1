# @see [[https://www.jianshu.com/p/63b2d2d39260 小米手机ADB删除系统应用去广告]]
# @see [[http://www.hackdig.com/10/hack-39893.htm 一探小米Analytics后门]]

$scriptFileDirPath = if ($PSScriptRoot) { $PSScriptRoot } else { 'C:/Tools/PS/Android' }
if (-not (."$scriptFileDirPath/Config-AdbEnvironment.ps1")) {
  throw "Failed to start adb server or can not linke to device."
}

. "$scriptFileDirPath/AdbFileManagement.ps1"
. "$scriptFileDirPath/AdbPackageManagement.ps1"

$appToPackageNameMap = ."$scriptFileDirPath/Get-AndroidPackageNames.ps1"

# 可删除APK：
# 小米钱包 com.mipay.wallet
# 米连服务 com.milink.service
# 计算器 com.miui.calculator
# 天气 com.miui.weather2
# 搜索 com.android.quicksearchbox
# 有道翻译 com.miui.translation.youdao
# 金山翻译 com.miui.translation.kingsoft



# @note Since Miui App Store will auto update or reinstall `com.miui.analytics` via network,
#       so we should also block website `ad.xiaomi.com`.
Remove-Apk 'com.miui.systemAdSolution'
Disable-Apk 'com.miui.analytics'

Remove-Apk $appToPackageNameMap['miSogouInput']
Remove-Apk 'com.xiaomi.gamecenter.sdk.service'    # 游戏服务
Remove-Apk 'com.xiaomi.gamecenter'                # 游戏 
Remove-Apk $appToPackageNameMap['miHybrid']       # 快应用

Disable-Apk 'com.xiaomi.metoknlp'             # 网络位置服务
Disable-Apk 'com.xiaomi.mi_connect_service'   # 小米互联通信服务
Disable-Apk 'com.xiaomi.simactivate.service'  # 小米sim卡激活服务
Disable-Apk 'com.miui.bugreport'              # 用户反馈 

Disable-Apk 'com.miui.voicetrigger'           # 语音唤醒
Disable-Apk 'com.miui.voiceassist'            # 小爱 (语音助手)

Disable-Apk 'com.milink.service'              # 投屏

Disable-Apk 'com.miui.video'                  # 小米视频
Disable-Apk 'com.miui.player'                 # 小米音乐 



# Not work: (Package xxx new state: default)
# Disable-Apk 'com.xiaomi.finddevice'           # 查找手机
