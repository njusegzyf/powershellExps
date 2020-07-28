# Note: 执行脚本必须有管理员权限，且执行完后必须重启电脑才会生效
# @see [[https://jingyan.baidu.com/article/6181c3e04fb222152ff1534e.html]]

$currentControlKey = Get-Item HKLM:\SYSTEM\CurrentControlSet\Control

$storageDevicePoliciesKeyPath = "$($currentControlKey.PSPath)\StorageDevicePolicies"
if (Test-Path $storageDevicePoliciesKeyPath) { # Test key $storageDevicePoliciesKeyPath
  $storageDevicePoliciesKey = Get-Item $storageDevicePoliciesKeyPath
} else {
  Write-Output "Create registry key $storageDevicePoliciesKeyPath."
  $storageDevicePoliciesKey = New-Item $storageDevicePoliciesKeyPath
}

# get property in the key if exists
$writeProtectProperty = Get-ItemProperty -Path $storageDevicePoliciesKeyPath -Name WriteProtect

if ($writeProtectProperty) {
  Write-Output "Set property WriteProtect's value to 0."
  Set-ItemProperty -Path $storageDevicePoliciesKeyPath -Name WriteProtect -Value 0
} else {
  Write-Output "Create property WriteProtect as DWrod with value 0."
  New-ItemProperty -Path $storageDevicePoliciesKeyPath -Name WriteProtect -PropertyType DWord -Value 0
}
