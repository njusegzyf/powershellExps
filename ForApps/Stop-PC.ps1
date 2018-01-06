<#
.Synopsis
   Stop PC. 
.DESCRIPTION
   详细描述
.EXAMPLE
   [timespan]"0:0:10" | Stop-PC
.EXAMPLE
   另一个如何使用此 cmdlet 的示例
#>
function Stop-PC
{
    [CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact='High')]
    [OutputType('bool')]
    Param
    (
        [Parameter(Mandatory=$false,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0,
                   HelpMessage='Set the timeout used to allow programs to close gracefully before a restart or shutdown in seconds. The default timeout is 60 seconds')]
        [ValidateRange(0, 1000000)]
        [ValidateScript({$_ -ge 0})]
        [Alias('TimeOutInSeconds', 'TimeOut')]
        [int]
        $Seconds = 60,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=1)]
        [ValidateRange(0, 1000000)]
        [int]
        $Minutes = 0,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=2)]
        [ValidateRange(0, 1000000)]
        [int]
        $Hours = 0,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=3)]
        [Switch]
        $IsDoLog,

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true,
                   Position=4)]
        [AllowNull()]
        #ValidateNotNull, ValidateNotNullOrEmpty
        [String]
        $Message = ""
    )

    Begin
    {
        #if ($Seconds -lt 0 -or $Minutes -lt 0 -or $Hours -lt 0)
        #{
        #    return $false
        #}
    }
    Process
    {
        if ($Message -eq $null){
            $Message = "";
        }

        [int]$TotalSeconds = $Seconds + $Minutes * 60 + $Hours * 3600;
        
        if (!$PSCmdlet.ShouldProcess('localhost', "Close PC in $TotalSeconds seconds")){
            return $false;
        } else {
            #Write-Host 'Stop PC'

            if ($IsDoLog){
            #HashTable
            $Table = [Ordered]@{
                'OperationTime' = Get-Date
                'CloseTimeSpan' = [System.TimeSpan]::FromSeconds($TotalSeconds)
                 # 'CloseTimeSpan' = [System.TimeSpan]"$Hours`:$Minutes`:$Seconds"
                'Reason' = $Message
            }

            #Write-Output $Table | Export-Clixml -Path "C:\_Test_Temp\Log.xml"

            #New PSCustomObject
            $NewObj = New-Object -TypeName 'PSObject' -Property $Table
            $NewObj | Write-Output | Export-Clixml -Path "C:\_Test_Temp\Log.xml" 
            }

            #shutdown -s -t "$TotalSeconds
            return $true
        }
<# 
Block comments. 
#>

#multiline string(here-string)
#@"
#Strings
#"@

#@'
#Strings
#'@        
    }
    End
    {
       
    }
}

#Stop-PC -Seconds 6000 -Confirm | Out-Null

#[TimeSpan]"0:0:0" | Stop-PC -IsDoLog -Verbose -Confirm | Out-Null