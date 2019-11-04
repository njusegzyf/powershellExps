# Start-Job. These jobs are ran in managed thread, and are local to current session

$task = {
    param($p)
    Write-Host "Job $p Begin."
    $r = Get-Random -Maximum 60 -Minimum 40
    Start-Sleep $r
    Write-Host "Job $p ends in $r seconds."
}

$jobs = ForEach ($i in 1..3){
    Start-Job -ScriptBlock $task -ArgumentList $i -Name "Job $i"
}

Get-Job
# 每一个Job包括一个主Job，其启动子Job执行Script，因此至少会有一个主Job和一个子Job
Get-Job -IncludeChildJob
$jobs = Get-Job

# Receive outputs of jobs
Get-Job | Receive-Job 
Get-Job | Receive-Job -Keep # keep 选项在获取Job输出（保存在内存中）的同时，不清除掉内存上保存的输出

# Wait jobs, Blocking
Get-Job | Wait-Job
# or
$r = (Get-Job)[0] | Wait-Job # TypeName:System.Management.Automation.PSRemotingJob
$r.State

# Stop jobs
Get-Job | Stop-Job

# Remove jobs. Can not remove a job if it is not completed
# 此外，不可直接删除子Job，而必须从父Job删除
Get-Job | Remove-Job

# -Force 选项强制移除任务，不用先 Stop 任务
Get-Job | Remove-Job -Force

# 在指定的运程电脑以 Job 形式运行三个 Script ，返回一个以这三个 Job 做为子 Job 的主 Job
$remoteJobs = Invoke-Command -ScriptBlock $task `
              -ComputerName localhost,localhost,localhost -AsJob



# Scheduled Job, 由 Windows Task Schedule 控管（相关定义存在个人目录下），不依存于 Session，并支持多种触发条件 （Once, AtLogon, AtStartup, Daily, Weekly）
# @see [[https://docs.microsoft.com/en-us/powershell/module/psscheduledjob/register-scheduledjob]]
# @see [[https://docs.microsoft.com/en-us/powershell/module/psscheduledjob/new-scheduledjoboption]]

# 该触发器只执行一次，持续时间一个小时，每隔一分钟执行对应的脚本
$trigger = New-JobTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration (New-TimeSpan -Hours 1)

$scheduledJobName = "MyCounter"
$scheduledJob = Register-ScheduledJob -Name $scheduledJobName -Trigger $trigger -FilePath '...'

Get-ScheduledJob

Unregister-ScheduledJob -Name $scheduledJobName


# Example: Run a script at specified time
# $startTime = Get-Date '2019-9-15T14:38:00'
$currentTime = Get-Date
$startTime = $currentTime.AddMinutes(2)
$trigger = New-JobTrigger -Once -At $startTime
$exePath = 'D:\BaiduNetdisk\BaiduNetdisk.exe'
$scheduledJobName = "RunExeOnce"
$scheduledJob = `
  Register-ScheduledJob -Name $scheduledJobName -Trigger $trigger `
                        -ScriptBlock { 'Test' | Out-File -Encoding ascii -FilePath 'Z:/Test.txt' } `
                        -ScheduledJobOption (New-ScheduledJobOption -WakeToRun -RunElevated)
                        # -File 'Z:\Task.ps1'
# { Start-Process -FilePath $exePath }

Unregister-ScheduledJob -Name $scheduledJobName

# FIXME: 
# 全新安装的 Windows Server 2019 可以正常创建并运行任务，但是旧 Win10 系统创建任务报错：
# 初步推断原因：
# 在MMC中，创建的任务点击立即执行仍然无法执行
# 但是如果将任务计划的 安全选项 从 不管用户是否登录都要运行 改为 只在用户登录时运行，则任务计划可以正常执行
# 推断问题和执行计划的选项有关，但是在 Register-ScheduledJob 和 ScheduledJobOption 中都未找到修改上述设置的选项
<#
日志名称:          System
来源:            Microsoft-Windows-TaskScheduler
日期:            2019/9/15 15:24:24
事件 ID:         414
任务类别:          任务配置错误
级别:            警告
关键字:           
用户:            SYSTEM
计算机:           dell-PC
描述:
任务计划程序服务在 NT TASK\Microsoft\Windows\PowerShell\ScheduledJobs\RunExeOnce 定义中发现配置错误。其他数据: 错误值: powershell.exe。
#>

# 无效：
# @see [[https://blog.csdn.net/andyguan01_2/article/details/90061860 win10定时任务问题解决：任务尚未运行（0x41303）]]
