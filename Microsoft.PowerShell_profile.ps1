Import-Module posh-git
Import-Module Terminal-Icons
Import-Module z
function title {
    param (
        $name
    )
    $host.UI.RawUI.WindowTitle = $name
}
$env:PNPPOWERSHELL_UPDATECHECK="false"
$env:PYTHONIOENCODING='utf-8'
$ENV:STARSHIP_CONFIG = "$HOME\.starship\starship.toml"
$ENV:STARSHIP_DISTRO = "者 "
Invoke-Expression (&starship init powershell)
Set-PSReadLineOption -PredictionSource History
Set-PSReadLineOption -PredictionViewStyle ListView
