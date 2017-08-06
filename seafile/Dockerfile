FROM resin/rpi-raspbian:latest

RUN apt-get update && apt-get install -y \
		python2.7 libpython2.7 python-setuptools \
		python-imaging python-ldap python-urllib3 python-requests \
		sqlite3 wget netcat
RUN useradd -ms /bin/bash seafile && adduser seafile sudo

USER seafile
WORKDIR /home/seafile

# Get the tar for raspberry. Then unpack it and move it to the right places,
# according to the installation documentation.
# TODO: Make configurable: site, version
RUN wget https://github.com/haiwen/seafile-rpi/releases/download/v6.1.1/seafile-server_6.1.1_stable_pi.tar.gz
RUN tar -xzf seafile-server_* && \
	mkdir installed && \
	mv seafile-server_* installed

# TODO: Make configurable: site, domain.
# TODO: Make volume of data directory
RUN cd seafile-server-* && \
    ./setup-seafile.sh auto -n girls4ever -i girls4ever.zapto.org -p 8082 -d /home/seafile/seafile-data

COPY entrypoint.sh ./

EXPOSE 8000 8082

ENTRYPOINT ["./entrypoint.sh"]
CMD ["usage"]