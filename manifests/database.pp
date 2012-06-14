define postgres::database(
  $ensure = 'present',
  $owner = false,
  $encoding = 'absent'
){
  $ownerstring = $owner ? {
    false => "",
    default => "-O ${owner}"
  }

  $encodingstring = $encoding ? {
    'absent' => "",
    default => "-E ${encoding}"
  }

  case $ensure {
    present: {
      exec { "create_${name}_postgres_db":
        command => "/usr/bin/createdb ${ownerstring} ${encodingstring} ${name}",
        user => "postgres",
        unless => "/usr/bin/psql -l | grep '${name}  *|'",
        require => Service['postgresql'],
      }
    }
    absent:  {
      exec { "remove_${name}_postgres_db":
        command => "/usr/bin/dropdb ${name}",
        onlyif => "/usr/bin/psql -l | grep '${name}  *|'",
        user => "postgres",
        require => Service['postgresql'],
      }
    }
    default: {
      fail("Invalid 'ensure' value '${ensure}' for postgres::database")
    }
  }
}
