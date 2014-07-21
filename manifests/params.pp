class mongo::params{

  case $::osfamily {
    'redhat': {
      $baseurl        = "http://downloads-distro.mongodb.org/repo/redhat/os/${::architecture}"
      $source         = 'mongo::sources::yum'
      $package        = 'mongodb-server'
      $service        = 'mongod'
      $service_mongos = 'mongos'
      $pkg_10gen      = 'mongo-10gen-server'
    }
    'debian': {
      $locations = {
        'sysv'    => 'http://downloads-distro.mongodb.org/repo/debian-sysvinit',
        'upstart' => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart'
      }
      case $::operatingsystem {
        'Debian': {
          $init = 'sysv'
          $mongos_init = 'not-written-yet'
      }
        'Ubuntu': {
          $init = 'upstart'
          $mongos_init = 'mongos-init-upstart.erb'
        }
      }
      $source         = 'mongo::sources::apt'
      $package        = 'mongodb'
      $service        = 'mongodb'
      $service_mongos = 'mongos'
      $pkg_10gen      = 'mongodb-10gen'
    }
    default: {
      fail ("mongodb: ${::operatingsystem} is not supported.")
    }
  }
}
