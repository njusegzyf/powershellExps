Copy-Item -Path C:\IdeaWorkspace\ProjJSE8 -Destination Z:\ -Force -Recurse

# Run IDEA
Start-Process -FilePath "C:\Program Files (x86)\IDEA\bin\idea.exe"

Start-Process -FilePath 'C:\Program Files\7-Zip\7z.exe'

$outputFile = "Z:\out.txt"

Start-Process -FilePath "C:\Program Files\7-Zip\7z.exe" -ArgumentList "l", "Z:\Base.zip"  -RedirectStandardOutput $outputFile
Get-Process 7z | Wait-Process
notepad "$outputFile"

# Transcript is not supported
Start-Transcript $outputFile -Append -Force
&"C:\Program Files\7-Zip\7z.exe" "l" "Z:\Base.zip"
Stop-Transcript

&"C:\Program Files\7-Zip\7z.exe" "l" "Z:\Base.zip" > $outputFile

"C:/Program Files/WinRAR/WinRAR.exe"

"C:\Program Files (x86)\IDEA\bin\idea.exe"

$compressToArchive = "Z:/Dest.rar"
$compressFromDirectory = "Z:/Source/"

// Add 
&"C:/Program Files/WinRAR/WinRAR.exe" "a" "-r" $compressToArchive $compressFromDirectory

// 以完整路径名称从压缩文件解压压缩 
&"C:/Program Files/WinRAR/WinRAR.exe" "x" "-r" $compressToArchive "*" "Z:\"


$timeInterval = 600 # in seconds

$ideaProcess = Get-Process "IDEA"

if ($ideaProcess == null) {
    exit
}

while (1){
    $ideaProcess | Wait-Process -Timeout $timeInterval

    if ($ideaProcess.HasExited){
        break;
    }

    # Process after run IDEA $timeInterval seconds
}

# Process after exit IDEA 

$hddDirectory = 'E:\BackUp\'
$ramDirectory = 'Z:\ProjTemp\'

$workFilesArchiveName = "ProjJSE8.rar"

$backUpArchiveTag = "Backup"

try {
    $backUpArchive = "$backUpArchiveTag$workFilesArchiveName"
} catch{
} finally{
}