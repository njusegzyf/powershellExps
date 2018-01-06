# Get-Service -DisplayName *hyper*

# Show NICs information
# netsh interface show interface

# Start script

# Record ConfirmPreference and temporarily set it to None
$preCP = $ConfirmPreference
$ConfirmPreference = 'None'

# Start network adapters
# netsh interface set interface 'VMware Network Adapter VMnet1' enabled 
# netsh interface set interface 'VMware Network Adapter VMnet8' enabled

# Start all VMware realted services
Start-Service -DisplayName *hyper*

# Start Hyper-V
# Start-Process -FilePath 'C:\Program Files (x86)\VMware\VMware Workstation\vmware.exe'

# Resore ConfirmPreference
$ConfirmPreference = $preCP

# End script
