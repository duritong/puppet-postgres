class postgres::client {
  package{'postgresql': 
    ensure => installed,
  }
  if hiera('use_shorewall',false) {
    include shorewall::rules::out::postgres
  }
}
