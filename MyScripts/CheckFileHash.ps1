Get-ChildItem Z:\ExpDpc2 -Recurse  | ForEach-Object -Process {
  if($_ -is [System.IO.FileInfo]) {
    Write-Host($_.name);
  }
}