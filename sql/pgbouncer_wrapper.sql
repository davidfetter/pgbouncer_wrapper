/*
 * Author: David Fetter <david@farmersbusinessnetwork.com>
 * Created at: 2015-03-31 07:18:40 -0700
 *
 */

--
-- This is a example code genereted automaticaly
-- by pgxn-utils.

SET client_min_messages = warning;

-- If your extension will create a type you can
-- do somenthing like this
CREATE TYPE pgbouncer_wrapper AS ( a text, b text );

-- Maybe you want to create some function, so you can use
-- this as an example
CREATE OR REPLACE FUNCTION pgbouncer_wrapper (text, text)
RETURNS pgbouncer_wrapper LANGUAGE SQL AS 'SELECT ROW($1, $2)::pgbouncer_wrapper';

-- Sometimes it is common to use special operators to
-- work with your new created type, you can create
-- one like the command bellow if it is applicable
-- to your case

CREATE OPERATOR #? (
	LEFTARG   = text,
	RIGHTARG  = text,
	PROCEDURE = pgbouncer_wrapper
);
