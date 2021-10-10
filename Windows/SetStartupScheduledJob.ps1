
$scriptFileDirPath = if ($PSScriptRoot) { $PSScriptRoot } else { 'C:/Tools/PS/Windows' }

Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope LocalMachine

$startupJobName = 'ZyfStartupJob'

# 定义触发器，设置定时任务：
$trigger = New-JobTrigger -AtStartup -RandomDelay 00:00:10
Unregister-ScheduledJob -Name $startupJobName
Register-ScheduledJob -Trigger $trigger -FilePath "C:\Tools\PS\StartupJob.ps1" -Name $startupJobName

Enable-ScheduledJob -Name $startupJobName
Disable-ScheduledJob -Name $startupJobName
