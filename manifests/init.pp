# == Class: puppet
# Installs and configures puppet.
# The config is derived from hiera, a hash called puppet_config.
#
# === Parameters:
#
# [*package_ensure*]
#   The ensure parameter for the puppet package. Default 'installed'
# [*service_ensure*]
#   The ensure parameter for the puppet service. Default 'running'.
# [*service_enable*]
#   The enable parameter for the puppet service. Default true.
# [*puppet_master_host*]
#   The hostname for the puppet master. Default 'puppet'.
# [*puppet_master_ip*]
#   The IP/VIP for the puppet master. Default defined in hiera.
# [*puppet_ca_host*]
#   The hostname for the puppet ca server.  Default 'puppet-ca'.
# [*puppet_ca_ip*]
#   The IP for the puppet ca server. Default defined in hiera.
# [*puppet_config_hash*]
#   A hash of config options, see config.pp for more details.
# [*puppet_config_content*]
#   A string containing the config to be pushed to puppet.conf
#
class puppet (
  $package_ensure          = 'installed',
  $service_ensure          = 'running',
  $service_enable          = true,
  $puppet_master_host      = 'puppet',
  $puppet_master_ip        = undef,
  $puppet_ca_host          = 'puppet-ca',
  $puppet_ca_ip            = undef,
  $puppet_config_hash      = undef,
  $puppet_config_content   = undef,
) {

  anchor { 'puppet::start': }->
  class { 'puppet::install':  } ->
  class { 'puppet::cronjobs': } ->
  class { 'puppet::config':   } ~>
  class { 'puppet::service':  }
  anchor { 'puppet::end': }

}
