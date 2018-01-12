
This is the Alpine version with Snapraid 11.2

![http://linuxserver.io](https://raw.githubusercontent.com/linuxserver/docker-templates/master/linuxserver.io/img/linuxserver_medium.png)

The [LinuxServer.io](https://www.linuxserver.io/) team brings you another quality container release featuring auto-update on startup, easy user mapping and community support. Be sure to checkout our [forums](https://forum.linuxserver.io/index.php) or for real-time support our [IRC](https://www.linuxserver.io/irc/) on freenode at `#linuxserver.io`.

# linuxserver/snapraid

SnapRAID is an application which computes parity across a set of hard drives (usually in JBOD configuration) allowing recovery from drive failure. It is known as a ‘snapshot’ RAID implementation meaning that it is not ‘real-time’ such as mdadm, ZFS or unRAID. It is free and open source under a GPL v3 license. It supports mismatched disk sizes although the largest must be your parity drive and is very well suited to use cases with lots of large, relatively static filesystems such as media collections. This container has been born out of several years of personal SnapRAID usage, I even wrote an article in 2014 about [how to setup SnapRAID on Arch](https://www.linuxserver.io/index.php/2014/09/06/how-to-setup-snapraid-on-arch-linux/). There's a lot of useful information in this article so I won't repeat it here!

Use is made of the [snapraid-runner](https://github.com/Chronial/snapraid-runner) project, a simple Python app which provides the following features:

* Runs diff before sync to see how many files were deleted and aborts if that number exceeds a set threshold
* Can create a size-limited rotated logfile
* Can send notification emails after each run or only for failures
* Can run scrub after sync

## Usage

```
docker create -d \
  -v /mnt:/mnt \
  -v <local-configs-path-on-host>/snapraid:/config \
  -e PGID=1001 -e PUID=1001 \
  --name snapraid \
  linuxserver/snapraid
```

This container is configured using two files `snapraid.conf` and `snapraid-runner.conf`. These should both be placed into your hosts local config directory to be mounted as a volume **before** the container is executed for the first time.

**Parameters**
* `-v /mnt` - The location of your data disks, a good convention is `/mnt/disk*` for your data drives
* `-v /config` - The location of the Snapraid and SnapRAID-runner configurations
* `-e PGID` for GroupID - see below for explanation
* `-e PUID` for UserID - see below for explanation

It is based on phusion-baseimage with ssh removed, for shell access whilst the container is running do `docker exec -it snapraid /bin/bash`.

### User / Group Identifiers

**TL;DR** - The `PGID` and `PUID` values set the user / group you'd like your container to 'run as' to the host OS. This can be a user you've created or even root (not recommended).

Part of what makes our containers work so well is by allowing you to specify your own `PUID` and `PGID`. This avoids nasty permissions errors with relation to data volumes (`-v` flags). When an application is installed on the host OS it is normally added to the common group called users, Docker apps due to the nature of the technology can't be added to this group. So we added this feature to let you easily choose when running your containers.

## Setting up the application

SnapRAID has a comprehensive manual available [here](http://www.snapraid.it/). Any SnapRAID command can be executed from the host easily using `docker exec -it <container-name> <command>`, for example `docker exec -it snapraid snapraid diff`.

Note that by default snapraid-runner is set to run via cron at 00.30 daily. Tips and tricks on configuration snapraid-runner can be found on our [forums](https://forum.linuxserver.io/index.php?threads/snapraid-runner-script-email-issue.97).


## Updates

* Upgrade to the latest version simply `docker restart snapraid`.
* To monitor the logs of the container in realtime `docker logs -f snapraid`.

## Versions

+ **10.11.2015** Initial release - IronicBadger <ironicbadger@linuxserver.io>

