# @see [[https://www.sconstantinou.com/powershell-script-blocks/ PowerShell Script Blocks]]
# @see script `FunctionParamPipeline.ps1` for the difference of `$_` and input parameter

<# Syntax 
PowerShell script blocks can have parameters, similar to functions. And also they are able to accept the below keywords
    DynamicParam
    Begin
    Process
    End 

Moreover, unlike functions, you are not able to specify parameters outside of the braces. Check the syntax below:
{ param([type]$Variable1, [type]$Variable2, ...) <list of statements and expressions>}
#>

<# Usage
A script block is an instance of a Microsoft .NET Framework type (System.Management.Automation.ScriptBlock).
Some commands have -ScriptBlock parameter that you are able to assign values. An example of such command is Invoke-Command.
#>
Invoke-Command -ScriptBlock {Get-NetAdapter -Physical}

$scriptBlock = { param($in = 'Synny') Write-Host "$in Weather" }
Invoke-Command -ScriptBlock $scriptBlock                      # Sunny Weather
Invoke-Command -ScriptBlock $scriptBlock -ArgumentList "Bad"  # Bad Weather
# or
& $scriptBlock        # Sunny Weather
& $scriptBlock "Bad"  # Bad Weather

# Or use auto variable `$args`
$scriptBlock = { Write-Host "$(if($args[0]) { $args[0] } else { 'Synny' }) Weather" }
& $scriptBlock        # Sunny Weather
& $scriptBlock "Bad"  # Bad Weather

<# Delay-Bind Script Blocks
A delay-bind script block allows you to pipe input to a given parameter, 
then use script blocks for other parameters using the pipeline variable $_ to reference the same object.
#>
Get-ChildItem -Path "C:\TestFolder" | Rename-Item -NewName { "test-" + $_.Name }

# Note: Do not use auto variable names like `$input` or `$_`, whose value will be filled by system and overwrite the default value.
# For example:
$errorBlock = { param($input = "Sunny") Write-Host "$input Weather" }
& $errorBlock # output ` Weather`, which means `$input` is null
& $errorBlock "Bad" # still output ` Weather`, which means `$input` is null
