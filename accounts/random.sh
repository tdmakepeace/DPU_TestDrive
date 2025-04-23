#!/bin/bash




vmware()
{
## VMware

#	echo "Parameter #1 is $1"
#	echo "Parameter #2 is $2"
	
	cd /pensandotools/PSM_Test_Drive_Light/accounts/

	pwsh ./ESXI-Password.ps1 -pass "$1"  -vrf $2

# pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 1

}

elk()
{
	
userName=$2
pass=$1

JSON_STRING=$( jq -n \
                  --arg un "$userName" \
                  --arg ps "$pass" \
                  '{username: $un, "roles": [ "CX10K-readonly" ], password : $ps, "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }')                

	
	echo $JSON_STRING
	
  url="http://localhost:9200/_security/user/$userName?pretty"
  echo $url
  
  response=$(curl --write-out '%{http_code}\n' -v -u elastic:changeme $url -H 'Content-Type: application/json' -d "$JSON_STRING" )
	echo "Response from: $response"


	
# curl -u elastic:changeme -X POST "http://localhost:9200/_security/user/vrf1_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf1_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'


}

psm()
{
	cd /pensandotools/PSM_Test_Drive_Light/PSM/PythonScripts/

		user="vrf"$2"_user"


	echo "name,email,password
$user,$user@amd.com,$1
" > singleuser.csv

echo "name,rolebinding,user,vrf,vlanpre,policypre
vrf$2role,vrf$2role_binding,vrf$2_user,vrf$2,vlan$2,vrf$2_vlan$2
" > singlerole.csv



sleep 1
python3 user.py singleuser.csv
python3 role.py singlerole.csv
sleep 1
python3 deleterolebinding.py rolebinding_list.txt
python3 deleterole.py role_list.txt
python3 deleteuser.py user_list.txt
sleep 1
python3 importuser.py user_csv.json
python3 importrole.py role_csv.json
sleep 1
python3 importrolebinding.py rolebinding_csv.json

sleep 1
 
rm *.json
rm *.csv
rm *.txt

	
	
#			curl -u elastic:changeme -X POST "http://localhost:9200/_security/user/vrf1_user?pretty" -H 'Content-Typ#e: application/json' -d '{"username": "vrf1_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'

}




while true ;
do


	echo " 
	Confirm you want to reset all passwords to the random passwords
	
	y or n
	
	"
	read x
  x=${x,,}
  
  clear
  
 	if  [ $x == "y" ]; then

		for i in {1..10}
		do
		 echo "Loop spin:" $i
				#eval "pass${i}=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c10)$(< /dev/urandom tr -dc '!@#$%^&*!@#$%^!@#$%^!@#$%^' | head -c1)"
				eval "pass${i}=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c11)\$"
				eval "user${i}=\"vrf\"${i}\"_user\""
				eval "echo \"\${user${i}} -  \${pass${i}} \""
				id=$i
    		eval "vmware \${pass${i}} \$id"
    		eval "elk \${pass${i}} \${user${i}}"
    		eval "psm  \${pass${i}} \$id"
    
		done

			
#		clear

								
		for j in {1..10}
		do
			eval "string=\"	VMware User : \"\${user${j}}\"@vsphere.local  Elk + PSM  User : \"\${user${j}}\" Password : \"\${pass${j}}"
			echo $string
		done
				
 
		elif [  $x ==  "n" ]; then
				break


  	else
    	echo "try again"
  	fi


done