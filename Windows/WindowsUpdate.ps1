# @see https://blog.feiyuit.cn/archives/11.html

function Set-WindowsServiceStartType(
  [Parameter(Mandatory=$true)][String]$serviceName, 
  [Parameter(Mandatory=$true)][Int]$startType) {

  Process {
    if (Test-Path "Registry::HKLM\SYSTEM\CurrentControlSet\Services\$serviceName") {
      Write-Host "Set $serviceName's start type to $startType via registry."
      REG add "HKLM\SYSTEM\CurrentControlSet\Services\$serviceName" /v 'Start' /t REG_DWORD /d "$startType" /f
    }
  }
}

function Disable-WindowsService([Parameter(Mandatory=$true, ValueFromPipeline=$true)][String]$serviceName) {
  Process {
    Write-Host "Disable $serviceName via registry."
    Set-WindowsServiceStartType -serviceName $serviceName -startType 4
  }
}

function Disable-WindowsUpdateRelatedService() {
  # 设置相关服务
  # Get-Service | Out-File 'Z:/services.txt' # Out-GridView
  $windowsUpdateRelatedServices = @('BITS', 'UsoSvc', 'wuauserv', 'TrustedInstaller', 'WpnService' ) # 'sedsvc'
  # TrustedInstaller: Windows Modules Installer
  # WpnService, WpnUserService: 推送系统服务

  Get-Service -Name $windowsUpdateRelatedServices | Set-Service -StartupType Disabled
  
  # 注：禁用后再设置中将无法打开 Windows更新 页面

  # 'WaaSMedicSvc' 为 Windows Update Medic Service，在 System 权限下页无法修改，因此直接通过注册表进行修改
  'DoSvc', 'WaaSMedicSvc', "WpnUserService_$userServicePostfix", 'SgrmBroker' | Disable-WindowsService
}

# Disable-WindowsUpdateRelatedService



function Set-WindowsServiceStartAndFailureActions($path) {
  Set-ItemProperty -Path $path -Name 'Start' -Value 0x4
  $property = Get-ItemProperty -Path $path -Name 'FailureActions'
  $propertyValue = $property.FailureActions
  $propertyValue[20] = 0
  $propertyValue[28] = 0
  Set-ItemProperty -Path $path -Name 'FailureActions' -Value $propertyValue
}

function Disable-WindowsUpdateRelatedServiceOld {

  # 需要禁用4个服务，其中后两者需要提权到 System 后禁用或通过修改注册表禁用
  # Background Intelligent Transfer Service
  # Windows Update
  # Update Orchestrator Service
  # Windows Update Medic Service

  Get-Service 'bits' | Set-Service -StartupType Disabled
  Get-Service 'wuauserv' | Set-Service -StartupType Disabled

  # 禁用 Windows Update Medic Service 并设置恢复操作
  $waaSMedicSvcKeyPath = 'HKLM:\SYSTEM\CurrentControlSet\Services\WaaSMedicSvc'
  # $waaSMedicSvcStartProperty = Get-ItemProperty -Path $waaSMedicSvcKeyPath -Name ‘Start’
  Set-StartAndFailureActions $waaSMedicSvcKeyPath
  
  # 禁用 Update Orchestrator Service 并设置恢复操作
  net stop UsoSvc | Out-Null
  Get-Service 'UsoSvc' | Set-Service -StartupType Disabled # or use: sc.exe config UsoSvc start=DISABLED | Out-Null
  Set-StartAndFailureActions 'HKLM:\SYSTEM\CurrentControlSet\Services\UsoSvc'
  Set-StartAndFailureActions 'HKLM:\SYSTEM\ControlSet001\Services\UsoSvc'
}

function Get-WindowsServiceGroupId() {
  $groupIdChars = (Get-Service -Name WpnUserService_*).Name.ToCharArray() | Select-Object -Last 5
  [System.String]::Concat($groupIdChars)
}

# $windowsServiceGroupId = Get-WindowsServiceGroupId

{
  # 设置相关计划任务
  # \Microsoft\Windows\UpdateOrchestrator, \Microsoft\Windows\WaaSMedic, \Microsoft\Windows\WindowsUpdate
  # 任务文件位置：C:\Windows\System32\Tasks\Microsoft\Windows\UpdateOrchestrator
  # 可以对其改名
}

{
  # 清理 WindowsUpdate 数据库
  # If you delete the files in the DataStore folder (you can delete them and sometimes emptying this folder solves problems with an update that fails to install),
  # you will lose the history of installed updates and available updates.
  # The next time Windows checks for updates it will think you have never checked for updates and it will basically start from scratch and check everything. 
  # There's no point in deleting DataStore.edb

  # Remove-Item "$($env:windir)\softwaredistribution\datastore\datastore.edb" -Force
  # esentutl /d "$($env:windir)\softwaredistribution\datastore\datastore.edb"
}

function Clear-WindowsUpdateLog {
  # 清理 WindowsUpdate Log
  Remove-Item "$($env:windir)\softwaredistribution\datastore\Logs" -Recurse -Force
}

function Clear-WindowsUpdateDownloadDirectory([switch]$createFakeFile) {
  # 清理 WindowsUpdate 已下载文件
  Remove-Item "$($env:windir)\softwaredistribution\Download" -Recurse -Force
  if ($createFakeFile) {
    "Disable Download." | Out-File -FilePath "$($env:windir)\softwaredistribution\Download"
  }
}
