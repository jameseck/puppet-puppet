# ==Class: puppet::master
#
# Describes a puppet master (RHEL only for now)
#
class puppet::master (
  $apache_or_nginx           = 'apache',
  $puppet_master_port        = '8140',
  $puppetdb_host             = undef,
  $puppetdb_ip               = undef,
  $puppetdb_port             = 8081,
) {

  if ( $apache_or_nginx != 'apache' and $apache_or_nginx != 'nginx' and $apache_or_nginx != 'nginx_unicorn' ) {
    fail('You must specify apache or nginx.')
  }

  class { 'puppet::master::cronjobs': }

  anchor { 'puppet::master::begin':             } ->
  class { 'puppet::master::install':            } ->
  class { 'puppet::master::config':             } ~>
  class { 'puppet::master::tagmail':            } ->
  class { 'puppet::master::puppetdb':           } ->
  class { 'puppet::master::hiera':              } ->
  class { "puppet::master::${apache_or_nginx}": } ->
  class { 'puppet::master::service':            } ->
  anchor { 'puppet::master::end': }

  Class['puppet::master::install']  ~> Class['puppet::master::service']
  Class['puppet::master::config']   ~> Class['puppet::master::service']
  Class['puppet::master::tagmail']  ~> Class['puppet::master::service']
  Class['puppet::master::puppetdb'] ~> Class['puppet::master::service']
  Class['puppet::master::hiera']    ~> Class['puppet::master::service']
  Class["puppet::master::${apache_or_nginx}"] ~> Class['puppet::master::service']

}
