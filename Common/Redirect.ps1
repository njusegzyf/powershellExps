
# @see [[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-6 about_redirection]]
# @see [[https://www.cnblogs.com/volcanol/archive/2012/05/12/2497437.html Powershell中重定向机制、目录和文件管理]]

# PowerShell redirection operators
# 默认情况下，PowerShell会在控制台中发送命令，警告和错误的输出。
# 您可以将这些输出发送到文件以便存储它们。将输出重定向到文件有多种不同的方法：
#    Out-File
#    Tee-Object
#    Set-Content
#    Add-Content
#    重定向操作符

<# Stream
1 	Success Stream
2 	Error Stream
3 	Warning Stream
4 	Verbose Stream
5 	Debug Stream
6 	Information Stream
* 	All Streams
# There is also a Progress stream in PowerShell, but it is not used for redirection.
#>

<# Redirection operators
The PowerShell redirection operators are as follows, where n represents the stream number.
The Success stream ( 1 ) is the default if no stream is specified.
Operator  Description 	                                            Syntax
>         Send specified stream to a file. 	                        n>
>> 	      Append specified stream to a file. 	                    n>>
>&1       Redirects the specified stream to the Success stream. 	n>&1
#>

<# Examples
    > – 将 Success stream ( 1，未指定时的默认值 ) 发送到指定的文件
    >> – 将 Success stream 附加到指定文件的内容
    3> – 发送警告到指定的文件
    3>> – 将警告附加到指定文件的内容。
    3>&1 – 发送警告和成功输出到成功输出流
    *> – 将所有输出类型发送到指定的文件
    *>> – 将所有输出类型追加到指定文件的内容
    *>&1 – 将所有输出类型发送到成功输出流
#>

# Example 1: Redirect errors and output to a file
dir 'C:\', 'fakepath' 2>&1 > .\dir.log

# This example runs dir on one item that will succeed, and one that will error.
# It uses 2>&1 to redirect the Error stream to the Success stream, 
# and > to send the resultant Success stream to a file called dir.log



# Tee-Object
# Saves command output in a file or variable and also sends it down the pipeline
#
# The Tee-Object cmdlet redirects output, that is, it sends the output of a command in two directions (like the letter T).
# It stores the output in a file or variable and also sends it down the pipeline. 
# If Tee-Object is the last command in the pipeline, the command output is displayed at the prompt.

# @see [[https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/tee-object?view=powershell-6]]
