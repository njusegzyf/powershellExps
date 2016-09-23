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

# 该触发器只执行一次，持续时间一个小时，每隔一分钟执行对应的脚本
$trigger = New-JobTrigger -Once -At (Get-Date) -RepetitionInterval (New-TimeSpan -Minutes 1) -RepetitionDuration (New-TimeSpan -Hours 1)

$scheduledJobName = "MyCounter"
$scheduledJob = Register-ScheduledJob -Name $scheduledJobName -Trigger $trigger -FilePath '...'

Get-ScheduledJob

Unregister-ScheduledJob -Name $scheduledJobName

