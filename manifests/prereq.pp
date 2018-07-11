#Calss kubernetes prereq,
class kubernetes::prereq (
){

  $facts['partitions'].each | $name, $partinfo | {
    if($partinfo['filesystem'] == 'swap' ) {
      # notify{ "Swapoff ${name} / UUID=${partinfo['uuid']}":}
      exec { "swap-off /dev/${name}":
        command => "/sbin/swapoff -v /dev/${name}",
        onlyif  => "/sbin/swapon -s | grep ${name}",
      }
    }
  }

  file_line { 'remove_swap':
    path              => '/etc/fstab',
    ensure            => absent,
    match             => '^.* swap .*$',
    match_for_absence => true,
    multiple          => true
  }

}
