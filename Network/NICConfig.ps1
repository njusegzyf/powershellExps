ipconfig -all
Clear-Host

tracert channel9.msdn.com
tracert www.baidu.com
tracert www.amazon.co.jp

<#
netstat -s
——本选项能够按照各个协议分别显示其统计数据。如果你的应用程序（如Web浏览器）运行速度比较慢，或者不能显示Web页之类的数据，那么你就可以用本选项来查看一下所显示的信息。你需要仔细查看统计数据的各行，找到出错的关键字，进而确定问题所在。
netstat -e
——本选项用于显示关于以太网的统计数据，它列出的项目包括传送数据报的总字节数、错误数、删除数，包括发送和接收量（如发送和接收的字节数、数据包数[1]），或有广播的数量。可以用来统计一些基本的网络流量。
netstat -r
——本选项可以显示关于路由表的信息，类似于后面所讲使用routeprint命令时看到的信息。除了显示有效路由外，还显示当前有效的连接。
netstat -a
——本选项显示一个所有的有效连接信息列表，包括已建立的连接（ESTABLISHED），也包括监听连接请求（LISTENING）的那些连接。
netstat -n
——显示所有已建立的有效连接。[3]
netstat -p
——显示协议名查看某协议使用情况
#>

netstat -s
netstat -p

<# 
    Write-Host "当前接口信息如下：" 
    netsh interface ipv4 show interface    
    $IntefaceName = Read-Host "请输入需要修改的接口名称" 
    $NewIntefaceName = Read-Host "请输入新的接口名称" 
    $InterfaceAddress = Read-Host "请输入服务器需配置的IP地址" 
    $InterfaceMask = Read-Host "请输入服务器需配置的子网掩码" 
    $InterfaceGateWay = Read-Host "请输入服务器需配置的网关" 
    $InterfaceDNS = Read-Host "请输入服务器需配置的DNS地址" 
     
    netsh interface ipv4 set address name=$IntefaceName source=static address=$InterfaceAddress mask=$InterfaceMask gateway=$InterfaceGateWay 
    netsh interface ipv4 set dns name=$IntefaceName source=static address=$InterfaceDNS register=primary 
    netsh interface set interface name=$IntefaceName newname=$NewIntefaceName 
     
    Write-Host "网卡接口信息配置成功！" -ForegroundColor Green 
#>

$IntefaceName = '本地连接'
$InterfaceDNSv4p = '8.8.8.8' 
$InterfaceDNSv4s = '8.8.4.4'
$InterfaceDNSv6p = '2001:4860:4860::8888'
$InterfaceDNSv6s = '2001:4860:4860::8844'

# set ipv4 dns using netsh
<#
用法: set dnsservers [name=]<字符串> [source=]dhcp|static
             [[address=]<IP 地址>|none]
             [[register=]none|primary|both]
             [[validate=]yes|no]

参数:

      标记           值
      name         - 接口的名称或索引。
      source       - 下列值之一:
                     dhcp: 将 DHCP 设置为源，以便为特定接口
                           配置 DNS 服务器。
                     static: 将用于配置 DNS 服务器的源设置为
                             本地静态配置。
      address      - 下列值之一:
                     <IP address>: DNS 服务器的 IP 地址。
                     none: 清除 DNS 服务器列表。
      register     - 下列值之一:
                     none: 禁用动态 DNS 注册。
                     primary: 仅在主 DNS 后缀下注册。
                     both: 在主 DNS 后缀下注册，同时在特定连接
                           后缀下注册。
      validate     - 指定是否将验证 DNS 服务器设置。
                     默认情况下，值为 yes。

备注: 将 DNS 服务器配置设置为 DHCP 或静态模式。仅当
      源为 "static" 时，"addr" 选项还可用于为指定的接口
      配置 DNS 服务器 IP 地址的静态列表。
      如果 Validate 开关为 yes，
      则验证新设置的 DNS 服务器。
#>
netsh interface ipv4 set dnsservers name=$IntefaceName source=static address=$InterfaceDNSv4p register=primary
# 添加dns server，默认添加在末尾，或者指定的index（从1开始）
<#
用法: add dnsservers [name=]<字符串> [address=]<IPv6 地址>
             [[index=]<整数>] [[validate=]yes|no]

参数:

      标记            值
      name         - 要添加的 DNS 服务器的接口的名称或
                     索引。
      address      - 要添加的 DNS 服务器的 IPv6 地址。
      index        - 为指定的 DNS 服务器地址指定
                     索引(首选项)。
      validate     - 指定是否将验证 DNS 服务器设置。
                     默认情况下，值为 yes。

备注: 将新的 DNS 服务器 IPv6 地址添加到静态配置的列表。
      默认情况下，将 DNS 服务器添加到列表结尾。如果指定了索引，
      则 DNS 服务器将被放置在该列表的此位置上，其他服务器依次下移
      以腾出空间。
      如果 Validate 开关为 yes，则验证新添加的 DNS
      服务器。
#>
netsh interface ipv4 add dnsservers name=$IntefaceName address=$InterfaceDNSv4s index=2
netsh interface ipv4 set dnsservers name=$IntefaceName source=dhcp

# set ipv4 dns using Powershell
Get-DnsClientServerAddress -InterfaceAlias $IntefaceName -AddressFamily IPv4 | # | Out-GridView -PassThru
Set-DnsClientServerAddress -Addresses $InterfaceDNSv4p,$InterfaceDNSv4s
# reset (get from dhcp)
Get-DnsClientServerAddress -InterfaceAlias $IntefaceName -AddressFamily IPv4 | # | Out-GridView -PassThru
Set-DnsClientServerAddress -ResetServerAddresses

# flush DNS
Clear-DnsClientCache
 
# set ipv6 dns using netsh
netsh interface ipv6 set dnsservers name=$IntefaceName source=static address=$InterfaceDNSv6p register=primary 
netsh interface ipv6 add dnsservers name=$IntefaceName address=$InterfaceDNSv6s index=2
netsh interface ipv6 set dnsservers name=$IntefaceName source=dhcp

# flush DNS
ipconfig /flushdns

# set ipv6 dns using Powershell
Get-DnsClientServerAddress -InterfaceAlias $IntefaceName -AddressFamily IPv6 | # | Out-GridView -PassThru
Set-DnsClientServerAddress -Addresses $InterfaceDNSv6p,$InterfaceDNSv6s
# reset (get from dhcp)
Get-DnsClientServerAddress -InterfaceAlias $IntefaceName -AddressFamily IPv6 | # | Out-GridView -PassThru
Set-DnsClientServerAddress -ResetServerAddresses

# flush DNS
Clear-DnsClientCache

Get-DnsClientServerAddress -InterfaceAlias $IntefaceName

# Resovle dns name
Resolve-DnsName google.com | Format-Table -AutoSize
Resolve-DnsName google.com | Select-Object IPAddress



# 查询PowerShell中文博客的IP地址
Resolve-DnsName -name www.pstips.net -NoHostsFile | foreach {
 # IP地址服务
 $ipSvc= 'http://ip.taobao.com/service/getIpInfo.php?ip='+ $_.IPAddress

 # 向IP地址服务发送Rest请求
 $r = Invoke-RestMethod $ipSvc

 #在 Data 对象中加入IP属性
 $r.data | Add-Member -MemberType NoteProperty 'IP' $_.IPAddress -Force

 #筛选属性
 $r.data | select ip,country,region,city,isp
}



Function Test-TcpPort
{
    Param(
        [string]$ComputerName = 'localhost',
        [Int]$port = 5985,
        [Int]$timeout = 1000
    )

    try
    {
        $tcpclient = New-Object -TypeName system.Net.Sockets.TcpClient
        $iar = $tcpclient.BeginConnect($ComputerName,$port,$null,$null)
        $wait = $iar.AsyncWaitHandle.WaitOne($timeout,$false)
        if(!$wait)
        {
            $tcpclient.Close()
            return $false
        }
        else
        {
            # Close the connection and report the error if there is one
            
            $null = $tcpclient.EndConnect($iar)
            $tcpclient.Close()
            return $true
        }
    }
    catch 
    {
        $false 
    }
}

Test-TcpPort -ComputerName localhost



netsh interface show interface
netsh interface ipv4 show dnsservers
netsh interface ipv6 show dnsservers
netsh interface ipv6 delete dnsservers $IntefaceName all

# 可用以下指令可以清除所有IPv6的配置，恢复系统默认值，推荐存在故障时使用此命令恢复默认值，然后再次重新配置IPv6的接入方式：
netsh interface ipv6 reset

# 用以下指令可将隧道服务禁用：
netsh interface ipv6 6to4 set state disable
netsh interface ipv6 isatap set state disable
netsh interface ipv6 teredo set state disable


# LSP(Layered Service Provider)，是一些重要网络协议的接口
 netsh winsock reset
 <#
audit          - 显示已经安装和删除的 Winsock LSP 列表。
dump           - 显示一个配置脚本。
help           - 显示命令列表。
remove         - 从系统中删除 Winsock LSP。
reset          - 重置 Winsock 目录为清除状态。
set            - 设置 Winsock 选项。
show           - 显示信息。
 #>