class drush (
  // By default, use the current HEAD of the recommended branch.
  $git_ref = "6.x"
){

  vcsrepo { "/var/lib/drush":
    ensure => present,
    provider => git,
    source => 'https://github.com/drush-ops/drush.git',
    revision => $git_ref,
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

  file { "/etc/drush/drushrc.php":
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

  package { 'Console_Table':
    ensure   => installed,
    provider => pear,
  }

}
