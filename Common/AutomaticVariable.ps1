# Automatic variables
<#
see : http://www.pstips.net/powershell-automatic-variables.html
Powershell 自动化变量 是存储 Windows PowerShell 状态信息的变量，由 Windows PowerShell 创建并维护。
这些变量一般存放的内容包括
    用户信息：例如用户的根目录$home
    配置信息:例如powershell控制台的大小，颜色，背景等。
    运行时信息：例如一个函数由谁调用，一个脚本运行的目录等。
powershell中的某些自动化变量只能读，不能写。例如:$Pid。
可以通过 Get-Help about_Automatic_variables 查看Automatic_variables的帮助。
#>

# 会话所收到的最后一行中的首个/最后一个令牌
$^, $$ 
<#
Get-Process -Name '*ali*' -Verbose
$^ # 返回 Get-Process
$$ # 返回 -Verbose
#>

# 最后一个操作的执行状态，$true or $false
$?

# 管道对象中的当前对象。在对管道中的每个对象或所选对象执行操作的命令中，可以使用此变量
$_

# 由未声明参数和/或传递给函数、脚本或脚本块的参数值组成的数组。
# 在创建函数时可以声明参数，方法是使用 param 关键字或在函数名称后添加以圆括号括起、分隔的参数列表。
$Args

# 包含错误对象的数组，这些对象表示最近的一些错误。最近的错误是该数组中的第一个错误对象($Error[0])。
$Error