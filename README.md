pgbouncer_wrapper
=================

This is a wrapper around Peter Eisentraut's excellent [post](http://peter.eisentraut.org/blog/2015/03/25/retrieving-pgbouncer-statistics-via-dblink/)

If you've ever wanted to run SQL queries against pgbouncer's SHOW output, this
is a handy way to do just that.

To build it, just do this:

    make
    make install

Be sure that you have `pg_config` installed and in your path. If you used a
package management system such as RPM to install PostgreSQL, be sure that the
`-devel` package is also installed. If necessary tell the build process where
to find it:

    env PG_CONFIG=/path/to/pg_config make && make install

Once pgbouncer_wrapper is installed, you can add it to a database like this:

    CREATE EXTENSION pgbouncer_wrapper;

Dependencies
------------
`pgbouncer_wrapper` depends on dblink.

Copyright and License
---------------------

Copyright (c) 2015-2019 David Fetter <david@fetter.org>.
