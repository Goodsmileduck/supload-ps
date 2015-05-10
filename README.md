What is ``supload``?
--------------------

It's simple script for upload file to cloud storage based on
`OpenStack Swift API `


Feature
-------

* check files by MD5 hash
* find and upload only newest file


Restrictions
------------
* support only less than 5G file to upload

Installation
------------

Usage
-----
./supload-ps -user <USER> -key <PASSWORD> <DEST_DIR> <SRC_PATH>
Changes
-------
0.1:
* find and upload only newest file
