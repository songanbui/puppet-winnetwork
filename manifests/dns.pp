# == Class: winnetwork::dns
#
# Manages dns configuration
#
# === Parameters
#
# [*None*]
#
# === Examples
#
#  include winnetwork::dns
#
# === Authors
#
# songan.bui@thomsonreuters.com
#
# === Comment
#
# 
#
class winnetwork::dns (
  $dns_primary   = '0.0.0.1',
  $dns_secondary = '0.0.0.2',
) {
  case $::osfamily {
    'windows': {
      $ipinterfaces = split($::interfaces, ',')
      $firstipint = regsubst($ipinterfaces[0],'_',' ','G')
      # Set dns primary server on first ip interface (default)
      exec { 'set dns primary':
        path     => $::path,
        command  => "netsh interface ip set dns name=\"${firstipint}\" source=static address=${dns_primary} register=none",
        unless   => template('winnetwork/check_primary_dns.ps1.erb'),
        provider => powershell,
        notify   => Exec['stop network post-proxyconfig'],
      }
      # Set dns secondary server on first ip interface (default)
      exec { 'set dns secondary':
        path     => $::path,
        command  => "netsh interface ip add dns name=\"${firstipint}\" address=${dns_secondary} index=2",
        unless   => template('winnetwork/check_secondary_dns.ps1.erb'),
        provider => powershell,
        require  => Exec['set dns primary'],
        notify   => Exec['stop network post-proxyconfig'],
      }
      
      exec { 'stop network post-proxyconfig':
        command     => 'ipconfig /release',
        path        => $::path,
        refreshonly => true,
      }
      ~>
      exec { 'start network post-proxyconfig':
        command     => 'ipconfig /renew',
        path        => $::path,
        refreshonly => true,
      }
    }
    default: { fail("${::osfamily} is not a supported platform.") }
  }
}