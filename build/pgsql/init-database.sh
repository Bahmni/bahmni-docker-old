#!/bin/bash

{ gosu postgres pg_ctl start -w && gosu postgres /usr/bin/psql -Upostgres < /tmp/db.pgdump >/dev/null && gosu postgres pg_ctl stop -w
} && /bin/rm -f ${DB_PG_DUMP_FILE}
