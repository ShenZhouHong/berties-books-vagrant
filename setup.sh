#!/bin/bash

# Source environment variables
source /vagrant/.env

# Install dependencies
apt-get update
apt-get install -y nodejs npm mysql-server

# Install nodejs dependencies
cd /vagrant/
npm install

# Configure MYSQL
# First we set root password
echo "Configuring root password for MYSQL"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_ROOT_PW';"

# Then we configure the databases. These commands are analogous to ./create_db.sql
echo "Creating $MYSQL_DATABASE database"
mysql -u root --password=$MYSQL_ROOT_PW -e "CREATE DATABASE $MYSQL_DATABASE;"

echo "Creating tables for $MYSQL_DATABASE database"
mysql -u root --password=$MYSQL_ROOT_PW -D $MYSQL_DATABASE -e "CREATE TABLE books (id INT AUTO_INCREMENT,name VARCHAR(50),price DECIMAL(5, 2) unsigned,PRIMARY KEY(id));"
mysql -u root --password=$MYSQL_ROOT_PW -D $MYSQL_DATABASE -e "INSERT INTO books (name, price)VALUES('database book', 40.25),('Node.js book', 25.00), ('Express book', 31.99);"

echo "Creating application user $MYSQL_USERNAME"
mysql -u root --password=$MYSQL_ROOT_PW -e "CREATE USER '$MYSQL_USERNAME'@'$MYSQL_HOST' IDENTIFIED WITH mysql_native_password BY '$MYSQL_PASSWORD';"

echo "Granting permissions for application user $MYSQL_USERNAME"
mysql -u root --password=$MYSQL_ROOT_PW -e "GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USERNAME'@'$MYSQL_HOST';"

echo "Development environment setup is complete. Please IGNORE any mysql warnings on insecure passwords."
echo "In order to ssh into the development environment, run 'vagrant ssh' and then 'cd /vagrant/"
echo "Begin the nodejs server by running 'nodejs index.js' and navigate to localhost:8000 on your browser."
echo "For more information, see README.md."