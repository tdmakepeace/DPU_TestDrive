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
file_path="axislogaudit.txt"
basefolder="axis"
rootfolder="pensandotools"

### api token valid for 1 year, and will need to be refreshed. ###
apitoken=$AXIS_Key
groupid=$AXIS_WORKGROUP   ## only users with this group will be deleted ##


### END OF #####

bearer="Authorization: Bearer $apitoken"


	
apicommit()
{
curl --location --request POST 'https://admin-api.axissecurity.com/api/v1.0/Commit' --header 'Accept: application/json'  --header "$bearer"
	
}	


adduser()
{
	echo "Which pod user do you want to set up
		number 1 - 10
		
		beware this will reset a previous account.
		x to return to main menu
				"

	read pod 
	
	if [  $pod ==  "x" ]; then
				echo "returning to main menu"


	else
	
			user="vrf"$pod"_user"
			echo $user
			echo "Enter the Email address of the destination user"
			read email
			echo "how many days do you want the account to last"
			read days
			expiry=$(date '+%Y-%m-%d' -d "+$days day")"T23:59:59.000Z"
			echo """
			User account: $user
			For email address: $email
			
			Will expire on $expiry 
			"""


		userName=$user
		email=$email
		expiration=$expiry

		JSON_STRING=$( jq -n \
		                  --arg un "$userName" \
		                  --arg em "$email" \
		                  --arg dt "$expiration" \
		                  '{userName: $un, email: $em, firstName: $un,  expiration: $dt  ,    "lastName": $em,    "enabled": true, "groups": [ { "id": "e2bc9bf0-4041-4ae7-b1eb-230a0bc34416" } ] }' )
		                  

		response=$(curl --write-out '%{http_code}\n'  --location 'https://admin-api.axissecurity.com/api/v1/Users?PageNumber%20=1&PageSize%20=10' --header 'Content-Type: application/json' --header 'Accept: application/json' --header "$bearer" --data-raw "$JSON_STRING")
		echo "Response from: $response"
		sleep 1
		apicommit

		echo "$(date '+%Y-%m-%d %H:%M') - user: $email , pod : $user , expiry: $expiry - CREATED " >> $file_path

	fi
}

deletuser()
{
	
data=$(curl -s --location 'https://admin-api.axissecurity.com/api/v1.0/Users?pageNumber=1&pageSize=20' --header 'Accept: application/json' --header "$bearer" ) #| jq --raw-output -r '. | "\(.userName) \(.id)"')
#allusers=$(echo "$data" | jq '.data.[]')
allusers=$(echo "$data" | jq '.data')

# Loop through the JSON data and add a number to each formatted line
echo "$allusers" | jq -c '.[]' | while read -r item; do
    userName=$(echo "$item" | jq -r '.userName')
        email=$(echo "$item" | jq -r '.email')
#    id=$(echo "$item" | jq -r '.id')
    ((i++))
    echo "$i. userName: $userName		Email: $email		" #		 id: $id"
    done


echo "enter ID string or x to return to main menu"
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


updateuser()
{
	
	data=$(curl -s --location 'https://admin-api.axissecurity.com/api/v1.0/Users?pageNumber=1&pageSize=20' --header 'Accept: application/json' --header "$bearer" ) #| jq --raw-output -r '. | "\(.userName) \(.id)"')
	allusers=$(echo "$data" | jq '.data')

# Loop through the JSON data and add a number to each formatted line
	echo "$allusers" | jq -c '.[]' | while read -r item; do
    userName=$(echo "$item" | jq -r '.userName')
    email=$(echo "$item" | jq -r '.email')
    expiration=$(echo "$item" | jq -r '.expiration')
    id=$(echo "$item" | jq -r '.id')
    ((i++))
    echo "$i. userName: $userName		Email: $email		 expiration: $expiration"
	done



	echo "enter ID string or x to return to main menu"
	read row

	if [  $row ==  "x" ]; then
					echo "returning to main menu"


	else

	echo "how many days do you want the account to last"
	read days
	expiry=$(date '+%Y-%m-%d' -d "+$days day")"T23:59:59.000Z"
	expiration=$expiry


# allusers=$(echo "$data" | jq '.data')

# Loop through the JSON data and add a number to each formatted line
	echo "$allusers" | jq -c ".[$((row-1))]" | while read -r item; do
    userName=$(echo "$item" | jq -r '.userName')
    email=$(echo "$item" | jq -r '.email')
    id=$(echo "$item" | jq -r '.id')
    ((i++))
    group=$(echo "$item" | jq -r '.groups.[]')
    value=$(echo "$group" | jq -r '.value')
    if [ "$groupid" == "$value" ]  ; then 
    	update=$id
			
			JSON_STRING=$( jq -n \
                  --arg un "$userName" \
                  --arg em "$email" \
                  --arg dt "$expiration" \
                  '{userName: $un, email: $em, firstName: $un,  expiration: $dt  ,    "lastName": $em ,    "enabled": true, "groups": [ { "id": "e2bc9bf0-4041-4ae7-b1eb-230a0bc34416" } ] }' )
   
   
			
			url="https://admin-api.axissecurity.com/api/v1.0/Users/$update"
			response=$(curl --write-out '%{http_code}\n'curl --location --request PUT "$url"  --header 'Content-Type: application/json' --header 'Accept: application/json' --header "$bearer" --data-raw "$JSON_STRING")
			echo "Response from: $response"

			echo "user updated"
			apicommit
			echo "$(date '+%Y-%m-%d %H:%M') - user: $email , pod : $userName , expiry: $expiration - UPDATED " >> $file_path
		else 
		 echo "no no - not allowed"
  	fi
    
    
    
	done

fi
	
}
	
	
	

testcode()
{
		echo " 
		Space for testing
					"
# put current date as yyyy-mm-dd HH:MM:SS in $date

	echo "how many days do you want the account to last"
	read days
	test=$(date '+%Y-%m-%d %H:%M:%S' -d "+$days day")
	echo "Account will expire on $test"
					
}

while true ;
do
#	clear
  echo "press cntl-c  or x to exit at any time.
  
  
  
  "


data=$(curl -s --location 'https://admin-api.axissecurity.com/api/v1.0/Users?pageNumber=1&pageSize=20' --header 'Accept: application/json' --header "$bearer" ) #| jq --raw-output -r '. | "\(.userName) \(.id)"')
#allusers=$(echo "$data" | jq '.data.[]')
allusers=$(echo "$data" | jq '.data')
# echo $allusers

# Loop through the JSON data and add a number to each formatted line
echo "$allusers" | jq -c '.[]' | while read -r item; do
    userName=$(echo "$item" | jq -r '.userName')
    email=$(echo "$item" | jq -r '.email')
    #id=$(echo "$item" | jq -r '.id')
    expiration=$(echo "$item" | jq -r '.expiration')
    ((i++))
    echo "$i. userName: $userName		Email: $email	 expiration: $expiration"
done


	echo "
	Create                     - c
	delete                     - d
	update expiry              - u
	
	return to previous screen  - x
	
	
	
	
	c or d or u or x "
	read x
  x=${x,,}
  
  clear

		if  [ $x == "c" ]; then

  			adduser

		elif [  $x ==  "d" ]; then
			
				deletuser
				  
		elif [  $x ==  "u" ]; then
			
				updateuser

		elif [  $x ==  "t" ]; then
				testcode
				  

		elif [  $x ==  "x" ]; then
				break


  	else
    	echo "try again"
  	fi

done
