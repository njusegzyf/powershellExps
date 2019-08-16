
if (Get-NetIPAddress | ForEach-Object { $_.IPv6Address } | Where-Object { $_ -like '2001*' }) {
  # if we have get some vaild IPv6 addresses
} else {
  #
  ipconfig /renew6
}
