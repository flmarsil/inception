FROM debian:buster

RUN apt-get update -y \
	&& apt-get install -y nginx openssl wget \
	&& rm -f /etc/nginx/sites-available/default \
	&& rm -f /etc/nginx/sites-enabled/default \
	&& rm -rf /usr/share/nginx/html/* \
	&& mkdir -p /etc/nginx/tls \
	&& openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 \
		-keyout /etc/nginx/tls/private.key \
		-out /etc/nginx/tls/certificate.crt -subj '/CN=$DOMAIN_NAME' \
	&& rm -rf /var/lib/apt/lists/* 

COPY ./conf/default.conf /etc/nginx/sites-available/

RUN ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/default.conf \
	&& wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 \
	&& chmod +x /usr/bin/dumb-init \
	&& rm -rf /var/lib/apt/lists/* 

ENTRYPOINT [ "/usr/bin/dumb-init" , "--" ]

CMD ["nginx", "-g", "daemon off;"]