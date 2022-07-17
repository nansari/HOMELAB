# https://forge.puppet.com/modules/puppetlabs/postgresql
class postgres {
  include postgresql::server
  
  postgresql::server::db { 'demopostgres':
    user     => 'demouser',
    password => postgresql::postgresql_password('demouser', 'demopass'),
  }
}
