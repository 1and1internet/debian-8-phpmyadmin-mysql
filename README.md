# MySQL and phpMyAdmin on Debian 8 (Jessie) Docker Image

## Description

This image provides an instance of [MySQL](https://www.mysql.com/) and [phpMyAdmin](https://www.phpmyadmin.net/) running on [Debian 8](https://www.debian.org/). This is created specifically to be run under [OpenShift Origin](https://www.openshift.org/) and [Kubernetes](https://kubernetes.io/), as well as any other standard Docker environment.

**Ensure you specify a user id (UID) other than zero. Running as root is not a supported configuration.**

## Current Status: Work In Progress

This image is currently an experimental work in progress.

## Environment Variables

 * ``MYSQL_INITDB_SKIP_TZINFO`` - Any value causes timezone information import to be skipped.
 * ``MYSQL_ONETIME_PASSWORD`` - Any value causes all admin users to have their passwords expired immediately. Password will need to be changed before the user can be used.
 * ``MYSQL_ROOT_PASSWORD`` - Cause an admin user called 'root' to be created with the specified password.
 * ``MYSQL_RANDOM_ROOT_PASSWORD`` - Cause an admin user called 'root' to be created with a random password. Overrides any password specified in MYSQL_ROOT_PASSWORD.
 * ``MYSQL_ALLOW_EMPTY_PASSWORD`` - Cause an admin user called 'root' to be created even if no password is being set.
 * ``MYSQL_ADMIN_USER`` - Creates an admin user named after the value of this variable.
 * ``MYSQL_ADMIN_PASSWORD`` - Specifies the password for the admin user created by specifying MYSQL_ADMIN_USER. Does nothing if MYSQL_ADMIN_USER is not specified.
 * ``MYSQL_RANDOM_ADMIN_PASSWORD`` - Causes a random password to be set for the admin user created by specifying MYSQL_ADMIN_USER. Overrides any password specified in MYSQL_ADMIN_PASSWORD. Does nothing if MYSQL_ADMIN_USER is not specified.
 * ``MYSQL_USER`` - Creates a standard (non-admin) user named after the value of this variable. Will be given full access to any database created using MYSQL_DATABASE. Does nothing if MYSQL_PASSWORD is not specified.
 * ``MYSQL_PASSWORD`` - Specifies the password for the standard user created by specifying MYSQL_USER. Does nothing if MYSQL_USER is not specified.
 * ``MYSQL_DATABASE`` - Causes a blank database to be created named after the value of this variable. Any standard user created with MYSQL_USER will be granted full access to this database.
 * ``PMA_ARBITRARY``
 * ``PMA_HOST``
 * ``PMA_VERBOSE``
 * ``PMA_PORT``
 * ``PMA_HOSTS``
 * ``PMA_PORTS``
 * ``PMA_CONTROL_HOST``
 * ``PMA_CONTROL_PORT``
 * ``PMA_CONTROL_USER``
 * ``PMA_CONTROL_PASSWORD``
 * ``PMA_ABSOLUTE_URI``
 * ``PMA_USER``
 * ``PMA_PASSWORD``

## Mysql Package

In order to save space, the mysql binary tarball is being downloaded. The unrequired content is discarded and the remaining binaries are stripped.

A fake mysql-server package has been created using the equivs package, i.e:
 . apt-get install equivs
 . equivs-control mysql-server
 . <edit the file the gets created>
 . equivs-build mysql-server
