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
  case $::operatingsystem {
    default: { include postgres::base }
  }
  if hiera('use_munin',false) {
    include postgres::munin
  }
  if hiera('use_shorewall',false) {
    include shorewall::rules::postgres
  }
}
