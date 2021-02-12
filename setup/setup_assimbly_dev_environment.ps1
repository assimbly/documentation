Write-Output "Setup Assimbly dev environment"

Write-Output "Step 1: Install Scoop"
if (-not (Test-Path "$home\scoop\")) {
	Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

Write-Output "Step 2: Install Java"
scoop bucket add java
scoop install adopt11-hotspot

Write-Output "Step 3: Install NodeJS"
scoop bucket add extras
scoop install nodejs nvm

Write-Output "Step 3: Install Yarn"
scoop install yarn

Write-Output "Step 4: Install Git"
scoop install git
scoop install maven

Write-Output ""
Write-Output "Setup finished!"
