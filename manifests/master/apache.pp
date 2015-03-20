# ==Class: puppet::master::apache
#
#
class puppet::master::apache (
) {

  class { '::apache':
    default_mods        => false,
    default_confd_files => false,
  }
  apache::listen { '8140': }

#  class { 'apache::mod::ssl':
#    ssl_compression => false,
#    ssl_options     => [ 'StdEnvVars' ],
#  }

  apache::vhost { 'puppetmaster':
    port              => '8140',
    docroot           => '/etc/puppet/rack/public',
    rack_base_uris    => [ '/' ],
    directories       => [
    {            path => '/etc/puppet/rack',
      'options'       => 'None',
      'AllowOverride' => 'None',
      'Order'         => 'allow,deny',
      'allow'         => 'from all',
    } ],
    ssl               => true,
    ssl_protocol      => '-ALL +SSLv3 +TLSv1',
    ssl_cipher        => 'ALL:!ADH:RC4+RSA:+HIGH:+MEDIUM:-LOW:-SSLv2:-EXP',
    ssl_cert          => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    ssl_key           => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
    ssl_chain         => '/var/lib/puppet/ssl/ca/ca_crt.pem',
    ssl_ca            => '/var/lib/puppet/ssl/ca/ca_crt.pem',
    ssl_crl           => '/var/lib/puppet/ssl/ca/ca_crl.pem',
    ssl_verify_client => 'optional',
    ssl_verify_depth  => 1,
    ssl_options       => [ '+StdEnvVars' ],
  }

  class { 'apache::mod::passenger':
    passenger_high_performance   => 'On',
    passenger_pool_idle_time     => '300',
    passenger_max_requests       => undef,
    passenger_stat_throttle_rate => '120',
    rack_autodetect              => 'Off',
    rails_autodetect             => 'Off',
    passenger_root               => '/usr/share/rubygems/gems/passenger-3.0.21',
    passenger_ruby               => '/usr/bin/ruby',
    passenger_max_pool_size      => '8',
    passenger_use_global_queue   => 'On',
  }

}
