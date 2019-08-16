# @see https://powershellexplained.com/2017-04-10-Powershell-exceptions-everything-you-ever-wanted-to-know/
# @see https://blogs.msdn.microsoft.com/kebab/2013/06/09/an-introduction-to-error-handling-in-powershell/

# This creates a runtime exception that is a terminating error.
# It will be handled by a catch in a calling function or exit the script with a message like this.
function Throw-Exception {
  throw "Bad thing happened"
}



# Write-Error
# Write-Error does not throw a terminating error by default. 
# If you specify -ErrorAction Stop then Write-Errorgenerates a terminating error that can be handled with a catch.
function Write-ErrorCustom1 { 
  Write-Error -Message "We have a problem." # does not throw a terminating error 
}
function Write-ErrorCustom2 { 
  Write-Error -Message "We have a problem." -ErrorAction Stop # does throw a terminating error 
}

# Cmdlet -ErrorAction Stop
# If you specify -ErrorAction Stop on any advanced function or Cmdlet, 
# it will turn all Write-Error statements into terminating errors that will stop execution or that can be handled by a catch.
Write-ErrorCustom1 -ErrorAction Stop # make `Write-Error` in `Write-ErrorCustom1` throw a terminating error



# Try/Catch/Finally
# The way exception handling works in PowerShell is that you first try a section of code and if it throws an error, you can catch it.
try {
  Write-ErrorCustom2 -ErrorAction Stop
} catch {
  Write-Output "Something threw an exception or used Write-Error"
}

# Sometimes you don¡¯t need to handle an error but still need some code to execute if an exception happens or not.
# A finally script does exactly that.
$queryString = ''
$connection = ''
$command = [System.Data.SqlClient.SqlCommand]::New($queryString, $connection)
try {
  $command.Connection.Open()
  $command.ExecuteNonQuery()
} finally {
  $command.Connection.Close()
}



# $PSItem
# TODO 
