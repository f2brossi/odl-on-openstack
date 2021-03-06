$deps = [
    'mariadb-server',
]
file { '/etc/yum.repos.d/mariadb.repo':
	ensure => present,
	owner => 'root',
	group => 'root',
	content => template('/vagrant/puppet/templates/mariadb.repo.erb')
}


$hosts = hiera('hosts')

file { '/home/centos/devstack':
   ensure => 'link',
   target => '/opt/devstack',
}

package { $deps:
    ensure   => installed,
}

# Warm Maria up, so initial password is non-empty
# Ref: https://gist.github.com/333007187d69fe2fe282
#
service { 'mariadb.service':
    ensure => 'running',
    require => Package[$deps],
}
file { '/tmp/setup_mysql.txt':
    ensure  => present,
    owner   => 'centos',
    group   => 'centos',
    content => template('/vagrant/puppet/templates/setup_mysql.erb'),
}
exec { 'Warmup mysql':
    command => '/usr/bin/mysql --user=root --password="" mysql < /tmp/setup_mysql.txt',
    user    => 'centos',
    onlyif  => ['/usr/bin/test -f /usr/bin/mysql'],
    require => [File['/tmp/setup_mysql.txt'], Service['mariadb.service']],
}

vcsrepo { '/opt/devstack':
    ensure   => present,
    provider => git,
    user     => 'centos',
    source   => 'https://github.com/openstack-dev/devstack.git',
     #source   => 'https://github.com/flavio-fernandes/devstack.git',
    revision => 'stable/kilo',
    before   => File['/opt/devstack/local.conf'],
}

file { '/opt/devstack/local.conf':
    ensure  => present,
    owner   => 'centos',
    group   => 'centos',
    content => template('/vagrant/puppet/templates/control.local.conf.erb'),
}

