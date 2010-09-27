define postgres::database(
  $ensure = 'present',
  $owner = false
){
  require ::postgres
  require ::postgres::client
  $ownerstring = $owner ? {
    false => "",
    default => "-O $owner"
  }

  case $ensure {
    present: {
      exec { "Create $name postgres db":
        command => "/usr/bin/createdb $ownerstring $name",
        user => "postgres",
        unless => "/usr/bin/psql -l | grep '$name  *|'"
      }
    }
    absent:  {
      exec { "Remove $name postgres db":
        command => "/usr/bin/dropdb $name",
        onlyif => "/usr/bin/psql -l | grep '$name  *|'",
        user => "postgres"
      }
    }
    default: {
      fail "Invalid 'ensure' value '$ensure' for postgres::database"
    }
  }
}
