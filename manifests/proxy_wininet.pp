# == Class: winnetwork::proxy_wininet
#
# Manages proxy and bypass list for WININET library only
#
# === Parameters
#
# [*None*]
#
# === Examples
#
#  include winnetwork::proxy_wininet
#
# === Authors
#
# songan.bui@thomsonreuters.com
#
# === Comment
#
# 
#
class winnetwork::proxy_wininet (
  $proxy_host   = '0.0.0.1',
  $proxy_port   = '80',
  $proxy_bypass = 'localhost;127.0.0.1;',
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
      registry::value { 'ProxyServer':
        key  => $regkey,
        type => 'string',
        data => "${proxy_host}:${proxy_port}",
      }
      registry::value { 'ProxyOverride':
        key  => $regkey,
        type => 'string',
        data => $proxy_bypass,
      }
      registry::value { 'ProxyEnable':
        key  => $regkey,
        type => 'dword',
        data => '1',
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
      registry_value { "${regkey}\\AutoConfigURL":
        ensure => absent,
      }

      if ($::architecture == 'x64') {
        # Disable automatic proxy result cache
        registry::value { 'Wow6432Node EnableAutoproxyResultCache':
          key   => 'HKLM:\Software\Wow6432Node\Policies\Microsoft\Windows\CurrentVersion\Internet Settings',
          value => 'EnableAutoproxyResultCache',
          type  => 'dword',
          data  => '0',
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
        registry::value { 'Wow6432Node ProxyServer':
          key   => $regkey2,
          value => 'ProxyServer',
          type  => 'string',
          data  => "${proxy_host}:${proxy_port}",
        }
        registry::value { 'Wow6432Node ProxyOverride':
          key   => $regkey2,
          value => 'ProxyOverride',
          type  => 'string',
          data  => $proxy_bypass,
        }
        registry::value { 'Wow6432Node ProxyEnable':
          key   => $regkey2,
          value => 'ProxyEnable',
          type  => 'dword',
          data  => '1',
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
        registry_value { "${regkey2}\\AutoConfigURL":
          ensure => absent,
        }
      }
    }
    default: { fail("${::osfamily} is not a supported platform.") }
  }
}