#
# Module manifest for module 'NICConfig'
#

@{
RootModule = 'NICConfig.psm1'

ModuleVersion = '1.0'

#GUID = 'ced422f3-86a4-4841-9f80-a713eac9522a'

Author = 'Zhang Yifan'

CompanyName = 'NJU SEG'

#Copyright="© Microsoft Corporation. All rights reserved."

#Description = 'Module that implements the DSC extensions for PowerShell'

PowerShellVersion = '3.0'

# PowerShellHostName = ''

# PowerShellHostVersion = ''

# DotNetFrameworkVersion = ''

# CLRVersion = ''

# Processor architecture (None, X86, Amd64)
# ProcessorArchitecture = ''

# RequiredModules = @()

# RequiredAssemblies = @("Microsoft.Management.Infrastructure",
#                       "Microsoft.Windows.DSC.CoreConfProviders")

#NestedModules = @('PSDesiredStateConfiguration.psm1', 'Get-DSCConfiguration.cdxml')

#ModuleToProcess = @('NICConfig',
#                    'HostedNetworkConfig')

#TypesToProcess = @()

#FormatsToProcess = @('PSDesiredStateConfiguration.format.ps1xml')

FunctionsToExport = @('Start-WLAN',
                      'Stop-WLAN',
                      'Start-HostedNetwork',
                      'Stop-HostedNetwork',
                      'Set-DNSServer')

#CmdletsToExport = @('Set-DscLocalConfigurationManager',
#                      'Start-DscConfiguration')

#VariablesToExport = '*'

#AliasesToExport = @('sacfg', 'tcfg')

# ModuleList = @()

# FileList = @()

# PrivateData = ''

# HelpInfoURI = 'http://go.microsoft.com/fwlink/?LinkId=280237'

# DefaultCommandPrefix = ''

}