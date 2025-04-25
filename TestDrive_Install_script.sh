#!/bin/bash

###
### This script has been build to set up the enviroment for the TestDrive Management and is based on a default Ubuntu 22.04/24.04 servers install.
### The only packages needing to be installed as part of the deployment of the Ubuntu servers is openSSH.
###
### you can do a minimun install, but i would just stick with the servers install.
###
### Also it is recommended that you run a static-IP configuration, with a single or dual network interface.
### The script should be run as the first user create as part of the install, and uses SUDO for the deployment process.


	
rebootserver()
{
		echo "rebooting"
		
		sleep 5
		sudo reboot
		break
}

updates()
{
		
		sudo apt-get update 
		sudo NEEDRESTART_SUSPEND=1 apt-get dist-upgrade --yes 

		sleep 10
}

updatesred()
{
		subscription-manager attach --auto
		subscription-manager repos
		sudo yum update -y -q 

		sleep 10
}


download()
{
		real_user=$(whoami)


		os=`more /etc/os-release |grep PRETTY_NAME | cut -d  \" -f2 | cut -d " " -f1`
		if [ "$os" == "Ubuntu" ]; then 
				updates
				
		elif [ "$os" == "Red" ]; then
				updatesred
				
		fi 
		cd /
		
		if [ ! -d "$rootfolder" ]; then
				sudo mkdir $ROOT_INSTALL_DIR
  			sudo chown $real_user:$real_user $ROOT_INSTALL_DIR
		fi


		cd /$ROOT_INSTALL_DIR/
		git clone $GIT_REPO
		cd 	$DPUTD_INSTALL_DIR
		
		
		`git branch --all | cut -d "/" -f3 > gitversion.txt`
		echo "choose a branch "
		git branch --all | cut -d "/" -f3 |grep -n ''

		echo " Select the line number (but not line with the *)

		"
		read x
		testdrivever=`sed -n "$xp" gitversion.txt`
		git checkout  $testdrivever
		echo $testdrivever >installedversion.txt
		git pull
		
		cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR
		cd accounts
		chmod +x *.sh
		cd ../axis
		chmod +x *.sh
		cd ../PSM
		chmod +x *.sh
		cd 
		
		if [ -e "manage_script.sh" ]; then
		 rm manage_script.sh
		fi
		ln -s /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/accounts/manage_script.sh manage_script.sh

	}

basesetup()
{
		cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR
		cd ESX
		git clone https://github.com/vmware/PowerCLI-Example-Scripts.git

		if [ "$os" == "Ubuntu" ]; then 
				###################################
				# Prerequisites

				# Update the list of packages
				sudo apt-get update

				# Install pre-requisite packages.
				sudo apt-get install -y wget apt-transport-https software-properties-common

				# Get the version of Ubuntu
				source /etc/os-release

				# Download the Microsoft repository keys
				wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb

				# Register the Microsoft repository keys
				sudo dpkg -i packages-microsoft-prod.deb

				# Delete the Microsoft repository keys file
				rm packages-microsoft-prod.deb

				# Update the list of packages after we added packages.microsoft.com
				sudo apt-get update

				###################################
				# Install PowerShell
				sudo apt-get install -y powershell

				
		elif [ "$os" == "Red" ]; then
				updatesred
				
		fi 

	
	}
	
	
instruction()
{
	
	
	echo -e "\e[0;31mNOTE:\e[0m"
	echo -e """
	To run the TestDrive code you need to be running in Powershell.
	To run powershell you need to run the following command (recommend a second terminal window).
	
	\e[1;33m pwsh \e[0m
	
	Once in Powershell you need to import the PowerCli-Examples repo to be able to login to the the Vcentre server enviroment.
	
	to do that once in powershell in a second terminal screen copy the following lines.
		
		\e[1;33m

		cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/ESX
		Install-Module -Name VMware.PowerCLI -Confirm:\$false
		cd \"PowerCLI-Example-Scripts/Modules/VMware.vSphere.SsoAdmin\"
		Import-Module ./VMware.vSphere.SsoAdmin.psd1 	
		cd ../../../
		
		\e[0m
		
	
	"""
	
	read -p "	Select option (A) on the install 
	
	once the install complete and back at the command prompt and hit enter this screen for the next."
	
	echo -e """
		
		The script are ready for the DPU TestDrive.
		\e[1;33mNow to set up the enviromental variables. You need to have access to the Vcenter Admin at this stage \e[0m
			
		You first need to login to the Vcenter server and deploy a base image OVA that can be cloned.
		In our example a image has been prepared in the /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/VMimage folder.
		
		The image name shoud upload as an image in the root of the server. 
		The name of the VMimage will be asked for on the next screen
				
		"""
	
	read -p "	Hit enter, once you have access to the VM-admin"
	
	clear
	
		echo -e """
		
		\e[1;33mNow to set up the enviromental variables. You need to have access to the Vcenter Admin at this stage \e[0m
		or access to the Vcentre server. run from the powershell terminal - BuildVaribles.ps1
		located in the \e[0;31m/$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/ESX \e[0m folder
		
		The following information will be asked for
		

		\e[0;31mVcenter Server IP \e[0meg. vcenter.testdrive.com or 192.168.102.102
		\e[0;31mVcenter Administrator \e[0meg administrator@vsphere.local
		\e[0;31mVcenter password\e[0m
		\e[0;31mESXi host IP \e[0meg. 192.168.102.101
		\e[0;31mVmware image to be cloned \e[0meg. TinyVMDeploy (this is in the /pensandotools/PSM_Test_Drive_Light/ folder)
		\e[0;31mVmware Disk for the images to be stored \e[0meg. DL360SSD
		\e[0;31mVmware Vcenter Domain \e[0meg. Makepeacehouse
		\e[0;31mThe name of the distributed switch you want to create \e[0meg. VRF-Demo
		\e[0;31mThe of the TAG catogary to be used for the workload grouping. \e[0meg. Demo
		\e[0;31mThe of the TAG catogary to be used for the VRF grouping \e[0meg. VRFs
		\e[0;31mThe number of VRFs you want to create \e[0meg. 3
		\e[0;31mThe number of workloads per VRF you want to create \e[0meg. 3 or 5 recommended based on resources.

		\e[0m


	  \e[1;33m
					
		./BuildVaribles.ps1

		\e[0m
		
	
	"""
		
	read -p "Once complete hit enter"
	
echo -e "\e[1;33m

You can now manage via the ./manage_scripts.sh file
		\e[0m"
		
	read -p "Hit enter to access the script or return to the command prompt"
	cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/
	cd accounts
	./manage_script.sh
}	
	

esxnotes()
{
	
		echo """
	To run the TestDrive code you need to be running in Powershell.
	To run powershell you need to run the following command (recommend a second terminal window).
	
	\"
	
	pwsh
	
	\" 
	
		
	
	"""
	read -p "	once in powershell hit enter to continue. "
	clear
	
		echo """
		
	In the ESX folder you have a number of scripts the follow explains there function. 
	
		
	BuildVaribles.ps1                     - recreate the enviromental variables. output is stored in the TestDrive.ps1, and therefore should only be performed in a 
                                                secure envrioment and on a system allocated for TestDrives.

	ESXI-testdrive-Build1.ps1             - The Build 1 and Build 2 scripts set up the ESX enviroment based on the options you defined at the time of building the
	                                        variables. The reason the build is broken in to two scripts are there are some middle manual steps needing to be run.
	ESXI-testdrive-Build2.ps1             -

	ESXI-testdrive-clean1.ps1             - The Clean scripts are to clean the enviroment in the event of a full clean of the VMware enviroment required including 
	                                        the networkings, if you only run clean1, you can re-run Build2 to get back to the same place. 
	                                        if however you run clean1 and then clean2, you need to start from Build1 including the manual steps.

	ESXI-testdrive-clean2.ps1             -

	ESXI-testdrive-resetpod_all.ps1       - Post a full testdrive session and to reset all the ESX pods, you can run the reset_all script.

	ESXI-testdrive-resetpod.ps1           - if during a lab, or where needed you can reset just a single ESX pod the menu will ask you what pod you wish to reset.


		\" 
					
		Becarefull and make sure you understand what you are doing. 
		
		\"
		
	
	"""
	read -p "hit enter to read notes on each"
	clear 
	while true ;
		do 
			echo "File you want more notes and steps on.
			
				BuildVaribles.ps1                 - 1
				ESXI-testdrive-Build1.ps1         - 2
				ESXI-testdrive-Build2.ps1         - 3
				ESXI-testdrive-clean1.ps1         - 4
				ESXI-testdrive-clean2.ps1         - 5
				ESXI-testdrive-resetpod_all.ps1   - 6
				ESXI-testdrive-resetpod.ps1       - 7
				
				exit - x

			
		  	"
				
				read x
				clear
			  	  
		  	if  [ "$x" == "1" ]; then
		  		
		  		echo """
				The BuildVaribles.ps1 is for setting up the enviromental variables for the other scripts.
				you require to have the VMware enviromental knowledge accessable when setting it up.
				The output is TestDrive.ps1, that can be manaual edited rather than re-running the script.
				It should only be hosted in a secure enviroment.
				
				Vcenter Server IP eg. vcenter.testdrive.com or 192.168.102.102
				Vcenter Administrator eg administrator@vsphere.local
				Vcenter password
				ESXi host IP eg. 192.168.102.101
				Vmware image to be cloned eg. TinyVMDeploy (this is in the /pensandotools/PSM_Test_Drive_Light/ folder)
				Vmware Disk for the images to be stored eg. DL360SSD
				Vmware Vcenter Domain eg. Makepeacehouse
				The name of the distributed switch you want to create eg. VRF-Demo
				The of the TAG catogary to be used for the workload grouping. eg. Demo
				The of the TAG catogary to be used for the VRF grouping eg. VRFs
				The number of VRFs you want to create eg. 3
				The number of workloads per VRF you want to create eg. 3 or 5 recommended based on resources.

		  		"""
				elif  [ "$x" == "2" ]; then				
					echo """
					The ESXI-testdrive-Build1.ps1 script sets up all the base networking on the VMware enviroment, once this script 
					is complete you need to manaually assign the uplinks to the distributed switch.
					it is recommened that you just use 2 interfaces, one to each CX switch.
					1. Under the disributed switch, select the add host option, and select your ESXi host.
					2. Assign the interfaces from the host you wish to use, and just accept all the defaults.
					
					Read and review the script for more info.
					"""
				elif  [ "$x" == "3" ]; then				
					echo """
					The ESXI-testdrive-Build2.ps1 script should only be run after the The ESXI-testdrive-Build1.ps1 has been run, and the interfaces 
					assigned to the distributed switch. This will then build the VM resource groups, workloads, and permissions, for the pods.
					It will take about 3 minutes per pod assigned.
					
					Read and review the script for more info.
					"""
				elif  [ "$x" == "4" ]; then				
					echo """
					The ESXI-testdrive-clean1.ps1 script will clean down the VM resource groups, workloads, and permissions, for the pods.
					It will take about 3 minutes per pod assigned.
					
					Read and review the script for more info.
					
					"""

				elif  [ "$x" == "5" ]; then				
					echo """
					The ESXI-testdrive-clean2.ps1 script will clean down the VM users, and disributed switching. 
					It will take about 2 minutes to run.
					
					Read and review the script for more info.
					
					"""
				elif  [ "$x" == "6" ]; then				
					echo """
					The ESXI-testdrive-resetall.ps1 script will run both the Clean1 and Build2 scripts so as to reset the enviroment for the next
					class, this is just for the ESXi enviroment.
						
										
					Read and review the script for more info.
					
					"""
				elif  [ "$x" == "7" ]; then				
					echo """
					The ESXI-testdrive-reset.ps1 script will run both the Clean and Build function for a specific pod
					This is only needed when a user has had diffculties, or you are allocating single pods.
						
										
					Read and review the script for more info.
					"""
				elif  [ "$x" == "8" ]; then				
					echo """
					you can not count.
					"""
				elif [  $x ==  "x" ]; then
						break


		  	else
		    	echo "try again"
		  	fi

		done
	
	}	



psmnotes()
{
		echo """
		The following notes will take you through the setup and clean down scripts for PSM if you want to 
		do thing manaully, but the manage_script.sh calls all the scripts you need.
		The scripts are based on the fact you have already set up the CX and PSM for base functionality
		and is focussed on the pod build and resets.
			
		The first thing you need to do is edit the logindetails.py file in the PSM\PythonScripts folder.
		
		This is managed automaticatlly if you have used the manage_script.sh to set the enviroment varibles. 
		If not you need to create in the PSM\PythonScripts folder a file called logindetails.py
			
			Contents Example:
			PSM_IP = 'https://1.1.1.1'
			username = 'admin'
			password = 'Pensando0$'
			
			
		The second thing is to set the variable parameters in the CSV_example folder. - Examples give and are expect to 
		work for most customers and the default setup of the DPU TestDrive.
			
		In the PSM\PythonScripts folder are all the indervidual python scripts that are called from the shell scripts
		
		build.sh - takes the contents of the CSV files and builds the JSON and TXT payloads.
		           It then runs the json files against the PSM to build the objects.
		           if the objects exists they will return 404 or 414 errors.
							
		clean.sh - takes the contents of the CSV files and builds the JSON and TXT payloads.
		           It then runs the txt files against the PSM to delete the objects.
		           if the objects does not exists they will return 404 or 414 errors.
							
		rebuild.sh - takes the taks of clean and build and runs them to reset all the pods.				
							
	
	"""
	
	
	
	read -p "Once complete hit enter"
	
	
}

clean_psm_var(){
	cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR
	cd PSM/PythonScripts
	rm logindetails.py
}

enviroment()
{

	# Main execution
	echo "============================================="
	echo "Environment Setup Script"
	echo "============================================="

	# configure Git repo
	configure_git_repo
	
	# configure rootfolder Dir
	configure_root_dir

	# configure DPU TestDrive Dir
	configure_dpu_dir

	# Configure PSM IP
	configure_psm_ip
	
	# Configure PSM user and password
	configure_psm_user
	configure_psm_password
	
	# Configure AXIS key
	configure_axis_key
	
	# Configure AXIS workgroup
	configure_axis_workgroup

	# Configure network interface and IP
	get_network_interfaces
	select_interface

	# Setup .local/bin directory
	setup_local_bin

	# Ensure .bashrc sources .bashrc.local
	setup_bashrc_sourcing
	
	# Source .bashrc.local to get all environment variables
	source "$HOME/.bashrc.local"

	# Check if PSM_IP is set, if not run the configuration again
	if [ -z "$PSM_IP" ]; then
	  configure_psm_ip
	  source "$HOME/.bashrc.local"
	fi

	# Source .bashrc.local again to ensure all variables are set
	source "$HOME/.bashrc.local"

	# Verify all environment variables
	verify_environment


	# Final instructions
	echo -e "\n============================================="
	echo "Setup complete!"
	echo "============================================="
	echo "All environment variables are now set in your current shell."
	echo
	echo -e "\e[1;33mNOTE:\e[0m"
	echo -e "\e[1;33mYou must log out and log back in for the environment changes to take affect. Once you log back in, you can start run the next section of the script\e[0m"
	echo -e "\e[0;31m./TestDrive_Install_script.sh\e[0m"
	echo ""
	echo "To start running the management tools once deployment complete, run the following command:"
	echo "  ./manage_script"
	echo "============================================="
					
}


# Function to update or add environment variable to .bashrc.local
update_env_var() {
  local var_name="$1"
  local var_value="$2"
  local file="$HOME/.bashrc.local"

  # Create the file if it doesn't exist
  touch "$file"

  # Check if variable already exists in the file
  if grep -q "^export $var_name=" "$file"; then
    # Replace the existing line
    sed -i "s|^export $var_name=.*|export $var_name=\"$var_value\"|" "$file"
  else
    # Add the new variable
    echo "export $var_name=\"$var_value\"" >> "$file"
  fi

  # Also export the variable to the current shell
  export $var_name="$var_value"

  echo "Environment variable $var_name has been set to \"$var_value\" in .bashrc.local and current shell"
}

# Function to get network interfaces and IP addresses
get_network_interfaces() {
  echo "Checking network interfaces..."

  # Get the list of interfaces with IP addresses
  interfaces=()
  ip_addresses=()

  # Get interface information
  while read -r line; do
    iface=$(echo "$line" | awk '{print $2}')
    ip=$(echo "$line" | awk '{print $4}' | sed 's/\/.*$//')

    # Skip loopback and interfaces without IP
    if [[ "$iface" != "lo" && "$ip" != "" ]]; then
      interfaces+=("$iface")
      ip_addresses+=("$ip")
    fi
  done < <(ip -o -4 addr show)

  # Check if we found any interfaces
  if [ ${#interfaces[@]} -eq 0 ]; then
    echo "No network interfaces with IP addresses found."
    exit 1
  fi
}

# Function to display interfaces and let user select
select_interface() {
  # Display the first interface as default
  echo "Found network interfaces:"
  for i in "${!interfaces[@]}"; do
    echo "  $((i+1)). ${interfaces[$i]}: ${ip_addresses[$i]}"
  done

  # Ask user if the lowest numbered interface is correct
  echo ""
  echo "The default interface is ${interfaces[0]} with IP ${ip_addresses[0]}"
  read -p "Is this the IP address you want to use for connectivity? (y/n): " confirm

  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    selected_ip="${ip_addresses[0]}"
  else
    # Let user select an interface
    while true; do
      read -p "Enter the number of the interface you want to use (1-${#interfaces[@]}): " selection

      if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#interfaces[@]}" ]; then
        selected_ip="${ip_addresses[$((selection-1))]}"
        break
      else
        echo "Invalid selection. Please try again."
      fi
    done
  fi

  echo "Using IP address: $selected_ip"
  update_env_var "NODE_IP" "$selected_ip"
}

# Function to ensure .local/bin is in PATH and linked to current bin directory
setup_local_bin() {
  local_bin="$HOME/.local/bin"
  current_bin="$(pwd)/bin"

  # Check if HOME/.local/bin exists
  if [ ! -d "$HOME/.local" ]; then
    mkdir -p "$HOME/.local"
  fi

  # Check if bin directory exists in current directory
  if [ ! -d "$current_bin" ]; then
    mkdir -p "$current_bin"
  fi

  # Remove existing link or directory if it exists
  if [ -e "$local_bin" ]; then
    if [ -L "$local_bin" ]; then
      # It's a symlink, check if it points to the correct location
      if [ "$(readlink -f "$local_bin")" != "$(readlink -f "$current_bin")" ]; then
        rm "$local_bin"
      else
        echo "$local_bin is already linked to the current bin directory."
      fi
    else
      # It's a directory, backup and remove
      echo "$local_bin exists but is not a symlink. Backing it up to $local_bin.bak"
      mv "$local_bin" "$local_bin.bak"
    fi
  fi

  # Create the symlink if needed
  if [ ! -e "$local_bin" ]; then
    ln -s "$current_bin" "$local_bin"
    echo "Created symbolic link from $local_bin to $current_bin"
  fi

  # Check if .local/bin is in PATH
  if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
    update_env_var "PATH" "${HOME}/.local/bin:${PATH}"
    echo "Added $HOME/.local/bin to PATH in .bashrc.local"
  else
    echo "$HOME/.local/bin is already in PATH"
  fi
}

# Function to ensure .bashrc sources .bashrc.local
setup_bashrc_sourcing() {
  # Check if .bashrc exists
  if [ ! -f "$HOME/.bashrc" ]; then
    touch "$HOME/.bashrc"
  fi

  # Check if .bashrc already sources .bashrc.local
  if ! grep -q "source.*\.bashrc\.local" "$HOME/.bashrc" ; then
    echo -e "\n# Source local settings\nif [ -f \$HOME/.bashrc.local ]; then\n  source \$HOME/.bashrc.local\nfi" >> "$HOME/.bashrc"
    echo "Added .bashrc.local sourcing to .bashrc"
  else
    echo ".bashrc already sources .bashrc.local"
  fi
}


configure_git_repo() {
  read -p "Enter the gitrepo eg: https://github.com/tdmakepeace/DPU_TestDrive.git : " git_repo
  update_env_var "GIT_REPO" "$git_repo"

}
# Function to configure rootfolder
configure_root_dir() {
	echo "Enter the path of the rootfolder directory for the install:"
  read -p "Example: pensandotools: " root_dir
  update_env_var "ROOT_INSTALL_DIR" "$root_dir"
}


# Function to configure DPU Tesdrive Dir
configure_dpu_dir() {
	echo "Enter the full path of the DPU testdrive directory:"
  read -p "Example: DPU_TestDrive: " dpu_dir
  update_env_var "DPUTD_INSTALL_DIR" "$dpu_dir"
}


# Function to configure PSM IP
configure_psm_ip() {
  read -p "Enter the IP address of the PSM server: " psm_ip
  update_env_var "PSM_URL" "https://$psm_ip"
}

## Function to configure PSM URL
#configure_psm_url() {
#		echo "Enter the full PSM URL:"
#  read -p "Example https://1.1.1.1/: " psm_url
#  update_env_var "PSM_URL" "$psm_url"
#}

# Function to configure PSM user
configure_psm_user() {
  read -p "Enter the PSM API username: " psm_user
  update_env_var "PSM_USER" "$psm_user"
}

# Function to configure PSM password
configure_psm_password() {
  read -sp "Enter the PSM API password: " psm_password
  echo
  update_env_var "PSM_PASSWORD" "$psm_password"
}


# Function to configure AXIS API Key
configure_axis_key() {
	echo "Enter the AXIS API key refer to the install doc to get :"
  echo "Make sure no spaces or CR are included : "
  read -p "Only required if using API, ask you AMD SE to help :" api_key
  update_env_var "AXIS_KEY" "$api_key"
}


# Function to configure AXIS API Key
configure_axis_workgroup() {
	echo "Enter the AXIS workgroup you are going to grant access to :"
  read -p "Only required if using API, ask you AMD SE to help :" api_wg
  update_env_var "AXIS_WORKGROUP" "$api_wg"
}



# Function to display and verify all environment variables
verify_environment() {
  source "$HOME/.bashrc.local"

  echo -e "\nCurrent environment variables:"
  echo "ROOT_INSTALL_DIR=$ROOT_INSTALL_DIR"
  echo "DPUTD_INSTALL_DIR=$DPUTD_INSTALL_DIR"
  # echo "PSM_IP=$PSM_IP"
  echo "PSM_URL=$PSM_URL"
  echo "NODE_IP=$NODE_IP"
  echo "PSM_USER=$PSM_USER"
  echo "GIT_REPO=$GIT_REPO"
  echo "PSM_PASSWORD=*******" # Don't display the actual password
  if [ ! -z "$AXIS_KEY" ]; then
    echo "AXIS_KEY=*******" # Don't display the actual cookie
  fi
  echo "AXIS_WORKGROUP=$AXIS_WORKGROUP"


  echo -e "\nAre these values correct? (y/n): "
  read confirm

  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Which variable would you like to update?"
    echo "1. DPUTD_INSTALL_DIR"
    # echo "2. PSM_IP"
    echo "2. PSM_URL"
    echo "3. NODE_IP"
    echo "4. PSM_USER"
    echo "5. PSM_PASSWORD"
    echo "6. AXIS_KEY"
    echo "7. AXIS_WORKGROUP"
    echo "8. GIT_REPO"
    echo "10. All of them"
    read -p "Enter your choice (1-5): " choice

    case $choice in
      1) configure_root_dir && configure_dpu_dir ;;
      # 2) configure_psm_ip ;;
      2) configure_psm_ip ;;
      3) get_network_interfaces && select_interface ;;
      4) configure_psm_user ;;
      5) configure_psm_password ;;
      6) configure_axis_key ;;
      7) configure_axis_workgroup ;;
      8) configure_git-repo ;;
      10) 
         configure_root_dir 
         configure_dpu_dir 
         configure_psm_ip 
         get_network_interfaces && select_interface 
         configure_psm_user 
         configure_psm_password 
         configure_axis_key 
         configure_axis_workgroup 
         configure_git_repo
        ;;
      *) echo "Invalid choice." ;;
    esac

    source "$HOME/.bashrc.local"

    # Recursive call to verify again
    verify_environment
  fi
}


gitrefesh()
{
	cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/
	git pull
	cd accounts
	chmod +x *.sh
	cd ../axis
	chmod +x *.sh
	cd ../PSM
	chmod +x *.sh
	cd 
		
	read -p "Repo status is updated - enter to continue"
}


testcode()
{
		echo " 
		Space for testing
					"

					verify_environment
					
}

while true ;
do
	clear
  echo "press cntl-c  or x to exit at any time.
  
  
  
  "
  echo -e "
### This script has been build to set up the enviroment for the TestDrive Management and is based on a default Ubuntu 22.04/24.04 servers install.                 ###
### The only packages needing to be installed as part of the deployment of the Ubuntu servers is openSSH.                                                          ###
###                                                                                                                                                                ###
### you can do a minimun install, but i would just stick with the servers install.                                                                                 ###
###                                                                                                                                                                ###
### Also it is recommended that you run a static-IP configuration, with a single or dual network interface.                                                        ###
### The script should be run as the first user create as part of the install, and uses SUDO for the deployment process.                                            ###


If the ELK stack has not been installed, exit the script and deploy the ELK stack by running the single script installer. At minimun the base option of the ELK install needs to have been completed.

\e[0;31m

wget -O ELK_Install_Ubuntu_script.sh  https://raw.githubusercontent.com/tdmakepeace/ELK_Single_script/refs/heads/main/ELK_Install_Ubuntu_script.sh && chmod +x ELK_Install_Ubuntu_script.sh  &&  ./ELK_Install_Ubuntu_script.sh

\e[1;33m

Options for this setup need to be followed one by one :
\e[0m
E - Setup the enviromental variables. (directory, PSM details, Axis Details)
D - Download and clone the Git repo for the testdrive. 
B - Base setup of the powershell enviroment.
I - Install the modules required in powershell.

\e[1;33m
Other options:
\e[0m
C - Change the enviromental variables. (directory, PSM details, Axis Details)

G - Refesh the gitrepo
  

R - Read notes on using the VMware scripts manually. 
P - Read notes on using the PSM scripts manaually. 


x - to exit
  		
  	"
	echo "E or D or B or I"
	echo "C or G or R or P"
	read x
  x=${x,,}
  
  clear

		if  [ $x == "d" ]; then
				echo "
This should be a one off process do not repeat unless you have cancelled it for some reason.
	
		        "
				  echo "cntl-c  or x to exit"
				  echo ""    
				  echo "Enter 'C' to continue :"
				  read x
				    x=${x,,}
					  clear
				   while [ $x ==  "c" ] ;
				    do
				    	download
					  	x="done"
				  done
  		

		elif [  $x ==  "b" ]; then
			
					echo "(select option 'A')  - sometime it take time to run."
					basesetup
				  
		elif [  $x ==  "i" ]; then
					instruction
					break
		elif [  $x ==  "e" ]; then
					enviroment
					clean_psm_var
					read -p "Logout and then backin to use the enviroment variables."
					break
		elif [  $x ==  "c" ]; then
					verify_environment
					clean_psm_var
					read -p "Logout and then backin to use the enviroment variables."
					break
		
		elif [  $x ==  "g" ]; then
					gitrefesh
					clean_psm_var
					read -p "Logout and then backin to use the enviroment variables."
					break
		
		
		elif [  $x ==  "r" ]; then
					esxnotes
												
		elif [  $x ==  "p" ]; then
					psmnotes
					
		elif [  $x ==  "t" ]; then
					testcode
				  

		elif [  $x ==  "x" ]; then
				break


  	else
    	echo "try again"
  	fi

done