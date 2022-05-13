#
class puppet::agents {
  # on eavy system 
  $fqdn_agent_name = $facts['fqdn']
  service { 'puppet':
      ensure  => 'running',
      enabled => true;
    }
  package { 'puppet-agent':
    ensure => 'installed',
    notify => Service['puppet'];
  }

  if $facts['hostname'] != 'puppet' {
    # except puppet master
    file { '/etc/puppetlabs/puppet/puppet.conf':
      notify  => Service['puppet'],
      require => Package['puppet-agent'],
      content => template('puppet/agents/puppet.conf.erb');
    }
  }
}
