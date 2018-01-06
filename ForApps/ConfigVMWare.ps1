Get-Service -DisplayName *vm*

# Show NICs information
netsh interface show interface

# Start script

# Record ConfirmPreference and temporarily set it to None
$preCP = $ConfirmPreference
$ConfirmPreference = 'None'

# Start VMware network adapters
netsh interface set interface 'VMware Network Adapter VMnet1' enabled 
netsh interface set interface 'VMware Network Adapter VMnet8' enabled

# Start all VMware realted services
Start-Service -DisplayName *vm*

# Start VMware worksation
Start-Process -FilePath 'C:\Program Files (x86)\VMware\VMware Workstation\vmware.exe'

# Resore ConfirmPreference
$ConfirmPreference = $preCP

# End script



# Record ConfirmPreference and temporarily set it to None
$preCP = $ConfirmPreference
$ConfirmPreference = 'None'

# if exists multi vmware processes
# (Get-Process -Name vmware) -is [Array] 

if (!(Get-Process -Name vmware -ErrorAction SilentlyContinue)){
    # only do work when no VMware process exists

    Write-Host "Start stop all VMware related utils"

    netsh interface set interface 'VMware Network Adapter VMnet1' disabled
    netsh interface set interface 'VMware Network Adapter VMnet8' disabled

    # Stop all VMWare related processes
    Stop-Process -Name *vm*

    Stop-Service -DisplayName *vm* -Force

    Write-Host "End stop all VMware related utils"
}

# Resore ConfirmPreference
$ConfirmPreference = $preCP


