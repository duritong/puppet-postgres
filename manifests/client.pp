class postgres::client {
   package{ ['postgresql','ruby-postgres']: 
      ensure => installed,
   }
}
