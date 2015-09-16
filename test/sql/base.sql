\set ECHO 0
BEGIN;
CREATE EXTENSION IF NOT EXISTS dblink;
CREATE EXTENSION pgbouncer_wrapper;
\set ECHO all

-- Make sure that the views are actually there.

SELECT * FROM pgbouncer.active_sockets WHERE false;
SELECT * FROM pgbouncer.clients WHERE false;
SELECT * FROM pgbouncer.config WHERE false;
SELECT * FROM pgbouncer.databases WHERE false;
SELECT * FROM pgbouncer.dns_hosts WHERE false;
SELECT * FROM pgbouncer.dns_zones WHERE false;
SELECT * FROM pgbouncer.fds WHERE false;
SELECT * FROM pgbouncer.lists WHERE false;
SELECT * FROM pgbouncer.mem WHERE false;
SELECT * FROM pgbouncer.pools WHERE false;
SELECT * FROM pgbouncer.servers WHERE false;
SELECT * FROM pgbouncer.sockets WHERE false;
SELECT * FROM pgbouncer.stats WHERE false;
SELECT * FROM pgbouncer.users WHERE false;

ROLLBACK;
