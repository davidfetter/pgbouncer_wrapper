/*
 * Author: David Fetter <david@fetter.org>
 * Created at: 2015-03-31 07:18:40 -0700
 *
 */

--
-- This is a example code genereted automaticaly
-- by pgxn-utils.

SET client_min_messages = warning;

BEGIN;

-- You can use this statements as
-- template for your extension.

DROP VIEW pgbouncer.active_sockets CASCADE;
DROP VIEW pgbouncer.clients CASCADE;
DROP VIEW pgbouncer.config CASCADE;
DROP VIEW pgbouncer.databases CASCADE;
DROP VIEW pgbouncer.dns_hosts CASCADE;
DROP VIEW pgbouncer.dns_zones CASCADE;
DROP VIEW pgbouncer.fds CASCADE;
DROP VIEW pgbouncer.lists CASCADE;
DROP VIEW pgbouncer.mem CASCADE;
DROP VIEW pgbouncer.pools CASCADE;
DROP VIEW pgbouncer.servers CASCADE;
DROP VIEW pgbouncer.sockets CASCADE;
DROP VIEW pgbouncer.stats CASCADE;
DROP VIEW pgbouncer.stats_averages CASCADE;
DROP VIEW pgbouncer.stats_totals CASCADE;
DROP VIEW pgbouncer.totals CASCADE;
DROP VIEW pgbouncer.users CASCADE;
DROP FUNCTION pgbouncer.disable(db TEXT);
DROP FUNCTION pgbouncer.enable(db TEXT);
DROP FUNCTION pgbouncer.kill(db TEXT);
DROP FUNCTION pgbouncer.pause(db TEXT);
DROP FUNCTION pgbouncer.reconnect(db TEXT);
DROP FUNCTION pgbouncer.reload();
DROP FUNCTION pgbouncer.resume(db TEXT);
DROP FUNCTION pgbouncer.shutdown();
DROP FUNCTION pgbouncer.suspend();
DROP FUNCTION pgbouncer.wait_close(db TEXT);
DROP FUNCTION pgbouncer."set"(key TEXT, value TEXT);
DROP SCHEMA pgbouncer CASCADE;
DROP SERVER pgbouncer CASCADE;

COMMIT;
