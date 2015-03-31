/*
 * Author: David Fetter <david@farmersbusinessnetwork.com>
 * Created at: 2015-03-31 07:18:40 -0700
 *
 */

-- customize start
CREATE SERVER pgbouncer FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    host 'localhost',
    port '6432',
    dbname 'pgbouncer'
);

CREATE USER MAPPING FOR PUBLIC SERVER pgbouncer OPTIONS (
    user 'pgbouncer'
);
-- customize stop

CREATE SCHEMA pgbouncer;

CREATE VIEW pgbouncer.clients AS
    SELECT * FROM dblink('pgbouncer', 'show clients') AS _(
        type text,
        "user" text,
        database text,
        state text,
        addr text,
        port int,
        local_addr text,
        local_port int,
        connect_time timestamp with time zone,
        request_time timestamp with time zone,
        ptr text,
        link text
    );

CREATE VIEW pgbouncer.config AS
    SELECT * FROM dblink('pgbouncer', 'show config') AS _(
        key text,
        value text,
        changeable boolean
    );

CREATE VIEW pgbouncer.databases AS
    SELECT * FROM dblink('pgbouncer', 'show databases') AS _(
        name text,
        host text,
        port int,
        database text,
        force_user text,
        pool_size int,
        reserve_pool int
    );

CREATE VIEW pgbouncer.lists AS
    SELECT * FROM dblink('pgbouncer', 'show lists') AS _(
        list text,
        items int
    );

CREATE VIEW pgbouncer.pools AS
    SELECT * FROM dblink('pgbouncer', 'show pools') AS _(
        database text,
        "user" text,
        cl_active int,
        cl_waiting int,
        sv_active int,
        sv_idle int,
        sv_used int,
        sv_tested int,
        sv_login int,
        maxwait int
    );

CREATE VIEW pgbouncer.servers AS
    SELECT * FROM dblink('pgbouncer', 'show servers') AS _(
        type text,
        "user" text,
        database text,
        state text,
        addr text,
        port int,
        local_addr text,
        local_port int,
        connect_time timestamp with time zone,
        request_time timestamp with time zone,
        ptr text,
        link text
    );

CREATE VIEW pgbouncer.sockets AS
    SELECT * FROM dblink('pgbouncer', 'show sockets') AS _(
        type text,
        "user" text,
        database text,
        state text,
        addr text,
        port int,
        local_addr text,
        local_port int,
        connect_time timestamp with time zone,
        request_time timestamp with time zone,
        ptr text,
        link text,
        recv_pos int,
        pkt_pos int,
        pkt_remain int,
        send_pos int,
        send_remain int,
        pkt_avail int,
        send_avail int
    );
