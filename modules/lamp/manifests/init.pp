class lamp {

  $rdsname = 'sretestdb.olxtest.com'
  $rdsdb = 'webserver'
  $rdsuser = 'webserveruser'
  $rdspass = 'w3b$erv3r1243'
  
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
  package { ['libapache2-mod-php','php','php-mysql','libapache2-modsecurity']:
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

  # ensure info.php file exists
  file { '/var/www/html/info.php':
    ensure => file,
    content => '<?php  phpinfo(); ?>',    # phpinfo code
    require => Package['apache2'],        # require 'apache2' package before creating
  }

  file { '/var/www/html/index.html':
    content => template('lamp/index.html.erb'),
    owner   => www-data,
    group   => www-data,
    mode    => 644,
}

}
