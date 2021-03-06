Set-ExecutionPolicy Unrestricted

Start-WLAN -NICName 'Wlan'

Start-Service -Name 'wlansvc'

$ConfirmPreference = 'None'
Start-HostedNetwork -ssid  'arx-9' -key 'arx7arx8'

shutdown -s -t 7200
exit

Stop-HostedNetwork -ssid  'arx-9'

Stop-HostedNetwork -ssid  'arx-9' -StopWLANandWlansvc
exit

# check whether hosted network is supported like `支持的承载网络  : 否`
netsh wlan show drivers

Set-DNSServer -NICName '本地连接' -DNSServerAddress '8.8.8.8'
Set-DNSServer -NICName 'Wlan' -DNSServerAddress '8.8.8.8'

Set-DNSServer -IsDHCP -NICName '本地连接'
Set-DNSServer -IsDHCP -NICName 'Wlan'

# Start goagent and flashget 1.96
Start-Process -FilePath F:\goagent\local\goagent.exe
Start-Process -FilePath C:\tools\flashget\flashget.exe 

# Start apple service
Get-Service *Apple* | Start-Service

Resolve-DnsName www.kizuna-infinity.net -Server 223.5.5.5
