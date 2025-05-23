Import-Module posh-git
Import-Module Terminal-Icons
Import-Module z
Import-Module Az.Tools.Predictor
$env:PNPPOWERSHELL_UPDATECHECK='false'
$env:PYTHONIOENCODING='utf-8'
$env:POETRY_VIRTUALENVS_IN_PROJECT=1
$env:PIPENV_VENV_IN_PROJECT=1
Set-PSReadLineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -PredictionViewStyle ListView
New-Alias -Name v -Value nvim
oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\catppuccin.omp.json" | Invoke-Expression
