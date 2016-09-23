$targetSolutionName = 'SinglePageApp'
$targetSolutionSlnName = "$targetSolutionName.sln" # 'SinglePageApp.sln'

$solutionsDirectory = 'C:\VsProj15'

$ramDiskSolutionsDirectory = 'Z:\Solutions'

# copy solution to ram disk
Copy-Item -Path "$solutionsDirectory\$targetSolutionName" -Destination "$ramDiskSolutionsDirectory\$targetSolutionName" -Recurse

$vsPath = 'W:\Program\VS14\Common7\IDE\devenv.exe'

# open solution in visual studio
&$vsPath "$ramDiskSolutionsDirectory\$targetSolutionName\$targetSolutionSlnName"
