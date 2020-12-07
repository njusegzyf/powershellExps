# @see https://blog.darkthread.net/blog/vscode-ps-encoding/

# VSCode 存檔預設是採用 UTF-8 編碼，而 Windows 10 內建 PowerShell 版本為 5.1，在中文版 Windows 預設的檔案編碼為 BIG5 (CodePage 950)，亂碼源自 PowerShell 用 BIG5 編碼解讀 UTF-8 檔案。
# PowerShell 在 6.0 版之後預設檔案編碼已改為 UTF-8，預計不會再有此問題，而要讓 PowerShell 5.1 正確讀取 UTF-8 編碼檔案，需在檔案前方加上 UTF-8 BOM (Byte Order Mark)。

# 在 VSCode 切換編碼很簡單，點選下方狀態列的 UTF-8 帶出選單，點兩下改成 UTF-8 with BOM (utf8bom) 就搞定。

# 但每次建新檔案都要改太麻煩，VSCode 支援針對 .ps1 指定編碼格式，可根本解決問題，即在 settings.json 加入：
# "[powershell]": {
#     "files.encoding": "utf8bom",
#     "files.autoGuessEncoding": true
# }

notepad "$($env:APPDATA)\Code\User\settings.json"
