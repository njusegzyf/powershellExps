{
  # 设置相关服务
  Get-Service | Out-File 'Z:/services.txt' # Out-GridView
  $windowsUpdateRelatedServices = @('BITS', 'UsoSvc', 'wuauserv', 'WaaSMedicSvc', 'TrustedInstaller')
  # TrustedInstaller: Windows Modules Installer

  Get-Service -Name $windowsUpdateRelatedServices | Set-Service -StartupType Disabled
  # 注：禁用后再设置中将无法打开 Windows更新 页面
}

{
  # 设置相关计划任务
  # 任务文件位置：C:\Windows\System32\Tasks\Microsoft\Windows\UpdateOrchestrator
  # 可以对其改名
}

{
  # 清理 WindowsUpdate 数据库
  # If you delete the files in the DataStore folder
  # (you can delete them and sometimes emptying this folder solves problems with an update that fails to install),
  # you will lose the history of installed updates and available updates.
  # The next time Windows checks for updates it will think you have never checked for updates and
  # it will basically start from scratch and check everything. There's no point in deleting DataStore.edb

  # Remove-Item "$($env:windir)\softwaredistribution\datastore\datastore.edb" -Force
  # esentutl /d "$($env:windir)\softwaredistribution\datastore\datastore.edb"
}

{
  # 清理 WindowsUpdate Log
  Remove-Item "$($env:windir)\softwaredistribution\datastore\Logs" -Recurse -Force
}

{
  # 清理 WindowsUpdate 已下载文件
  Remove-Item "$($env:windir)\softwaredistribution\Download" -Recurse -Force
}
