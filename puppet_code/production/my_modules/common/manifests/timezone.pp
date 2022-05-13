#
class common::timezone (
  $tz,
){
exec { "timedatectl set-tz ${tz}":
    command => "/usr/bin/timedatectl set-timezone '${tz}'",
    unless  => "/usr/bin/timedatectl status | grep -qe 'Time zone:.*${tz}'";
  }
}
