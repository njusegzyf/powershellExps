
# 在 Edge 中输入 EdgeBrowser，查看 配置文件路径
# $edgeSettingsPath = 'C:/Users/zhangyf/AppData/Local/Microsoft/Edge/User Data/Default'
# $newCacheRootPath = 'Z:/Cache/Edge'

# C:\Program Files (x86)\Microsoft\EdgeUpdate

Function Set-EdgeBrowserCache([String]$edgeSettingsPath, [String]$newCacheRootPath) {

  $cacheDirNameList = @('Cache', 'Code Cache')
 
  # 将配置中的 Cache 文件夹替换为指向所需路径的符号链接
  foreach ($cacheDirName in $cacheDirNameList) {
    $oldCacheDirPath = "$edgeSettingsPath/$cacheDirName"
    $newCacheDirPath = "$newCacheRootPath/$cacheDirName"

    if (Test-Path $oldCacheDirPath -PathType Container) {
      Remove-Item $oldCacheDirPath -Force -Recurse
    }
    if (-not (Test-Path $newCacheDirPath -PathType Container)) {
      New-Item -Path $newCacheDirPath -ItemType Directory
    }
    New-Item -Path $oldCacheDirPath -ItemType SymbolicLink -Value $newCacheDirPath -Force
  }
  
}

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
