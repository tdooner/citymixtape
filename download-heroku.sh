#!/bin/bash
set -exuo pipefail

#postgres -D /usr/local/var/postgres &
#postgres_pid=$!
#heroku pg:pull DATABASE_URL mytownplaylist
pg_restore --schema-only tmp/db.dump > tmp/dbdump.sql
pg_restore --data-only tmp/db.dump > tmp/dbdata.sql

# 1. remove the SETs at the beginning:
sed -i -e '/PostgreSQL database dump/,/-- Name: artists/d' tmp/dbdump.sql

# 2. remove "OWNER TO"
sed -i -e 's/^ALTER TABLE .* OWNER TO .*$//' tmp/dbdump.sql

# 3. Remove sequence shenanigans
sed -i -e '/^CREATE SEQUENCE*/,/;/d' tmp/dbdump.sql
sed -i -e 's/^ALTER SEQUENCE .*$//' tmp/dbdump.sql

# 4. "ALTER TABLE ONLY" -> "ALTER TABLE"
sed -i -e 's/^ALTER TABLE ONLY/ALTER TABLE/' tmp/dbdump.sql

# 5. Remove this nextval function call -- what is that anyway?
sed -i -e 's/.*ALTER COLUMN .* SET DEFAULT nextval.*//g' tmp/dbdump.sql

# 6. Remove "USING btree"
sed -i -e 's/USING btree //' tmp/dbdump.sql

rm db/development.sqlite3
sqlite3 db/development.sqlite3 < tmp/dbdump.sql || true

# 6. Try the whole separator thing
for TABLE in $(grep -oE '^COPY ([^ ]+)' tmp/dbdata.sql | sed -e 's/COPY //'); do
  echo "Importing $TABLE"

  sed -n -e "/^COPY ${TABLE}.*/,/^\\\./p" tmp/dbdata.sql |
    sed -e "s#\\\N##g" |
    tail -n +2 > tmp/dbdata-${TABLE}.sql

  sqlite3 db/development.sqlite3 <<-SQLITE || true
.separator "\t"
.import tmp/dbdata-${TABLE}.sql $TABLE
SQLITE
done
