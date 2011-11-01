define postgres::role(
  $ensure = present, 
  $options = '',
  $password = false
) {
  require ::postgres
  require ::postgres::client
  $real_password = $password ? {
    'trocla' => trocla("postgres_${name}",'pgsql',"username: ${name}"),
    default => $password,
  }
  $passtext = $real_password ? {
    false => "",
    default => "ENCRYPTED PASSWORD '${real_password}'"
  }
  case $ensure {
    present: {
      # The createuser command always prompts for the password.
      exec { "Create $name postgres role":
        command => "/usr/bin/psql -c \"CREATE ROLE ${name} ${options} ${passtext} LOGIN\"",
        user => "postgres",
        unless => "/usr/bin/psql -c '\\du' | grep '^  *$name'",
        require => Service['postgresql'],
      }
    }
    absent:  {
      exec { "Remove ${name} postgres role":
        command => "/usr/bin/dropuser ${name}",
        user => "postgres",
        onlyif => "/usr/bin/psql -c '\\du' | grep '${name}  *|'",
        require => Service['postgresql'],
      }
    }
    default: {
      fail "Invalid 'ensure' value '${ensure}' for postgres::role"
    }
  }
}
