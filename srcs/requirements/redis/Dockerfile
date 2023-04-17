FROM debian:buster

RUN apt-get update -y \
	&& apt-get upgrade -y \
	&& apt-get install -y wget make curl gcc pkg-config tcl procps \
	# install dumb init 
	&& wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.5/dumb-init_1.2.5_x86_64 \
	&& chmod +x /usr/bin/dumb-init \
	# install redis more properly
	&& cd tmp \
	&& wget http://download.redis.io/redis-stable.tar.gz \
	&& tar xvzf redis-stable.tar.gz \
	&& cd redis-stable \
	&& make \
	&& cp src/redis-server /usr/local/bin/ \
	&& cp src/redis-cli /usr/local/bin/ \
	&& mkdir -p /etc/redis \
	&& mkdir -p /var/redis \
	&& mkdir -p /var/redis/6379 \
	&& touch /var/log/redis_6379.log \
	&& cp utils/redis_init_script /etc/init.d/redis_6379 \
	&& cp redis.conf /etc/redis/6379.conf \
	&& echo "maxmemory 256mb" >> /etc/redis/6379.conf \
	&& echo "maxmemory-policy allkeys-lru" >> /etc/redis/6379.conf \
	&& update-rc.d redis_6379 defaults \
	&& rm -rf /var/lib/apt/lists/*

# import script set-up
COPY ./setup.sh /tmp/
RUN chmod +x ./tmp/setup.sh 

ENTRYPOINT [ "/usr/bin/dumb-init" , "--" ]

CMD ["sh", "-c", "/tmp/setup.sh"]

# https://redis.io/topics/quickstart
# https://redis.io/topics/lru-cache 

# for testing redis is working type "redis-cli monitor" 
# in the container and make request from wordpress
# install Query Monitor manually in wordpress site for check 
# for clear cache manually type "redis-cli flushall"