class mongo::sources::apt inherits mongo::params {
  include apt

  if $::rfc1918_gateway == 'true' {
    exec { '10gen-apt-key':
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      command     => "apt-key adv --recv-keys --keyserver keyserver.ubuntu.com --keyserver-options http-proxy=\"${::http_proxy}\" 7F0CEB10",
      unless      => 'apt-key list | grep 7F0CEB10 >/dev/null 2>&1',
    }

  } else {
    apt::key { '10gen':
      key        => '492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10',
      key_server => 'keyserver.ubuntu.com',
    }
  }

  apt::source { '10gen':
    location    => 'http://repo.mongodb.org/apt/ubuntu',
    release     => 'trusty/mongodb-org/3.0',
    repos       => 'multiverse',
    key         => '492EAFE8CD016A07919F1D2B9ECBEC467F0CEB10',
    include_src => false,
  }

}
