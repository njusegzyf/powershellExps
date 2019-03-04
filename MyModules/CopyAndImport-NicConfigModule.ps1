$Variable:ConfirmPreference = 'None'

$moduleName = 'NICConfig'
$moduleBaseDir = '.' 

# import functions from other scripts files
. "$PSScriptRoot/../MyScripts/Copy-Module.ps1"

Copy-Module -moduleName $moduleName -moduleBaseDir $moduleBaseDir
