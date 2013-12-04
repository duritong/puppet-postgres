# setup the common things for postgres
class postgres::base {
  class{'postgres::client':
    manage_shorewall => $postgres::manage_shorewall
  }

  package { 'postgresql-server':
    ensure => present,
  } -> service{'postgresql':
    ensure    => running,
    enable    => true,
    hasstatus => true,
  }

  exec{'service postgresql initdb':
    unless  => 'test -f /var/lib/pgsql/data/postgresql.conf',
    require => Package['postgresql-server'],
    before  => File['/var/lib/pgsql/data/pg_hba.conf',
      '/var/lib/pgsql/data/postgresql.conf'],
  }

  file{
  '/etc/cron.d/pgsql_backup.cron':
    source  => 'puppet:///modules/postgres/backup/pgsql_backup.cron',
    owner   => root,
    group   => 0,
    mode    => '0600';
  '/etc/cron.d/pgsql_vacuum.cron':
    source  => 'puppet:///modules/postgres/maintenance/pgsql_vacuum.cron',
    require => Service['postgresql'],
    owner   => root,
    group   => 0,
    mode    => '0600';
  '/var/lib/pgsql/data/pg_hba.conf':
    source  => [
      "puppet:///modules/site_postgres/${::fqdn}/pg_hba.conf",
      'puppet:///modules/site_postgres/pg_hba.conf',
      "puppet:///modules/postgres/config/pg_hba.conf.${::operatingsystem}",
      'puppet:///modules/postgres/config/pg_hba.conf'
    ],
    require => Package['postgresql-server'],
    notify  => Service['postgresql'],
    owner   => postgres,
    group   => postgres,
    mode    => '0600';
  '/var/lib/pgsql/data/postgresql.conf':
    source  => [
      "puppet:///modules/site_postgres/${::fqdn}/postgresql.conf",
      "puppet:///modules/site_postgres/postgresql.conf.${::operatingsystem}.${::operatingsystemmajrelease}",
      'puppet:///modules/site_postgres/postgresql.conf',
      "puppet:///modules/postgres/config/postgresql.conf.${::operatingsystem}",
      'puppet:///modules/postgres/config/postgresql.conf'
    ],
    require => Package['postgresql-server'],
    notify  => Service['postgresql'],
    owner   => postgres,
    group   => postgres,
    mode    => '0600';
  '/usr/local/bin/readonly_for_pgsql.sh':
    source  => 'puppet:///modules/postgres/maintenance/readonly_for_pgsql.sh',
    require => Package['postgresql-server'],
    owner   => postgres,
    group   => postgres,
    mode    => '0500';
  }
}
