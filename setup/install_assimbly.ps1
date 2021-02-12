Write-Output "Start Assimbly installation"

Write-Output "Step 1: Install Scoop"
if (-not (Test-Path "$home\scoop\")) {
	Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

Write-Output "Step 2: Install Java"
scoop bucket add java
scoop install adopt11-hotspot

Write-Output "Step 3: Download Assimbly"
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$DownloadUrl = Invoke-RestMethod -uri  https://api.github.com/repos/assimbly/gateway/releases/latest | select -ExpandProperty assets | ? { $_.name.Contains("jar")} | select -expand browser_download_url
Invoke-WebRequest $DownloadUrl -OutFile "$HOME/assimbly/gateway.jar"

Write-Output "Step 4: Create start script"
New-Item -Path "$home\assimbly\"  -Name "start_assimbly.ps1" -ItemType File -Value 'java -jar gateway.jar' -Force
cd "$home\assimbly"

Write-Output ""
Write-Output "Installation finished!"
Write-Output ""
Write-Output "Start Assimbly with the command: .\start_assimbly.ps1"