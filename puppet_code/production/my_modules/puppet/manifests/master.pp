#
class puppet::master {
  if $facts['hostname'] == 'puppet' {
    # section for only puppet master
    service { 'crond':
        ensure => running;

      'puppetserver':
        ensure  => running,
        enabled => true;
    }

    cron {'update_code_on_puppet_master':
      command => 'cd /etc/puppetlabs/code/environments/homelab && /usr/bin/git pull',
      user    => 'root',
      minute  => '*/15',
    }
  }
}
