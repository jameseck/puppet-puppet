# ==Class: puppet::master::service
#
# Ensures that the puppetmaster service is stopped
# since we are using apache.
#
class puppet::master::service (
) {

  service { 'puppetmaster':
    ensure => stopped,
    enable => false,
  }

}
