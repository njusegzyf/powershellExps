
$editToolCommand = 'npp'

function Edit-Hosts {
  # Start-Process notepad -Verb runas -ArgumentList $env:windir\System32\drivers\etc\hosts -Wait
  .$editToolCommand "$env:windir\System32\drivers\etc\hosts"
  ipconfig /flushdns | Out-Null
}

# Set-Alias eh Edit-Hosts
