
Write-Host "Host" # 输出到 Console

Write-Output 'Output'
Write-Debug 'Debug'
Write-Verbose 'Verbose'
# Write-Progress ...

# $DebugPreference、$VerbosePreference 和 $ProgressPreference 可接受的值有：
#   安静模式（SilentlyContinue）: 不显示输出信息
#   停止模式（Stop）：将输出视为错误，终止当前命令
#   继续模式（Continue）：显示输出
#   询问模式（Inquire）：显示继续操作信息

# 默认情况下，$DebugPreference = SilentlyContinue， $VerbosePreference = SilentlyContinue, $ProgressPreference = Continue
# 因此，只有 Write-Progress 会输出信息到控制台

function Write-DebugInfo { 
  [CmdletBinding()]
  Param()
  
  Write-Host "DebugPreference = $DebugPreference"
  Write-Debug 'Debug' 
  Write-Host 'Info' 
}

# 如果
$DebugPreference = 'Continue'
# 则
Write-DebugInfo
# 会输出信息到控制台

# 如果
$DebugPreference = 'Stop'
# 则
Write-DebugInfo
# 会输出信息到控制台，同时终止当前运行的命令，即 Write-DebugInfo 函数终止执行，`Write-Host 'Info' ` 不再得到执行

# 如果函数有 [CmdletBinding()]，则
Write-DebugInfo -Debug # 在函数执行中，$DebugPreference 设为 Inquire，即显示 Debug 信息，并弹出对话框询问后继操作
Write-DebugInfo -Verbose # 在函数执行中，$VerbosePreference 设为 Continue，即显示 Verbose 信息


# 类似地，$ErrorActionPreference 影响 Write-Error 的行为，默认值为 Continue，即输出 Error 信息，但是继续执行命令
Write-Error "Error"
# `-ErrorAction Stop` 让 Write-Error 中断命令的执行
Write-DebugInfo -ErrorAction Stop
