# @see [[https://www.cnblogs.com/kennyhip/articles/5791531.html 注册表原理解析说明]]
# @see [[https://www.cnblogs.com/kennyhip/articles/5791531.html 注册表结构]]
# @see [[http://www.pstips.net/the-registry.html]]

<#
注册表由键、子键和值项构成，一个键就是分支中的一个文件夹，而子键就是这个文件夹中的子文件夹，子键同样是一个键。
一个值项则是一个键的当前定义，由名称、数据类型以及分配的值组成。一个键可以有一个或多个值，每个值的名称各不相同，
如果一个值的名称为空，则该值为该键的默认值。

下面的表格列出了访问注册表所需的所有命令。
命令 	描述
Get-ChildItem 	列出键的内容
Set-Location 	更改当前（键）目录
HKCU:, HKLM: 	预定义的两个重要注册表根目录虚拟驱动器
Get-ItemProperty 	读取键的值
Set-ItemProperty 	设置键的值
New-ItemProperty 	给键创建一个新值
Clear-ItemProperty 	删除键的值内容
Remove-ItemProperty 删除键的值
New-Item            创建一个新键
Remove-Item         删除一个键
Test-Path 	        验证键是否存在
#>

# Note: We can only use `\` but not `/` 
# (`Get-Item 'Registry::HKEY_CLASSES_ROOT/Directory'` not find item, while `Get-Item 'Registry::HKEY_CLASSES_ROOT\Directory'`  works fine) 
$dirBackgroundShellKey = Get-Item Registry::HKEY_CLASSES_ROOT\Directory\Background\shell
Get-Item  "$($dirBackgroundShellKey.PSPath)\AnyCode" # | Remove-Item -Recurse
# If key does not exist, returns $null

Get-Item Registry::HKEY_CLASSES_ROOT\Directory\shell\AnyCode # | Remove-Item -Recurse

# Note: `*` must be escaped, like: 'Registry::HKEY_CLASSES_ROOT\`*\shellex\ContextMenuHandlers\IntelShellExt'

# Example
$rootDir = "C:\Users\dell\Desktop\PS" # "$PSScriptRoot\.."
psEdit "$rootDir\MyScripts\Disable-DiskWritePretectInRegistry.ps1"
psEdit "$rootDir\MyScripts\Remove-ExplorerMyComputerFolderShortcuts.ps1"
