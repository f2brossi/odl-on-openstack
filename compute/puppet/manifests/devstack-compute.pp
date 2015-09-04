
$hosts = hiera('hosts')

file { '/home/stack/devstack':
   ensure => 'link',
   target => '/opt/devstack',
}

vcsrepo { '/opt/devstack':
    ensure   => present,
    provider => git,
    user     => 'stack',
    source   => 'https://github.com/openstack-dev/devstack.git',
    # source   => 'https://github.com/flavio-fernandes/devstack.git',
    revision => 'stable/kilo',
    before   => File['/opt/devstack/local.conf'],
}

file { '/opt/devstack/local.conf':
    ensure  => present,
    owner   => 'stack',
    group   => 'stack',
    content => template('/vagrant/puppet/templates/compute.local.conf.erb'),
}
