class mongo::params{

  # Ubuntu only
  $init           = 'upstart'
  $mongos_init    = 'mongos-init-upstart.erb'
  $source         = 'mongo::sources::apt'
  $package        = 'mongodb'
  $service        = 'mongod'
  $service_mongos = 'mongos'
  $pkg_10gen      = 'mongodb-org'
}
