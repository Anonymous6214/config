Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Install-Module posh-git -Scope CurrentUser -Force
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module z -AllowClobber
Install-Module -Name Az.Tools.Predictor
winget install --id Git.Git -e --source winget
winget install JanDeDobbeleer.OhMyPosh -s winget
winget install JanDeDobbeleer.OhMyPosh --source winget --scope user --force