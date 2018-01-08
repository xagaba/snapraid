#!/bin/ash
# Ensures that configuration files for both SnapRAID and snapraid-runner are present
# in /config. In reality, both files should be edited manually before running this
# container to ensure correct operation.

# test for /etc/snapraid.conf being a file and not a link, delete if file.
if [ ! -L /etc/snapraid.conf ] && [ -f /etc/snapraid.conf ]; then
    rm /etc/snapraid.conf
fi

# test if snapraid.conf is in /config, copy from /defaults/snapraid.conf.example if not.
if [ ! -f /config/snapraid.conf ]; then
    echo "No config found. You must configure SnapRAID before running this container."
    exit 1
fi
if [ ! -f /config/snapraid-runner.conf ]; then
    echo "No config found. You must configure snapraid-runner before running this container"
    exit 1
fi

# test if link is made between /etc/snapraid.conf and /config/snapraid.conf, make if not
if [ ! -L /etc/snapraid.conf ]; then
    ln -s /config/snapraid.conf /etc/snapraid.conf
fi

/usr/sbin/crond -d 6 -c /etc/crontabs -f 

