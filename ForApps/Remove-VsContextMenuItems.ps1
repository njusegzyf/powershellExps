# 删除 “open in visual studio” 右键菜单
# @see https://www.zhihu.com/question/53655783
# 删除以下两个注册表项：
# HKEY_CLASSES_ROOT\Directory\Background\shell\AnyCode
# HKEY_CLASSES_ROOT\Directory\shell\AnyCode

# PowerShell管理注册表之系列文章
# @see http://www.pstips.net/the-registry.html

# Note: We can only use `\` but not `/` 
# (`Get-Item 'Registry::HKEY_CLASSES_ROOT/Directory'` not find item, while `Get-Item 'Registry::HKEY_CLASSES_ROOT\Directory'`  works fine) 
$dirBackgroundShellKey = Get-Item Registry::HKEY_CLASSES_ROOT\Directory\Background\shell
Get-Item  "$($dirBackgroundShellKey.PSPath)\AnyCode" | Remove-Item -Recurse

Get-Item Registry::HKEY_CLASSES_ROOT\Directory\shell\AnyCode | Remove-Item -Recurse
