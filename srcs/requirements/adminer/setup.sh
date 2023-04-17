#!/bin/bash

if [[ ! -f $ADMINER_PATH/index.php ]]
then
	# Install adminer
	mkdir -p /usr/share/nginx/html/adminer 
	wget -O /usr/share/nginx/html/adminer/latest.php https://www.adminer.org/latest.php > /dev/null 2>&1
	ln -s /usr/share/nginx/html/adminer/latest.php /usr/share/nginx/html/adminer/index.php  
fi
# Force to stay in foreground and ignore daemonize option from configuration file.
php-fpm7.4 -F