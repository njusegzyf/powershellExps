$protocPath = 'W:\Program\protoc-3.0.0'
$protocExePath = "$protocPath\protoc.exe"
$preCompiledProtoPath = "$protocPath\protobuf"

$protoFileSourcePath = 'Z:\addressbook.proto'

$protoDir = "Z:\proto"
$protoFileName = 'addressbook.proto'
$protoFilePath = "$protoDir/$protoFileName"

# copy pre-compiled protocol files
Copy-Item -Path $preCompiledProtoPath -Destination $protoDir -Recurse -Force 
# copy protocol file
Copy-Item -Path $protoFileSourcePath -Destination $protoFilePath -Force

$javaOutPath = "Z:\"

.$protocExePath -I="$protoDir" --java_out="$javaOutPath" "$protoFilePath"