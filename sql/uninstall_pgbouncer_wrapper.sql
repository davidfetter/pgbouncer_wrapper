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

DROP VIEW active_sockets CASCADE;
DROP VIEW clients CASCADE;
DROP VIEW config CASCADE;
DROP VIEW databases CASCADE;
DROP VIEW dns_hosts CASCADE;
DROP VIEW dns_zones CASCADE;
DROP VIEW fds CASCADE;
DROP VIEW lists CASCADE;
DROP VIEW mem CASCADE;
DROP VIEW pools CASCADE;
DROP VIEW servers CASCADE;
DROP VIEW sockets CASCADE;
DROP VIEW stats CASCADE;
DROP VIEW stats_averages CASCADE;
DROP VIEW stats_totals CASCADE;
DROP VIEW totals CASCADE;
DROP VIEW users CASCADE;
DROP SCHEMA pgbouncer CASCADE;
DROP SERVER pgbouncer CASCADE;

COMMIT;
