pgbouncer_wrapper
=================

This is a wrapper around Peter Eisentraut's excellent [post](http://peter.eisentraut.org/blog/2015/03/25/retrieving-pgbouncer-statistics-via-dblink/)

A long description

To build it, just do this:

    make
    make installcheck
    make install

If you encounter an error such as:

    "Makefile", line 8: Need an operator

You need to use GNU make, which may well be installed on your system as
`gmake`:

    gmake
    gmake install
    gmake installcheck

If you encounter an error such as:

    make: pg_config: Command not found

Be sure that you have `pg_config` installed and in your path. If you used a
package management system such as RPM to install PostgreSQL, be sure that the
`-devel` package is also installed. If necessary tell the build process where
to find it:

    env PG_CONFIG=/path/to/pg_config make && make installcheck && make install

And finally, if all that fails (and if you're on PostgreSQL 8.1 or lower, it
likely will), copy the entire distribution directory to the `contrib/`
subdirectory of the PostgreSQL source tree and try it there without
`pg_config`:

    env NO_PGXS=1 make && make installcheck && make install

If you encounter an error such as:

    ERROR:  must be owner of database regression

You need to run the test suite using a super user, such as the default
"postgres" super user:

    make installcheck PGUSER=postgres

Once pgbouncer_wrapper is installed, you can add it to a database like this:

    CREATE EXTENSION pgbouncer_wrapper;

Dependencies
------------
`pgbouncer_wrapper` depends on dblink.

Copyright and License
---------------------

Copyright (c) 2015 David Fetter <david@farmersbusinessnetwork.com>.

