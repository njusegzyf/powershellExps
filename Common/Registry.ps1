# @see http://www.pstips.net/the-registry.html

# Note: We can only use `\` but not `/` 
# (`Get-Item 'Registry::HKEY_CLASSES_ROOT/Directory'` not find item, while `Get-Item 'Registry::HKEY_CLASSES_ROOT\Directory'`  works fine) 
$dirBackgroundShellKey = Get-Item Registry::HKEY_CLASSES_ROOT\Directory\Background\shell
Get-Item  "$($dirBackgroundShellKey.PSPath)\AnyCode" | Remove-Item -Recurse

Get-Item Registry::HKEY_CLASSES_ROOT\Directory\shell\AnyCode | Remove-Item -Recurse

# Note: `*` must be escaped, like: 'Registry::HKEY_CLASSES_ROOT\`*\shellex\ContextMenuHandlers\IntelShellExt',
