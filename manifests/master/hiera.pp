# ==Class: puppet::master::hiera
#
#
class puppet::master::hiera (
) {

  file { '/etc/puppet/hiera.yaml':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('puppet/master/hiera.yaml.erb'),
  }

  file { '/etc/puppet/hiera_keys':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0700',
  }

  file { '/etc/puppet/hiera_keys/public_key.pkcs7.pem':
    ensure => file,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0400',
    source => 'puppet:///modules/puppet/master/hiera/public_key.pkcs7.pem',
  }

  # The private key needs to be deployed manually - do NOT store it in the git repo

}
