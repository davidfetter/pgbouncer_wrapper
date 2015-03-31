\set ECHO 0
BEGIN;
\i sql/pgbouncer_wrapper.sql
\set ECHO all

-- You should write your tests

SELECT pgbouncer_wrapper('foo', 'bar');

SELECT 'foo' #? 'bar' AS arrowop;

CREATE TABLE ab (
    a_field pgbouncer_wrapper
);

INSERT INTO ab VALUES('foo' #? 'bar');
SELECT (a_field).a, (a_field).b FROM ab;

SELECT (pgbouncer_wrapper('foo', 'bar')).a;
SELECT (pgbouncer_wrapper('foo', 'bar')).b;

SELECT ('foo' #? 'bar').a;
SELECT ('foo' #? 'bar').b;

ROLLBACK;
