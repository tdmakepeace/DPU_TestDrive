#!/bin/bash




axis()
{
		cd /pensandotools/PSM_Test_Drive_Light/axis/
		./TestDrive_axis_users.sh
}
	
esxpod()
{
 cd /pensandotools/PSM_Test_Drive_Light/ESX
 pwsh ./ESXI-testdrive-resetpod.ps1
}
	
	
esxall()
{
 cd /pensandotools/PSM_Test_Drive_Light/ESX
 pwsh ./ESXI-testdrive-all-resetpods.ps1
}
	

psmpod()
{
 cd /pensandotools/PSM_Test_Drive_Light/PSM   
 ./rebuildpod.sh
 
}
		
psmall()
{
 cd /pensandotools/PSM_Test_Drive_Light/PSM
 ./rebuild.sh
 
}		

singlepassword()
{
 cd /pensandotools/PSM_Test_Drive_Light/accounts
  /pensandotools/PSM_Test_Drive_Light/accounts/single.sh
}


defpass()
{
	 cd /pensandotools/PSM_Test_Drive_Light/accounts
  ./all.sh
}

ranpass()
{
	 cd /pensandotools/PSM_Test_Drive_Light/accounts
   ./random.sh
}
		
expireduser()
{
	cd /pensandotools/PSM_Test_Drive_Light/axis/
	./TestDrive_axis_sessionend.sh
 
}  		

expiredpod()
{
	cd /pensandotools/PSM_Test_Drive_Light/axis/
	./TestDrive_axis_sessionend.sh $1
 
}  		


while true ;
do
clear
  echo "press cntl-c  or x to exit at any time."
  
  echo -e "\e[1;33mSingle funtion scripts\e[0m"
  
  echo "
  
  Axis accounts                         -  a
  Create / Delete / Update Expiry 
  
  ESX single pod reset                  -  b
  Reset a single POD VM's
  
  PSM single pod reset                  -  c
  Reset a single POD PSM

  Single Password reset                 -  d
   
  "
  echo -e "\e[1;33mAfter a full lab sessions\e[0m"
  
  echo "   
  
  Full ESX pods reset                   -  e
  
  Full PSM Reset                        -  f
  
  Recreate all default Passwords        -  g
  
  Recreate all random Passwords         -  h
  
  "
  echo -e "\e[1;33mCombined Scripts\e[0m"
  
  echo "   
  
  Delete expired user and reset pod     -  m
  (interactive option, by email)
  
  Delete expired user and reset pod     -  n
  (by pod numbers)
    
  "
  
  echo -e "\e[1;33mSingle account or single pod\e[0m"
  
  echo " 	 
	
	 a or b or c or d 
	 
	 or 
  "
  echo -e "\e[1;33mFull System Reset \e[0m"
  
  echo " 	 
	 
	 e or f or g or h
	"
  echo -e "\e[1;33mEnd of session pod clean \e[0m"
  
  echo " 	 
	 
	 m or n
	  
	 or
	 x for exit "
	read x
  x=${x,,}
  
  clear

		if  [ $x == "a" ]; then

			axis

		elif [  $x ==  "b" ]; then
			
			esxpod
				  
		elif [  $x ==  "c" ]; then

			psmpod
			
		elif [  $x ==  "d" ]; then
			
			singlepassword
			
		elif [  $x ==  "e" ]; then
			
			esxall
			
		elif [  $x ==  "f" ]; then
			
			psmall
			
		elif [  $x ==  "g" ]; then
			
			defpass
		
		elif [  $x ==  "h" ]; then
			
			ranpass
		elif [  $x ==  "m" ]; then
			
			expireduser
		
		elif [  $x ==  "n" ]; then
			
		echo "Enter the pod number"
		read pod
		expiredpod  $pod
		
		elif [  $x ==  "x" ]; then
				break


  	else
    	echo "try again"
  	fi

done
		
