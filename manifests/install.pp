# == Class: puppet::install
#
#
class puppet::install (
) {

  case $::osfamily {
    'RedHat', 'Debian': { $pkg = 'puppet' }
    default : { fail("Unsupported osfamily ${::osfamily}") }
  }

  package { $pkg:
    ensure => $::puppet::package_ensure,
  }

}
