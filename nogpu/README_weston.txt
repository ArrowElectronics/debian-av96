Setps for adding Weston GUI and Midori browser to the image

- follow steps in README.txt

- the Weston image needs more space so it is adwised to either enlarge "rootfs"
  partition or simply create a bigger one. A minimum of 2GB is required.

- SSH into Av96 and execute:
    # apt-get install weston midori
  this will download about 500MB

- from a full Yocto build copy over weston-init package:
    $ scp .../build-openstlinuxweston-stm32mp1-av96/tmp-glibc/deploy/deb/all/weston-init_1.0-r0_all.deb root@<IP address>:deb/

- on Av96:
    # apt-get install kbd
    # dpkg -i deb/weston-init_1.0-r0_all.deb
	# echo "OPTARGS=--use-pixman" > /etc/default/weston
    # reboot
