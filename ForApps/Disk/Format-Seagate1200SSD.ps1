$seagateToolsBinDir = 'Z:\SeaChestUtilities\Windows\Win64'

Set-Location $seagateToolsBinDir
Set-Alias -Name SeaChest_Format -Value './SeaChest_Format_121_1183_64s.exe'

# scan devices
SeaChest_Format -s # --scan

# This option is the same as --scan or -s, however it will also perform a low level rescan to pick up other devices.
# SeaChest_Format -S # --Scan

$diskName = 'PD2'

# show info the the device
SeaChest_Format -d $diskName -i # --deviceInfo

# format the device with current unit size
# SeaChest_Format -d $diskName --formatUnit current --fastFormat 1 --confirm I-understand-this-command-will-erase-all-data-on-the-drive

# format the device with new logical unit size
SeaChest_Format -d $diskName --formatUnit 512 --fastFormat 1 --confirm I-understand-this-command-will-erase-all-data-on-the-drive

# show format progess
SeaChest_Format -d $diskName --progress format

# show the SCSI format status log 
# Note: This log is only valid after a successful format unit operation.
SeaChest_Format -d $diskName --showFormatStatusLog
