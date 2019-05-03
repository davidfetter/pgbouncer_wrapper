/*
 * Author: David Fetter <david@farmersbusinessnetwork.com>
 * Created at: 2015-03-31 07:18:40 -0700
 *
 * Update for pgbouncer v1.9.0: Michael Vitale <michaeldba@sqlexec.com>
 */

-- customize start
CREATE SERVER pgbouncer FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    host 'localhost',
    port '6432',
    dbname 'pgbouncer'
);

CREATE USER MAPPING FOR PUBLIC SERVER pgbouncer OPTIONS (
    user 'postgres'
);
-- customize stop

CREATE SCHEMA pgbouncer;


/* SHOW ACTIVE_SOCKETS */
CREATE VIEW pgbouncer.active_sockets AS
    SELECT * FROM dblink('pgbouncer', 'show active_sockets') AS _(
        type text,
        "user" text,
        database text,
        state text,
        addr text,
        port int,
        local_addr text,
        local_port int,
        connect_time timestamp,
        request_time timestamp,
        wait int,
        wait_us int,
        close_needed int,
        ptr text,
        link text,
        remote_pid int,
        tls text,
        recv_pos int,
        pkt_pos int,
        pkt_remain int,
        send_pos int,
        send_remain int,
        pkt_avail int,
        send_avail int
    );

/* SHOW CLIENTS */
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
        connect_time timestamp,
        request_time timestamp,
        wait int,
        wait_us int,
        close_needed int,
        ptr text,
        link text,
        remote_pid integer,
        tls text
    );

/* SHOW CONFIG */
CREATE VIEW pgbouncer.config AS
    SELECT * FROM dblink('pgbouncer', 'show config') AS _(
        key text,
        value text,
        changeable boolean
    );

/* SHOW DATABASES */
CREATE VIEW pgbouncer.databases AS
    SELECT * FROM dblink('pgbouncer', 'show databases') AS _(
        name text,
        host text,
        port int,
        database text,
        force_user text,
        pool_size int,
        reserve_pool int,
        pool_mode text,
        max_connections int,
        current_connections int,
        paused int,
        disabled int
    );

/* SHOW DNS_HOSTS */
CREATE VIEW pgbouncer.dns_hosts AS
    SELECT * FROM dblink('pgbouncer', 'show dns_hosts') AS _(
        hostname text,
        ttl bigint,
        addrs text
    );

/* SHOW DNS_ZONES */
CREATE VIEW pgbouncer.dns_zones AS
    SELECT * FROM dblink('pgbouncer', 'show dns_zones') AS _(
        zonename text,
        serial bigint,
        count int
    );

/* SHOW FDS */
CREATE VIEW pgbouncer.fds AS
    SELECT * FROM dblink('pgbouncer', 'show fds') AS _(
        fd integer,
        task text,
        "user" text,
        database text,
        addr text,
        port integer,
        cancel bigint,
        link integer,
        client_encoding text,
        std_strings text,
        datestyle text,
        timezone text,
        password text
    );

/* SHOW LISTS */
CREATE VIEW pgbouncer.lists AS
    SELECT * FROM dblink('pgbouncer', 'show lists') AS _(
        list text,
        items int
    );

/* SHOW HELP */
/* XXX Not implemented as this comes in as a NOTICE, not as a rowset. */

/* SHOW MEM */
CREATE VIEW pgbouncer.mem AS
    SELECT * FROM dblink('pgbouncer', 'show mem') AS _(
        name text,
        size integer,
        used integer,
        free integer,
        memtotal integer
    );

/* SHOW POOLS */
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
        maxwait int,
        maxwait_us int,
        pool_mode text
    );

/* SHOW SERVERS */
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
        connect_time timestamp,
        request_time timestamp,
        wait int,
        wait_us int,
        close_needed int,
        ptr text,
        link text,
        remote_pid int,
        tls text
    );

/* SHOW SOCKETS */
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
        connect_time timestamp,
        request_time timestamp,
        wait int,
        wait_us int,
        close_needed int,
        ptr text,
        link text,
        remote_pid int,
        tls text,
        recv_pos int,
        pkt_pos int,
        pkt_remain int,
        send_pos int,
        send_remain int,
        pkt_avail int,
        send_avail int
    );

/* SHOW STATS */
CREATE VIEW pgbouncer.stats AS
    SELECT * FROM dblink('pgbouncer', 'show stats') AS _(
        database text,
        total_xact_count bigint,
        total_query_count bigint,
        total_received    bigint,
        total_sent        bigint,
        total_xact_time   bigint,
        total_query_time  bigint,
        total_wait_time   bigint,
        avg_xact_count    bigint,
        avg_query_count   bigint,
        avg_recv          bigint,
        avg_sent          bigint,
        avg_xact_time     bigint,
        avg_query_time    bigint,
        avg_wait_time     bigint
    );

/* SHOW USERS */
CREATE VIEW pgbouncer.users AS
    SELECT * FROM dblink('pgbouncer', 'show users') AS _(
        name text,
        pool_mode text
    );

/* SHOW VERSION */
/* XXX Not implemented as this comes in as a NOTICE, not as a rowset. */
