#
class common::qemu_agent {
  package {'qemu-guest-agent':
    ensure => 'installed',
  }

service {'qemu-guest-agent':
  ensure => 'running',
  enable => true,
  }
}
