# ==Class: puppet::master::cronjobs
#
#
class puppet::master::cronjobs (
) {

  #Push out a cron to cleanup old reports from Puppet Masters.
  file { '/etc/cron.d/clean-puppetmaster-reports':
    ensure => file,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/puppet/master/clean-puppetmaster-reports.cron',
  }

}
