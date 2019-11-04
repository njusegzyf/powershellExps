# Start print spooler service
Get-Service -Name Spooler | Start-Service
Write-Host 'The Spooler service is started, press any key to continue...'

Read-Host
