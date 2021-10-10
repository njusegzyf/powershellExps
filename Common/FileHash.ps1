Get-FileHash Z:\DpcCoef.data -Algorithm SHA256

Get-FileHash Z:\DpcCoef.data -Algorithm SHA256 | Get-Member

<#
TypeName:Microsoft.Powershell.Utility.FileHash

Name        MemberType   Definition
----        ----------   ----------
Equals      Method       bool Equals(System.Object obj)
GetHashCode Method       int GetHashCode()
GetType     Method       type GetType()
ToString    Method       string ToString()
Algorithm   NoteProperty string Algorithm=SHA256
Hash        NoteProperty string Hash=EE8D0DFE283EA556B08C6205371047C93A9046DF0F25927F09EC3EA8BA19B429
Path        NoteProperty string Path=Z:\DpcCoef.data
#>
