# == Class: puppet::config
#
# There are three different ways to provide config.
# All three methods use the puppet_config parameter from puppet class.
#
# 1. The default, a hash in hiera.
#    We start with all the common options in common.yaml.
#    If you need to change or add an option, you can specify it in <fqdn>.yaml
#    or <server_role>.yaml.
#    The only time this falls down is where you want to nullify/remove a param
#    defined in common.yaml.  In this case, you need option 2 or 3.
#
# 2. Pass a hash of config options to the puppet module (puppet_config param)
#    This will be pushed through the template into the config file.
#    You can either create a hash in the manifest to pass to the puppet
#    class, or you can create a new hash in hiera with a different name
#    and use the hiera function in the manifest to pass that to the
#    puppet module.
#
# 3. Pass the config in a string.  This will be written to the file verbatim.
#
class puppet::config (
) {

  if ( $::puppet::puppet_config_content != undef ) {
    $puppet_config_content = $::puppet::config_content
  } elsif ( $::puppet::puppet_config != undef ) {
    $puppet_config_erb = ::puppet::puppet_config_hash
    $puppet_config_content = template('puppet/puppet.conf.erb')
  } else {
    $puppet_config_erb = hiera_hash('puppet_config')
    $puppet_config_content = template('puppet/puppet.conf.erb')
  }

  file { '/etc/puppet/puppet.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => $puppet_config_content,
  }

  # We need host file entries for puppet and puppetca

  host { $::puppet::puppet_master_host:
    ensure => present,
    ip     => $::puppet::puppet_master_ip,
  }

  host { $::puppet::puppet_ca_host:
    ensure => present,
    ip     => $::puppet::puppet_ca_ip,
  }

  if ( $::osfamily == 'Debian' ) {
    file { '/etc/default/puppet':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      source => 'puppet:///modules/puppet/_etc_default_puppet',
    }
  }

}
