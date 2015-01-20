# RTPI

A Ruby script for importing information from PuppetDB into Racktables.

The script will add the following fields to physical server:

* Processor
* Processor Cores
* Total RAM
* Serial Number
* Model
* Operating System
* Operating System Release
* Warranty Start Date (Dell only)
* Warranty End Date (Dell only)
* Warranty Level (Dell only)
* FQDN

The following fields will be added to a VM:
* Operating System
* Operating System Release
* FQDN

## Installation

### Requirements

This script require the **mysql2** ruby gem. This can be installed as follows: ``` sudo gem install mysql2```

### Install the script

Once the requirement have been installed, clone the git repo:

```
git clone https://github.com/tjayl/RTPI.git
```

## Configuration

You will need to edit the **config.rb** file to suit your enviroment.

`PUPPETDB_HOST`
The machine that is running the PuppetDB API.

`MYSQL_SOCKET`
The UNIX socket for mysqld running on the machines.

`MYSQL_HOST`
The host of the MySQL server.

`MYSQL_PORT`
The port of the MySQL server.

`MYSQL_DB`
The Racktables databases.

`MYSQL_USER`
The Racktables MySQL user.

`MYSQL_PASSWORD`
The Racktables MySQL password.

By default the `MYSQL_SOCKET` option will be prefered over the `MYSQL_HOST` as the script expects to be running on the machine with the mysql database installed.
