#!/bin/bash

###
### This script has been build to set up the enviroment for the TestDrive Management and is based on a default Ubuntu 22.04/24.04 servers install.
### The only packages needing to be installed as part of the deployment of the Ubuntu servers is openSSH.
###
### you can do a minimun install, but i would just stick with the servers install.
###
### Also it is recommended that you run a static-IP configuration, with a single or dual network interface.
### The script should be run as the first user create as part of the install, and uses SUDO for the deployment process.




###	 Only thing to touch without Toby Makepeace support #####
file_path="/$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/axislogaudit.txt"

### api token valid for 1 year, and will need to be refreshed. ###
apitoken=$AXIS_KEY
groupid=$AXIS_WORKGROUP   ## only users with this group will be deleted ##


### END OF #####

bearer="Authorization: Bearer $apitoken"


	
apicommit()
{
curl --location --request POST 'https://admin-api.axissecurity.com/api/v1.0/Commit' --header 'Accept: application/json'  --header "$bearer"
	
}	

deletuserclean()
{
	
### clear the PSM config to defualt ####
echo $1
user="vrf$1_user"
echo $user


	cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/PSM   
 ./rebuildpod.sh $pod & >/dev/null
	
### reset the VM space ####

 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/ESX
 pwsh ./ESXI-testdrive-resetpod.ps1	$pod & >/dev/null
 

### delete the axis user  ####


data=$(curl -s --location 'https://admin-api.axissecurity.com/api/v1.0/Users?pageNumber=1&pageSize=20' --header 'Accept: application/json' --header "$bearer" ) #| jq --raw-output -r '. | "\(.userName) \(.id)"')
#allusers=$(echo "$data" | jq '.data.[]')
allusers=$(echo "$data" | jq '.data')

# Loop through the JSON data and add a number to each formatted line
echo "$allusers" | jq -c '.[]' | while read -r item; do
    userName=$(echo "$item" | jq -r '.userName')
        email=$(echo "$item" | jq -r '.email')
        id=$(echo "$item" | jq -r '.id')
#    id=$(echo "$item" | jq -r '.id')
    ((i++))
#    echo "$i. userName: $userName		Email: $email		 id: $id"
    
		    if [ "$userName" == "$user" ] ; then 
		    	
		    	echo "delete $id"
		    	delete=$id
					echo "user deleted"
					    url="https://admin-api.axissecurity.com/api/v1.0/Users/$delete"
							response=$(curl --write-out '%{http_code}\n' --location --request DELETE "$url" --header 'Accept: application/json' --header "$bearer")
							echo "Response from: $response"
							apicommit
							echo "$(date '+%Y-%m-%d %H:%M') - user: $email , pod : $userName - DELETED " >> $file_path

		    # sleep 2
				else 
				    	echo "no delete $userName"
				    	
				fi 
    done

 sleep 2


}

deletuserpod()
{
	
data=$(curl -s --location 'https://admin-api.axissecurity.com/api/v1.0/Users?pageNumber=1&pageSize=20' --header 'Accept: application/json' --header "$bearer" ) #| jq --raw-output -r '. | "\(.userName) \(.id)"')
#allusers=$(echo "$data" | jq '.data.[]')
allusers=$(echo "$data" | jq '.data')

# Loop through the JSON data and add a number to each formatted line
echo "$allusers" | jq -c '.[]' | while read -r item; do
    userName=$(echo "$item" | jq -r '.userName')
        email=$(echo "$item" | jq -r '.email')
#    id=$(echo "$item" | jq -r '.id')
    expiration=$(echo "$item" | jq -r '.expiration')
    ((i++))
    if [ "$expiration" != "null" ]  ; then 
    echo "$i. userName: $userName		Email: $email	 expiration: $expiration"
  	fi 
    done


echo "enter ID string"
read row

if [  $row ==  "x" ]; then
				echo "returning to main menu"


else
  	
  	

#allusers=$(echo "$data" | jq '.data')

# Loop through the JSON data and add a number to each formatted line
echo "$allusers" | jq -c ".[$((row-1))]" | while read -r item; do
    userName=$(echo "$item" | jq -r '.userName')
    email=$(echo "$item" | jq -r '.email')
    id=$(echo "$item" | jq -r '.id')
    ((i++))
    group=$(echo "$item" | jq -r '.groups.[]')
    value=$(echo "$group" | jq -r '.value')
    if [ "$groupid" == "$value" ]  ; then 
    	delete=$id

pod=`echo $userName | tr -cd '[[:digit:]]'`
echo $pod



### clear the PSM config to defualt ####

	cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/PSM   
 ./rebuildpod.sh $pod
	
### reset the VM space ####

 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/ESX
 pwsh ./ESXI-testdrive-resetpod.ps1	$pod
 

### delete the axis user  ####

			echo "user deleted"
		    url="https://admin-api.axissecurity.com/api/v1.0/Users/$delete"
				response=$(curl --write-out '%{http_code}\n' --location --request DELETE "$url" --header 'Accept: application/json' --header "$bearer")
				echo "Response from: $response"
				apicommit
				echo "$(date '+%Y-%m-%d %H:%M') - user: $email , pod : $userName - DELETED " >> $file_path

		else 
		 echo "no no - not allowed only allow to touch your users"
  	fi

   done
fi 

}


while true ;
do
	
	
	clear
	if [ -z "$1" ]; then
	

			
		  echo "press cntl-c  or x to exit at any time.
		  
		  Allow 6 minutes for each pod reset
		  
		  "

			echo "press c to continue"
			read x
		  x=${x,,}
		  
		  clear

				if  [ $x == "c" ]; then

						deletuserpod
						  

				elif [  $x ==  "x" ]; then
					break


		  	else
		    	echo "try again"
		  	fi

	else 
		pod=$1   
		echo $pod
 		deletuserclean  $pod
		sleep 2
		break 
	fi  



done
