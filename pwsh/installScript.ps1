Set-ExecutionPolicy -ExecutionPolicy Unrestricted
Install-Module posh-git -Scope CurrentUser -Force
Install-Module -Name Terminal-Icons -Repository PSGallery
Install-Module z -AllowClobber
winget install JanDeDobbeleer.OhMyPosh -s winget