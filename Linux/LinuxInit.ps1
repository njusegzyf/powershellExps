
# Note: root required
# @see [[https://blog.csdn.net/chikey/article/details/85004556 一份关于各种安装LLVM的方法的总结]]

# Note: The script is in `Linux` sub directory in the script folder
$scriptFileDir = if ($PSScriptRoot) { "$PSScriptRoot/.." } else { "/home/njuseg/PS" }

# import help functions
. "$scriptFileDir/Linux/LinuxHelpers.ps1"

# import $rootPw, $aptSourcesListContent and so on
. "$scriptFileDir/Linux/LinuxInitConfig.ps1"

. "$scriptFileDir/Linux/Set-LinuxEnvironmentVariable.ps1"

$profilePath = '/etc/profile'
$aptSourcesListPath = '/etc/apt/sources.list'
$aptConfigPath = '/etc/apt/apt.conf'



# define help functions

function Start-SudoWithGivenPassword([String]$command) {
  Start-SudoWithPassword $rootPw $command
}

function Start-SudoPsCommandWithGivenPassword([String]$command) {
  Start-SudoPsCommandWithPassword $rootPw $command
}



# set Ubuntu general config
gsettings set org.gnome.desktop.interface enable-animations false

# disable software updater if required
if ($isDisableSoftwareUpdater) {
  systemctl stop apt-daily.timer apt-daily-upgrade.timer apt-daily-upgrade.timer
  systemctl disable apt-daily.timer apt-daily.service apt-daily-upgrade.timer apt-daily-upgrade.service
}

if ($isRemovePackagekit) {
  apt remove packagekit -y
}

# set global proxy
if ($isSetGlobalProxy) {
  "export http_proxy=$globalHttpProxy" | Out-File -FilePath $profilePath -Append
  "export https_proxy=$globalHttpsProxy" | Out-File -FilePath $profilePath -Append
  # Note: Can not write like `Out-File "export https_proxy=$globalHttpsProxy" -FilePath $profilePath -append`,
  #       The string content should be sent form the pipeline.
}

# set apt sources list content
cp $aptSourcesListPath "$aptSourcesListPath.old"
if ($aptSourcesListContent) {
  $aptSourcesListContent | Out-File -FilePath $aptSourcesListPath
}
else {
  gedit $aptSourcesListPath
}

# set apt proxy
# Note: Global proxy does not works.
# Start-SudoWithGivenPassword 'gedit /etc/apt/apt.conf'
if ($isSetGlobalProxy) {
  "Acquire::http::Proxy `"$globalHttpProxy`";" | Out-File -FilePath $aptConfigPath -Append
  "Acquire::https::Proxy `"$globalHttpsProxy`";" | Out-File -FilePath $aptConfigPath -Append
}

# apt clean and update
apt autoremove -y
apt-get clean
rm -rf '/var/lib/apt/lists/*'
apt-get update -o Acquire-by-hash=yes -o Acquire::https::No-Cache=True -o Acquire::http::No-Cache=True
# apt-get upgrade 



# install language support and input methods
# @see [[https://blog.csdn.net/AsynSpace/article/details/86293500 Ubuntu 18.04 LTS 命令行方式安装中文语言包]]

if ($installFPackages -contains 'language-pack-zh-hans') {
  apt-get install language-pack-zh-hans -y
  # apt-get install language-pack-zh-hant -y
  # apt-get install $(check-language-support) -y
  # apt-get install language-pack-gnome-zh-hans -y

  # set locale to zh_CN.UTF-8
  # localectl set-locale LANG=zh_CN.UTF-8
}

# install google pinyin
if ($installFPackages -contains 'fcitx-googlepinyin') {
  apt-get install fcitx fcitx-googlepinyin -y

  <# @see [[https://ywnz.com/linuxjc/2891.html Config fcitx-googlepinyin]]
  im-config
  fcitx-config-gtk3
  #>
}



# install and config IDEA
$ideaTarPath = Get-ChildItem -Path $downloadRoot -Filter 'idea*.tar.gz'

# Note: Not support .gz
# Expand-Archive -Path ($ideaTarPath.FullName) -DestinationPath './IDEA'  

tar -zxvf $ideaTarPath.FullName
$originIdeaDir = Get-ChildItem -Path '.' -Filter 'idea*'
Rename-Item $originIdeaDir.Name 'IDEA'

# ./IDEA/bin/idea.sh



# install and config cmake
snap install cmake --classic



# install LLVM+Clang from pre-build binary

# use the user given filter or default filter to find the binary file
$llvmClangPreBuildBinaryNameFilter = 
if ($llvmClangPreBuildBinaryNameFilter) { $llvmClangPreBuildBinaryNameFilter }
else { 'clang+llvm-*-x86_64-pc-linux-gnu.tar.xz' }
$llvmClangPreBuildBinaryPath = Get-ChildItem -Path $downloadRoot -Recurse -Filter $llvmClangPreBuildBinaryNameFilter

if ($llvmClangPreBuildBinaryPath.Length = = 0) {
  Write-Error "Can not find LLVM+Clang pre-build binary with name filter $llvmClangPreBuildBinaryNameFilter." -ErrorAction Stop
}
elseif ($llvmClangPreBuildBinaryPath.Length -ge 0) {
  Write-Error "Found $($llvmClangPreBuildBinaryPath.Length) LLVM+Clang pre-build binaries with name filter $llvmClangPreBuildBinaryNameFilter, can not decide which to use." -ErrorAction Stop
}

# install LLVM+Clang
. "$scriptFileDir/Linux/Expand-ArchiveCustom.ps1"
if (-not (Test-Path "./$llvmInstallDirectoryName")) {
  Expand-TarXzArchive -path $llvmClangPreBuildBinaryPath
  -destinationPath "./$llvmInstallDirectoryName"
  -removeDuplicateRootDirectory
}

# config environment variables
# "export LLVM_HOME=/home/$userName/$llvmInstallDirectoryName/bin" | Out-File -FilePath $profilePath -Append
# 'export PATH=$PATH:$LLVM_HOME' | Out-File -FilePath $profilePath -Append
Set-LinuxEnvironmentVariable -envVarName 'LLVM_HOME' -envVarValue "/home/$userName/$llvmInstallDirectoryName/bin"
Set-LinuxEnvironmentVariable -envVarName 'PATH' -envVarValue '$PATH:$LLVM_HOME'

# Note: We get error: Out-File : Access to the path '/etc/profile' is denied.
# even if we use sudo to execute the powershell command.
#
# $command = @"
# . "$scriptFileDir/Linux/Set-LinuxEnvironmentVariable.ps1"
# Set-LinuxEnvironmentVariable -envVarName 'LLVM_HOME' -envVarValue "/home/$userName/$llvmInstallDirectoryName/bin"
# "@
# Start-SudoPsCommandWithGivenPassword $command
