Setps for adding GPU support and glmark2 to the image

- follow steps in ../nogpu/README_weston.txt

- scp over dummy .deb files from dummy-debs folder to av96

- scp over these packages from Yocto build:
    stm32mp1_av96/gcnano-driver-stm32mp_6.2.4.p3-tarAUTOINC+271f87d816_armhf.deb
    stm32mp1_av96/gcnano-userland-multi-binary-stm32mp_6.2.4.p3-r0_armhf.deb
    cortexa7t2hf-neon-vfpv4/libweston-5_5.0.0-r0_armhf.deb
    cortexa7t2hf-neon-vfpv4/libgl-mesa_18.1.9-r0_armhf.deb
    cortexa7t2hf-neon-vfpv4/weston-xwayland_5.0.0-r0_armhf.deb
    cortexa7t2hf-neon-vfpv4/glmark2_2017.07+0+5e0e448ca2-r0_armhf.deb
    
- on av96:
    # apt remove libweston-5-0
    # apt-get install libpangoxft-1.0-0 xwayland libxkbcommon-x11-0
    # dpkg -i pango_1.42.4-r0_all.deb wayland_1.16.0-r0_all.deb
    # dpkg -i gcnano-driver-stm32mp_6.2.4.p3-tarAUTOINC+271f87d816_armhf.deb gcnano-userland-multi-binary-stm32mp_6.2.4.p3-r0_armhf.deb
    # dpkg -i libglib-2.0-0_2.58.0-r0_all.deb libxkbcommon_0.8.2-r0_all.deb libz1_1.2.11-r0_all.deb xserver-xorg-xwayland_1.20.1-r0_all.deb
    # dpkg -i libweston-5_5.0.0-r0_armhf.deb libweston-5-0_5.0.0-3_all.deb weston-xwayland_5.0.0-r0_armhf.deb
    # apt-get install weston
    # dpkg -i ../deb/weston-init_1.0-r0_all.deb

- weston now starts with pixman, let's enable GCnano:
    # systemctl stop weston
    # echo "#OPTARGS=--use-pixman" > /etc/default/weston
    # systemctl start weston

- install glmark2:
    # dpkg -i libglapi0_18.1.9-r0_all.deb libgl-mesa_18.1.9-r0_armhf.deb glmark2_2017.07+0+5e0e448ca2-r0_armhf.deb
    # glmark2-es2-wayland --annotate
