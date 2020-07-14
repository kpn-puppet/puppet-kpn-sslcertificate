# class sslcertificate

class sslcertificate {
  unless $facts['os']['family'] == 'windows' {
    fail('This module is not supported on operating systems other than Windows')
  }

  if ($::choco_install_path == 'C:\Management\Programs\Chocolatey' and versioncmp($::chocolateyversion,'0') > 0) {
    package { 'OpenSSL.Light':
      ensure   => present,
      provider => 'chocolatey',
    }
  }
}
