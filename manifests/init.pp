class drush (
  $drush_git_tag = '8.4.6',
  $launcher_git_tag = '0.9.0',
  $configs = {}
){


  wget::fetch { 'Download Drush Launcher':
    source      => 'https://github.com/drush-ops/drush-launcher/releases/download/${launcher_git_tag}/drush.phar',
    destination => '/tmp/drush-launcher.phar',
    timeout     => 0,
    verbose     => false,
  }

  file { '/usr/local/bin/drush':
    source => '/tmp/drush-launcher.phar',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/tmp/drush-launcher.phar':
    ensure => absent,
  }

  wget::fetch { 'Download Drush 8':
    source      => 'https://github.com/drush-ops/drush/releases/download/${drush_git_tag}/drush.phar',
    destination => '/tmp/drush8.phar',
    timeout     => 0,
    verbose     => false,
  }

  file { '/usr/local/bin/drush8':
    source => '/tmp/drush8.phar',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { '/tmp/drush8.phar':
    ensure => absent,
  }

  file_line { 'drush_fallback_env':
    ensure  => present,
    line    => 'DRUSH_LAUNCHER_FALLBACK=//drush',
    path    => '/etc/environment',
  }

  file { '/etc/drush':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }->

  file { '/etc/drush/drushrc.php':
    source => 'puppet:///modules/drush/drushrc.php',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }->

  file { '/etc/drush/conf.d':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/usr/share/drush':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }->

  file {  '/usr/share/drush/commands':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  create_resources(drush::config, $configs)

  include php
  include php::cli
  include php::pear

  package { 'Console_Table':
    ensure   => 'installed',
    provider => 'pear',
    require  => Class['php::pear'],
  }

}
