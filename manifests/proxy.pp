# == Class: winnetwork::proxy
#
# Manages proxy and bypass list (WINHTTP and WININET libraries)
#
# === Parameters
#
# [*None*]
#
# === Examples
#
#  include winnetwork::proxy
#
# === Authors
#
# songan.bui@thomsonreuters.com
#
# === Comment
#
# 
#
class winnetwork::proxy (
  $proxy_host   = '0.0.0.1',
  $proxy_port   = '80',
  $proxy_bypass = 'localhost;127.0.0.1;',
  $use_pac      = false,
  $proxy_pac    = 'http://localhost/proxy.pac',
) {
  case $::osfamily {
    'windows': {
      require devxexec
      
      if ($use_pac){
        class { 'winnetwork::proxy::wininetpac':
          proxy_pac => $proxy_pac,
          notify    => [File['start IE script'],Exec['start IE']],
        }
      }
      else {
        class { 'winnetwork::proxy::winhttp':
          proxy_host   => $proxy_host,
          proxy_port   => $proxy_port,
          proxy_bypass => $proxy_bypass,
        }
        class { 'winnetwork::proxy::wininet':
          proxy_host   => $proxy_host,
          proxy_port   => $proxy_port,
          proxy_bypass => $proxy_bypass,
          notify       => [File['start IE script'],Exec['start IE']],
        }
      }

      $iescript_path = 'C:\startIE.ps1'
      file { 'start IE script':
        ensure             => present,
        path               => $iescript_path,
        source_permissions => ignore,
        source             => 'puppet:///modules/winnetwork/startIE.ps1',
      }
      ->
      exec { 'start IE':
        path        => $::path,
        command     => "${devxexec::path} /user:${devxexec::username} /password:${devxexec::password} /sessionid:1 \"powershell -ExecutionPolicy unrestricted ${iescript_path}\"",
        refreshonly => true,
      }
    }
    default: { fail("${::osfamily} is not a supported platform.") }
  }
}