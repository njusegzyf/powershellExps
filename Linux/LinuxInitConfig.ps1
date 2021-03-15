# privacy settings
$userName = 'njuseg'
$rootPw = "'njuseg'" 



# directory settings
$downloadRoot = "/home/$userName/Downloads"


# config settings

$isDisableSoftwareUpdater = $true
$isRemovePackagekit = $true

$installFPackages = @(
  'language-pack-zh-hans',
  'fcitx-googlepinyin')

$isSetGlobalProxy = $true
$proxyAddress = '114.212.81.26'
$globalHttpProxy = "http://$($proxyAddress):8080"
$globalHttpsProxy = $globalHttpProxy # "https://$($proxyAddress):8080"
# Note: Use $($proxyAddress):8080, otherwise `$proxyAddress:8080` will be consider as a varibale

$ubuntuCodename = 'focal'; # 20.04

$aptSourcesListContent = @"
deb https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename-updates main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename-updates main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename-backports main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename-backports main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename-security main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename-security main restricted universe multiverse
deb https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename-proposed main restricted universe multiverse
deb-src https://mirrors.ustc.edu.cn/ubuntu/ $ubuntuCodename-proposed main restricted universe multiverse
"@


# LLVM + Clang
# `*` is for version number like 9.0.0
$llvmClangPreBuildBinaryNameFilter = 'clang+llvm-*-x86_64-pc-linux-gnu.tar.xz'
$llvmInstallDirectoryName = 'LLVM'
