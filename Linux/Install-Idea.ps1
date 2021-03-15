function Install-Idea($downloadRoot) {

# install and config IDEA
$ideaTarPath = Get-ChildItem -Path $downloadRoot -Filter 'idea*.tar.gz'

tar -zxvf $ideaTarPath.FullName
# Note: `Expand-Archive` does not support .gz
# Expand-Archive -Path ($ideaTarPath.FullName) -DestinationPath './IDEA'  

$originIdeaDir = Get-ChildItem -Path '.' -Filter 'idea*'
Rename-Item $originIdeaDir.Name 'IDEA'

# ./IDEA/bin/idea.sh

}