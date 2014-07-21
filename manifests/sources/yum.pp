class mongo::sources::yum inherits mongo::params {
  yumrepo { '10gen':
    baseurl   => $mongo::params::baseurl,
    gpgcheck  => '0',
    enabled   => '1',
  }
}
