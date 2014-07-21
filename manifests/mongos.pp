# == Class: mongo::mongos
#
# Manage mongodb shard server
#
# === Parameters
#
# init (auto discovered) - override init (sysv or upstart) for Debian derivatives
# servicename (auto discovered) - override the service name
#
# === Examples
#
# To install
#   class { 'mongo:mongos':
#     config_hosts => ['mongoc1', 'mongoc2', 'mongoc3']
#   }
#
# === Authors
#
# Craig Dunn <craig@craigdunn.org>
# Andy Botting <andy@andybotting.com>
#
# === Copyright
#
# Copyright 2012 PuppetLabs
# Copyright 2014 Andy Botting
#
class mongo::mongos (
  $init            = $mongo::params::init,
  $servicename     = $mongo::params::service_mongos,
  $logpath         = '/var/log/mongodb/mongos.log',
  $logappend       = true,
  $mongofork       = true,
  $port            = '27017',
  $config_port     = '27019',
  $config_hosts    = [],
) inherits mongo::params {

  # Ubuntu specific for now
  file { '/etc/init/mongos.conf':
    content => template('mongo/mongos-init-upstart.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mongodb'],
  }

  file { '/etc/init.d/mongos':
    ensure => link,
    target => '/lib/init/upstart-job',
  }

  file { '/etc/mongos.conf':
    content => template('mongo/mongos.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mongodb'],
  }

  service { 'mongos':
    name      => $servicename,
    ensure    => running,
    enable    => true,
    require   => File['/etc/init/mongos.conf'],
    subscribe => File['/etc/mongos.conf'],
  }

}
