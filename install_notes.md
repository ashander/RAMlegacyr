
# install notes: 
Circa 2011: Following doesn't work on several installs, fails with problem finding `libpq-fe.h`

 ```r
 install.packages('RPostgreSQL', type='source', configure.args="--with-pgsql-libraries=/opt/local/lib/postgresql83/ --with-pgsql-includes=/opt/local/include/postgresql83/")
 ```

 for install from mac ports, `install.packages('RPostgreSQL')` worked, because it found pg_config... `/opt/local/lib/postgresql83/bin/pg_config`
 with PATH set properly install works

Connection details:
```sh
## [ramlegacy]
## Driver=/usr/local/lib/psqlodbcw.so
## Description=Ram legacy database
## Servername=nautilus-vm.mathstat.dal.ca
## Port=5432
## Protocol=6.4
## FetchBufferSize=99
## Username=srdbuser
## Password=srd6us3r!
## Database=srdb
## ReadOnly=yes
## Debug=1
## CommLog=1
```
