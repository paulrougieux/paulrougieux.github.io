---
title: "MySQL Commands"
output: 
  html_document: 
    toc: yes
    toc_float: true
---

This page is the continuation of [my blog post on MySQL commands](https://paulremote.blogspot.de/2013/12/mysql-commands.html)

# MySQL Setup, user and db creation
 As root, create a database and grant permissions to a new user
To connect to the mysql client as root

    mysql -u root -p 

You'll be prompted for the password.

How to create a new user

    CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';

Create a database

    create database databasename 

Connect to a database

    connect databasename

 Grant permissions to a user

    GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';

Then you can log out of mysql

    quit 


# As a user 

To connect to the mysql client as a user

    mysql -u username -p 

If you have the correct privileges, you can also create a database with a pipe. How to create a database

    echo "create database databasename" | mysql -u username -p 

Load a dump

    cat file.sql | mysql -u username -p databasename

# Graphical client
On Ubuntu, I used mysql navigator by shi bok jang.
On Debian, I used  mysql workbench

# More on users
Change password, as the user itself or as root:

    SET PASSWORD FOR 'Karl'@'localhost' = PASSWORD('cleartext password');

As root , list all users

    SELECT User FROM mysql.user;

As root , delete a user

    drop user Rasdfas@localhost;

MySQL documentation on adding user accounts.


# More on databases

Commands below work if your shell user name is the same as your mysql user name. If it's dufferent add -u username to the command.

List all databases (in mysql client)

    show databases 

Delete a database (in the mysql client)

    DROP database databasename;

Rename a database  (in the shell)

    mysqladmin -p create new_database
    mysqldump -p old_database | mysql -p new_database

After you have verified that everything is in order

    drop database old_database

Move a table from one database to another

    mysqldump -p database_1 table_name | mysql -p database_2 

Back up only part of a database with the where option

    mysqldump -p -w"productcode=440799" tradeflows raw_flow_yearly > sawnwood99raw.sql

Back up only the structure of a database (not the data)

    mysqldump -p -d tradeflows > tradeflows.sql

Load a dump into a database :

    cat file.sql | mysql -u username -p databasename

# Configuration file my.cnf
It's not desirable to share user name and password in software disseminated over the internet. User name, password and database names can be placed under groups in the configuration file. For example for a given project enter this group in ~/.my.cnf

    [project_name]

    user = user
    password = password
    host = localhost
    database = dbname

Then simply specify group=project_name to the client that accesses the database. 
