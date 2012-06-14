class postgres::client(
  $manage_shorewall = false
) {
  package{'postgresql': 
    ensure => installed,
  }
  if $manage_shorewall {
    include shorewall::rules::out::postgres
  }
}
