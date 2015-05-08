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

  $concat_resource_options = {
    ensure  => $ensure,
    require => File['/etc/drush/drushrc.php'],
  }
  ensure_resource('concat', $target_file, $concat_resource_options)

  ensure_resource('concat::fragment', "drush-config-${file_name}-php-tag", {
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
