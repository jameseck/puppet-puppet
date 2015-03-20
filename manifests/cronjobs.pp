# == Class: puppet::cronjobs
#
#
class puppet::cronjobs (
) {

  # Push out a cron job to restart puppet daily, since it seems to be
  # a memory hog over time.
  $cron_minute_erb = fqdn_rand(60)

  case $::osfamily {
    'RedHat': { $service_path_erb = '/sbin/service'     }
    'Debian': { $service_path_erb = '/usr/sbin/service' }
    default: { fail("osfamily ${::osfamily} is not supported.") }
  }

  file { '/etc/cron.d/puppet_restart':
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('puppet/puppet_restart.erb'),
  }

  # Push out a cron.d file to execute a simple find and delete of any
  # puppetlock file that's old and might be stopping the Puppet daemon
  # from working.
  file { '/etc/cron.d/puppet_client_lock_cleanup':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0640',
    source => 'puppet:///modules/puppet/puppet_client_lock_cleanup.cron',
  }

}
