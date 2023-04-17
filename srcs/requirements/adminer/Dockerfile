FROM debian:buster

RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y wget \
	
	# Install dumb-init for PID handler
	&& wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64  \
	&& chmod +x /usr/bin/dumb-init  \
	# Download and store PPA repository in a file on your Debian Server/Desktop. But first, download GPG key.
	&& apt-get install -y lsb-release apt-transport-https ca-certificates  \
	&& wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg  \

	# Then add repository.
	&& echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list  \
	&& apt-get update -y  \
	&& apt-get upgrade -y  \

	# Install php7.4-fpm
	&& apt-get install -y php7.4-fpm php7.4-cli php7.4-mysql  \
	&& rm -f /etc/php/7.4/fpm/pool.d/*  \
	&& mkdir -p /var/run/php  \
	&& rm -rf /var/lib/apt/lists/* 

# Swap .conf 
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Import script set-up
COPY ./setup.sh /tmp/
RUN chmod +x ./tmp/setup.sh 

ENTRYPOINT [ "/usr/bin/dumb-init" , "--" ]

CMD ["sh", "-c", "/tmp/setup.sh"]

#https://www.techrepublic.com/article/how-to-make-mysql-administration-simple-with-adminer/