<#
.Synopsis
   简短描述 
.DESCRIPTION
   详细描述
.EXAMPLE
   [timespan]"0:0:10" | Close-PC
.EXAMPLE
   另一个如何使用此 cmdlet 的示例
#>
function Start-WLAN
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    [OutputType('bool')]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   HelpMessage='Help message')]
        [String]
        $NICName = 'WLAN',

        [Parameter(Mandatory=$false,
                   Position=1)]
        [Switch]
        $NotStartWlansvc
    )

    Begin
    {
    		if (-Not $NotStartWlansvc){
				Start-Service -Name 'wlansvc'
			}
    }
    Process
    {
        Try{
            $wlanNIC =  Get-NetAdapter -Name "$NICName"

			#endable WLAN NetAdapter and start necessary services
			$wlanNIC | Enable-NetAdapter
			
            return $true
        } Catch{
            return $false
        }
    }
    End
    {
       
    }
}

function Stop-WLAN
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    [OutputType('bool')]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   HelpMessage='Help message')]
        [String]
        $NICName = 'WLAN',

        [Parameter(Mandatory=$false,
                   Position=1)]
        [Switch]
        $NotStopWlansvc
    )

    Begin
    {
            if (-Not $NotStopWlansvc){
				Stop-Service -Name 'wlansvc'
			}
    }
    Process
    {
        Try{
            $wlanNIC =  Get-NetAdapter -Name "$NICName"
			$wlanNIC | Disable-NetAdapter

            return $true
        } Catch{
            return $false
        }
    }
    End
    {
       
    }
}

function Start-HostedNetwork
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    [OutputType('bool')]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   HelpMessage='Help message')]
        [String]
        $ssid,

        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1,
                   HelpMessage='Help message')]
        [String]
        $key,

        [Parameter(Mandatory=$false,
                   Position=2)]
        [Switch]
        $NotStartWLANandWlansvc,

        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3,
                   HelpMessage='Help message')]
        [String]
        $NICName = 'WLAN'
    )

    Begin
    {
    		if (-Not $NotStartWLANandWlansvc){
				Start-WLAN "$NICName"
			}
    }
    Process
    {
        Try{
            netsh wlan set hostednetwork mode=allow ssid="$ssid" key="$key"
            netsh wlan start hostednetwork
			
            return $true
        } Catch{
            return $false
        }
    }
    End
    {
       
    }
}

function Stop-HostedNetwork
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    [OutputType('bool')]
    Param
    (
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   HelpMessage='Help message')]
        [String]
        $ssid,

        [Parameter(Mandatory=$false,
                   Position=1)]
        [Switch]
        $StopWLANandWlansvc,

        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2,
                   HelpMessage='Help message')]
        [String]
        $NICName = 'WLAN'
    )

    Begin
    {
    }
    Process
    {
        netsh wlan stop hostednetwork
    }
    End
    {
       if ($StopWLANandWlansvc){
			Stop-WLAN "$NICName"
        }
    }
}

function Set-DNSServer
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='Medium')]
    [OutputType('bool')]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   HelpMessage='Help message')]
        [Switch]
        $IsDHCP,   

        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1,
                   HelpMessage='Help message')]
        [String]
        $NICName = '本地连接',

        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2,
                   HelpMessage='Help message')]
        [String]
        $DNSServerAddress = '8.8.8.8',

        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3,
                   HelpMessage='Help message')]
        [Switch]
        $IsRegisterBoth,
        
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=4,
                   HelpMessage='Help message')]
        [Switch]
        $IsIPV6
    )

    Begin
    {
        if (-Not $IsIPV6){
            #For ipv4
            if ($IsDHCP){
                netsh interface ipv4 set dnsservers name="$NICName" source=dhcp
            }else{
                if (-Not $IsRegisterBoth){
                    netsh interface ipv4 set dnsservers name="$NICName" source=static address="$DNSServerAddress" register=primary 
                }else{
                    netsh interface ipv4 set dnsservers name="$NICName" source=static address="$DNSServerAddress" register=both 
                }
            }
        }else{
            #For ipv6
        }
    }
    Process
    {
    }
    End
    {
    }
}