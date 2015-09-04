$deps = [
    'mariadb-server',
]

$hosts = hiera('hosts')

file { '/home/stack/devstack':
   ensure => 'link',
   target => '/opt/devstack',
}

package { $deps:
    ensure   => installed,
}

# Warm Maria up, so initial password is non-empty
# Ref: https://gist.github.com/333007187d69fe2fe282
#
service { 'mysql':
    ensure => 'running',
    require => Package[$deps],
    enable => true,
}
file { '/tmp/setup_mysql.txt':
    ensure  => present,
    owner   => 'stack',
    group   => 'stack',
    content => template('/vagrant/puppet/templates/setup_mysql.erb'),
}
exec { 'Warmup mysql':
    command => '/usr/bin/mysql --user=root --password="" mysql < /tmp/setup_mysql.txt',
    user    => 'stack',
    onlyif  => ['/usr/bin/test -f /usr/bin/mysql'],
    require => [File['/tmp/setup_mysql.txt'], Service['mysql']],
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
    content => template('/vagrant/puppet/templates/control.local.conf.erb'),
}

