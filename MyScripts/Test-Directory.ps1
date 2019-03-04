function Test-Directory([String]$path) {
  # returns true if and only if path exists and is a directory
  return (Test-Path -Path $path) -and 
         ((Get-Item -Path $path).GetType().FullName -eq 'System.IO.DirectoryInfo')
}
