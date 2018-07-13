class slave {

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

  file { '/etc/mysql/mysql.conf.d/slave.cnf':
    content => template('slave/slave.cnf.erb'),
    owner   => root,
    group   => root,
    mode    => 644,
    notify  => Service['mysql'],
  }
}
