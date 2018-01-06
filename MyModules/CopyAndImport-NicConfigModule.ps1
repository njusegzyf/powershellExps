$Variable:ConfirmPreference = "None"

$moduleName = "NICConfig"
$moduleBaseDir = "C:\Users\---\Desktop\PS\MyModules" 

$psModulePath = ($env:PSModulePath -split ';')[0]


Try{
    if (Test-Path "$psModulePath\$moduleName"){
		Remove-Module $moduleName
        Remove-Item "$psModulePath\$moduleName" -Recurse
    }
}Catch{
    $CurrentError | Write-Host
}

Copy-Item -Path "$moduleBaseDir\$moduleName" -Destination "$psModulePath\" -Recurse

Import-Module $moduleName
