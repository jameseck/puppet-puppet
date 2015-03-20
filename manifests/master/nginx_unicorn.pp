class puppet::master::nginx_unicorn (
) {

  include '::nginx'

  nginx::resource::vhost { 'unicorn_puppetmaster':
    ensure               => present,
    server_name          => ['puppet'],
    listen_port          => $::puppet::master::puppet_master_port,
    ssl                  => true,
    ssl_cert             => "/var/lib/puppet/ssl/certs/${::fqdn}.pem",
    ssl_key              => "/var/lib/puppet/ssl/private_keys/${::fqdn}.pem",
    ssl_port             => $::puppet::master::puppet_master_port,
    ssl_protocols        => 'TLSv1 TLSv1.1 TLSv1.2',
    ssl_ciphers          => 'ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS',
    vhost_cfg_append     => {
      'ssl_crl'                => '/var/lib/puppet/ssl/ca/ca_crl.pem',
      'ssl_client_certificate' => '/var/lib/puppet/ssl/certs/ca.pem',
      'ssl_verify_client'      => 'optional',
      'ssl_verify_depth'       => 1,
    },
    www_root             => '/etc/puppet/rack/public',
    use_default_location => false,
    access_log           => '/var/log/nginx/puppetmaster_access.log',
    error_log            => '/var/log/nginx/puppetmaster_error.log',
    proxy_read_timeout   => '120',
  }
  nginx::resource::location { '/':
    ensure           => present,
    location         => '/',
    vhost            => 'unicorn_puppetmaster',
    proxy            => 'http://unicorn_puppetmaster',
    proxy_set_header => [
      'Host $host',
      'X-Real-IP &remote_addr',
      'X-Forwarded-For $proxy_add_x_forwarded_for',
      'X-Client-Verify $ssl_client_verify',
      'X-Client-DN $ssl_client_s_dn',
      'X-SSL-Issuer $ssl_client_i_dn',
      'X-SSL-Subject $ssl_client_s_dn',
    ],
    ssl              => true,
    ssl_only         => true,
  }
  nginx::resource::upstream { 'unicorn_puppetmaster':
    upstream_fail_timeout => '0',
    members               => [ 'unix:/var/run/puppet/unicorn_puppetmaster.sock' ],
  }

}
