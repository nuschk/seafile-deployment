# Samba

Install package and prepare shared folder

	sudo apt-get install -y samba samba-common-bin
	mkdir /home/pi/share
	chmod 777 /home/pi/share
	sudo smbpasswd -a pi

Then edit /etc/samba/smb.conf and add the folowing:
    - change: workgroup = HOME
    - Add to end:
		[share]
		comment = Share
		path = /home/pi/share/
		writeable = Yes
		only guest = Yes
		create mask = 0777
		directory mask = 0777
		browseable = Yes
		public = yes
		

# Install Docker

Follow the steps here: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#uninstall-old-versions

	sudo apt-get update
	sudo apt-get install \
	    apt-transport-https \
	    ca-certificates \
	    curl \
	    software-properties-common-image-extra-virtual
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo apt-key add -

	sudo add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/raspbian $(lsb_release -cs) stable"

# Install seafile

Update distro

	sudo apt-get update
	sudo apt-get dist-upgrade

Install prerequisites

	sudo apt-get install -y python2.7 libpython2.7 python-setuptools python-imaging python-ldap python-urllib3 python-requests sqlite3

Setup en_US.UTF-8 locale. Use the following command and select it from the list.

	 sudo dpkg-reconfigure locales

Create the seafile user

	sudo adduser seafile --disabled-login
	cd

Download seafile

	wget https://github.com/haiwen/seafile-rpi/releases/download/v6.1.1/seafile-server_6.1.1_stable_pi.tar.gz

Install (according to docs, we're using the guide to sqlite here [https://manual.seafile.com/deploy/using_sqlite.html]):

	mkdir girls4ever
	mv seafile-server_* girls4ever
	cd girls4ever
	# after moving seafile-server_* to this directory
	tar -xzf seafile-server_*
	mkdir installed
	mv seafile-server_* installed

Setup

	cd seafile-server-*
	./setup-seafile.sh 

Current setup

	server name:        girls4ever
	server ip/domain:   girls4ever.zapto.org
	seafile data dir:   /home/seafile/girls4ever/seafile-data
	fileserver port:    8082

Start
  
  	./seafile.sh start
  	./seahub.sh start 8000

Auto Start after bootup: With the defuault user (pi):
	
	sudo nano /etc/rc.local
	
Then add the following line

	su seafile -c '/home/seafile/girls4ever/seafile-server-latest/seafile.sh start && /home/seafile/girls4ever/seafile-server-latest/seahub.sh start 8000'

# Caddy HTTPS

Customize the caddy download for ARM7 from the website. We need the cache module, otherwise, everthing is included. On the bottom of the page, there will be a direct download address. Get it on the Pi, as seafile user, then upack.

 	 wget https://caddyserver.com/download/linux/arm7?plugins=http.cache --content-disposition
 	 tar vzxf caddy_v0.10.6_linux_arm7_custom.tar.gz

Allow caddy to bind to port 80 and 443. Execute as pi user:

	sudo setcap cap_net_bind_service=+ep /home/seafile/caddy


# Dynamic DNS

Setup Dynamic DNS with no-ip (run as main user, pi)

	mkdir /home/pi/noip
	cd ~/noip
	wget http://www.no-ip.com/client/linux/noip-duc-linux.tar.gz	
	tar vzxf noip-duc-linux.tar.gz
	cd noip-2.1.9-1/
	sudo make
	sudo make install
	(Input email and password)
	sudo noip2 ­-S

Data will be stored in /home/seafile/girls4ever/seafile-data by default.	


# WLAN Router Setup:
- We assign a fixed IP to the Raspberry Pi (192.168.0.100)
- The seafile server is running on port 8082
- The seb service is running on port 8000
- Setup port forwarding for these ports.

Resources:
  - https://github.com/haiwen/seafile-rpi/releases