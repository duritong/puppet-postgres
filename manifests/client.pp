class postgres::client {
  include ruby::postgres
  package{'postgresql': 
    ensure => installed,
  }
  if $use_shorewall {
    include shorewall::rules::out::postgres
  }
}
