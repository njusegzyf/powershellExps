
# MATLAB 默认根据系统语言和编码，确定保存文件的编码，中文版Windows将使用 GBK
# 可以 在命令窗口输入命令：feature('locale') 查看当前的设置

# 如需使用 UTF-8，可以修改 MATLAB 安装目录下的 locale 数据库文件 lcdata.xml (matlab bin 目录下)
# 删除
# <encoding name="GBK">  
#  < encoding_alias name="936">  
# </encoding>
# ,并将
# <encoding name="UTF-8">  
#   <encoding_alias name="utf8"/> 
# </encoding>  
# 改为
# <encoding name="UTF-8">  
#  <encoding_alias name="utf8"/>  
#   <encoding_alias name="GBK"/>  
# </encoding>
#
# 对于 MATLAB 2017 以后的版本，lcdata.xml 是仅包含注释的空文件，需要将 lcdata_utf8.xml 重命名为 lcdata.xml ，然后进行修改。

$editCmd = 'notepad'

$matlabBinDirPath = 'C:/Program Files/MatlabR2020a/bin'
Rename-Item "$matlabBinDirPath/lcdata.xml" -NewName "$matlabBinDirPath/lcdata-back.xml"
Copy-Item "$matlabBinDirPath/lcdata_utf8.xml" -Destination "$matlabBinDirPath/lcdata.xml"

.$editCmd "$matlabBinDirPath/lcdata.xml"
