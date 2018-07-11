## kubernetes repos

class kubernetes::repos (
  String $container_runtime = $kubernetes::container_runtime,
){

  case $facts['osfamily']  {
    'Debian': {
      apt::source { 'kubernetes':
        location => 'http://apt.kubernetes.io',
        repos    => 'main',
        release  => 'kubernetes-xenial',
        key      => {
          'id'     => '54A647F9048D5688D7DA2ABE6A030B21BA07F4FB',
          'source' => 'https://packages.cloud.google.com/apt/doc/apt-key.gpg',
          },
        }
      case $facts['os']['name'] {
        'Ubuntu':{
          case $facts['os']['release']['major'] {
            '14.04': {
                if $container_runtime == 'docker' {
                  apt::source { 'docker':
                    location => 'https://apt.dockerproject.org/repo',
                    repos    => 'main',
                    release  => 'ubuntu-trusty',
                    key      => {
                      'id'     => '58118E89F3A912897C070ADBF76221572C52609D',
                      'source' => 'https://apt.dockerproject.org/gpg',
                  },
                }
              } # ubuntu 14.04 trusty
            }
            '16.04': {
                if $container_runtime == 'docker' {
                  apt::source { 'docker':
                    location => 'https://apt.dockerproject.org/repo',
                    repos    => 'main',
                    release  => 'ubuntu-xenial',
                    key      => {
                      'id'     => '58118E89F3A912897C070ADBF76221572C52609D',
                      'source' => 'https://apt.dockerproject.org/gpg',
                  },
                }
              }
            } # Ubuntu 16.04 xenial
            default: {
              fail("The Ubuntu release $facts['os']['release']['major'] is not supported")
            }
          }
        } # os::name == Ubuntu
        'Debian': {
          package { 'apt-transport-https':
            ensure => present
          }
          case $facts['os']['release']['major'] {
            '8': {
                if $container_runtime == 'docker' {
                  apt::source { 'docker':
                    location => 'https://apt.dockerproject.org/repo',
                    repos    => 'main',
                    release  => 'debian-jessie',
                    key      => {
                      'id'     => '58118E89F3A912897C070ADBF76221572C52609D',
                      'source' => 'https://apt.dockerproject.org/gpg',
                  },
                }
              }
            } # debian-jessie
            '9': {
                if $container_runtime == 'docker' {
                  apt::source { 'docker':
                    location => 'https://apt.dockerproject.org/repo',
                    repos    => 'main',
                    release  => 'debian-stretch',
                    key      => {
                      'id'     => '58118E89F3A912897C070ADBF76221572C52609D',
                      'source' => 'https://apt.dockerproject.org/gpg',
                  },
                }
              }
            } # debian stretch
            default: {
              fail("The Debian release $facts['os']['release']['major'] is not supported")
            }
          }
        } # os::name == Debian
        default: {
          fail("The Debian variant $facts['os']['name'] is not supported")
        }
      }
    } # os_family == Debian
    'RedHat': { # RHEL / CentOS 7 !
      if $container_runtime == 'docker' {
        yumrepo { 'docker':
          descr    => 'docker',
          baseurl  => 'https://yum.dockerproject.org/repo/main/centos/7',
          gpgkey   => 'https://yum.dockerproject.org/gpg',
          gpgcheck => true,
        }
      }

      yumrepo { 'kubernetes':
        descr    => 'Kubernetes',
        baseurl  => 'https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64',
        gpgkey   => 'https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg',
        gpgcheck => true,
      }
    } #os_family == Redhat

  default: { notify {"The OS family $facts['osfamily'] is not supported by this module":} }

  }
}
