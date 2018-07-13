class master {

  $rootuser = 'root'
  $rootpass = 'root'

  # execute 'apt-get update'
  exec { 'apt-update':                    # exec resource named 'apt-update'
    command => '/usr/bin/apt-get update'  # command this resource will run
  }

  package { 'mysql-server':
    require => Exec['apt-update'],
    ensure => installed,
  }

  service { 'mysql':
    ensure => running,
  }

  file { '/etc/mysql/mysql.conf.d/master.cnf':
    content => template('master/master.cnf.erb'),
    owner   => root,
    group   => root,
    mode    => 644,
    notify  => Service['mysql'],
  }

  file { 'master-sql':
    path    => '/tmp/master.sql',
    ensure  => file,
    source  => 'puppet:///modules/master/master.sql',
  }

  exec { 'run-sql':
    command => '/usr/bin/mysql < /tmp/master.sql'
    notify  => Service['mysql'],
  }

}
