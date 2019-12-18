function Test-File([String]$path) {
  # returns true if and only if path exists and is a file
  return (Test-Path -Path $path) -and 
         ((Get-Item -Path $path).GetType().FullName -eq 'System.IO.FileInfo')
}
