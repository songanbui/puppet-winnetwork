# == Class: winnetwork
#
# Manages proxy and dns configuration
#
# === Parameters
#
# [*None*]
#
# === Examples
#
#  include winnetwork
#
# === Authors
#
# songan.bui@thomsonreuters.com
#
# === Comment
#
# 
#
class winnetwork {
  include winnetwork::proxy
  include winnetwork::dns
}