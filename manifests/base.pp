class postgres::base {
  package { 'postgresql-server':
    ensure => present,
  }

  service{'postgresql':
    enable => true,
    ensure => running,
    hasstatus => true,
    require => Package['postgresql-server'],
  }

  exec{'service postgresql initdb':
      unless => 'test -f /var/lib/pgsql/data/postgresql.conf',
      require => Package['postgresql-server'],
      before => File['/var/lib/pgsql/data/pg_hba.conf','/var/lib/pgsql/data/postgresql.conf'],
  }

  # wen want to be sure that this exists
  file{'/var/lib/pgsql/backups':
    ensure => directory,
    require => Package['postgresql-server'],
    owner => postgres, group => postgres, mode => 0700;
  }

  file{'/etc/cron.d/pgsql_backup.cron':
    source => "puppet:///modules/postgres/backup/pgsql_backup.cron",
    require => File['/var/lib/pgsql/backups'],
    owner => root, group => 0, mode => 0600;
  }
  file{'/etc/cron.d/pgsql_vacuum.cron':
    source => "puppet:///modules/postgres/maintenance/pgsql_vacuum.cron",
    owner => root, group => 0, mode => 0600;
  }

  file{'/var/lib/pgsql/data/pg_hba.conf':
      source => [
        "puppet:///modules/site-postgres/${::fqdn}/pg_hba.conf",
        "puppet:///modules/site-postgres/pg_hba.conf",
        "puppet:///modules/postgres/config/pg_hba.conf.${::operatingsystem}",
        "puppet:///modules/postgres/config/pg_hba.conf"
      ],
      ensure => file,
      require => Package['postgresql-server'],
      notify => Service['postgresql'],
      owner => postgres, group => postgres, mode => 0600;
  }
  file{'/var/lib/pgsql/data/postgresql.conf':
      source => [
        "puppet:///modules/site-postgres/${::fqdn}/postgresql.conf",
        "puppet:///modules/site-postgres/postgresql.conf",
        "puppet:///modules/postgres/config/postgresql.conf.${::operatingsystem}",
        "puppet:///modules/postgres/config/postgresql.conf"
      ],
      ensure => file,
      require => Package['postgresql-server'],
      notify => Service['postgresql'],
      owner => postgres, group => postgres, mode => 0600;
  }
}
