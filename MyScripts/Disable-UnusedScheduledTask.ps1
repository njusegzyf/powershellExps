$pathsToDisable = @('\Microsoft\Windows\UpdateOrchestrator\')
$namesToDisable = @()

Get-ScheduledTask -TaskPath $pathsToDisable | Disable-ScheduledTask  
# foreach ($pathToDisable in $pathsToDisable) {
#   Get-ScheduledTask -TaskPath $pathToDisable | Disable-ScheduledTask
# }

Get-ScheduledTask -TaskName $namesToDisable | Disable-ScheduledTask 
