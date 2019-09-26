Steps for creating a simple Debian 10 (buster) image for the Avenger96 board

- create a standard Yocto BSP image

- modify the Yocto kernel, disable iwdg2 (watchdog) in stm32mp157a-av96.dtsi

- modify Yocto u-boot,  disable iwdg2 in stm32mp157a-av96.dtsi

- rebuild u-boot and kernel, update the uSD image with them

- in this folder execute:
    $ sudo ./build.sh
  this will create a minimal Debian 10 rootfs

- clean the 'rootfs' partition on uSD card

- execute this in current folder (copy over all files):
    $ sudo cp rootfs/* /media/<user>/rootfs/ -a
	$ sudo chown root: rootfs.add/ -R

- copy files and symlinks from rootfs.add/ to uSD card
  preferably as "root" and with "-a" as above

- remove "getty-static.service" on uSD card:
    $ sudo rm /media/<user>/rootfs/lib/systemd/system/getty.target.wants/getty-static.service

- unmount uSD card (and sync)

- connect debug console and ethernet connector of Av96, insert uSD card
  and power up board. Ethernet connection will need a DHCP server.

- when Av96 finishes booting press Enter and execute the following:
    # mount -t proc nodev /proc
	# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin dpkg --configure -a

- during configuration select TimeZone and answer "no" when asked if /bin/dash should replace /bin/sh

- some packages can't be configured so let's execute this again:
   	# PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin dpkg --configure -a

- create root password (which is "root")
    # echo root:root | /usr/sbin/chpasswd

- now we prepare for the first real boot
    # cd /sbin
	# rm init
	# mv init.orig init
	# sync

- press Ctrl-D, the kernel will panic
- reset the board

- after startup login as root	
	
- enable and start networking
    # systemctl enable systemd-resolved
	# systemctl start systemd-resolved
	# systemctl enable systemd-networkd
	# systemctl start systemd-networkd

- after a few seconds we should have network connection, let's check it:
    # ping google.com

- execute the following:
    # passwd -d root
	# apt-get update
	# apt-get install iw vim openssh-server openssh-client network-manager rng-tools
- this will take some time
  when openssh-server is being set up select "2. keep the local version ..."

- let's allow passwordless login through SSH:
    # vi /etc/pam.d/common-auth
  change this line (17):
    auth    [success=1 default=ignore]      pam_unix.so nullok_secure
  to this:
    auth    [success=1 default=ignore]      pam_unix.so nullok

- now let's test the SSH connection
  find out local IP address by:
    # ifconfig eth0

  on PC execute:
    $ ssh root@<IP address of Av96>

- now copy over WiFi firmware files with "scp" from
    .../layers/meta-av96/recipes-bsp/av96-root-files/files/lib/firmware
  to /lib/firmware on Av96

- now copy over all kernel .deb packages from
    .../build-openstlinuxweston-stm32mp1-av96/tmp-glibc/deploy/deb/stm32mp1_av96
  to /root/deb (create /root/deb on Av96 first)

- now install packages
    # cd /root/deb
	# dpkg -i kernel_4.19-r0_armhf.deb kernel-4.19.9_4.19-r0_armhf.deb kernel-vmlinux_4.19-r0_armhf.deb
	# dpkg -i kernel-module*
    # mkdir /vendor
- uncomment "/boot" and "/vendor" in /etc/fstab
  then:
    # reboot

- after startup and login WiFi should work
    # nmcli dev wifi rescan
	# nmcli dev wifi list
    # nmcli dev wifi connect <SSID> passphrase <passphrase>
