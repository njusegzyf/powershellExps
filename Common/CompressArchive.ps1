# 以 Optimal level 进行压缩，将 Z:\dir 下的所有文件（包括子文件） 压缩到 Z:\archive.zip
# 压缩文件包含 dir 文件夹的目录结构
Compress-Archive -Path Z:\dir -DestinationPath Z:\archive -CompressionLevel Optimal

# 与前面的压缩命令类似，但是压缩文件不会保留 dir 文件夹的目录结构
Compress-Archive -Path Z:\dir\*.* -DestinationPath Z:\archive -CompressionLevel NoCompression

# -Path 可以包含多个路径
Compress-Archive -Path 'Z:\dir\Disc 1', 'Z:\dir\Disc 2\*.mp3' -DestinationPath Z:\archive -CompressionLevel NoCompression

# 解压文件
Expand-Archive 'Z:\archive.zip' 'Z:\expandDir' 

# 如果要被解压的文件在解压目录下已存在，会产生错误
# 使用 -Force 选项可以让被解压文件覆盖原有文件
Expand-Archive 'Z:\archive.zip' 'Z:\expandDir' -Force
