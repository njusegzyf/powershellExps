Function Start-MyJob {
    Param([Int]$p)
    Process {
        Write-Host "Job $p Begin."
        $r = Get-Random -Maximum 5 -Minimum 1
        Start-Sleep $r
        Write-Host "Job $p ends in $r seconds."
    }
}

Workflow Demo {
    # 让以下 Task 并行执行
    Parallel {
        Sequence { Start-MyJob 1 }
        Sequence { Start-MyJob 2 }
        Sequence { Start-MyJob 3 }
    }
}

Workflow ParamWorkflow{
    Param([int]$num)

    Sequence {
        # 在 Workflow 内必须 By Name 传递参数
        $num | Where-Object -FilterScript { $_ -eq $null }
        
        Foreach -Parallel ($item in 1..$num) {
            Start-MyJob $item
        }
    }

    Sequence {
        $users = 11..20
        Foreach -Parallel ($user in $users) { 
            Start-MyJob $Using:user
        }
    }
}

# Run Workflow
Demo
ParamWorkflow -num 10

# 将 Workflow 输出为 XAML，可以通过 VS 查看
Get-Command Demo | Select-Object -ExpandProperty XamlDefinition | Out-File 'Z:\demo.xaml'

# 从 XAML 读取并执行
Import-Module 'Z:\demo.xaml'
Get-Module
# Run XAML
Demo
Remove-Module -Name demo

# Run Workflow as job and resume job

Workflow CheckpointWorkflow
{
    Param([int]$num)

    Sequence {
        Foreach -Parallel ($item in 1..$num) {
            Checkpoint-Workflow # 记录执行状态
            Strat-MyJob $item
        }
    }
}

# 关闭 Session 后，Job 自动变为 Suspend，可以在重新开启 Session 后检查 Job 状态，以及Resume Job
CheckpointWorkflow -AsJob

$jobName = (Get-Job)[0].Name
Receive-Job -Name $jobName
Resume-Job -Name $jobName
Stop-Job $jobName
Remove-Job $jobName

# Powershell 序列化时只保存状态不保存方法，因此方法定义和使用必须在一个 Script 里
# 即，如果使用 InlineScript，方法定义必须放在 InlineScript里
# 此外，在 InlineScript 里，通过 $Using: 指定外层定义的变量 （否则认为是在 InlineScript 内层定义的变量）
