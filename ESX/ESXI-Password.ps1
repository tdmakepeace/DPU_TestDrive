param (
    [string]$pass,
    [int]$vrf
)

Write-Output   $pass
Write-Output   $vrf


# cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/ESX
Install-Module -Name VMware.PowerCLI -Confirm:$false
cd "PowerCLI-Example-Scripts/Modules/VMware.vSphere.SsoAdmin"
Import-Module ./VMware.vSphere.SsoAdmin.psd1
cd ../../../


##Import variables ##
.\TestDrive.ps1




## support unsigned certs
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers

##Connect to vCenter
		$vrfuser = "vrf"+$vrf+"_user"
		Connect-SsoAdminServer -Server $vcenter_server -User $vcenter_user -Password "$vcenter_pwd" -SkipCertificateCheck
		
		Get-SsoPersonUser -Name $vrfuser -Domain vsphere.local  |Set-SsoPersonUser -NewPassword $pass
		Disconnect-SsoAdminServer -Server $vcenter_server
