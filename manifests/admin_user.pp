# create your password with
# ruby -r'digest/md5' -e 'puts "md5" + Digest::MD5.hexdigest(ARGV[1] + ARGV[0])' USERNAME PASSWORD
define postgres::admin_user(
  $ensure = present,
  $password
){
  postgres::role{$name:
    password => $password ? {
      'trocla' => trocla("pgsql_admin-user_${name}",'pgsql',"username: ${name}"),
      default => $password
    },
    options => "SUPERUSER CREATEDB CREATEROLE",
    ensure => $ensure;
  }
}
