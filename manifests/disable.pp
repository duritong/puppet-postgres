class postgres::disable {
  case $operatingsystem {
    centos: { include postgres::centos::disable }
    default: { include postgres::base::disable }
  }
}
