# == Definition: selinux::module
#
# This definition builds a binary SELinux module from a supplied set of SELinux
# security policies. It is then possible to load it using a Selmodule resource.
#
# Parameters:
#
# - *name*: the name of the SELinux module
# - *workdir*: where the module source and binary files are stored. Defaults to
#   "/etc/puppet/selinux"
# - *dest*: where the binary module must be copied. Defaults to
#   "/usr/share/selinux/targeted/"
# - *content*: inline content or template of the module source
# - *source*: file:// or puppet:// URI of the module source file
#
# Example usage:
#
#   selinux::module { "foobar":
#     notify => Selmodule["foobar"],
#     source => "puppet:///modules/myproject/foobar.te",
#   }
#
#   selmodule { "foobar":
#     ensure      => present,
#     syncversion => true,
#   }
#
define selinux::module (
  $workdir='/etc/puppet/selinux',
  $dest='/usr/share/selinux/targeted/',
  $content=undef,
  $source=undef
) {

  if !defined(File[$workdir]) {
    file { $workdir:
      ensure => directory,
      mode   => '0700',
      owner  => 'root',
    }
  }

  case $osfamily {

    'RedHat': {
      selinux::module::redhat{ "$name":
        workdir => $workdir,
        dest    => $dest,
        content => $content,
        source  => $source
      }
    }

    'Debian': {
      selinux::module::debian{ "$name":
        workdir => $workdir,
        dest    => $dest,
        content => $content,
        source  => $source
      }
    }

    default: { fail("${::operatingsystem} is not supportted.") }

  }

}
