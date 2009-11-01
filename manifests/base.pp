class postgres::base {
    include postgres::client

    package { 'postgresql-server':
        ensure => present,
    }

    service{'postgresql':
        enable => true,
        ensure => running,
        hasstatus => true,
        require => Package[postgresql-server],
    }

    # wen want to be sure that this exists
    file{'/var/lib/pgsql/backups':
        ensure => directory,
        require => Package['postgresql-server'],
        owner => postgres, group => postgres, mode => 0700;
    }

    file{'/etc/cron.d/pgsql_backup.cron':
        source => "puppet://$server/modules/postgres/backup/pgsql_backup.cron",
        require => File['/var/lib/pgsql/backups'],
        owner => root, group => 0, mode => 0600;
    }
    file{'/etc/cron.d/pgsql_vacuum.cron':
        source => "puppet://$server/modules/postgres/maintenance/pgsql_vacuum.cron",
        owner => root, group => 0, mode => 0600;
    }

    file{'/var/lib/pgsql/data/pg_hba.conf':
            source => [
                "puppet://$server/files/postgres/${fqdn}/pg_hba.conf",
                "puppet://$server/files/postgres/pg_hba.conf",
                "puppet://$server/modules/postgres/config/pg_hba.conf.${operatingsystem}",
                "puppet://$server/modules/postgres/config/pg_hba.conf"
            ],
            ensure => file,
            require => Package[postgresql-server],
            notify => Service[postgresql],
            owner => postgres, group => postgres, mode => 0600;
    }
    file{'/var/lib/pgsql/data/postgresql.conf':
            source => [
                "puppet://$server/files/postgres/${fqdn}/postgresql.conf",
                "puppet://$server/files/postgres/postgresql.conf",
                "puppet://$server/modules/postgres/config/postgresql.conf.${operatingsystem}",
                "puppet://$server/modules/postgres/config/postgresql.conf"
            ],
            ensure => file,
            require => Package[postgresql-server],
            notify => Service[postgresql],
            owner => postgres, group => postgres, mode => 0600;
    }
}
