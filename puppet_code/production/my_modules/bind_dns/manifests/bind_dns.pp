# 
class bind_dns::bind_dns (
  # need to be supplied via hiera for DNS server node.yaml
  $dns_vm_ip = undef
){
  if ( $dns_vm_ip != undef) {
  $bind_packages = [ 'bind', 'bind-chroot', 'bind-utils', ]
    package { $bind_packages:
    ensure => installed,
    }

    file {
      '/etc/named.conf':
        mode   => '0640',
        owner  => 'root',
        group  => 'named',
        notify => Service['named'],
        source => 'puppet://modules/modules/bind_dns/etc/named.conf';

      '/var/named/10.168.192.in-addr.arpa':
        mode   => '0644',
        owner  => 'root',
        group  => 'root',
        notify => Service['named'],
        source => 'puppet://modules/modules/bind_dns/var/named/10.168.192.in-addr.arpa';

      '/etc/named.conf':
        mode   => '0644',
        owner  => 'root',
        group  => 'root',
        notify => Service['named'],
        source => 'puppet://modules/modules/bind_dns/var/named/family.net.zone';
      }

    service { 'named':
      ensure => running,
      enable => true;
      }

    file_line { 'nameserver_in_resolv_conf':
      ensure            => present,
      path              => '/etc/resolv.conf',
      line              => "nameserver ${dns_vm_ip}",
      match             => '^nameserver ',
      match_for_absence => true,
    }
  }
}
