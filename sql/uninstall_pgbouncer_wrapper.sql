/*
 * Author: David Fetter <david@farmersbusinessnetwork.com>
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

DROP OPERATOR #? (text, text);
DROP FUNCTION pgbouncer_wrapper(text, text);
DROP TYPE pgbouncer_wrapper CASCADE;
COMMIT;
