
function Switch-WlanAndLan {
  [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
  [OutputType('bool')]
  Param
    (
        [Parameter(Mandatory=$false,
                   Position=0,
                   HelpMessage='Wlan Name')]
        [String]
        $wlanName = 'WLAN',

        [Parameter(Mandatory=$false,
                   Position=1,
                   HelpMessage='Wlan Name')]
        [String]
        $lanName = '本地连接'
    )

  Process
    {
      try {
        $wlan = Get-NetAdapter -Name $wlanName
        $lan = Get-NetAdapter -Name $lanName
      } catch {
        return $false;
      }

      $isWlanUp = $wlan.Status -eq 'up'
      if ($isWlanUp) {
        # disable wlan and enable lan
        $wlan | Disable-NetAdapter
        $lan | Enable-NetAdapter
      } else {  
        # disable lan and enable wlan
        $lan | Disable-NetAdapter
        $wlan | Enable-NetAdapter
      }
      return $true;
    }
}

Switch-WlanAndLan
