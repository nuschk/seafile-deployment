FROM resin/rpi-raspbian:latest

RUN apt-get update && apt-get install -y \
		python2.7 libpython2.7 python-setuptools \
		python-imaging python-ldap python-urllib3 python-requests \
		sqlite3 wget
RUN useradd -ms /bin/bash seafile && adduser seafile sudo

USER seafile

# Get the tar for raspberry. Then unpack it and move it to the right places,
# according to the installation documentation.
# TODO: Make configurable: site, version
RUN cd && wget https://github.com/haiwen/seafile-rpi/releases/download/v6.1.1/seafile-server_6.1.1_stable_pi.tar.gz
RUN cd && \
	mkdir girls4ever && \
	mv seafile-server_* girls4ever && \
	cd girls4ever && \
	tar -xzf seafile-server_* && \
	mkdir installed && \
	mv seafile-server_* installed


