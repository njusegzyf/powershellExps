Set-Location 'Z:\performance'
. 'C:\Program Files\MATLABR2020a\bin\matlab.exe' -nosplash -r "coder -build run"

# @note `-nodisplay` does not works in Windows

# converts the existing project named `$projectname.prj` to the equivalent script of MATLAB commands. The script is named scriptname.
# coder -tocode projectname -script $scriptname
