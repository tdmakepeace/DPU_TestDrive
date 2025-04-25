#!/bin/bash




axis()
{
		cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/axis/
		./TestDrive_axis_users.sh
}
	
esxpod()
{
 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/ESX
 pwsh ./ESXI-testdrive-resetpod.ps1
}
	
	
esxall()
{
 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/ESX
 pwsh ./ESXI-testdrive-all-resetpods.ps1
}

setupesx()
{
 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/ESX
 pwsh ./ESXI-testdrive-Build1.ps1
 addintdelay
 pwsh ./ESXI-testdrive-Build2.ps1
 
}
	
setuppsm()
{
 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/PSM
 ./build.sh
} 

psmpod()
{
 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/PSM   
 ./rebuildpod.sh
 
}
		
psmall()
{
 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/PSM
 ./rebuild.sh
 
}		

singlepassword()
{
 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/accounts
  ./single.sh
}


defpass()
{
	 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/accounts
  ./all.sh
}

ranpass()
{
	 cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/accounts
   ./random.sh
}
		
expireduser()
{
	cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/axis/
	./TestDrive_axis_sessionend.sh
 
}  		

expiredpod()
{
	cd /$ROOT_INSTALL_DIR/$DPUTD_INSTALL_DIR/axis/
	./TestDrive_axis_sessionend.sh $1
 
}  		

addintdelay()
{
  while true ;
    do
		clear
	echo -e "\e[0;31mVMware Setup\e[0m"
	echo -e "
	Please login to the Vcenter server and complete the following actions. 
	
\e[1;33m1. Upload the base image you want to use for the enviroment\e[0m
		In our example you will find a example image to work from in the VMimage folder.
		
		\e[0;31mTinyCoreBash.ova \e[0m
		
	The name of the uploaded VMimage should be: \e[1;33mTinyVMDeploy\e[0m
	Or the name you referenced in the BuildVaribles.ps1 process. (TinyVMDeploy is the example used)
	
\e[1;33m2. Attach the host to the VRF-Demo distributed switch\e[0m
	Please refer the the DPU TestDrive Deployment document, or your AMD Pensando SE.
		
		"
	read -p "hit enter once you have confirmed the network is attached and image is uploaded"
  echo ""
  echo "Enter 'C' to confirm :"
  read x
    x=${x,,}
    if [  $x ==  "c" ]; then
				break
  	else
    echo "Please complete the task first"
    read -p ""
  	fi
  done
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
  echo -e "\e[1;33mInitial Scripts\e[0m"
  
  echo "   
  
  Setup and build the first ESX config     -  o
  (networking/users/vrf/pods, etc - one off process)
  
  Setup and build the first PSM config     -  p
  (networking/users/vrf/pods, etc - one off process)
    
  "
    
  echo -e "\e[1;33mSingle account or single pod\e[0m"
  
  echo " 	 

	 a or b or c or d 

  "
  echo -e "\e[1;33mFull System Reset \e[0m"
  
  echo " 	 
	 
	 e or f or g or h
	"
  echo -e "\e[1;33mEnd of session pod clean \e[0m"
  
  echo " 	 
	 
	 m or n
	 "
  echo -e "\e[1;33mInital setup \e[0m"
  
  echo " 	 
	 
	 o or p
	 
	 or x for exit "
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
		
		elif [  $x ==  "o" ]; then
			setupesx
		
		elif [  $x ==  "p" ]; then
			setuppsm
		
		elif [  $x ==  "r" ]; then
			gitrefesh
		
		elif [  $x ==  "q" ]; then
				break
		elif [  $x ==  "x" ]; then
				break


  	else
    	echo "try again"
  	fi

done
		
