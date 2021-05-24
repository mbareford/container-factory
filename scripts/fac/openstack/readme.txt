The instructions below explain how to create an Eleanor cloud instance.


The first steps involve installing a miniconda3 environment on your local machine. You then need to install the packages for the OpenStack command line client.

conda install pip
 
pip install python-heatclient
pip install python-openstackclient
 
conda update -n root --all


From your local machine, source the OpenStack RC script downloaded from the Eleanor Horizon API Access page.
This script will prompt you for your Active Directory (AD) password.

. ./EPCC-ContainerFactory-openrc.sh

The OpenStack Command Line Client can now be used to issue the command for instance creation.

openstack stack create -t factory.yml epcc-container-factory

Once the create command has finished, return to your Eleanor Horizon session and go to the Instances page. You should see your new Ubuntu instance listed;
make a note of the floating IP address and click "Start Instance" under the Actions column. And when the instance is listed as running (under Power State)
you can ssh into it from your local machine.

ssh -i EPCC-ContainerFactoryKey.pem ubuntu@172.16.50.172

The key (pem) file can be downloaded from the Eleanor Horizon Key Pairs page.
