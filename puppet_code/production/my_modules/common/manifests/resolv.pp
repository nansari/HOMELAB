#
class common::resolv (
  $nameservers,
  $search,
){
  file { '/etc/resolv.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('common/resolv/resolv.conf.erb'),
    # common_is_parent_modulename/templates/resolve_dir/resolv.conf.erb_file
  }
}
