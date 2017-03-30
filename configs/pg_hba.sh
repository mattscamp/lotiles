echo "local   all             postgres                                peer
local   all             osm                                     trust
host    all             all                 ::1/128              trust" > /etc/postgresql/9.3/main/pg_hba.conf