# From Free EBook - Windows PowerShell Networking Guide

<#
  1. Identifying network adapters
#>

# The Get-NetAdapter cmdlet returns the name, interface description, index number, and status 
# of all network adapters present on the system.
$netAdapters = Get-NetAdapter
$localNetAdapter = Get-NetAdapter -Name '本地连接'

# dive into details
Get-NetAdapter | Format-List -Property * 

Get-NetAdapter -Name '本地连接' |
Select-Object -Property ifname, adminstatus, MediaConnectionState, LinkSpeed, PhysicalMediaType

# look only for network adapters that are in the admin status of _up
Get-NetAdapter | Where-Object -Property AdminStatus -EQ 'up'

# When I combine the Get-NetAdapter function with the Get-NetAdapterBinding function I can
# easily find out which protocols are bound to which network adapter. I just send the results to
# the Where-Object and check to see if the enabled property is equal to true or not.
Get-NetAdapter | Get-NetAdapterBinding | Where-Object -Property enabled -EQ $true

Get-NetAdapter |
Get-NetAdapterBinding |
Where-Object {$_.enabled -AND $_.displayname -match 'Internet'}



<#
  2. Enabling and disabling network adapters
#>

Get-NetAdapter | Where-Object Status -NE 'up' | Enable-NetAdapter

# Using the NetAdapter module
Get-Command -Noun 'NetAdapter' | Select-Object -Property Name, ModuleName

# disable the nonconnected network adapters
Get-NetAdapter | Where-Object -Property Status -NE 'up' | Disable-NetAdapter
# To suppress the prompt, I need to supply $false to the -confirm parameter.
Get-NetAdapter | Where-Object -Property Status -NE 'up' | Disable-NetAdapter -Confirm $false



<#
  3. Renaming the network adapter
#>

Get-NetAdapter -Name 'Ethernet' | Rename-NetAdapter -NewName 'MyRenamedAdapter'
# pass the `whatif` parameter to ensure accomplishes what I want. 
Get-NetAdapter -Name '本地连接' | Rename-NetAdapter -NewName 'MyRenamedAdapter' -WhatIf
# return an instance of the renamed network adapter
$renamedAdpater = Get-NetAdapter -Name '本地连接' | Rename-NetAdapter -NewName 'MyRenamedAdapter' -PassThru



<#
  4. Finding connected network adapters
#>

# Use the -physical parameter with the Get-NetAdapter function and filter for a status of `up`. 
Get-NetAdapter -Physical | Where-Object -Property Status -eq 'up'



<#
  5. Identifying and Configuring network adapter power setting
#>

Get-NetAdapterPowerManagement -Name '本地连接'
Get-NetAdapter -InterfaceIndex 2 | Get-NetAdapterPowerManagement
Get-NetAdapter -InterfaceIndex 2 | Set-NetAdapterPowerManagement -WakeOnMagicPacket Enabled

# To make changes to multiple computers, I first use the New-CimSession cmdlet to make my remote connections. 
# I can specify the computer names and the credentials to use to the connection. I then store the remote connection in a variable. 
# Next, I pass that cimsession to the -cimsession parameter. 
$session = New-CimSession -ComputerName edlt
$powerManagement = Set-NetAdapterPowerManagement -CimSession $session -name ethernet -ArpOffload Enabled -DeviceSleepOnDisconnect Disabled `
    -NSOffload Enabled -WakeOnMagicPacket Disabled -WakeOnPattern Disabled -PassThru



<#
  6. Gathering network adapter statistics
#>
# To collect performance counter information, I need to know the performance counter set names so I can easily gather the information. 
# To do this, I use the Get-Counter cmdlet and I choose all of the listsets. 
# I then like to sort on the countersetName property and then select only that property. 
# The following command retrieves the available listsets.

Get-Counter -ListSet * |
Sort-Object CounterSetName |
Select-Object CounterSetName |
Out-GridView

# First obtain the paths
$paths = (Get-Counter -ListSet ipv4).paths
# Next I use the paths with the Get-Counter cmdlet to retrieve a single instance of the IPv4 performance information.
$counters = Get-Counter -Counter $paths

# If I want to monitor a counter set for a period of time, I use the -SampleInterval property and the -MaxSamples parameter. 
# In this way I can specify how long I want the counter collection to run. 
Get-Counter -Counter $paths -SampleInterval 60 -MaxSamples 60
# If I want to monitor continuously, until I type Ctrl-C and break the command, I use the Continuous parameter and the -SampleInterval parameter.
Get-Counter -Counter $paths -SampleInterval 30 -Continuous

# Using Get-NetAdapterStatistics function

# The Get-NetAdapterStatistics function from the NetAdapter module provides a quick overview of the sent and received packets.
Get-NetAdapterStatistics
Get-NetAdapter -ifIndex 2 | Get-NetAdapterStatistics | Format-List *
 


<#
  Test network connection
#>

# Do ping(ICMP) test. This command comes from `Microsoft.PowerShell.Management`.
Test-Connection -ComputerName 8.8.8.8

# Do ping(ICMP) test . This command comes from `NetTCPIP`(Microsoft).
Test-NetConnection -ComputerName 8.8.8.8 -Port 21
Test-NetConnection -ComputerName www.baidu.com -CommonTCPPort HTTP
Test-NetConnection -ComputerName www.baidu.com -TraceRoute
