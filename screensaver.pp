# == Class: screensaver
#
# Inspired by http://plankenau.com/blog/post-10/gaussianlock
#
# Tested on Arch Linux and Ubuntu 14.04
#
# === Authors
#
# Carla Souza <contact@carlasouza.com>
#
# === Copyright
#
# Copyright 2014 Carla Souza

class screensaver(
  $user = 'carla',
  $timeout = 1
) {

  package { ['i3lock', 'scrot', 'imagemagick', 'xautolock']:
    ensure => latest
  }

  file { '/bin/lock':
    ensure  => present,
    mode    => 0755,
    content => '#!/bin/bash
scrot /tmp/screenshot.png
convert /tmp/screenshot.png -blur 0x5 /tmp/screenshot.png
i3lock -i /tmp/screenshot.png',
    require => Package['i3lock', 'imagemagick', 'scrot']
  }

  exec { 'xautolock':
    command => "/usr/bin/su -c '/usr/bin/xautolock -time ${timeout} -locker /bin/lock &' ${user}",
    unless  => "/bin/pgrep xautolock -u ${user}",
    require => Package['xautolock']
  }

}
