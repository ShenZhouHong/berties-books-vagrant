--Deprecated. Setup is completed in setup.sh.
CREATE DATABASE myBookshop;
USE myBookshop;
CREATE TABLE books (id INT AUTO_INCREMENT,name VARCHAR(50),price DECIMAL(5, 2) unsigned,PRIMARY KEY(id));
INSERT INTO books (name, price)VALUES('database book', 40.25),('Node.js book', 25.00), ('Express book', 31.99) ;
CREATE USER 'appuser'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PUT-YOUR-MYSQL-APP-PASSWORD-HERE';
GRANT ALL PRIVILEGES ON myBookshop.* TO 'appuser'@'localhost';