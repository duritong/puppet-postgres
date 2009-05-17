class postgres::client {
   include ruby::postgres
   package{'postgresql': 
      ensure => installed,
   }
}
