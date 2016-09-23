$sourceDirPath = 'C:\VsProj15'
$projectName = 'SinglePageApp'
$slnName = "$projectName.sln"
$destDirPath = 'Z:\'

$vsPath = 'W:\Program\VS14\Common7\IDE'
$vsExePath = "$vsPath\devenv.exe"

# copy project from source to destination
Copy-Item -Path "$sourceDirPath\$projectName" -Destination $destDirPath -Recurse -Force

# run vs
&$vsExePath "$destDirPath\$projectName\$slnName"
# devenv "$destDirPath\$projectName\$slnName"

# copy project back
# Copy-Item -Path "$destDirPath/$projectName" -Destination $sourceDirPath -Recurse -Force

