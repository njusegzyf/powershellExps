
# @see [[https://blog.csdn.net/zmoneyz/article/details/16343167]]

$sampleExePath = 'C:\Program Files\WinRAR\Rar.exe'

<#
3.5.5 Dot source notation
When a script file, script block, or function is executed from within another script file, script block, or function, 
the executed script file creates a new nested scope.
  Script1.ps1 
  & "Script1.ps1"
  & { … }
  FunctionA

However, when dot source notation is used, no new scope is created before the command is executed,
so additions/changes it would have made to its own local scope are made to the current scope instead.
  . Script2.ps1
  . "Script2.ps1"
  . { … }
  . FunctionA
#>

# "&"操作符能允许你调用一个命令, 脚本, 或函数
& $sampleExePath
& './sample.ps1'

$pingCommand = Get-Command ping -CommandType Application # of type [System.Management.Automation.ApplicationInfo]
& $pingCommand

# Note: 传递的字符串不能包含参数，即
& 'echo x'   # Error 
& 'echo' 'x' # Right

# 使用"&"操作符，执行过程会创建新的作用域，因此脚本中定义的变量和函数会在脚本运行结束后消失
# 而使用 dot sourcing 来运行脚本的时候, 所有脚本中定义的变量和函数会在脚本运行结束后依然存在
# 即会将所有脚本中的内容作用域提升到当前作用域
. $sampleExePath

# Note: 在调用脚本时，`./source1.ps1` 的 `.`，实际上是路径的一部分（当前位置），而不是 dot sourcing，
# 因此，实际上 dot sourcing 需要写成
. ./source1.ps1 # 即为 `. './source1.ps1'`

# 也可以使用 Import-Module 来引入 Script 中定义的变量和函数
Import-Module ./source1.ps1



# Invoke-Experssion
$echoContent = 'Test'
Invoke-Expression "echo $echoContent"
# 字符串可以包含参数，可以调用外部命令
Invoke-Expression 'ping www.baidu.com'
# Example: Invoke-Expression "adb shell cmd appops get $appName $opName"



# Invoke-Command，用于在其它机器上执行指令



# @see [[https://blog.csdn.net/WPwalter/article/details/94128752 PowerShell 的命令行启动参数（可用于执行命令、传参或进行环境配置）]]
