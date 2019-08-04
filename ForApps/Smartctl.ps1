﻿Set-Location 'C:\Program Files\smartmontools\bin'

Set-Alias -Name smartctl -Value './smartctl'

smartctl -h

# scan disks
smartctl --scan

smartctl -a /dev/sda


#smartctl 7.0 2018-12-30 r4883 [x86_64-w64-mingw32-w10-1607] (sf-7.0-1)
#Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org
#
#Usage: smartctl [options] device
#
#============================================ SHOW INFORMATION OPTIONS =====
#
#  -h, --help, --usage
#         Display this help and exit
#
#  -V, --version, --copyright, --license
#         Print license, copyright, and version information and exit
#
#  -i, --info
#         Show identity information for device
#
#  --identify[=[w][nvb]]
#         Show words and bits from IDENTIFY DEVICE data                (ATA)
#
#  -g NAME, --get=NAME
#        Get device setting: all, aam, apm, dsn, lookahead, security,
#        wcache, rcache, wcreorder, wcache-sct
#
#  -a, --all
#         Show all SMART information for device
#
#  -x, --xall
#         Show all information for device
#
#  --scan
#         Scan for devices
#
#  --scan-open
#         Scan for devices and try to open each device
#
#================================== SMARTCTL RUN-TIME BEHAVIOR OPTIONS =====
#
#  -j, --json[=[cgiosuv]]
#         Print output in JSON format
#
#  -q TYPE, --quietmode=TYPE                                           (ATA)
#         Set smartctl quiet mode to one of: errorsonly, silent, noserial
#
#  -d TYPE, --device=TYPE
#         Specify device type to one of:
#         ata, scsi[+TYPE], nvme[,NSID], sat[,auto][,N][+TYPE], usbcypress[,X], usbjmicron[,p][,x][,N], usbprolific, usbsu
#nplus, sntjmicron[,NSID], intelliprop,N[+TYPE], aacraid,H,L,ID, areca,N[/E], auto, test
#
#  -T TYPE, --tolerance=TYPE                                           (ATA)
#         Tolerance: normal, conservative, permissive, verypermissive
#
#  -b TYPE, --badsum=TYPE                                              (ATA)
#         Set action on bad checksum to one of: warn, exit, ignore
#
#  -r TYPE, --report=TYPE
#         Report transactions (see man page)
#
#  -n MODE[,STATUS], --nocheck=MODE[,STATUS]                           (ATA)
#         No check if: never, sleep, standby, idle (see man page)
#
#============================== DEVICE FEATURE ENABLE/DISABLE COMMANDS =====
#
#  -s VALUE, --smart=VALUE
#        Enable/disable SMART on device (on/off)
#
#  -o VALUE, --offlineauto=VALUE                                       (ATA)
#        Enable/disable automatic offline testing on device (on/off)
#
#  -S VALUE, --saveauto=VALUE                                          (ATA)
#        Enable/disable Attribute autosave on device (on/off)
#
#  -s NAME[,VALUE], --set=NAME[,VALUE]
#        Enable/disable/change device setting: aam,[N|off], apm,[N|off],
#        dsn,[on|off], lookahead,[on|off], security-freeze,
#        standby,[N|off|now], wcache,[on|off], rcache,[on|off],
#        wcreorder,[on|off[,p]], wcache-sct,[ata|on|off[,p]]
#
#======================================= READ AND DISPLAY DATA OPTIONS =====
#
#  -H, --health
#        Show device SMART health status
#
#  -c, --capabilities                                            (ATA, NVMe)
#        Show device SMART capabilities
#
#  -A, --attributes
#        Show device SMART vendor-specific Attributes and values
#
#  -f FORMAT, --format=FORMAT                                          (ATA)
#        Set output format for attributes: old, brief, hex[,id|val]
#
#  -l TYPE, --log=TYPE
#        Show device log. TYPE: error, selftest, selective, directory[,g|s],
#        xerror[,N][,error], xselftest[,N][,selftest], background,
#        sasphy[,reset], sataphy[,reset], scttemp[sts,hist],
#        scttempint,N[,p], scterc[,N,M], devstat[,N], defects[,N], ssd,
#        gplog,N[,RANGE], smartlog,N[,RANGE], nvmelog,N,SIZE
#
#  -v N,OPTION , --vendorattribute=N,OPTION                            (ATA)
#        Set display OPTION for vendor Attribute N (see man page)
#
#  -F TYPE, --firmwarebug=TYPE                                         (ATA)
#        Use firmware bug workaround:
#        none, nologdir, samsung, samsung2, samsung3, xerrorlba, swapid
#
#  -P TYPE, --presets=TYPE                                             (ATA)
#        Drive-specific presets: use, ignore, show, showall
#
#  -B [+]FILE, --drivedb=[+]FILE                                       (ATA)
#        Read and replace [add] drive database from FILE
#        [default is +C:/Program Files/smartmontools/bin/drivedb-add.h
#         and then    C:/Program Files/smartmontools/bin/drivedb.h]
#
#============================================ DEVICE SELF-TEST OPTIONS =====
#
#  -t TEST, --test=TEST
#        Run test. TEST: offline, short, long, conveyance, force, vendor,N,
#                        select,M-N, pending,N, afterselect,[on|off]
#
#  -C, --captive
#        Do test in captive mode (along with -t)
#
#  -X, --abort
#        Abort any non-captive test on device
#
#=================================================== SMARTCTL EXAMPLES =====
#
#  smartctl -a /dev/sda                       (Prints all SMART information)
#
#  smartctl --smart=on --offlineauto=on --saveauto=on /dev/sda
#                                              (Enables SMART on first disk)
#
#  smartctl -t long /dev/sda              (Executes extended disk self-test)
#
#  smartctl --attributes --log=selftest --quietmode=errorsonly /dev/sda
#                                      (Prints Self-Test & Attribute errors)
#  smartctl -a /dev/sda
#             (Prints all information for disk on PhysicalDrive 0)
#  smartctl -a /dev/pd3
#             (Prints all information for disk on PhysicalDrive 3)
#  smartctl -a /dev/tape1
#             (Prints all information for SCSI tape on Tape 1)
#  smartctl -A /dev/hdb,3
#                (Prints Attributes for physical drive 3 on 3ware 9000 RAID)
#  smartctl -A /dev/tw_cli/c0/p1
#            (Prints Attributes for 3ware controller 0, port 1 using tw_cli)
#  smartctl --all --device=areca,3/1 /dev/arcmsr0
#           (Prints all SMART info for 3rd ATA disk of the 1st enclosure
#            on 1st Areca RAID controller)
#
#  ATA SMART access methods and ordering may be specified by modifiers
#  following the device name: /dev/hdX:[saicm], where
#  's': SMART_* IOCTLs,         'a': IOCTL_ATA_PASS_THROUGH,
#  'i': IOCTL_IDE_PASS_THROUGH, 'f': IOCTL_STORAGE_*,
#  'm': IOCTL_SCSI_MINIPORT_*.
#  The default on this system is /dev/sdX:pasifm
