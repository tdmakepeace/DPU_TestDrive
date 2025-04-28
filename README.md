# DPU_TestDrive
Installer tools used by the AMD Pensando for setting up DPU TestDrives for partners.

This application currently supports Ubuntu 20.04, 22.04, or 24.04 (though it may work with other versions as well).

A deployment script is provided as part of this repository, which performs the following tasks:

1. Prepares the base operating system creating the enviromental variables.
2. Downloads and deploys the dependencies from github.
3. Walks you though the setup steps.
4. Has a day to day managment script to call all funtions.


Run the installation script using the following command:


    wget -O TestDrive_Install_script.sh  https://raw.githubusercontent.com/tdmakepeace/DPU_TestDrive/refs/heads/main/TestDrive_Install_script.sh && chmod +x TestDrive_Install_script.sh  &&  ./TestDrive_Install_script.sh
    
    
There is a dependency on the OS being setup with minimun packages. We recommend that the base option from the Pensando_Tools repo is run first.

    wget -O Install_pensando_tools.sh  https://raw.githubusercontent.com/tdmakepeace/pensando-tools/refs/heads/main/Install_pensando_tools.sh && chmod +x Install_pensando_tools.sh  &&  ./Install_pensando_tools.sh


If you have any questions talk to your SE first.

## Platform support

For support or feedback on the installation script or any other components of this repository, please [file an issue](https://github.com/tdmakepeace/DPU_TestDrive/issues).


## Disclaimer

The script provided by AMD / Toby Makepeace is open-source and is governed by its applicable licensing terms. AMD is not responsible for any issues arising from the use of this script.

Please note that the software components installed and configured by this script, including but not limited to Ubuntu Linux, Elasticsearch, Logstash, Kibana, and ElastiFlow, powerCLI are also governed by their respective licensing terms and conditions. It is the responsibility of the end user to review, understand, and comply with these licensing agreements.
AMD / Toby Makepeace assumes no responsibility for any licensing obligations or issues that may arise from the use of these software components.

By using this script, you acknowledge and agree that you are solely responsible for ensuring compliance with all applicable licensing requirements referred above.
