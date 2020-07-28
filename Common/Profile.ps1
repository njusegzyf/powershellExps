# profile 文件用于自定义 powershell environment
# see https://msdn.microsoft.com/en-us/library/bb613488%28VS.85%29.aspx
# 

# PowerShell supports several profile files. Also, PowerShell host programs can support their own host-specific profiles.
# For example, the PowerShell console supports the following basic profile files. The profiles are listed in precedence order. 
# The first profile has the highest precedence.
#
# Description 	Path
# All Users, All Hosts 	$PSHOME\Profile.ps1
# All Users, Current Host 	$PSHOME\Microsoft.PowerShell_profile.ps1
# Current User, All Hosts 	$Home\[My]Documents\PowerShell\Profile.ps1
# Current user, Current Host 	$Home\[My]Documents\PowerShell\
# Microsoft.PowerShell_profile.ps1
#
# The profile paths include the following variables:
#   The $PSHOME variable, which stores the installation directory for PowerShell
#   The $Home variable, which stores the current user's home directory
#
# In addition, other programs that host PowerShell can support their own profiles.
# For example, Visual Studio Code supports the following host-specific profiles.
# Description 	Path
# All users, Current Host 	$PSHOME\Microsoft.VSCode_profile.ps1
# Current user, Current Host 	$Home\[My ]Documents\PowerShell\Microsoft.VSCode_profile.ps1
#
# In PowerShell Help, the "CurrentUser, Current Host" profile is the profile most often referred to as "your PowerShell profile".

# For powershell ISE C:\Users\zhangyf\Documents\WindowsPowerShell\Microsoft.PowerShellISE_profile.ps1
npp $profile

# To see the current values of the $PROFILE variable, type:
# $PROFILE | Get-Member -Type NoteProperty

# Common profile
npp $PSHOME\Profile.ps1
