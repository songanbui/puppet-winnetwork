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
  $disable_public = false,
) {
  case $::osfamily {
    'windows': {
      if ($disable_public == true) {
        exec { 'disable public profile firewall':
        path     => $::path,
        command  => '& netsh advfirewall set publicprofile state off',
        unless   => template('winnetwork/check_public_firewall_state.ps1.erb'),
        provider => powershell,
      }
      }
    }
    default: { fail("${::osfamily} is not a supported platform.") }
  }
}