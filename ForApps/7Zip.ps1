[String]$7zExePath = 'C:\Program Files\7-Zip\7z.exe'
[String]$archivePath = 'Z:\archive.zip'

# test archive
# test all doc files in the archive recursively
.$7zExePath t $archivePath *.pdf *.docx -r
# test all doc files in the archive non-recursively (by default)
.$7zExePath t $archivePath *.pdf -r-



# @see https://www.pstips.net/the-registry.html

function Remove-7ZipHistory() {

  # $7ZipRoot = 'Microsoft.PowerShell.Core\Registry::HKEY_CURRENT_USER\SOFTWARE\7-Zip\Compression'
  $7ZipRoot = 'HKCU:\SOFTWARE\7-Zip\Compression'
  $7ZipCompress = "$7ZipRoot/Compress"
  $7ZipExtraction = "$7ZipRoot/Extraction"
  $7ZipFileManager = "$7ZipRoot/FM"
  
  # clear item property `history`'s value in compress register key 
  Clear-ItemProperty -Path $7ZipCompress -Name 'history'
  # remove item property `history` in compress register key
  Remove-ItemProperty -Path $7ZipCompress -Name 'history'
}
