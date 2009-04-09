class postgres::client {
   package{ ['postgres','ruby-postgres']: 
      ensure => installed,
   }
}
