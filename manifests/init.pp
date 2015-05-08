class drush (
  # By default, use the current HEAD of the recommended branch.
  $git_ref = "6.x",
  $configs = {}
){

  ensure_resource('package', 'git')

  vcsrepo { "/var/lib/drush":
    ensure => present,
    provider => git,
    source => 'https://github.com/drush-ops/drush.git',
    revision => $git_ref,
    require  => Package['git'],
  }

  file { "/usr/local/bin/drush":
    require => [Vcsrepo["/var/lib/drush"]],
    ensure => link,
    target => "/var/lib/drush/drush",
    owner => 'root',
    group => 'root',
    mode => 755,
  }

  file { "/etc/drush":
    ensure => directory,
    owner => root,
    group => root,
    mode => 755,
  }->

  file { '/etc/drush/drushrc.php':
    source => 'puppet:///modules/drush/drushrc.php',
    owner => root,
    group => root,
    mode => 755,
  }->

  file { "/etc/drush/conf.d":
    ensure => directory,
    owner => root,
    group => root,
    mode => 755,
  }

  file { "/usr/share/drush":
    ensure => directory,
    owner => root,
    group => root,
    mode => 755,
  }->

  file {  "/usr/share/drush/commands":
    ensure => directory,
    owner => root,
    group => root,
    mode => 755,
  }


  require php::composer

  # Newer versions of drush require dependencies
  exec { 'drush-composer-install':
    command     => "/usr/bin/php /usr/local/bin/composer install --no-dev",
    cwd         => "/var/lib/drush",
    creates     => "/var/lib/drush/vendor",
    environment => "HOME=/root/",
    require     => [
      Class['php::cli'],
      Class['php::composer'],
      Vcsrepo['/var/lib/drush'],
    ],
    subscribe   => Vcsrepo["/var/lib/drush"],
  }



  create_resources(drush::config, $configs)

  include php
  include php::cli
  include php::pear

  package { 'Console_Table':
    ensure   => installed,
    provider => pear,
    require  => Class['php::pear'],
  }

}
