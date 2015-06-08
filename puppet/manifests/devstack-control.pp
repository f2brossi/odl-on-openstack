vcsrepo {'/home/stack/devstack':
    ensure   => present,
    provider => git,
    user     => 'stack',
    source   => 'https://github.com/openstack-dev/devstack.git',
    # source   => 'https://github.com/flavio-fernandes/devstack.git',
    # revision => 'odlDevel',
    before   => File['/home/stack/devstack/local.conf'],
}

$hosts = hiera('hosts')

file { '/home/stack/devstack/local.conf':
    ensure  => present,
    owner   => 'stack',
    group   => 'stack',
    content => template('/vagrant/puppet/templates/control.local.conf.erb'),
}
