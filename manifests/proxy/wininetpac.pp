# == Class: winnetwork::proxy::wininetpac
#
# Manages proxy auto configuration (PAC) for WININET library only
#
# === Parameters
#
# [*None*]
#
# === Examples
#
#  include winnetwork::proxy::wininetpac
#
# === Authors
#
# songan.bui@thomsonreuters.com
#
# === Comment
#
# 
#
class winnetwork::proxy::wininetpac (
  $proxy_pac   = 'http://localhost/proxy.pac',
) {
  case $::osfamily {
    'windows': {
      # Disable automatic proxy result cache
      registry::value { 'EnableAutoproxyResultCache':
        key  => 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings',
        type => 'dword',
        data => '0',
      }
      # Apply system-wide proxy settings
      registry::value { 'ProxySettingsPerUser':
        key  => 'HKLM:\Software\Policies\Microsoft\Windows\CurrentVersion\Internet Settings',
        type => 'dword',
        data => '0',
      }
      # Apply in HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings
      $regkey = 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Internet Settings'
      registry_value { "${regkey}\\ProxyServer":
        ensure => absent,
      }
      registry_value { "${regkey}\\ProxyOverride":
        ensure => absent,
      }
      registry::value { 'ProxyEnable':
        key  => $regkey,
        type => 'dword',
        data => '0',
      }
      registry::value { 'ProxyHttp1.1':
        key  => $regkey,
        type => 'dword',
        data => '1',
      }
      registry::value { 'EnableHttp1_1':
        key  => $regkey,
        type => 'dword',
        data => '1',
      }
      registry::value { 'NoNetAutodial':
        key  => $regkey,
        type => 'dword',
        data => '0',
      }
      registry::value { 'EnableAutodial':
        key  => $regkey,
        type => 'dword',
        data => '0',
      }
      registry::value { 'AutoConfigURL':
        key   => $regkey,
        value => 'AutoConfigURL',
        type  => 'string',
        data  => $proxy_pac,
      }

      if ($::architecture == 'x64') {
        # Disable automatic proxy result cache
        registry::value { 'Wow6432Node EnableAutoproxyResultCache':
          key  => 'HKLM:\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings',
          type => 'dword',
          data => '0',
        }
        # Apply system-wide proxy settings
        registry::value { 'Wow6432Node ProxySettingsPerUser':
          key   => 'HKLM:\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings',
          value => 'ProxySettingsPerUser',
          type  => 'dword',
          data  => '0',
        }
        # Apply in HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings
        $regkey2 = 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Internet Settings'
        registry_value { "${regkey2}\\ProxyServer":
          ensure => absent,
        }
        registry_value { "${regkey2}\\ProxyOverride":
          ensure => absent,
        }
        registry::value { 'Wow6432Node ProxyEnable':
          key   => $regkey2,
          value => 'ProxyEnable',
          type  => 'dword',
          data  => '0',
        }
        registry::value { 'Wow6432Node ProxyHttp1.1':
          key   => $regkey2,
          value => 'ProxyHttp1.1',
          type  => 'dword',
          data  => '1',
        }
        registry::value { 'Wow6432Node EnableHttp1_1':
          key   => $regkey2,
          value => 'EnableHttp1_1',
          type  => 'dword',
          data  => '1',
        }
        registry::value { 'Wow6432Node NoNetAutodial':
          key   => $regkey2,
          value => 'NoNetAutodial',
          type  => 'dword',
          data  => '0',
        }
        registry::value { 'Wow6432Node EnableAutodial':
          key   => $regkey2,
          value => 'EnableAutodial',
          type  => 'dword',
          data  => '0',
        }
        registry::value { 'Wow6432Node AutoConfigURL':
          key   => $regkey2,
          value => 'AutoConfigURL',
          type  => 'string',
          data  => $proxy_pac,
        }
      }
    }
    default: { fail("${::osfamily} is not a supported platform.") }
  }
}