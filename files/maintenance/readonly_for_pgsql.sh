#!/bin/sh

if [ -z $1 ] || [ -z $2 ]; then
  echo "Usage $0 database username"
  exit 1
fi

tables=$(psql $1 -A -t -c "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';")

for table in $tables
do
echo "Granting select to readonly on $table"
psql $1 -c "GRANT SELECT ON $table to $2;"
done
