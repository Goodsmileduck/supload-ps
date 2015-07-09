What is ``supload-ps``?
--------------------

It's simple script for upload file to cloud storage based on
`OpenStack Swift API ` Selectel


Feature
-------

* check files by `MD5` hash
* upload files to Selectel storage

Restrictions
------------
* support only less than `5Gig` file to upload

Installation
------------

Usage
-----
```
 ./supload-ps.ps1 -user USER -key PASSWORD DEST_DIR SRC_PATH
```
Changes
-------
### 0.2:
Added console output about errors and statuscodes</br>
Script for upload multiple files
### 0.1:
Find and upload only newest file
