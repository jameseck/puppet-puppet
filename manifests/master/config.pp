# ==Class: puppet::master::config
#
#
class puppet::master::config (
) {

  file { '/etc/puppet':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0700',
  }

  file { '/etc/puppet/environments':
    ensure => directory,
  }

  file { '/etc/puppet/rack':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0755',
  }

  file { '/etc/puppet/rack/public':
    ensure => directory,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0755',
  }

  file { '/etc/puppet/config.ru':
    ensure => file,
    owner  => 'puppet',
    group  => 'puppet',
    mode   => '0644',
    source => 'puppet:///modules/puppet/master/config.ru',
  }

  file { '/etc/puppet/auth.conf':
    ensure  => file,
    owner   => 'puppet',
    group   => 'puppet',
    mode    => '0644',
    content => template('puppet/master/auth.conf.erb'),
  }

}
