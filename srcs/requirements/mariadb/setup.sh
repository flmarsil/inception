#!/bin/bash

if [[ ! -f $MARIADB_PATH/tc.log ]]
then

	sleep 3

create_db=`mktemp`
cat > $create_db << EOF
	# Create new database
	CREATE DATABASE IF NOT EXISTS $MARIADB_DATABASE \
	DEFAULT CHARACTER SET 'utf8' COLLATE 'utf8_bin';
	# Use new database
	USE $MARIADB_DATABASE;

	# Create new user 
	CREATE USER'$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

	# Give all privileges on new database to new user
	GRANT ALL PRIVILEGES ON $MARIADB_DATABASE.* TO '$MARIADB_USER'@'%' IDENTIFIED BY '$MARIADB_PASSWORD';

	# Make changes take effect
	FLUSH PRIVILEGES;
EOF

secure_mariadb=`mktemp`
cat > $secure_mariadb << EOF
	# Make sure that NOBODY can access the server without a password
	UPDATE mysql.user SET Password=PASSWORD('$MARIADB_ROOT_PASSWORD') WHERE User='root';

	# Kill the anonymous users
	DELETE FROM mysql.user WHERE User='';

	# disallow remote login for root
	DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');

	# Kill off the demo database
	DROP DATABASE IF EXISTS test;
	DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';

	# Make changes take effect
	FLUSH PRIVILEGES;
EOF

	echo "MYSQL INSTALLATION <*********"
	/usr/bin/mysql_install_db > /dev/null 2>&1
	sleep 3
	service mysql start
	sleep 3
	echo "WORDPRESS DATA BASE CREATION <*********"
	mysql -u root < $create_db 
	sleep 3
	echo "MYSQL SECURISATION <*********"
	mysql -u root < $secure_mariadb
	sleep 3
	rm -f $secure_mariadb
	rm -f $create_db
fi

# service mysql start
/usr/bin/mysqld_safe

sleep 10
