class puppet::master::tagmail (
  $config_hash = undef,
) {

  if ( $config_hash != undef ) {
    file { '/etc/puppet/tagmail.conf':
      ensure  => file,
      owner   => 'puppet',
      group   => 'puppet',
      mode    => '0644',
      content => template('puppet/master/tagmail.conf.erb'),
    }
  }

}
