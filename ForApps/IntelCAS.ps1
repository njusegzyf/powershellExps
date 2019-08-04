# @note Please run as administrator to use application

$appFolder = 'C:/Program Files/IntelCAS'
$appName = 'IntelCASCLI'

Set-Alias -Name IntelCASCLI -Value './IntelCASCLI'
Set-Location $appFolder

IntelCASCLI --stats

IntelCASCLI --help

#  Use –H after the command to learn detailed instruction. For example:
#  C:\Program Files\Intel\Cache Acceleration Software\IntelCASCLI.exe –S -H
#  NOTE: Adjust accordingly if using different installation folder.
#  The available command options are:
#  Command (short) Command (long)  Description
#  -S  --start-cache   Start new cache instance or load using metadata
#  -T  --stop-cache  Stop cache instance
#  -Q  --set-cache-mode  Set cache mode
#  -A  --add-rule  Add new caching rule to cache instance
#  -R  --remove-rules   Remove caching rules
#  -L  --list-caches  List all cache instances
#  -P  --stats  Print statistics for cache instance
#  -Z  --reset-stats  Reset cache statistics
#  -X  --list-rules  List all caching rules
#  -F  --flush-cache  Flush all dirty data from the caching device to core devices
#  -V  --version  Prints Intel Cache Acceleration Software version
#  -N
#  --set-NAS-support  Enable/disable NAS support
#  Valid command line options:
#  --set-NAS-support –N  -m –mode<MODE> ON/OFF
#  Ex:     “IntelCASCLI.exe –-set-NAS-support –-mode ON”
#  OR    “IntelCASCLI.exe –N –m ON”
#  -H  --help  Give this help list

