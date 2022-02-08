#!/bin/bash
export NUMBER="${NUMBER:-"undef"}"
export SLEEPTIME="${SLEEPTIME:-"10s"}"
export LIRC="${LIRC:-"no"}"

if [ $NUMBER != "undef" ]; then

   if [ -s /var/run/dbus/pid ]; then
      rm /var/run/dbus/pid
   fi

   echo "Starting DBus System Daemon"
   dbus-daemon --system --address=unix:path=/run/dbus/system_bus_socket
   
   echo $NUMBER
   echo "Starting signal-cli"
   sudo -u fhem /usr/local/bin/signal-cli -u $NUMBER --config /opt/fhem/.local/share/signal-cli/ daemon --system &

   echo "Wait $SLEEPTIME to give signal-cli time to come up"
   sleep $SLEEPTIME
fi

if [ "$LIRC" = "yes" ]; then

   if [ ! -d "/var/run/lirc" ]; then
      mkdir "/var/run/lirc"
   fi
   echo "Starting lircd"
   /usr/sbin/lircd -O /opt/lirc/lirc_options.conf /opt/lirc/lircd.conf
fi
