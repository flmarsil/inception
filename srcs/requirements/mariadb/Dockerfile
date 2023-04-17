FROM debian:buster

RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y mariadb-server mariadb-client wget \
	&& wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 \
	&& chmod +x /usr/bin/dumb-init \
	&& rm -rf /etc/mysql/my.cnf \
	&& rm -rf /var/lib/apt/lists/* 

COPY ./conf/my.cnf /etc/mysql/my.cnf

COPY ./setup.sh ./tmp
RUN chmod +x ./tmp/setup.sh 

ENTRYPOINT [ "/usr/bin/dumb-init" , "--" ]

CMD ["sh", "-c", "/tmp/setup.sh"]
