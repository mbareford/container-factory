How to Create an Eleanor Cloud Instance
=======================================

The first steps involve installing a `miniconda3` environment on your local machine.
You then need to install the packages for the OpenStack command line client.

```bash
conda install pip
 
pip install python-heatclient
pip install python-openstackclient
 
conda update -n root --all
```

From your local machine, source the [OpenStack RC script](/scripts/fac/openstack/EPCC-ContainerFactory-openrc.sh) downloaded from the Eleanor Horizon API Access page.
This script will prompt you for your Active Directory (AD) password.

```bash
. ./EPCC-ContainerFactory-openrc.sh
```

The OpenStack Command Line Client can now be used to issue the command for instance creation. Note, the factory instance flavor (or spec) is given in the [factory yml file](/scripts/fac/openstack/factory.yml) file.

```bash
openstack stack create -t factory.yml epcc-container-factory
```

Further details on the available instance flavors can be found via this [UoE wiki link](https://www.wiki.ed.ac.uk/display/ResearchServices/Cloud+Flavors).

Once the create command has finished, return to your [Eleanor Horizon](https://horizon.ecdf.ed.ac.uk/dashboard/auth/login/) session and go to the Instances page. You should see your new Ubuntu instance listed;
make a note of the floating IP address and click "Start Instance" under the Actions column. And when the instance is listed as running (under Power State)
you can ssh into it from your local machine using something like the following command.

```bash
ssh -i EPCC-ContainerFactoryKey.pem ubuntu@172.16.50.172
```

The key (pem) file can be downloaded from the Eleanor Horizon Key Pairs page.