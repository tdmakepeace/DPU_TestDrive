#!/bin/bash





cd PythonScripts

file="logindetails.py"

if [ ! -e "$file" ]; then
echo "PSM_IP = '"$PSM_URL"'
username = '"$PSM_USER"'
password = '"$PSM_PASSWORD"'
		" > $file
		
sleep 1
fi


python3 networks.py ../CSV_example/networks.csv
python3 role.py ../CSV_example/role.csv
python3 user.py ../CSV_example/user.csv
python3 vrf.py ../CSV_example/vrf.csv
python3 policy_FIRST.py ../CSV_example/policy_FIRST.csv
python3 policy_NEW.py ../CSV_example/policy_NEW.csv
python3 workload.py ../CSV_example/workload.csv
python3 ipcollection.py ../CSV_example/ipcollection.csv

sleep 5 

python3 importpolicy.py policy_FIRST_csv.json
python3 importpolicy.py policy_NEW_csv.json
python3 importvrf.py vrf_csv.json
python3 importnetworks.py networks_csv.json
python3 importworkload.py workload_csv.json
python3 importipcollection.py ipcollection_csv.json

sleep 2
python3 importuser.py user_csv.json
python3 importrole.py role_csv.json
python3 importuser.py readonlyuser_csv.readonly
python3 importrole.py readonlyrole_csv.readonly

sleep 2
python3 importrolebinding.py rolebinding_csv.json
python3 importrolebinding.py readonlybinding_csv.readonly

sleep 2
rm *.txt
rm *.json
