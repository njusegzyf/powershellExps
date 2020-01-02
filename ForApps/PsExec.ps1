# @see [[https://docs.microsoft.com/en-us/sysinternals/downloads/psexec PsExec]]
# @see [[https://answers.microsoft.com/zh-hans/windows/forum/windows_7-performance/windows-7/3b6d8786-0da9-4b6c-8e7b-97efc9aa61e0 PsEvec The network path was not found]]

$psToolsDirPath = 'C:\Tools\_SystemTools\PSTools'
$psExecName = 'psexec64.exe'

Set-Location $psToolsDirPath
Set-Alias -Name psexec -Value "./$psExecName"

# for first time run(to accept eula)
# psexec -e -i -d -s -accepteula mmc
 
# 启动 计算机管理
psexec -e -i -d -s mmc c:\windows\system32\compmgmt.msc

# 启动 任务计划程序
psexec -e -i -d -s mmc c:\windows\system32\taskschd.msc

# -e Does not load the specified account’s profile.
# -i Run the program so that it interacts with the desktop of the specified session on the remote system. If no session is specified the process runs in the console session.
# -d Don't wait for process to terminate (non-interactive).
# -s Run the remote process in the System account.

# @note 需要管理员权限来 install PSEXESVC service
# @note 必需打开 Server 服务: Start-Service -DisplayName Server
# @see [[https://answers.microsoft.com/zh-hans/windows/forum/windows_7-performance/windows-7/3b6d8786-0da9-4b6c-8e7b-97efc9aa61e0 
#        提示 The network path was not found 表明网络路径无法定位如何解决]]
