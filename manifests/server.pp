# == Class: mongo::server
#
# Manage mongodb server on RHEL, CentOS, Debian and Ubuntu.
# Server can be either a standalone MongoDB server, or part of a shard
# configuration (as a mongod or mongoc server).
#
# === Parameters
#
# TODO
#
# === Examples
#
# To install with defaults from the distribution packages on any system:
#   include mongo
#
# To install a shard server:
#   class { 'mongo::server':
#     shardsvr => true,
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
#
class mongo::server (
  $servicename     = $mongo::params::service,
  $logpath         = '/var/log/mongodb/mongodb.log',
  $logappend       = true,
  $mongofork       = true,
  $dbpath          = '/var/lib/mongodb',
  $configsvr       = false,
  $shardsvr        = false,
  $port            = undef,
  $replicaset      = undef,
  $nojournal       = undef,
  $cpu             = undef,
  $noauth          = undef,
  $auth            = undef,
  $verbose         = undef,
  $objcheck        = undef,
  $quota           = undef,
  $oplog           = undef,
  $nohints         = undef,
  $nohttpinterface = undef,
  $noscripting     = undef,
  $notablescan     = undef,
  $noprealloc      = undef,
  $nssize          = undef,
  $mms_token       = undef,
  $mms_name        = undef,
  $mms_name        = undef,
  $mms_interval    = undef,
  $slave           = undef,
  $only            = undef,
  $master          = undef,
  $source          = undef
) inherits mongo::params {

  # Default ports for MongoDB services
  if $port == undef {
    if $shardsvr  {
        $port_real = '27018'
    }
    elsif $configsvr {
        $port_real = '27019'
    }
    else {
        $port_real = '27017'
    }
  }
  else {
    $port_real = '27017'
  }

  file { '/etc/mongodb.conf':
    content => template('mongo/mongodb.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['mongodb'],
  }

  service { 'mongodb':
    name      => $servicename,
    ensure    => running,
    enable    => true,
    subscribe => File['/etc/mongodb.conf'],
  }

  $infra_hosts = hiera('firewall::infra_hosts', [])
  firewall::multisource {[ prefix($infra_hosts, '200 mongodb,') ]:
    action => 'accept',
    proto  => 'tcp',
    dport  => $port_real,
  }

}
