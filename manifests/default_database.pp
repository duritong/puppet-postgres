# create a database with an owner and optionally create that owner
# encrypt password like
# ruby -r'digest/md5' -e 'puts "md5" + Digest::MD5.hexdigest(ARGV[1] + ARGV[0])' USERNAME PASSWORD
define postgres::default_database(
  $username = 'absent',
  $password,
  $ensure = 'present'
) {
  case $username {
    'absent': { $owner = $name }
    default: { $owner = $username }
  }
  case $password {
    'absent': { info("we don't create the user for database: ${name}") }
    default: {
      postgres::role{
        $owner:
          password => $password,
          ensure => $ensure,
          before => Postgres::Database[$name];
      }
    }
  }
  postgres::database{
    $name:
      ensure => $ensure,
      owner => $owner;
  }
}
