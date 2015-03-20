# ==Class: puppet::master:;install
#
#
class puppet::master::install (
) {

  case $::osfamily {
    'RedHat': {
      $pkgs = [ #'puppet-server', # The puppet-server package is actually pretty useless if you use passenger/unicorn
                'rubygem-deep_merge',
                'rubygem-hiera-eyaml',
                'rubygem-xml-simple'
              ]
    }
    default:  { fail("osfamily ${::osfamily} is not supported.") }
  }

  package { $pkgs:
    ensure => present,
  }

}
