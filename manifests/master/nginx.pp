class puppet::master::nginx (
) {

  include '::nginx'

  nginx::resource::vhost { 'puppet':
    ensure               => present,
    server_name          => ['puppet'],
    listen_port          => 8140,
    ssl                  => true,
    ssl_cert             => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    ssl_key              => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
    ssl_port             => 8140,
    vhost_cfg_append     => {
      'ssl_crl'                => '/var/lib/puppet/ssl/ca/ca_crl.pem',
      'ssl_client_certificate' => '/var/lib/puppet/ssl/certs/ca.pem',
      'ssl_verify_client'      => 'optional',
      'ssl_verify_depth'       => 1,
    },
    www_root             => '/etc/puppet/rack/public',
    use_default_location => false,
    access_log           => '/var/log/nginx/puppet_access.log',
    error_log            => '/var/log/nginx/puppet_error.log',
  }

}
