#!/bin/bash
set -e
mkdir -pv /var/lib/postgresql/tablespaces/{cliente,tablespace1,tablespace2,tablespace3,tablespace4,tablespace5,tablespace6,tablespace7}
chown -R postgres:postgres /var/lib/postgresql/tablespaces