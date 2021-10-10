# @see [[https://www.cnblogs.com/kangxiaopao/p/8509111.html]]

$rdpRegistryKeyPath = 'HKCU:Software\Microsoft\Terminal Server Client'
$rdpRegistryKey = Get-Item $rdpRegistryKeyPath

# 删除 Default : 存储最近10次的rdp登录
$rdpRegistryDefaultKey = $rdpRegistryKey.OpenSubKey('Default', $true)
# Note: 直接通过 Get-Item "$rdpRegistryKeyPath\Default" 获取的 Key 可能没有写入权限，
# 导致后续删除时出现错误：无法写入到注册表项
foreach ($mruValueName in $rdpRegistryDefaultKey.GetValueNames()) {
  $rdpRegistryDefaultKey.DeleteValue($mruValueName);
}

# 删除 Server：存储着所有连接过的rdp的ip地址和登录账户
$rdpRegistryServersKey = $rdpRegistryKey.OpenSubKey('Servers', $true)
# $rdpRegistryServersKey = Get-Item "$rdpRegistryKeyPath\Servers"
foreach ($serverKeyName in $rdpRegistryServersKey.GetSubKeyNames()) {
  # Note: DeleteSubKey 只能删除没有子项的的子键，而 DeleteSubKeyTree 则可以递归删除，类似于 Remove-Item $path -Recurse
  $rdpRegistryServersKey.DeleteSubKeyTree($serverKeyName);
}

# 删除 LocalDevices：存储着所有连接过的rdp的ip地址和登录账户
$rdpRegistryLocalDevicesKey = $rdpRegistryKey.OpenSubKey('LocalDevices', $true)
foreach ($localDevicesValueName in $rdpRegistryLocalDevicesKey.GetValueNames()) {
  $rdpRegistryLocalDevicesKey.DeleteValue($localDevicesValueName);
}

# 删除包含默认RDP连接的Default.rdp文件(包含最新的RDP会话信息) 
# Default.rdp文件被设置为隐藏属性。
# $docs = [environment]::getfolderpath("mydocuments") + '\Default.rdp'
# Remove-Item $docs -Force 2>&1 | Out-Null

# 清除缓存的rdp凭据
# 打开 控制面板\所有控制面板项\凭据管理器 ，删除相关 Windows 凭据



# 如何用脚本清除掉RDP连接历史记录
# 上面我们讨论了如何通过注册表去删除rdp历史记录，但是手工操作相对而言很耗时，特别是在电脑很多的情况下。因此，我们提供一个小脚本(bat文件),来自动清除历史记录。
# 想要自动化清除rdp历史记录，你可以把这个脚本放在Startup文件夹下或者将创建一个组策略

# @echo off
# reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Default" /va /f
# reg delete "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers" /f
# reg add "HKEY_CURRENT_USER\Software\Microsoft\Terminal Server Client\Servers"
# cd %userprofile%\documents\
# attrib Default.rdp -s -h
# del Default.rdp

# 此外，你还可以用powershell脚本来清除rdp连接历史记录
# Get-ChildItem "HKCU:\Software\Microsoft\Terminal Server Client" -Recurse | Remove-ItemProperty -Name UsernameHint -Ea 0
# Remove-Item -Path 'HKCU:\Software\Microsoft\Terminal Server Client\servers' -Recurse  2>&1 | Out-Null
# Remove-ItemProperty -Path 'HKCU:\Software\Microsoft\Terminal Server Client\Default' 'MR*'  2>&1 | Out-Null
# $docs = [environment]::getfolderpath("mydocuments") + '\Default.rdp'
# remove-item  $docs  -Force  2>&1 | Out-Null 
