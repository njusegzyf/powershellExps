$backgroundRunScripts = @('[]Startup.ps1')
$iseScripts = @('[]Shutdown.ps1')

Set-Location $PSScriptRoot

# run background scripts first
foreach ($backgroundRunScript in $backgroundRunScripts){
  powershell.exe -file $backgroundRunScript
}

powershell_ise.exe $iseScripts

ipconfig /renew6
