$IntefaceName = '本地连接'
$InterfaceDNSv4p = '8.8.8.8' 
$InterfaceDNSv4s = '8.8.4.4'
$InterfaceDNSv6p = '2001:4860:4860::8888'
$InterfaceDNSv6s = '2001:4860:4860::8844'

$DNS01 = '119.29.29.29'
$DNS02 = '223.5.5.5'

# set v4 and v6 dns to google
Get-DnsClientServerAddress -InterfaceAlias $IntefaceName -AddressFamily IPv4 | # | Out-GridView -PassThru
Set-DnsClientServerAddress -Addresses $InterfaceDNSv4p,$InterfaceDNSv4s
Get-DnsClientServerAddress -InterfaceAlias $IntefaceName -AddressFamily IPv6 | # | Out-GridView -PassThru
Set-DnsClientServerAddress -Addresses $InterfaceDNSv6p,$InterfaceDNSv6s
Clear-DnsClientCache

# set v4 dns to ali
Get-DnsClientServerAddress -InterfaceAlias $IntefaceName -AddressFamily IPv4 | # | Out-GridView -PassThru
Set-DnsClientServerAddress -Addresses '223.5.5.5','223.6.6.6'

# reset v4 and v6 dns
Get-DnsClientServerAddress -InterfaceAlias $IntefaceName -AddressFamily IPv4 | # | Out-GridView -PassThru
Set-DnsClientServerAddress -ResetServerAddresses
Get-DnsClientServerAddress -InterfaceAlias $IntefaceName -AddressFamily IPv6 | # | Out-GridView -PassThru
Set-DnsClientServerAddress -ResetServerAddresses
Clear-DnsClientCache

ipconfig -all

<#
tracert(trace router的缩写，为路由跟踪命令)
　　主要用于显示将数据包从计算机传递到目标位置的一组IP路由器，以及每个跃点所需的时间(即跟踪数据报传送路径),测试网络连通性问题.
基本用法: tracert [-d] [-h maximum_hops] [-j host-list] [-w timeout]                
　　　　　　　　　[-R] [-S srcaddr] [-4] [-6] target_name(目标IP、URL或域名)
选项:
    -d                 不将地址解析成主机名.
    -h maximum_hops    搜索目标的最大跃点数.
    -j host-list       与主机列表一起的松散源路由(仅适用于 IPv4).
    -w timeout         等待每个回复的超时时间(以毫秒为单位).
    -R                 跟踪往返行程路径(仅适用于 IPv6).
    -S srcaddr         要使用的源地址(仅适用于 IPv6).
    -4                 强制使用 IPv4.
    -6                 强制使用 IPv6.
#>

tracert -6 [2001:da8:9000::232] 

<#
nslookup 
    nslookup [-opt ...] # 使用默认服务器的交互模式
　　nslookup [-opt ...] - server # 使用 "server" 的交互模式
　　nslookup [-opt ...] host # 仅查找使用默认服务器的 "host"
　　nslookup [-opt ...] host server # 仅查找使用 "server" 的 "host"
#>

Resolve-DnsName -name bt.neu6.edu.cn -NoHostsFile

nslookup bt.neu6.edu.cn 
nslookup bt.neu6.edu.cn 223.5.5.5
nslookup bt.neu6.edu.cn $InterfaceDNSv6p



