#!/bin/bash

if [[ ! -f $WORDPRESS_PATH/index.php ]]
then
	# Wait for the mariadb container to finish installing
	sleep 30
	
	# Add new non-root user in the container for use wp-cli command without --allow-root flag for security reason
	sudo adduser $MARIADB_USER --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
	
	# Change new user password
	echo "$MARIADB_USER:$MARIADB_PASSWORD" | sudo chpasswd

	# Download wordpress
	sudo -u $MARIADB_USER -i -- wp core download --path=$WORDPRESS_PATH

	sleep 3

	# Create wp-config.php file
	echo "GENERATE wp-config.php file <*********"
	sudo -u $MARIADB_USER -i -- wp config create --path=$WORDPRESS_PATH --dbname=$MARIADB_DATABASE \
		--dbuser=$MARIADB_USER --dbpass=$MARIADB_PASSWORD --dbhost=$MARIADB_HOST \
		--dbprefix=$WORDPRESS_DB_PREFIX --dbcharset=$WORDPRESS_DB_CHARSET \
		--extra-php <<PHP
			define('WP_CACHE', true);
			define('WP_REDIS_PORT', 6379);
			define('WP_REDIS_HOST', 'redis');
PHP
	
	sleep 3

	# Install wordpress and set wordpress administrator user
	echo "WORDPRESS INSTALLATION & ADMINISTRATOR USER CREATION <*********"
	sudo -u $MARIADB_USER -i -- wp core install --path=$WORDPRESS_PATH \
		--url=https://$DOMAIN_NAME/ --title="42 Inception" --admin_user=$WORDPRESS_DB_ROOT_USER \
		--admin_password=$WORDPRESS_DB_ROOT_USER_PASSWORD --admin_email=$WORDPRESS_DB_ROOT_USER@student.42.fr \
		--skip-email

	sleep 3

	# Add normal wordpress user 
	echo "SIMPLE USER CREATION <*********"
	sudo -u $MARIADB_USER -i -- wp user create --path=$WORDPRESS_PATH \
		$WORDPRESS_DB_USER --user_pass=$WORDPRESS_DB_USER_PASSWORD \
		$WORDPRESS_DB_USER@student.42.fr --role=subscriber 
	
	sleep 3

	echo "INSTALL redis-cache plugin <*********"
	sudo -u $MARIADB_USER -i -- wp plugin install --path=$WORDPRESS_PATH redis-cache --activate
	chown -R www-data:www-data $WORDPRESS_PATH

	echo "CLEAR BASH HISTORY <*********"
	cat /dev/null > ~/.bash_history && history -c
fi

# Force to stay in foreground and ignore daemonize option from configuration file.
php-fpm7.4 -F