#
# postgres module
#
# Copyright 2008, Puzzle ITC
# Marcel Härry haerry+puppet(at)puzzle.ch
# Simon Josi josi+puppet(at)puzzle.ch
#
# This program is free software; you can redistribute 
# it and/or modify it under the terms of the GNU 
# General Public License version 3 as published by 
# the Free Software Foundation.
#
# Module is base on the one from the immerda project
# https://git.puppet.immerda.ch/module-pgsql
# as well on Luke Kanies 
# http://github.com/lak/puppet-postgres/tree/master
#

class postgres {
    case $operatingsystem {
        default: { include postgres::base }
    }
}

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
        source => "puppet://$server/postgres/backup/pgsql_backup.cron",
        require => File['/var/lib/pgsql/backups'],
        owner => root, group => 0, mode => 0600;
    }
    file{'/etc/cron.d/pgsql_vacuum.cron':
        source => "puppet://$server/postgres/maintenance/pgsql_vacuum.cron",
        owner => root, group => 0, mode => 0600;
    }

    if $use_munin {
        include postgres::munin
    }
    file{'/var/lib/pgsql/data/pg_hba.conf':
            source => [
                "puppet://$server/files/postgres/${fqdn}/pg_hba.conf",
                "puppet://$server/files/postgres/pg_hba.conf",
                "puppet://$server/postgres/config/pg_hba.conf.${operatingsystem}",
                "puppet://$server/postgres/config/pg_hba.conf"
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
                "puppet://$server/postgres/config/postgresql.conf.${operatingsystem}",
                "puppet://$server/postgres/config/postgresql.conf"
            ],
            ensure => file,
            require => Package[postgresql-server],
            notify => Service[postgresql],
            owner => postgres, group => postgres, mode => 0600;
    }
}
