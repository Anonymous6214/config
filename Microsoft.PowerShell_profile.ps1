Import-Module posh-git
Import-Module Terminal-Icons
Import-Module z
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\robbyrussel.omp.json" | Invoke-Expression