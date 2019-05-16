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

You can find how many clients are coming from each address like this:

```sql
SELECT
    addr, count(*)
FROM
    clients
GROUP BY addr
ORDER BY count(*) DESC;
```

You can change pgbouncer settings like this:
```sql
SELECT set('default_pool_size', '300');
```

To see whether the current configuration is out of step with `pgbouncer.ini`, you can do:

```sql
SELECT
    count(*) > 0 AS "out of step"
FROM
    regexp_split_to_table(
        pg_read_file('/etc/pgbouncer/pgbouncer.ini'),
        E'\n'
    ) WITH ORDINALITY AS t(l, o)
JOIN
    config c
    ON (
        c.key =
        (string_to_array(t.l, ' = '))[1]
    )
WHERE
    format('%s = %s', key, value) <> l;
```

Dependencies
------------
`pgbouncer_wrapper` depends on dblink.

Copyright and License
---------------------

Copyright (c) 2015-2019 David Fetter <david@fetter.org>.
