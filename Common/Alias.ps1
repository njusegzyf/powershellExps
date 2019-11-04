# @see [[https://www.pstips.net/powershell-alias.html Powershell 别名]]

Get-Command *alias*

# 查询别名所指的真实cmdlet命令
Get-Alias -Name ls

# 查看可用的别名
# 查看可用的别名，可以通过 `ls Alias:` (Alias 是 PSDrive) 或者 `Get-Alias`
Get-Alias
Get-Alias | Where-Object { $_.Definition.Contains('ChildItem') } | Out-GridView 

# 有的cmdlet命令可能有2-3个别名，我们可以通过下面的命令查看所有别名和指向cmdlet的别名的个数
Get-ChildItem Alias: | Group-Object Definition | Sort-Object Count -Descending

# 创建自己的别名
# 给记事本创建一个别名，并查看该别名
Set-Alias -Name Edit -Value notepad
Edit
$Alias:Edit

# Note:
# 对于指定绝对路径的Exe文件，直接在 Value 传入绝对路径即可
Set-Alias -Name smartctl1 -Value 'C:\Program Files\smartmontools\bin\smartctl.exe'
# 对于执行目录中的Exe文件，可以用下面的形式：
$smartMonToolsBinDir = 'C:\Program Files\smartmontools\bin'
Set-Location $smartMonToolsBinDir
Set-Alias -Name smartctl2 -Value './smartctl'

# New-Alias 与 Set-Alias 效果类似，但是不允许覆盖已有的别名
New-Alias -Name smartctl1 -Value './smartctl' # New-Alias : 不允许使用该别名，因为名为“smartctl”的别名已存在

# 删除自己的别名
# 别名不用删除，自定义的别名在powershell退出时会自动清除。
# 可以手工删除别名（包括系统预定义的别名 ls 等）
Remove-Item Alias:Edit
Remove-Item Alias:ls

# 保存自己的别名
# 可以使用Export-Alias将别名导出到文件，需要时再通过Import-Alias导入。但是导入时可能会有异常，提示别名已经存在无法导入：
# Import-Alias alias.ps1 # Import-Alias : Alias not allowed because an alias with the name 'ac' already exists.
# 这时可以使用Force强制导入。
Set-Location Z:
Get-Alias *smartctl* | Export-Alias alias.ps1
Import-Alias -Force alias.ps1
