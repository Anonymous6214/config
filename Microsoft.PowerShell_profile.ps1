Import-Module posh-git
Import-Module Terminal-Icons
Import-Module z
$env:PNPPOWERSHELL_UPDATECHECK="false"
$env:PYTHONIOENCODING='utf-8'
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin.omp.json" | Invoke-Expression
