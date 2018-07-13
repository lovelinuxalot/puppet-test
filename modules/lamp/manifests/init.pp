class lamp {

  $rdsname = '10.100.40.118'
  $rdsdb = 'webserver'
  $rdsuser = 'webserveruser'
  $rdspass = 'weBs3rv3rU$er'

  # execute 'apt-get update'
  exec { 'apt-update':                    # exec resource named 'apt-update'
    command => '/usr/bin/apt-get update'  # command this resource will run
  }

  # install apache2 package
  package { 'apache2':
    require => Exec['apt-update'],        # require 'apt-update' before installing
    ensure => installed,
  }

  # install all packages
  package { ['libapache2-mod-php','php','php-mysql','php-mcrypt','libapache2-modsecurity']:
    require => Package['apache2'],        # require 'apt-update' before installing
    ensure => installed,
  }

  # ensure apache2 service is running
  service { 'apache2':
    ensure => running,
  }

  file { 'vhost-file':
    path    => '/etc/apache2/sites-enabled/000-default.conf',
    ensure  => file,
    source  => 'puppet:///modules/lamp/default.conf',
    notify  => Service['apache2'],
    require => Package['apache2'],
  }

  file { 'config-file':
    path    => '/etc/apache2/apache2.conf',
    ensure  => file,
    source  => 'puppet:///modules/lamp/apache2.conf',
    notify  => Service['apache2'],
    require => Package['apache2'],
  }

  file { '/var/www/html/dbcheck.php':
    content => template('lamp/dbcheck.php.erb'),
    owner   => www-data,
    group   => www-data,
    mode    => 644,
  }

  file { '/var/www/html/index.php':
    content => template('lamp/index.php.erb'),
    owner   => www-data,
    group   => www-data,
    mode    => 644,
}

  exec { 'remove index.html':
    command => '/bin/rm /var/www/html/index.html'
  }

}
