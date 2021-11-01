# note : config IIS needs administrator rights 
<# All IIS cmdlets from moodule IISAdministration
CommandType     Name                                               Version    Source                                
-----------     ----                                               -------    ------                                
Cmdlet          Clear-IISConfigCollection                          1.0.0.0    IISAdministration                     
Cmdlet          Get-IISAppPool                                     1.0.0.0    IISAdministration                     
Cmdlet          Get-IISConfigAttributeValue                        1.0.0.0    IISAdministration                     
Cmdlet          Get-IISConfigCollection                            1.0.0.0    IISAdministration                     
Cmdlet          Get-IISConfigCollectionElement                     1.0.0.0    IISAdministration                     
Cmdlet          Get-IISConfigElement                               1.0.0.0    IISAdministration                     
Cmdlet          Get-IISConfigSection                               1.0.0.0    IISAdministration                     
Cmdlet          Get-IISServerManager                               1.0.0.0    IISAdministration                     
Cmdlet          Get-IISSite                                        1.0.0.0    IISAdministration                     
Cmdlet          New-IISConfigCollectionElement                     1.0.0.0    IISAdministration                     
Cmdlet          New-IISSite                                        1.0.0.0    IISAdministration                     
Cmdlet          Remove-IISConfigAttribute                          1.0.0.0    IISAdministration                     
Cmdlet          Remove-IISConfigCollectionElement                  1.0.0.0    IISAdministration                     
Cmdlet          Remove-IISConfigElement                            1.0.0.0    IISAdministration                     
Cmdlet          Remove-IISSite                                     1.0.0.0    IISAdministration                     
Cmdlet          Reset-IISServerManager                             1.0.0.0    IISAdministration                     
Cmdlet          Set-IISConfigAttributeValue                        1.0.0.0    IISAdministration                     
Cmdlet          Start-IISCommitDelay                               1.0.0.0    IISAdministration                     
Cmdlet          Start-IISSite                                      1.0.0.0    IISAdministration                     
Cmdlet          Stop-IISCommitDelay                                1.0.0.0    IISAdministration                     
Cmdlet          Stop-IISSite                                       1.0.0.0    IISAdministration

It turns out that the IISAdministration powershell module is a server feature.
With PowerShell you enable it with: Install-WindowsFeature web-mgmt-console
Or from the Server Manager GUI, under Server Roles, you select: Web Server (IIS) -> Management Tools -> IIS Management Scripts and Tools
#>

$IISSites = Get-IISSite

$ftpSite = Get-IISSite -Name 'ZYF-FTP'
# or 
$ftpSite = $IISSites | ? { $_.Name -eq 'ZYF-FTP'}

$ftpSiteStatus = $ftpSite.State

$ftpSiteStartStatus = $ftpSite.Start()
