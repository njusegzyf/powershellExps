[String]$commandName = 'Get-FileHash'
[System.Management.Automation.PSModuleInfo]$module = (Get-Command $commandName).ModuleName | Get-Module

Show-Module $module
explorer (Get-ModuleDirectpry $module)

foreach ($nestedModule in $module.NestedModules) {
  Show-Module $nestedModule
  explorer (Get-ModuleDirectpry $nestedModule)
}

function Show-Module([System.Management.Automation.PSModuleInfo]$module) {
    npp (Get-Item $commandModule.Path)
}

function Get-ModuleDirectpry([System.Management.Automation.PSModuleInfo]$module) {
    return (Get-Item $commandModule.Path).Directory 
} 
