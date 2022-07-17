# https://forge.puppet.com/modules/puppetlabs/postgresql
class postgres (
) {
  if ( $facts['hostname'] == 'postgres' ) {
class { 'postgresql::server':
  postgres_password          => 'demopass',
  package_ensure => 'present',
  service_ensure => 'running',
  service_enable => true,
  service_manage => true,
 
}
  
  postgresql::server::db { 'demopostgres':
    user     => 'demouser',
    password => postgresql::postgresql_password('demouser', 'demopass'),
  }
}
}
