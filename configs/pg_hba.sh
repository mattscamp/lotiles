echo "local   all             postgres                                peer
local   all             $PG_USER                                    md5
host    all             all                 ::1/128              md5" > /etc/postgresql/9.3/main/pg_hba.conf