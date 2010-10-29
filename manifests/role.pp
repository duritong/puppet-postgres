define postgres::role(
  $ensure = present, 
  $options = '',
  $password = false
) {
  require ::postgres
  require ::postgres::client
  $passtext = $password ? {
    false => "",
    default => "ENCRYPTED PASSWORD '$password'"
  }
  case $ensure {
    present: {
      # The createuser command always prompts for the password.
      exec { "Create $name postgres role":
        command => "/usr/bin/psql -c \"CREATE ROLE $name $options $passtext LOGIN\"",
        user => "postgres",
        unless => "/usr/bin/psql -c '\\du' | grep '^  *$name'",
        require => Service['postgresl'],
      }
    }
    absent:  {
      exec { "Remove $name postgres role":
        command => "/usr/bin/dropeuser $name",
        user => "postgres",
        onlyif => "/usr/bin/psql -c '\\du' | grep '$name  *|'"
        require => Service['postgresl'],
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for postgres::role"
    }
  }
}
