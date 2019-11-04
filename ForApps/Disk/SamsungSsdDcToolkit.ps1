# @see Samsung_DCToolkit_V2.1_User_Guide
# @note Please run as administrator to use application
# @note Samsung nvme driver must be installed

$appFolder = 'C:\Tools\`[`]DiskTools\Samsung_SSD_DC_Toolkit'
$appName = 'DCToolkit'
$outputPath = 'Z:/output/'
$diskIndex = '0:c'

Set-Alias -Name DCToolkit -Value './DCToolkit'
Set-Location $appFolder

# Display the command line options which are supported by DCToolkit application. 
DCToolkit --help # -H

# Display a list of attached Samsung SSDs
DCToolkit --list # -L

# Displays Identify information 
DCToolkit --disk $diskIndex --identify --path $outputPath



# For SATA SSDs

# Select a specific drive connected to the system and get the SMART Value
DCToolkit --disk $diskIndex --smart
DCToolkit --disk $diskIndex --smart --query # Display the percentage of the available LBA to replace

# Display Log Pages on specified NVMe disk
DCToolkit --disk $diskIndex -NG --error 4 # --smart



# For NVME SSDs

DCToolkit --disk $diskIndex --health-monitor --nvme-smart --path $outputPath
