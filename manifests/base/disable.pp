class postgres::base::disable inherits postgres::base {
  Service['postgresql']{
    ensure => stopped,
    enable => false,
  }

  File['/etc/cron.d/pgsql_backup.cron', '/etc/cron.d/pgsql_vacuum.cron']{
    ensure => absent,
  }

}
