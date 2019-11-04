
# Settings
$isStartOptionalServices = $true

$essentialServiceNames = @(
  'bthserv'          # 蓝牙支持服务
)

$optionalSreviceNames = @(
  'BthHFSrv',           # Bluetooth Handsfree Service
  'ibtsiva'             # Intel Bluetooth Service
)

$toStartServiceNames = if ($isStartOptionalServices) { $essentialServiceNames + $optionalSreviceNames } else { $essentialServiceNames }
$toStartServices = $toStartServiceNames | Get-Service

foreach ($service in $toStartServices) {
  if ($service.StartType -eq 'Disabled') {
    $service | Set-Service -StartupType 'Manual'
  }
}
$toStartServices | Start-Service



# Enable services
# $essentialServices + $optionalSrevices | Set-Service -StartupType Manual

# Disable services if bluetooth is not used
# $essentialServices + $optionalSrevices | Set-Service -StartupType Disabled
