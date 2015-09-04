require 'vagrant-openstack-provider'

Vagrant.configure("2") do |config|

  config.vm.box = "openstack"
  config.vm.box_url = "https://github.com/ggiamarchi/vagrant-openstack/raw/master/source/dummy.box"

  config.ssh.shell = "bash"
  config.ssh.username = "stack"
  #config.ssh.pty = true

  config.vm.provider :openstack do |os|
    os.username = ENV['OS_USERNAME']
    os.password = ENV['OS_PASSWORD']
    os.tenant_name = ENV['OS_TENANT_NAME']
    os.openstack_auth_url = ENV['OS_AUTH_URL']
    os.openstack_compute_url = ENV['OS_COMPUTE_URL']
    os.openstack_network_url = ENV['OS_NETWORK_URL']
    os.region = ENV['OS_REGION']
    #os.keypair_name = ENV['OS_KEYPAIR_NAME']
  end

  # Devstack Controller
  config.vm.define "devstack-control", primary: true do |control|
   control.vm.provider :openstack do |os|
     os.server_name = "devstack-control"
     os.floating_ip = ENV['OS_FLOATING_IP']
     os.flavor = ENV['OS_FLAVOR']
     os.image = ENV['OS_IMAGE']
     #os.networks = [ENV['OS_NETWORK']]
     os.networks = [
        {
          id: '2733e36c-7f85-44dd-8423-17332cf706a0',
          address: '192.168.10.20'
        }]
   end
  end

  # Install puppet
  config.vm.provision "shell", path: "puppet/scripts/bootstrap.sh"

  config.vm.provision "puppet" do |puppet|
     puppet.hiera_config_path = "puppet/hiera.yaml"
     puppet.working_directory = "/vagrant/puppet"
     puppet.manifests_path = "puppet/manifests"
     puppet.manifest_file  = "base.pp"
     puppet.options = "--verbose --debug"
  end

  config.vm.provision "puppet" do |puppet|
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/vagrant/puppet"
      puppet.manifests_path = "puppet/manifests"
      puppet.manifest_file  = "devstack-control.pp"
      puppet.options = "--verbose --debug"
  end
end
