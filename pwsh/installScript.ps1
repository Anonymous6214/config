Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope CurrentUser
Install-Module -Name Terminal-Icons -Repository PSGallery -Scope CurrentUser -Force
$wingetArgs = '-e', '--source', 'winget', '--scope', 'user', '--accept-source-agreements', '--accept-package-agreements'
winget install --id ajeetdsouza.zoxide @wingetArgs
winget install --id Git.Git @wingetArgs
winget install --id JanDeDobbeleer.OhMyPosh @wingetArgs
# Neovim 在 winget 只有 machine scope 的 MSI，安裝時會跳 UAC
winget install --id Neovim.Neovim @($wingetArgs | Where-Object { $_ -notin '--scope', 'user' })

# 把 profile 放到 profile 資料夾（通常是 Documents\PowerShell）
$profileDir = Split-Path $PROFILE
New-Item -ItemType Directory -Force $profileDir | Out-Null
Copy-Item "$PSScriptRoot\Microsoft.PowerShell_profile.ps1" $profileDir -Force

# oh-my-posh（winget/MSIX 版）內建的所有主題在這裡，profile 直接讀這裡的主題：
#   "$((Get-AppxPackage ohmyposh.cli).InstallLocation)\themes"
