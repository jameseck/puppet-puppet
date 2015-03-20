# ==Class: puppet::master::puppetdb
#
#
class puppet::master::puppetdb (
  $soft_write_failure = true,
) {

  if ( $::puppet::master::puppetdb_host != undef ) {

    package { 'puppetdb-terminus':
      ensure => installed,
    }

    # If the puppetdb_ip is also set, add a hosts file entry
    if ( $::puppet::master::puppetdb_ip != undef ) {
      validate_ip($::puppet::master::puppetdb_ip)
      host { $::puppet::master::puppetdb_host:
        ip => $::puppet::master::puppetdb_ip,
      }
    }

    # Construct variables for the puppetdb conf template
    $erb_puppetdb_host = $::puppet::master::puppetdb_host
    $erb_puppetdb_port = $::puppet::master::puppetdb_port
    $erb_puppetdb_soft_write_failure = $soft_write_failure

    file { '/etc/puppet/puppetdb.conf':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template('puppet/master/puppetdb.conf.erb'),
    }

    file { '/etc/puppet/routes.yaml':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/puppet/master/routes.yaml',
    }

  }

}
