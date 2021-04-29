$download_uri = "https://cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi"
$installer_path = "C:\Windows\Temp\cloudbase_init.msi"
$install_log_folder = "C:\ProgramData\Packer\"
$install_log = "$install_log_folder\install_cloudbase-init.log"
$arguments = @(
	"/i $installer_path"
	"/qn"
	"/lv* $install_log"
	"RUN_SERVICE_AS_LOCAL_SYSTEM=1"
	"USERNAME=Administrator"
)

function Get-Installer {
	$progressPreference = "silentlyContinue"
	Invoke-WebRequest -OutFile $installer_path $download_uri
}

function Install-Cloudbase {
	New-Item -ItemType Directory -Force -Path $install_log_folder
	$p = Start-Process -PassThru -FilePath msiexec -ArgumentList $arguments -Wait -NoNewWindow
	if (($p.ExitCode -ne 0) -and ($p.ExitCode -ne 3010)) {
		$p.ExitCode
		Write-Error "ERROR: problem encountered during cloudbase-init install"
	}

	$conf_path = "${env:ProgramFiles}\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init.conf"
	$unattend_path = "${env:ProgramFiles}\Cloudbase Solutions\Cloudbase-Init\conf\cloudbase-init-unattend.conf"

	Copy-Item "C:\Windows\Temp\config\cloudbase-init.conf" -Destination $conf_path
	Copy-Item "C:\Windows\Temp\config\cloudbase-init-unattend.conf" -Destination $unattend_path

	Stop-Service cloudbase-init -Force
	Start-Process cmd -ArgumentList '/c sc config cloudbase-init start= disabled'
}

Write-Host "BEGIN: install_cloudbase_init.ps1"
Write-Host "Downloading Cloudbase-init from $download_uri"
Get-Installer
Write-Host "Installing Cloudbase-init"
Install-Cloudbase
Write-Host "END: install_cloudbase_init.ps1"