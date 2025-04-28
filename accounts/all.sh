#!/bin/bash



vmware()
{
	
	cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/accounts/

	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 1
	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 2
	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 3
	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 4
	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 5
	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 6
	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 7
	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 8
	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 9
	pwsh ./ESXI-Password.ps1 -pass "Pensando0$"  -vrf 10
	
	
}

elk()
{
	
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf1_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf1_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf2_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf2_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf3_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf3_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf4_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf4_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf5_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf5_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf6_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf6_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf7_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf7_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf8_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf8_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf9_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf9_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'
curl -u $elkuser:$elkpass -X POST "http://localhost:9200/_security/user/vrf10_user?pretty" -H 'Content-Type: application/json' -d '{"username": "vrf10_user", "roles": [ "CX10K-readonly" ], "password" : "Pensando0$", "full_name": "",  "email": "",  "metadata": {}, "enabled": true   }'


}

psm()
{
	cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/PSM/PythonScripts/

sleep 1
python3 user.py ../CSV_example/user.csv
python3 role.py ../CSV_example/role.csv
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
	Confirm you want to reset all passwords to the default \"Pensando0$\"
	
	y or n
	
	"
	read x
  x=${x,,}
  
  clear
  
 	if  [ $x == "y" ]; then

#		pass=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c9)$(< /dev/urandom tr -dc '!@#$%^&*()_+' | head -c1)
#		# echo $pass
#		id=$x
#		user="vrf"$id"_user"
#	
    vmware 
    elk 
    psm  

#		echo "
#		
#		
#		VMware User : $user@vsphere.local  	
#		Elk + PSM  User : $user
#		Password : $pass
#		
#		"
 
		elif [  $x ==  "n" ]; then
				break


  	else
    	echo "try again"
  	fi


done