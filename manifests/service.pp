# == Class: puppet::service
#
#
class puppet::service (
) {

  service { 'puppet':
    ensure => $::puppet::service_ensure,
    enable => $::puppet::service_enable,
  }

}
