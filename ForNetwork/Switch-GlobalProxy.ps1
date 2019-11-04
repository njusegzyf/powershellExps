$proxyAddress = '114.212.81.250:8080'

$enableProxy = Get-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings' -Name ProxyEnable

if($enableProxy.ProxyEnable -eq 1)
{
    Write-Host "IE proxy is disabled"
    Set-ItemProperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -value 0
}
else
{
    Write-Host "IE proxy is enabled"
    Set-ItemProperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyEnable" -value 1
    Set-ItemProperty -path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" -Name "ProxyServer" -value $proxyAddress
}
