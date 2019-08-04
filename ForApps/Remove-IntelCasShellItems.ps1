$intelCasShellExtRegistries = 
  @('Registry::HKEY_CLASSES_ROOT\Directory\shellex\ContextMenuHandlers\IntelShellExt',
    'Registry::HKEY_CLASSES_ROOT\Drive\shellex\ContextMenuHandlers\IntelShellExt',
    'Registry::HKEY_CLASSES_ROOT\`*\shellex\ContextMenuHandlers\IntelShellExt', # Note: `*` must be escaped
    'Registry::HKEY_CLASSES_ROOT\Folder\shellex\ContextMenuHandlers\IntelShellExt')

foreach ($registryItem in $intelCasShellExtRegistries) {
  if (Test-Path $registryItem) {
    Write-Host "Delete registry item $registryItem."
    Get-Item $registryItem | Remove-Item -Recurse
  }
}
