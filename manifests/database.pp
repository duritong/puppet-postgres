define postgres::database(
  $ensure = 'present',
  $owner = false,
  $encoding = 'absent'
){
  require ::postgres
  require ::postgres::client

  $ownerstring = $owner ? {
    false => "",
    default => "-O $owner"
  }

  $encodingstring = $encoding ? {
    'absent' => "",
    default => "-E $encoding"
  }

  case $ensure {
    present: {
      exec { "Create $name postgres db":
        command => "/usr/bin/createdb $ownerstring $encodingstring $name",
        user => "postgres",
        unless => "/usr/bin/psql -l | grep '$name  *|'",
        require => Service['postgresql'],
      }
    }
    absent:  {
      exec { "Remove $name postgres db":
        command => "/usr/bin/dropdb $name",
        onlyif => "/usr/bin/psql -l | grep '$name  *|'",
        user => "postgres",
        require => Service['postgresql'],
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for postgres::database"
    }
  }
}
