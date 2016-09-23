cd ~/Desktop/PS

# open script in ISE
ISE DNSConfig.ps1

# get and set ISE options
$psISEOrgZoom = $psISE.Options.Zoom
$psISE.Options.Zoom = 200
$psISE.Options.Zoom = $psISEOrgZoom
Remove-Variable psISEOrgZoom

$psISE.Options.ShowToolBar = $false
$psISE.Options.ShowToolBar = $true