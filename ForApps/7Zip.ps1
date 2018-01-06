[String]$7zExePath = 'C:\Program Files\7-Zip\7z.exe'
[String]$archivePath = 'Z:\archive.zip'

# test archive
# test all doc files in the archive recursively
.$7zExePath t $archivePath *.pdf *.docx -r
# test all doc files in the archive non-recursively (by default)
.$7zExePath t $archivePath *.pdf -r-
