#!/bin/bash
# Automated build and patch script for AllStar Raspbian install
#Used to update and prepare images for shipping
# Also used for resetting AllStar to defaults in test environments
# For developers only!
# Do not use unless you know what you're doing,
	# and you've made a complete backup first!
# This script can break your node!
# This script should only be run on development Raspberry Pis!
# You have been warned!

# Script Start
cd /usr/src/utils
git pull
chmod +x /usr/src/utils/AllStar-build/common/update-dahdi.sh
/usr/src/utils/AllStar-build/common/update-dahdi.sh
chmod +x /usr/src/utils/AllStar-build/common/update-libpri.sh
/usr/src/utils/AllStar-build/common/update-libpri.sh
chmod +x /usr/src/utils/AllStar-build/common/update-asterisk.sh
/usr/src/utils/AllStar-build/common/update-asterisk.sh
echo "Building URI diag..."
cd /usr/src/utils/astsrc/uridiag
make
make install
echo "Done"
echo "Setting up defaults for AllStar..."
mkdir /etc/asterisk
cd /etc/asterisk
cp /usr/src/utils/AllStar-build/configs/* .
echo "Done"
echo "Installing default sound files..."
cp -a /usr/src/utils/astsrc/sounds/* /var/lib/asterisk/sounds
sndbcm=$(grep -ic "snd_bcm2835" /etc/modules )
sndpcm=$(grep -ic "snd_pcm_oss" /etc/modules )
if [ $sndbcm -eq 1 ]
then
  sed -i '/snd_bcm2835/d' /etc/modules
fi
if [ $sndpcm -eq 0 ]
then
  echo "snd_pcm_oss" >> /etc/modules
fi
echo "Done"
echo "Setting up startup scripts and system-update..."
(cp /usr/src/utils/AllStar-build/common/rc.updatenodelist /usr/local/bin/rc.updatenodelist;chmod +x /usr/local/bin/rc.updatenodelist)
cp /usr/src/utils/AllStar-build/common/asterisk.service /etc/systemd/system
cp /usr/src/utils/AllStar-build/common/asterisk.timer /etc/systemd/system
cp /usr/src/utils/AllStar-build/common/dahdi.timer /etc/systemd/system
cp /usr/src/utils/AllStar-build/common/updatenodelist.service /etc/systemd/system
systemctl daemon-reload
systemctl enable asterisk.timer
systemctl enable dahdi.timer
systemctl enable updatenodelist.service
chmod +x /usr/src/utils/AllStar-build/rpi/make-links.sh
/usr/src/utils/AllStar-build/rpi/make-links.sh
service cron restart
echo "Done"
echo "Starting Asterisk..."
systemctl start asterisk
echo "Done"
echo "AllStar is now installed..."
echo "You can update the system at any time by running 'system-update' at a root prompt."
echo "Please edit rpt.conf, iax.conf, extensions.conf, and usbradio.conf."
echo "If you want to use EchoLink, edit echolink.conf."
echo "If you don't want to use EchoLink, you don't need to do anything."
echo "EchoLink is disabled by default."
echo "All files are located in /etc/asterisk."
echo "After editing files, reboot to get your node online."
echo "Enjoy AllStar on Raspbian!"
exit 0
