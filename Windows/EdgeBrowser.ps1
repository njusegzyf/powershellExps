
Function Set-EdgeBrowserCache([String]$edgeSettingsPath, [String]$newCacheRootPath) {

  $cacheDirNameList = @('Cache', 'Code Cache')
 
  # 将配置中的 Cache 文件夹替换为指向所需路径的符号链接
  foreach ($cacheDirName in $cacheDirNameList) {
    $oldCacheDirPath = "$edgeSettingsPath/$cacheDirName"
    $newCacheDirPath = "$newCacheRootPath/$cacheDirName"

    # @note `(Get-Item $oldCacheDirPath).Attributes -match 'ReparsePoint'` is uesd to test whether the path points to a symbolic link
    if ((-not (Get-Item $oldCacheDirPath).Attributes -match 'ReparsePoint') -and (Test-Path $oldCacheDirPath -PathType Container)) {
      Remove-Item $oldCacheDirPath -Recurse -Force
    }
    if (-not (Test-Path $newCacheDirPath -PathType Container)) {
      New-Item -Path $newCacheDirPath -ItemType Directory
    }
    New-Item -Path $oldCacheDirPath -ItemType SymbolicLink -Value $newCacheDirPath -Force
  }
}

# 可以在 Edge 中输入 EdgeBrowser，查看 配置文件路径
$userName = 'zhangyf'
$edgeSettingsPath = "C:/Users/$userName/AppData/Local/Microsoft/Edge/User Data/Default"
$newCacheRootPath = 'Z:/Cache/Edge'
Set-EdgeBrowserCache $edgeSettingsPath $newCacheRootPath

# 其它修改 Edge 浏览器缓存目录方法：
#
# 方法1：通过启动参数 --disk-cache-dir 设置，此时 Edge 将优先在该路径下新建 Cache 和 Code Cache 文件保存缓存
# "C:\ProgramFiles\Microsofte\Edge\Application\Edge.exe"
# --user-data-dir="C:\Program Files\Microsoft\Edge\UserData") #  设置用户数据目录
# --disk-cache-dir="Z:\Cache\Edge\DiskCache" # 设置浏览器缓存目录命令
#
# 方法2：通过修改注册表
# [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge] "UserDataDir"="D:\\EDGE\\Data" 
# [HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Edge] "DiskCacheDir"="D:\\EDGE\\DiskData"



# 禁止 Edge 自动更新： 删除 EdgeUpdate 程序，禁用相关 Services，禁用相关 Scheduled Tasks
Remove-Item 'C:\Program Files (x86)\Microsoft\EdgeUpdate' -Recurse -Force
Get-Service *Edge* | Set-Service -StartupType Disabled
Get-ScheduledTask *Edge* | Disable-ScheduledTask

# Microsoft Edge - 更新策略
# @see [[https://docs.microsoft.com/zh-cn/DeployEdge/microsoft-edge-update-policies]]

# 下载并部署 Microsoft Edge 商业版
# @see [[https://www.microsoft.com/zh-cn/edge/business/download]]
