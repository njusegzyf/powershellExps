# @see [[https://docs.microsoft.com/en-us/sysinternals/downloads/psexec PsExec]]
# @see [[https://answers.microsoft.com/zh-hans/windows/forum/windows_7-performance/windows-7/3b6d8786-0da9-4b6c-8e7b-97efc9aa61e0 PsEvec The network path was not found]]

$psToolsDirPath = 'C:\Tools\_System\PSTools'
$psExecName = 'psexec64.exe'

Set-Location $psToolsDirPath
Set-Alias -Name psexec -Value "./$psExecName"

# for first time run(to accept eula)
# psexec -e -i -d -s -accepteula mmc
 
# 启动 计算机管理
psexec -e -i -d -s mmc c:\windows\system32\compmgmt.msc
psexec -e -i -d -s -u Administrator -p sony890508 mmc c:\windows\system32\compmgmt.msc

# 启动 任务计划程序
psexec -e -i -d -s mmc c:\windows\system32\taskschd.msc

# -e Does not load the specified account’s profile.
# -i Run the program so that it interacts with the desktop of the specified session on the remote system. If no session is specified the process runs in the console session.
# -d Don't wait for process to terminate (non-interactive).
# -s Run the remote process in the System account.

# @note 需要管理员权限来 install PSEXESVC service
# @note 必需打开 Server , Workstation 和 TCP/IP NetBIOS Helper 服务: Start-Service -Name LanmanServer, LanmanWorkstation, lmhosts
# @see [[https://answers.microsoft.com/zh-hans/windows/forum/windows_7-performance/windows-7/3b6d8786-0da9-4b6c-8e7b-97efc9aa61e0 提示 The network path was not found 表明网络路径无法定位如何解决]]

# delete PSEXESVC service
sc delete PSEXESVC

# 直接删除 %windir%\system32\PSEXESVC.exe, HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PSEXESVC
Remove-Item "$($env:windir)\System32\PSEXESVC.exe"

# 请打开注册表编辑器，找到以下路径下 HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services
# 一般服务会以相同的名字在这里显示一个主健，直接删除便可
