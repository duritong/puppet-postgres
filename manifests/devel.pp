class postgres::devel {
  package { "postgresql-devel.${::architecture}":
    ensure => present,
  }
}
