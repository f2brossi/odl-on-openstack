odl-on-openstack
==============

This repo provides a Vagrantfile for the Vagrant Openstack Provider (https://github.com/ggiamarchi/vagrant-openstack-provider) with Puppet provisioning that one can use to easily get a cluster of nodes configured with DevStack using OpenDayligth as SDN.

Usage
-----

To use these drivers with Devstack....

1) Edit your local.conf. Key sections to modify are::

    [[local|localrc]] LOGFILE=stack.sh.log
    enable_plugin networking-odl https://github.com/stackforge/networking-odl

    Q_PLUGIN=ml2
    Q_ML2_TENANT_NETWORK_TYPE=vxlan
    ODL_MGR_IP=${ODL_IP}
    ENABLE_TENANT_TUNNELS=True
    Q_ML2_TENANT_NETWORK_TYPE=vxlan

    ODL_MODE=allinone

2) Start devstack::

    cd devstack
    ./stack.sh

Testing
-------

A Vagrantfile is provided to easily create a DevStack environment to test with.
First, run the ODL Controller on devstack-control ::

    vagrant up --provider=openstack
    vagrant ssh
    cd devstack
    ./stack.sh
    
Second,  run the Compute node ::
    
    cd compute
    vagrant up --provider=openstack
    vagrant ssh
    cd devstack
    ./stack.sh
    
If you would like more than one compute node, you can set thse following environment variable::

    #Note: Only 3 or less nodes are supported today
    export DEVSTACK_NUM_COMPUTE_NODES=3
