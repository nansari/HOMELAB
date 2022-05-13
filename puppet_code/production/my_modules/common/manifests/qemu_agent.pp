# qemu-guest-agent neede only on QEMU VMs not LXC containers
class common::qemu_agent {
  if $facts['dmi']['manufacturer'] == 'QEMU' {
    package {'qemu-guest-agent':
      ensure => 'installed',
      notify => Service['qemu-guest-agent'];
    }

    service {'qemu-guest-agent':
      ensure => 'running',
      enable => true,
    }
  }
}
