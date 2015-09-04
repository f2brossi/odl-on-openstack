odl-on-openstack
==============

This repo provides a Vagrantfile for the Vagrant Openstack Provider (https://github.com/ggiamarchi/vagrant-openstack-provider) with Puppet provisioning that one can use to easily get a cluster of nodes configured with DevStack using OpenDaylight as SDN.

Testing
-------

A Vagrantfile is provided to easily create a DevStack environment to test with.
First, run the ODL Controller on devstack-control ::

    vagrant up --provider=openstack
    vagrant ssh
    cd devstack
    ./stack.sh   and take a coffee 
    
Second,  run the Compute node ::
    
    cd compute
    vagrant up --provider=openstack
    vagrant ssh
    cd devstack
    ./stack.sh  And wait again
    
    
Where to find an Openstack public cloud provider ?
------
[List of Openstack public cloud providers] (https://www.openstack.org/marketplace/public-clouds/)
