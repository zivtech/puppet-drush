define drush::config (
  $drush_conf_dir = '/etc/drush/conf.d',
  $conf_variable = 'options',
  $file = false,
  $ensure = 'present',
  $key = false,
  $string = true,
  $value
) {

  if (!$file) {
    $file_name = $name
  }
  else {
    $file_name = $file
  }

  if (!$key) {
    $key_name = $name
  }
  else {
    $key_name = $key
  }

  if ($string) {
    $printable_value = "'${value}'"
  }
  else {
    $printable_value = $value
  }

  $target_file = "${drush_conf_dir}/${file_name}.php"

  ensure_resource('concat', $target_file, { ensure => $ensure })

  ensure_resource('concat::fragment', "drush-config-${file}-php-tag", { 
    ensure  => $ensure,
    content => "<?php\n",
    target  => $target_file,
    order   => '00',
  })

  concat::fragment { "drush-config-${name}":
    target  => $target_file,
    content => "$${conf_variable}['${key_name}'] = ${printable_value};\n",
    order   => '01',
  }

}