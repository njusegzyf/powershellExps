
# get WebAdministration module
$module = Get-Module -Name *web* -ListAvailable 

# show commands
Get-Command -Module $module

$ftpSiteName = 'ZYF-Desktop'
$ftpSite = Get-Website $ftpSiteName
# Note: 如果在 X86 Powershell 中运行，将出现问题 Retrieving the COM class factory for component with CLSID {688EEEE5-6A7E-422F-B2E1-6AF00DC944A6} failed 

# TypeName:Microsoft.IIs.PowerShell.Framework.ConfigurationElement#site
# $ftpSite | gm

# change ftp physical path
$ftpSite.physicalPath = 'E:/'

# start ftp service
Get-Service FTPSVC | Start-Service

# start ftp server
# Note: Call `Start` method on `ftpServer`,  not the `site`
$ftpServer = $ftpSite.ftpServer

# TypeName:Microsoft.IIs.PowerShell.Framework.ConfigurationElement#site#ftpServer
# $ftpSite.ftpServer | gm

$ftpServer | Get-Member
$ftpServer.Start()

$ftpServer.Stop()

# @see 使用PowerShell在IIS FTP站点上设置权限和设置 http://www.voidcn.com/article/p-rhunnzbc-buo.html
