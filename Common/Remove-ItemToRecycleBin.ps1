function Remove-ItemToRecycleBin([String]$itemPath, $sehll=(New-Object -ComObject "Shell.Application")) {

    $item = $shell.Namespace(0).ParseName((Resolve-Path $itemPath).Path)
    $item.InvokeVerb("delete")
}
