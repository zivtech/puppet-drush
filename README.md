# Puppet Drush

Yet another module for installing drush.  This module relies on the excellent
[node-php](https://forge.puppetlabs.com/nodes/php) module and provides a resource
for placing configuration files in a recursively required conf.d directory.  This
module installs drush from git and installs drush's sole dependency
([Console_Table](http://pear.php.net/package/Console_Table/)) using PEAR.


## Installation

```` shell
puppet module install zivtech-drush
````

## Useage

### Simple
The simplest way is to just include the drush module:

```` puppet
include drush
````

### Advanced

```` puppet
class { 'drush':
  # Here any git ref from the drush repo can be used
  git_ref => 'master',
}

drush::config { 'dump-dir':
  value => '/path/to/dumpdir',
}

drush::config { 'alias-path':
  value  => 'array(\'/path/to/aliases\', \'/path2/to/more/aliases\')'
  string => false,
}
````
