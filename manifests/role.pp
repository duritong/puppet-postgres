# manages a postgres role
define postgres::role(
  $ensure   = present,
  $options  = '',
  $password = false
) {
  require ::postgres
  require ::postgres::client
  $real_password = $password ? {
    'trocla' => trocla("postgres_${name}",'pgsql',"username: ${name}"),
    default  => $password,
  }
  $passtext = $real_password ? {
    false   => '',
    default => "ENCRYPTED PASSWORD '${real_password}'"
  }
  exec{"Manage ${name} postgres role":
    user    => 'postgres',
    require => Service['postgresql'],
  }
  case $ensure {
    present: {
      # The createuser command always prompts for the password.
      Exec["Manage ${name} postgres role"]{
        command => "/usr/bin/psql -c \
\"CREATE ROLE \\\"${name}\\\" ${options} ${passtext} LOGIN\"",
        unless  => "/usr/bin/psql -c '\\du' | grep '^  *${name}'",
      }
    }
    absent:  {
      Exec["Manage ${name} postgres role"]{
        command => "/usr/bin/dropuser ${name}",
        onlyif  => "/usr/bin/psql -c '\\du' | grep '${name}  *|'",
      }
    }
    default: {
      fail "Invalid 'ensure' value '${ensure}' for postgres::role"
    }
  }
}
