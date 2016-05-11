# == Class: winnetwork::firewall
#
# Manages firewall configuration
#
# === Parameters
#
# [*None*]
#
# === Examples
#
#  include winnetwork::firewall
#
# === Authors
#
# songan.bui@thomsonreuters.com
#
# === Comment
#
# 
#
class winnetwork::firewall (
  $disable_private = false,
  $disable_public = false,
) {
  case $::osfamily {
    'windows': {
      $private_state = $disable_private ? {
        true    => 'OFF',
        false   => 'ON',
        default => 'ON',
      }
      exec { 'private profile firewall':
        path     => $::path,
        command  => "& netsh advfirewall set private state ${private_state}",
        unless   => template('winnetwork/check_private_firewall_state.ps1.erb'),
        provider => powershell,
      }

      $public_state = $disable_public ? {
        true    => 'OFF',
        false   => 'ON',
        default => 'ON',
      }
      exec { 'public profile firewall':
        path     => $::path,
        command  => "& netsh advfirewall set public state ${public_state}",
        unless   => template('winnetwork/check_public_firewall_state.ps1.erb'),
        provider => powershell,
      }
    }
    default: { fail("${::osfamily} is not a supported platform.") }
  }
}