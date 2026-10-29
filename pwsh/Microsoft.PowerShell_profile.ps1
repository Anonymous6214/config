$env:PNPPOWERSHELL_UPDATECHECK='false'
$env:PYTHONIOENCODING='utf-8'
$env:POETRY_VIRTUALENVS_IN_PROJECT=1
$env:PIPENV_VENV_IN_PROJECT=1
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
New-Alias -Name v -Value nvim

# oh-my-posh：把 init 腳本快取成檔案，省掉每次啟動跑兩次 oh-my-posh.exe。
# 主題直接用 winget（MSIX）套件內建的 themes。套件路徑含版本號（Get-AppxPackage 太慢，改查登錄檔），
# 升級後路徑一變就自動重新產生快取；要手動重建就刪掉 $ompCache。
$ompPackages = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Packages')
$ompRoot = $ompPackages.OpenSubKey(@($ompPackages.GetSubKeyNames() -like 'ohmyposh.cli_*')[-1]).GetValue('PackageRootFolder')
$ompConfig = "$ompRoot\themes\catppuccin.omp.json"
$ompCache = "$env:LOCALAPPDATA\oh-my-posh\init-cache.ps1"
if ((Get-Content $ompCache -TotalCount 1 -ErrorAction Ignore) -ne "# $ompConfig") {
    $ompScript = (oh-my-posh init pwsh --config=$ompConfig --print) -join "`n"
    # 產生出來的腳本寫死了 session ID，改成每個視窗各自產生
    $ompScript = $ompScript -replace '\$env:POSH_SESSION_ID = [''"][^''"]*[''"]', '$$env:POSH_SESSION_ID = [guid]::NewGuid().ToString()'
    if ($ompScript -notmatch 'POSH_SESSION_ID = \[guid\]') { Write-Warning 'oh-my-posh init 格式變了，session ID 沒有替換成功' }
    New-Item -ItemType Directory -Force (Split-Path $ompCache) | Out-Null
    Set-Content -Path $ompCache -Value "# $ompConfig", $ompScript -Encoding utf8
}
. $ompCache
Remove-Variable ompPackages, ompRoot, ompConfig, ompCache, ompScript -ErrorAction Ignore

# zoxide（取代 z 模組）：z <關鍵字> 跳目錄，zi 互動選擇；cd 照常使用也會被記錄
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# Terminal-Icons 載入很慢，等提示字元出現、第一次閒置時才在背景載入。
# 它每次載入都會重寫主題快取（%APPDATA%\powershell\Community\Terminal-Icons\*.xml），
# 寫到一半被中斷會留下截斷的檔案，之後就載入失敗；失敗時刪掉解析不了的檔案（會自動重建）再試一次。
$null = Register-EngineEvent -SourceIdentifier PowerShell.OnIdle -MaxTriggerCount 1 -Action {
    try {
        Import-Module Terminal-Icons -Global -ErrorAction Stop
    } catch {
        $broken = Get-ChildItem "$env:APPDATA\powershell\Community\Terminal-Icons" -Filter *.xml -ErrorAction Ignore |
            Where-Object { try { $null = [xml](Get-Content $_.FullName -Raw); $false } catch { $true } }
        if (-not $broken) { throw }
        $broken | Remove-Item -Force
        Write-Host "`nTerminal-Icons：已刪除損壞的快取 $($broken.Name -join ', ')，重新載入" -ForegroundColor Yellow
        Import-Module Terminal-Icons -Global -Force
    }
}
