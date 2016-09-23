<#
.Synopsis
.DESCRIPTION
.EXAMPLE
#>
Function global:Back-RamDisk
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([Boolean])]
    Param
    (
		[Parameter(Mandatory=$true,
				   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
		[String]
        $ramDiskPathString,

		[Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
		[String]
        $backupPathString = 'e:\RamDiskBack',

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
		[String[]]
        $excludePaths = @('temp', '$RECYCLE.BIN', 'Internet 临时文件', 'Temporary Internet Files'),

        [Parameter(Mandatory=$false,
                   ValueFromPipelineByPropertyName=$true)]
		[Switch]
        $isBackFolderAsArchive = $false
    )

    Process
    {
        # back files to a directory named with current datetime under the given backup path
        $curDateTime = Get-Date -Format 'yyyy-MM-dd_HH-mm-ss'
        $backupPathString = "$backupPathString\$curDateTime"

		$ramDiskItem = Get-Item -Path $ramDiskPathString

		if (!$ramDiskItem.Exists) { return $false }

		Try {
			# for each file
			ForEach ($backItem in $ramDiskItem.GetFiles()) {
			# skip exclude paths
				if ($excludePaths -contains $backItem.Name ) { continue } 

				Write-Host "Back file `"$backItem`"."
				Copy-Item -Path $backItem -Destination "$backupPathString\${$backItem.name}"
			}

			# for each directory
			ForEach ($backItem in $ramDiskItem.GetDirectories()) {
				# skip exclude paths
				if ($excludePaths -contains $backItem.Name ) { continue } 

				Write-Host "Back directory `"$backItem`"."
				if ($isBackFolderAsArchive) {
					# archive directory to the back directory
					Compress-Archive -Path $backItem -DestinationPath "$backupPathString\$backItem" -CompressionLevel Optimal
				} else {
					# directly copy directory to the back directory
					Copy-Item -Path $backItem.FullName -Destination "$backupPathString\$backItem" -Recurse 
				}
			}
		} Catch {
			return $false
		}

		Write-Host "All files and directories are backed up to $backupPathString"
		return $true
    }
}
