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
