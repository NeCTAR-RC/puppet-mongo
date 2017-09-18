# == Class: mongo
#
# Manage mongodb installations on RHEL, CentOS, Debian and Ubuntu installing
# from the 10Gen repo
#
# === Parameters
#
# packagename (auto discovered) - override the package name
#
# === Examples
#
# To install with defaults from the distribution packages on any system:
#   include mongo
#
# === Authors
#
# Craig Dunn <craig@craigdunn.org>
# Andy Botting <andy@andybotting.com>
#
# === Copyright
#
# Copyright 2012 PuppetLabs
#
class mongo (
  $packagename = undef,
) inherits mongo::params {

  # Set up repo

  class { $mongo::params::source: }

  package { 'mongodb':
    name    => $mongo::params::pkg_10gen,
    ensure  => installed,
    require => Class[$mongo::params::source],
    notify  => Exec['stop-on-package-install'],
  }

  exec { 'stop-on-package-install':
    command     => '/usr/sbin/service mongodb stop; echo manual > /etc/init/mongodb.override',
    refreshonly => true,
  }

  logrotate::rule { 'mongodb':
    ensure  => present,
    path    => '/var/log/mongodb/*.log',
    options => [
      'rotate 5',
      'daily',
      'copytruncate',
      'delaycompress',
      'compress',
      'notifempty',
      'missingok'
    ],
    require => Package['mongodb'],
  }
}
