param(
    [Parameter(Mandatory=$False, Position=0, ValueFromPipeline=$false)]
    [System.String]
    $Param1

)

Write-Host $Param1



# cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/ESX
Install-Module -Name VMware.PowerCLI -Confirm:$false
cd "PowerCLI-Example-Scripts/Modules/VMware.vSphere.SsoAdmin"
Import-Module ./VMware.vSphere.SsoAdmin.psd1
cd ../../../

## git clone https://github.com/vmware/PowerCLI-Example-Scripts.git
#cd "C:\Users\tmakepea\OneDrive - Advanced Micro Devices Inc\SE-stuff\Toby Technotes\Aruba\TestDriveLight\Testdrive light working folder"
#cd "PowerCLI-Example-Scripts\Modules\VMware.vSphere.SsoAdmin"
#Import-Module .\VMware.vSphere.SsoAdmin.psd1
## Import-Module VMware.VimAutomation.Sso
#cd ../../../
#
#cd "C:\Users\tmakepea\OneDrive - Advanced Micro Devices Inc\SE-stuff\Toby Technotes\Aruba\TestDriveLight\Testdrive light working folder\ESX_Build\"

##Import variables ##
.\TestDrive.ps1


################################################### (End of EDIT to Suit Customer Enviroment) ##################################################



## support unsigned certs
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope AllUsers

##Connect to vCenter
connect-viserver -server $vcenter_server -User $vcenter_user -Password $vcenter_pwd






if (-not ($Param1)) {
    
	$reset = Read-Host "Enter the Pod number you want to reset eg. 1:"
	} 
else {
	$reset = $Param1
	}


$basevlan = $BASE_VLAN
$pvlanadd = $PVLAN_ADD

################################################## (End of EDIT to Suit Customer Enviroment) ##################################################



    $netnum = 10 * $_
    $netnum = $netnum + $basevlan
    $netnum1 = $netnum + 1
    $netnum2 = $netnum + 2
    $netnum3 = $netnum + 3
    
    $privnum1 = $pvlanadd + $netnum1
    $privnum2 = $pvlanadd + $netnum2
    $privnum3 = $pvlanadd + $netnum3
    
    $VmInt1 = "$netnum1"+"_"+"$privnum1"+"_PRO"
    $VmInt2 = "$netnum1"+"_"+"$privnum1"+"_ISO"
    


	$VRFworkloads | ForEach-Object {
					$workloadnumber = 10 + $_
					$VMclone = "Workstation"+"$netnum1"+"_"+"$workloadnumber"
					
					Stop-VM -VM $VMclone -Kill -Confirm:$false
					Remove-VM -DeletePermanently -RunAsync -VM $VMclone -Server $vcenter_server -Confirm:$False
		}
		
		
		Remove-ResourcePool -ResourcePool $vrf -Confirm:$False
		

Start-Sleep -Seconds 30


$location = Get-Datacenter -Name $DCName
echo $location


## working 


## Create the local resource pools for each 

$storeDisk = Get-Datastore -VMHost $Hostesxi | where { $_.Name -eq $DataStore }


		New-ResourcePool -Location $Hostesxi -Name $vrf
		$Location = Get-ResourcePool | where { $_.Name -eq $vrf } 

    $netnum = 10 * $reset
    $netnum1 = $netnum + 1
    
    $privnum1 = 1000 + $netnum1
    
    $VmInt1 = "$netnum1"+"_"+"$privnum1"+"_PRO"
    $VmInt2 = "$netnum1"+"_"+"$privnum1"+"_ISO"
		
		$vdSwitch = Get-VDSwitch -Name $Global:VmDS
		$vdPortGroup1 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt1
		$vdPortGroup2 = Get-VDPortGroup -VDSwitch $vdSwitch -Name $VmInt2
		$net = $_
		
		$VRFworkloads | ForEach-Object {
					$workloadnumber = 10 + $_
					$VMclone = "Workstation"+"$netnum1"+"_"+"$workloadnumber"
					$VMIP = "192.168."+"$netnum1"+"."+"$workloadnumber"
					$VMgateway = "192.168."+"$netnum1"+".1"
					$VMtag = "Workload"+"$_"
					
							New-VM -VM $VMsource -Name $VMclone -VMHost $Hostesxi -Datastore $storeDisk -DiskStorageFormat Thin -ResourcePool $Location -Notes "sudo ifconfig eth0 $VMIP netmask 255.255.255.0 up
		sudo route add default gw $VMgateway

		user: tc or root
		password: VMware1!" 
			
					<#
					$vrfg = Get-Tag -Name "$vrf" -Category $Workloadgroupname
					$workload = Get-Tag -Name $VMtag -Category $TagCategoryname
					
					$vms = Get-VM -name $VMclone
					Start-Sleep -Seconds 1
					New-TagAssignment -Tag $workload -Entity $vms	
					New-TagAssignment -Tag $vrfg -Entity $vms
					Start-Sleep -Seconds 1
					Start-VM -VM $VMclone -Confirm:$false -RunAsync
						
						#>
						
					Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone | where {$_.Name -eq "Network adapter 1" } ) -PortGroup $vdPortGroup1 -Confirm:$False
					Set-NetworkAdapter -NetworkAdapter ( Get-NetworkAdapter -VM $VMclone | where {$_.Name -eq "Network adapter 1" } ) -connected:$true  -Confirm:$False
		}
		

Start-Sleep -Seconds 30

		$VRFworkloads | ForEach-Object {
					$workloadnumber = 10 + $_
					$VMclone = "Workstation"+"$netnum1"+"_"+"$workloadnumber"
					$VMIP = "192.168."+"$netnum1"+"."+"$workloadnumber"
					$MASK = "255.255.255.0"
					$BCAST = "192.168."+"$netnum1"+".255"
					$GW = "192.168."+"$netnum1"+".1"
					$DNS = "192.168."+"$netnum1"+".1"
					$Domain = "testdrive"
					$VMtag = "Workload"+"$_"
			
					Invoke-VMScript -VM $VMclone -ScriptText "sudo /opt/set-ipv4-address.sh $VMIP $MASK $BCAST $GW $DNS $Domain" -GuestUser "root" -GuestPassword "VMware1!"
					
					
					$vrfg = Get-Tag -Name "$vrf" -Category $Workloadgroupname
					$workload = Get-Tag -Name $VMtag -Category $TagCategoryname
					
					$vms = Get-VM -name $VMclone
					Start-Sleep -Seconds 1
					New-TagAssignment -Tag $workload -Entity $vms	
					New-TagAssignment -Tag $vrfg -Entity $vms
					Start-Sleep -Seconds 1
					Start-VM -VM $VMclone -Confirm:$false -RunAsync
						
						

		}
				







		$viuser = "VSPHERE.LOCAL\"+"$vrf"+"_user"
		Get-ResourcePool $vrf |New-VIPermission -Role TestDrive -Principal $viuser







disconnect-viserver -server $vcenter_server -Confirm:$false
	





    