Get-NetAdapter -IncludeHidden | Where-Object { ($_.Status -eq 'Disconnected') -or ($_.Status -eq 'Not Present')} # | Enable-NetAdapter
Get-NetAdapter -Physical

Get-CimInstance -ClassName Win32_NetworkAdapter

# @see https://blogs.technet.microsoft.com/wincat/2012/09/06/device-management-powershell-cmdlets-sample-an-introduction/
Import-Module 'DeviceManagement'
# Error calling SetupDiGetDeviceProperty()
Get-Device -DeviceClass GUID_DEVCLASS_NET
