/*
 * Author: David Fetter <david@fetter.org>
 * Created at: 2015-03-31 07:18:40 -0700
 */

-- customize start
CREATE SERVER pgbouncer FOREIGN DATA WRAPPER dblink_fdw OPTIONS (
    host '/tmp',
    port '6432',
    dbname 'pgbouncer'
);

CREATE USER MAPPING FOR PUBLIC SERVER pgbouncer OPTIONS (
    user 'pgbouncer'
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
        port integer,
        local_addr text,
        local_port integer,
        connect_time timestamp with time zone,
        request_time timestamp with time zone,
        wait integer,
        wait_us integer,
        close_needed integer,
        ptr text,
        link text,
        remote_pid integer,
        tls text,
        application_name text,
        recv_pos integer,
        pkt_pos integer,
        pkt_remain integer,
        send_pos integer,
        send_remain integer,
        pkt_avail integer,
        send_avail integer
    );
COMMENT ON VIEW pgbouncer.active_sockets IS $$Shows low-level information about sockets or only active sockets. This includes the information shown under SHOW CLIENTS and SHOW SERVERS as well as other more low-level information.$$;

COMMENT ON COLUMN pgbouncer.active_sockets."type" IS $$C, for client.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."user" IS $$Client connected user.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."database" IS $$Database name.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."state" IS $$State of the client connection, one of active, used, waiting or idle.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."addr" IS $$IP address of client.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."port" IS $$Port client is connected to.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."local_addr" IS $$Connection end address on local machine.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."local_port" IS $$Connection end port on local machine.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."connect_time" IS $$Timestamp of connect time.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."request_time" IS $$Timestamp of latest client request.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."wait" IS $$Current waiting time in seconds.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."wait_us" IS $$Microsecond part of the current waiting time.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."close_needed" IS $$Is close_needed set? 0 for no.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."ptr" IS $$Address of internal object for this connection. Used as unique ID.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."link" IS $$Address of server connection the client is paired with.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."remote_pid" IS $$Process ID, in case client connects over Unix socket and OS supports getting it.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."tls" IS $$A string with TLS connection information, or empty if not using TLS.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."application_name" IS $$A string with application name, or empty if not set.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."recv_pos" IS $$See recv_pos in include/iobuf.h.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."pkt_pos" IS $$See parse_pos in include/iobuf.h.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."pkt_remain" IS $$See the SBuf struct in include/sbuf.h.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."send_pos" IS $$See send_pos in include/sbuf.h.h.$$;
COMMENT ON COLUMN pgbouncer.active_sockets."send_remain" IS $$Apparently always 0$$;
COMMENT ON COLUMN pgbouncer.active_sockets."pkt_avail" IS $$See socket_row() in admin.c$$;
COMMENT ON COLUMN pgbouncer.active_sockets."send_avail" IS $$See socket_row() in admin.c$$;

/* SHOW CLIENTS */
CREATE VIEW pgbouncer.clients AS
    SELECT * FROM dblink('pgbouncer', 'show clients') AS _(
        type text,
        "user" text,
        database text,
        state text,
        addr text,
        port integer,
        local_addr text,
        local_port integer,
        connect_time timestamp with time zone,
        request_time timestamp with time zone,
        wait integer,
        wait_us integer,
        close_needed integer,
        ptr text,
        link text,
        remote_pid integer,
        tls text,
        application_name text
    );
COMMENT ON VIEW pgbouncer.clients IS $$Details about clients$$;

COMMENT ON COLUMN pgbouncer.clients."type" IS $$C, for client.$$;
COMMENT ON COLUMN pgbouncer.clients."user" IS $$Client connected user.$$;
COMMENT ON COLUMN pgbouncer.clients."database" IS $$Database name.$$;
COMMENT ON COLUMN pgbouncer.clients."state" IS $$State of the client connection, one of active, used, waiting or idle.$$;
COMMENT ON COLUMN pgbouncer.clients."addr" IS $$IP address of client.$$;
COMMENT ON COLUMN pgbouncer.clients."port" IS $$Port client is connected to.$$;
COMMENT ON COLUMN pgbouncer.clients."local_addr" IS $$Connection end address on local machine.$$;
COMMENT ON COLUMN pgbouncer.clients."local_port" IS $$Connection end port on local machine.$$;
COMMENT ON COLUMN pgbouncer.clients."connect_time" IS $$Timestamp of connect time.$$;
COMMENT ON COLUMN pgbouncer.clients."request_time" IS $$Timestamp of latest client request.$$;
COMMENT ON COLUMN pgbouncer.clients."wait" IS $$Current waiting time in seconds.$$;
COMMENT ON COLUMN pgbouncer.clients."wait_us" IS $$Microsecond part of the current waiting time.$$;
COMMENT ON COLUMN pgbouncer.clients."close_needed" IS $$not used for clients$$;
COMMENT ON COLUMN pgbouncer.clients."ptr" IS $$Address of internal object for this connection. Used as unique ID.$$;
COMMENT ON COLUMN pgbouncer.clients."link" IS $$Address of server connection the client is paired with.$$;
COMMENT ON COLUMN pgbouncer.clients."remote_pid" IS $$Process ID, in case client connects over Unix socket and OS supports getting it.$$;
COMMENT ON COLUMN pgbouncer.clients."tls" IS $$A string with TLS connection information, or empty if not using TLS.$$;
COMMENT ON COLUMN pgbouncer.clients."application_name" IS $$A string with application name, or empty if not set.$$;

/* SHOW CONFIG */
CREATE VIEW pgbouncer.config AS
    SELECT * FROM dblink('pgbouncer', 'show config') AS _(
        key text,
        value text,
        "default" text,
        changeable boolean
    );
COMMENT ON VIEW pgbouncer.config IS $$Show the current configuration settings.$$;

COMMENT ON COLUMN pgbouncer.config."key" IS $$Configuration variable name$$;
COMMENT ON COLUMN pgbouncer.config."value" IS $$Configuration value$$;
COMMENT ON COLUMN pgbouncer.config."default" IS $$Default value$$;
COMMENT ON COLUMN pgbouncer.config."changeable" IS $$Either yes or no, shows if the variable can be changed while running. If no, the variable can be changed only at boot time. Use SET to change a variable at run time.$$;

/* SHOW DATABASES */
CREATE VIEW pgbouncer.databases AS
    SELECT * FROM dblink('pgbouncer', 'show databases') AS _(
        name text,
        host text,
        port integer,
        database text,
        force_user text,
        pool_size integer,
        min_pool_size integer,
        reserve_pool integer,
        pool_mode text,
        max_connections integer,
        current_connections integer,
        paused integer,
        disabled integer
    );
COMMENT ON VIEW pgbouncer.databases IS $$Info about databases pgbouncer knows about$$;

COMMENT ON COLUMN pgbouncer.databases."name" IS $$Name of configured database entry.$$;
COMMENT ON COLUMN pgbouncer.databases."host" IS $$Host pgbouncer connects to.$$;
COMMENT ON COLUMN pgbouncer.databases."port" IS $$Port pgbouncer connects to.$$;
COMMENT ON COLUMN pgbouncer.databases."database" IS $$Actual database name pgbouncer connects to.$$;
COMMENT ON COLUMN pgbouncer.databases."force_user" IS $$When user is part of the connection string, the connection between pgbouncer and PostgreSQL is forced to the given user, whatever the client user.$$;
COMMENT ON COLUMN pgbouncer.databases."pool_size" IS $$Maximum number of server connections.$$;
COMMENT ON COLUMN pgbouncer.databases."min_pool_size" IS $$Minimum number of server connections.$$;
COMMENT ON COLUMN pgbouncer.databases."pool_mode" IS $$The database’s override pool_mode, or NULL if the default will be used instead.$$;
COMMENT ON COLUMN pgbouncer.databases."max_connections" IS $$Maximum number of allowed connections for this database, as set by max_db_connections, either globally or per database.$$;
COMMENT ON COLUMN pgbouncer.databases."current_connections" IS $$Current number of connections for this database.$$;
COMMENT ON COLUMN pgbouncer.databases."paused" IS $$1 if this database is currently paused, else 0.$$;
COMMENT ON COLUMN pgbouncer.databases."disabled" IS $$1 if this database is currently disabled, else 0.$$;

/* SHOW DNS_HOSTS */
CREATE VIEW pgbouncer.dns_hosts AS
    SELECT * FROM dblink('pgbouncer', 'show dns_hosts') AS _(
        hostname text,
        ttl bigint,
        addrs text
    );
COMMENT ON VIEW pgbouncer.dns_hosts IS $$Show host names in DNS cache.$$;

COMMENT ON COLUMN pgbouncer.dns_hosts."hostname" IS $$Host name.$$;
COMMENT ON COLUMN pgbouncer.dns_hosts."ttl" IS $$How many seconds until next lookup.$$;
COMMENT ON COLUMN pgbouncer.dns_hosts."addrs" IS $$Comma separated list of addresses.$$;

/* SHOW DNS_ZONES */
CREATE VIEW pgbouncer.dns_zones AS
    SELECT * FROM dblink('pgbouncer', 'show dns_zones') AS _(
        zonename text,
        serial bigint,
        count integer
    );
COMMENT ON VIEW pgbouncer.dns_zones IS $$Show zones in DNS cache.$$;

COMMENT ON COLUMN pgbouncer.dns_zones."zonename" IS $$Zone name.$$;
COMMENT ON COLUMN pgbouncer.dns_zones."serial" IS $$Current serial.$$;
COMMENT ON COLUMN pgbouncer.dns_zones."count" IS $$Host names belonging to this zone.$$;

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
        password text,
        scram_client_key bytea,
        scram_server_key bytea
    )
    WHERE NOT EXISTS (
        SELECT 1
        FROM pgbouncer.databases
        WHERE
            name <> 'pgbouncer' AND
            paused=0 AND
            disabled=0
    );
COMMENT ON VIEW pgbouncer.fds IS $$Internal command - shows list of file descriptors in use with internal state attached to them.

When the connected user has the user name "pgbouncer", connects through the
Unix socket and has same the UID as the running process, the actual FDs are
passed over the connection. This mechanism is used to do an online restart.
Note: This does not work on Windows.

Because the underlying command also blocks the internal event loop, this
view will not call that command and hence will only return rows when all
non-pgbouncer databases are at least one of paused, disabled.$$;

COMMENT ON COLUMN pgbouncer.fds."fd" IS $$File descriptor numeric value.$$;
COMMENT ON COLUMN pgbouncer.fds."task" IS $$One of pooler, client or server.$$;
COMMENT ON COLUMN pgbouncer.fds."user" IS $$User of the connection using the FD.$$;
COMMENT ON COLUMN pgbouncer.fds."database" IS $$Database of the connection using the FD.$$;
COMMENT ON COLUMN pgbouncer.fds."addr" IS $$IP address of the connection using the FD, unix if a Unix socket is used.$$;
COMMENT ON COLUMN pgbouncer.fds."port" IS $$Port used by the connection using the FD.$$;
COMMENT ON COLUMN pgbouncer.fds."cancel" IS $$Cancel key for this connection.$$;
COMMENT ON COLUMN pgbouncer.fds."link" IS $$fd for corresponding server/client. NULL if idle.$$;

/* SHOW HELP */
/* XXX Not implemented as this comes in as a NOTICE, not as a rowset. */

/* SHOW LISTS */
CREATE VIEW pgbouncer.lists AS
    SELECT * FROM dblink('pgbouncer', 'show lists') AS _(
        list text,
        items integer
    );
COMMENT ON VIEW pgbouncer.lists IS $$Show following internal information, in columns (not rows):

databases
    Count of databases.
users
    Count of users.
pools
    Count of pools.
free_clients
    Count of free clients.
used_clients
    Count of used clients.
login_clients
    Count of clients in login state.
free_servers
    Count of free servers.
used_servers
    Count of used servers.
dns_names
    Count of DNS names in the cache.
dns_zones
    Count of DNS zones in the cache.
dns_queries
    Count of in-flight DNS queries.
dns_pending
    not used
$$;

/* SHOW MEM */
CREATE VIEW pgbouncer.mem AS
    SELECT * FROM dblink('pgbouncer', 'show mem') AS _(
        name text,
        size integer,
        used integer,
        free integer,
        memtotal integer
    );
COMMENT ON VIEW pgbouncer.mem IS $$Shows low-level information about the current sizes of various internal memory allocations. The information presented is subject to change.$$;

/* SHOW POOLS */
CREATE VIEW pgbouncer.pools AS
    SELECT * FROM dblink('pgbouncer', 'show pools') AS _(
        database text,
        "user" text,
        cl_active integer,
        cl_waiting integer,
        cl_active_cancel_req integer,
        cl_cancel_req integer,
        sv_active integer,
        sv_active_cancel integer,
        sv_being_canceled integer,
        sv_idle integer,
        sv_used integer,
        sv_tested integer,
        sv_login integer,
        maxwait integer,
        maxwait_us integer,
        pool_mode text
    );
COMMENT ON VIEW pgbouncer.pools IS $$One row per distinct combination of (database, user).$$;

COMMENT ON COLUMN pgbouncer.pools."database" IS $$Database name.$$;
COMMENT ON COLUMN pgbouncer.pools."user" IS $$User name.$$;
COMMENT ON COLUMN pgbouncer.pools."cl_active" IS $$Client connections that are linked to server connection and can process queries.$$;
COMMENT ON COLUMN pgbouncer.pools."cl_waiting" IS $$Client connections have sent queries but have not yet got a server connection.$$;
COMMENT ON COLUMN pgbouncer.pools."cl_active" IS $$Client connections that are either linked to server connections or are idle with no queries waiting to be processed.$$;
COMMENT ON COLUMN pgbouncer.pools."cl_cancel_req" IS $$Client connections that have not forwarded query cancellations to the server yet.$$;
COMMENT ON COLUMN pgbouncer.pools."sv_active" IS $$Server connections that linked to client.$$;
COMMENT ON COLUMN pgbouncer.pools."sv_active_cancel" IS $$Server connections that are currently forwarding a cancel request.$$;
COMMENT ON COLUMN pgbouncer.pools."sv_being_canceled" IS $$Servers that normally could become idle but are waiting to do so until all in-flight cancel requests have completed that were sent to cancel a query on this server.$$;
COMMENT ON COLUMN pgbouncer.pools."sv_idle" IS $$Server connections that unused and immediately usable for client queries.$$;
COMMENT ON COLUMN pgbouncer.pools."sv_used" IS $$Server connections that have been idle more than server_check_delay, so they needs server_check_query to run on it before it can be used.$$;
COMMENT ON COLUMN pgbouncer.pools."sv_tested" IS $$Server connections that are currently running either server_reset_query or server_check_query.$$;
COMMENT ON COLUMN pgbouncer.pools."sv_login" IS $$Server connections currently in logging in process.$$;
COMMENT ON COLUMN pgbouncer.pools."maxwait" IS $$How long the first (oldest) client in queue has waited, in seconds. If this starts increasing, then the current pool of servers does not handle requests quick enough. Reason may be either overloaded server or just too small of a pool_size setting.$$;
COMMENT ON COLUMN pgbouncer.pools."maxwait_us" IS $$Microsecond part of the maximum waiting time.$$;
COMMENT ON COLUMN pgbouncer.pools."pool_mode" IS $$The pooling mode in use.$$;

/* SHOW SERVERS */
CREATE VIEW pgbouncer.servers AS
    SELECT * FROM dblink('pgbouncer', 'show servers') AS _(
        type text,
        "user" text,
        database text,
        state text,
        addr text,
        port integer,
        local_addr text,
        local_port integer,
        connect_time timestamp with time zone,
        request_time timestamp with time zone,
        wait integer,
        wait_us integer,
        close_needed integer,
        ptr text,
        link text,
        remote_pid integer,
        tls text,
        application_name text
    );
COMMENT ON VIEW pgbouncer.servers IS $$One row per server pgbouncer knows about.$$;

COMMENT ON COLUMN pgbouncer.servers.type IS $$S, for server.$$;
COMMENT ON COLUMN pgbouncer.servers.user IS $$User name pgbouncer uses to connect to server.$$;
COMMENT ON COLUMN pgbouncer.servers.database IS $$Database name.$$;
COMMENT ON COLUMN pgbouncer.servers.state IS $$State of the pgbouncer server connection, one of active, used or idle.$$;
COMMENT ON COLUMN pgbouncer.servers.addr IS $$IP address of PostgreSQL server.$$;
COMMENT ON COLUMN pgbouncer.servers.port IS $$Port of PostgreSQL server.$$;
COMMENT ON COLUMN pgbouncer.servers.local_addr IS $$Connection start address on local machine.$$;
COMMENT ON COLUMN pgbouncer.servers.local_port IS $$Connection start port on local machine.$$;
COMMENT ON COLUMN pgbouncer.servers.connect_time IS $$When the connection was made.$$;
COMMENT ON COLUMN pgbouncer.servers.request_time IS $$When last request was issued.$$;
COMMENT ON COLUMN pgbouncer.servers.wait IS $$Current waiting time in seconds.$$;
COMMENT ON COLUMN pgbouncer.servers.wait_us IS $$Microsecond part of the current waiting time.$$;
COMMENT ON COLUMN pgbouncer.servers.close_needed IS $$1 if the connection will be closed as soon as possible, because a configuration file reload or DNS update changed the connection information or RECONNECT was issued.$$;
COMMENT ON COLUMN pgbouncer.servers.ptr IS $$Address of internal object for this connection. Used as unique ID.$$;
COMMENT ON COLUMN pgbouncer.servers.link IS $$Address of client connection the server is paired with.$$;
COMMENT ON COLUMN pgbouncer.servers.remote_pid IS $$PID of backend server process. In case connection is made over Unix socket and OS supports getting process ID info, its OS PID. Otherwise it’s extracted from cancel packet server sent, which should be PID in case server is PostgreSQL, but it’s a random number in case server it is another PgBouncer.$$;
COMMENT ON COLUMN pgbouncer.servers.tls IS $$A string with TLS connection information, or empty if not using TLS.$$;
COMMENT ON COLUMN pgbouncer.servers.application_name IS $$A string containing the application_name set on the linked client connection, or empty if this is not set, or if there is no linked connection.$$;

/* SHOW SOCKETS */
CREATE VIEW pgbouncer.sockets AS
    SELECT * FROM dblink('pgbouncer', 'show sockets') AS _(
        type text,
        "user" text,
        database text,
        state text,
        addr text,
        port integer,
        local_addr text,
        local_port integer,
        connect_time timestamp with time zone,
        request_time timestamp with time zone,
        wait integer,
        wait_us integer,
        close_needed integer,
        ptr text,
        link text,
        remote_pid integer,
        tls text,
        application_name text,
        recv_pos integer,
        pkt_pos integer,
        pkt_remain integer,
        send_pos integer,
        send_remain integer,
        pkt_avail integer,
        send_avail integer
    );
COMMENT ON VIEW pgbouncer.sockets IS $$Shows low-level information about all sockets. This includes the information shown under SHOW CLIENTS and SHOW SERVERS as well as other more low-level information.$$;

COMMENT ON COLUMN pgbouncer.sockets."type" IS $$C, for client.$$;
COMMENT ON COLUMN pgbouncer.sockets."user" IS $$Client connected user.$$;
COMMENT ON COLUMN pgbouncer.sockets."database" IS $$Database name.$$;
COMMENT ON COLUMN pgbouncer.sockets."state" IS $$State of the client connection, one of active, used, waiting or idle.$$;
COMMENT ON COLUMN pgbouncer.sockets."addr" IS $$IP address of client.$$;
COMMENT ON COLUMN pgbouncer.sockets."port" IS $$Port client is connected to.$$;
COMMENT ON COLUMN pgbouncer.sockets."local_addr" IS $$Connection end address on local machine.$$;
COMMENT ON COLUMN pgbouncer.sockets."local_port" IS $$Connection end port on local machine.$$;
COMMENT ON COLUMN pgbouncer.sockets."connect_time" IS $$Timestamp of connect time.$$;
COMMENT ON COLUMN pgbouncer.sockets."request_time" IS $$Timestamp of latest client request.$$;
COMMENT ON COLUMN pgbouncer.sockets."wait" IS $$Current waiting time in seconds.$$;
COMMENT ON COLUMN pgbouncer.sockets."wait_us" IS $$Microsecond part of the current waiting time.$$;
COMMENT ON COLUMN pgbouncer.sockets."close_needed" IS $$Is close_needed set? 0 for no.$$;
COMMENT ON COLUMN pgbouncer.sockets."ptr" IS $$Address of internal object for this connection. Used as unique ID.$$;
COMMENT ON COLUMN pgbouncer.sockets."link" IS $$Address of server connection the client is paired with.$$;
COMMENT ON COLUMN pgbouncer.sockets."remote_pid" IS $$Process ID, in case client connects over Unix socket and OS supports getting it.$$;
COMMENT ON COLUMN pgbouncer.sockets."tls" IS $$A string with TLS connection information, or empty if not using TLS.$$;
COMMENT ON COLUMN pgbouncer.sockets."application_name" IS $$A string containing the application_name set by the client for this connection, or empty if this was not set.$$;
COMMENT ON COLUMN pgbouncer.sockets."recv_pos" IS $$See recv_pos in include/iobuf.h.$$;
COMMENT ON COLUMN pgbouncer.sockets."pkt_pos" IS $$See parse_pos in include/iobuf.h.$$;
COMMENT ON COLUMN pgbouncer.sockets."send_pos" IS $$See send_pos in include/sbuf.h.h.$$;
COMMENT ON COLUMN pgbouncer.sockets."send_remain" IS $$Apparently always 0$$;
COMMENT ON COLUMN pgbouncer.sockets."pkt_avail" IS $$See socket_row() in admin.c$$;
COMMENT ON COLUMN pgbouncer.sockets."send_avail" IS $$See socket_row() in admin.c$$;

/* SHOW STATE
This was added in anticipation of 1.19, as 1.18 does not yet include it.

CREATE VIEW pgbouncer.state AS
    SELECT * FROM dblink('pgbouncer', 'show state') AS _(
        key text,
        value text
    );
COMMENT ON VIEW pgbouncer.state IS $$Show the PgBouncer state settings. Current states are active, paused and suspended.$$;

COMMENT ON COLUMN pgbouncer.state."key" IS $$Setting name$$;
COMMENT ON COLUMN pgbouncer.state."value" IS $$Setting value, currently one of (active, paused, suspended).$$;
 */

/* SHOW STATS */
CREATE VIEW pgbouncer.stats AS
    SELECT * FROM dblink('pgbouncer', 'show stats') AS _(
        database text,
        total_xact_count bigint,
        total_query_count bigint,
        total_received bigint,
        total_sent bigint,
        total_xact_time bigint,
        total_query_time bigint,
        total_wait_time bigint,
        avg_xact_count bigint,
        avg_query_count bigint,
        avg_recv bigint,
        avg_sent bigint,
        avg_xact_time bigint,
        avg_query_time bigint,
        avg_wait_time bigint
    );
COMMENT ON VIEW pgbouncer.stats IS $$Shows statistics. In this and related commands, the total figures are since process start, the averages are updated every stats_period.$$;

COMMENT ON COLUMN pgbouncer.stats.database IS $$Statistics are presented per database.$$;
COMMENT ON COLUMN pgbouncer.stats.total_xact_count IS $$Total number of SQL transactions pooled by pgbouncer.$$;
COMMENT ON COLUMN pgbouncer.stats.total_query_count IS $$Total number of SQL queries pooled by pgbouncer.$$;
COMMENT ON COLUMN pgbouncer.stats.total_received IS $$Total volume in bytes of network traffic received by pgbouncer.$$;
COMMENT ON COLUMN pgbouncer.stats.total_sent IS $$Total volume in bytes of network traffic sent by pgbouncer.$$;
COMMENT ON COLUMN pgbouncer.stats.total_xact_time IS $$Total number of microseconds spent by pgbouncer when connected to PostgreSQL in a transaction, either idle in transaction or executing queries.$$;
COMMENT ON COLUMN pgbouncer.stats.total_query_time IS $$Total number of microseconds spent by pgbouncer when actively connected to PostgreSQL, executing queries.$$;
COMMENT ON COLUMN pgbouncer.stats.total_wait_time IS $$Time spent by clients waiting for a server in microseconds.$$;
COMMENT ON COLUMN pgbouncer.stats.avg_xact_count IS $$Average transactions per second in last stat period.$$;
COMMENT ON COLUMN pgbouncer.stats.avg_query_count IS $$Average queries per second in last stat period.$$;
COMMENT ON COLUMN pgbouncer.stats.avg_recv IS $$Average received (from clients) bytes per second.$$;
COMMENT ON COLUMN pgbouncer.stats.avg_sent IS $$Average sent (to clients) bytes per second.$$;
COMMENT ON COLUMN pgbouncer.stats.avg_xact_time IS $$Average transaction duration in microseconds.$$;
COMMENT ON COLUMN pgbouncer.stats.avg_query_time IS $$Average query duration in microseconds.$$;
COMMENT ON COLUMN pgbouncer.stats.avg_wait_time IS $$Time spent by clients waiting for a server in microseconds (average per second).$$;

/* SHOW STATS_AVERAGES */
CREATE VIEW pgbouncer.stats_averages AS
    SELECT * FROM dblink('pgbouncer', 'show stats_averages') AS _(
        database text,
        xact_count bigint,
        query_count bigint,
        bytes_received bigint,
        bytes_sent bigint,
        xact_time bigint,
        query_time bigint,
        wait_time bigint
    );
COMMENT ON VIEW pgbouncer.stats_averages IS $$Subset of SHOW STATS showing the average values (avg_).$$;

COMMENT ON COLUMN pgbouncer.stats_averages.database IS $$Statistics are presented per database.$$;
COMMENT ON COLUMN pgbouncer.stats_averages.xact_count IS $$Average transactions per second in last stat period.$$;
COMMENT ON COLUMN pgbouncer.stats_averages.query_count IS $$Average queries per second in last stat period.$$;
COMMENT ON COLUMN pgbouncer.stats_averages.bytes_received IS $$Average received (from clients) bytes per second.$$;
COMMENT ON COLUMN pgbouncer.stats_averages.bytes_sent IS $$Average sent (to clients) bytes per second.$$;
COMMENT ON COLUMN pgbouncer.stats_averages.xact_time IS $$Average transaction duration in microseconds.$$;
COMMENT ON COLUMN pgbouncer.stats_averages.query_time IS $$Average query duration in microseconds.$$;
COMMENT ON COLUMN pgbouncer.stats_averages.wait_time IS $$Time spent by clients waiting for a server in microseconds (average per second).$$;

/* SHOW STATS_TOTALS */
CREATE VIEW pgbouncer.stats_totals AS
    SELECT * FROM dblink('pgbouncer', 'show stats_totals') AS _(
        database text,
        xact_count bigint,
        query_count bigint,
        bytes_received bigint,
        bytes_sent bigint,
        xact_time bigint,
        query_time bigint,
        wait_time bigint
    );
COMMENT ON VIEW pgbouncer.stats_totals IS $$Subset of SHOW STATS showing the total values (total_).$$;

COMMENT ON COLUMN pgbouncer.stats_totals.database IS $$Statistics are presented per database.$$;
COMMENT ON COLUMN pgbouncer.stats_totals.xact_count IS $$Total number of SQL transactions pooled by pgbouncer.$$;
COMMENT ON COLUMN pgbouncer.stats_totals.query_count IS $$Total number of SQL queries pooled by pgbouncer.$$;
COMMENT ON COLUMN pgbouncer.stats_totals.bytes_received IS $$Total volume in bytes of network traffic received by pgbouncer.$$;
COMMENT ON COLUMN pgbouncer.stats_totals.bytes_sent IS $$Total volume in bytes of network traffic sent by pgbouncer.$$;
COMMENT ON COLUMN pgbouncer.stats_totals.xact_time IS $$Total number of microseconds spent by pgbouncer when connected to PostgreSQL in a transaction, either idle in transaction or executing queries.$$;
COMMENT ON COLUMN pgbouncer.stats_totals.query_time IS $$Total number of microseconds spent by pgbouncer when actively connected to PostgreSQL, executing queries.$$;
COMMENT ON COLUMN pgbouncer.stats_totals.wait_time IS $$Time spent by clients waiting for a server in microseconds.$$;

/* SHOW TOTALS */
CREATE VIEW pgbouncer.totals AS
    SELECT * FROM dblink('pgbouncer', 'show totals') AS _(
        name text,
        value bigint
    );
COMMENT ON VIEW pgbouncer.totals IS $$Like SHOW STATS but aggregated across all databases.$$;

COMMENT ON COLUMN pgbouncer.totals.name IS $$The setting$$;
COMMENT ON COLUMN pgbouncer.totals.value IS $$The value$$;

/* SHOW USERS */
CREATE VIEW pgbouncer.users AS
    SELECT * FROM dblink('pgbouncer', 'show users') AS _(
        name text,
        pool_mode text
    );
COMMENT ON VIEW pgbouncer.totals IS $$Users known to pgbouncer$$;

COMMENT ON COLUMN pgbouncer.users.name IS $$The user name$$;
COMMENT ON COLUMN pgbouncer.users.pool_mode IS $$The user’s override pool_mode, or NULL if the default will be used instead.$$;

/* SHOW VERSION */
CREATE VIEW pgbouncer.version AS
    SELECT * FROM dblink('pgbouncer', 'show version') AS _(
        version text
    );
COMMENT ON VIEW pgbouncer.version IS $$Version number$$;
COMMENT ON COLUMN pgbouncer.version.version IS $$Version number as text$$;

/* DISABLE db */
CREATE FUNCTION pgbouncer.disable(db TEXT)
RETURNS VOID
LANGUAGE sql
AS $$
    SELECT dblink_exec('pgbouncer', pg_catalog.format('%s%s', 'disable', COALESCE(' ' || pg_catalog.quote_ident(db), '')));
$$;
COMMENT ON FUNCTION pgbouncer.disable(db TEXT) IS $$Reject all new client connections on the given database.$$;

/* ENABLE db */
CREATE FUNCTION pgbouncer.enable(db TEXT)
RETURNS VOID
LANGUAGE sql
AS $$
    SELECT dblink_exec('pgbouncer', pg_catalog.format('%s%s', 'enable', COALESCE(' ' || pg_catalog.quote_ident(db), '')));
$$;
COMMENT ON FUNCTION pgbouncer.enable(db TEXT) IS $$Allow new client connections after a previous DISABLE command.$$;

/* KILL db */
CREATE FUNCTION pgbouncer.kill(db TEXT)
RETURNS VOID
LANGUAGE sql
AS $$
    SELECT dblink_exec('pgbouncer', pg_catalog.format('%s%s', 'kill', COALESCE(' ' || pg_catalog.quote_ident(db), '')));
$$;
COMMENT ON FUNCTION pgbouncer.kill(db TEXT) IS $$Immediately drop all client and server connections on given database.

New client connections to a killed database will wait until RESUME is called.$$;

/* PAUSE [db] */
CREATE FUNCTION pgbouncer.pause(db TEXT DEFAULT NULL)
RETURNS VOID
LANGUAGE sql
AS $$
SELECT
    dblink_exec('pgbouncer', pg_catalog.format('%s%s', 'pause', COALESCE(' ' || pg_catalog.quote_ident(db), '')));
$$;
COMMENT ON FUNCTION pgbouncer.pause(db TEXT) IS $$PgBouncer tries to disconnect from all servers, first waiting for all queries to
complete. The command will not return before all queries are finished. To be
used at the time of database restart.

If database name is given, only that database will be paused.

New client connections to a paused database will wait until RESUME is called.$$;

/* RECONNECT [db] */
CREATE FUNCTION pgbouncer.reconnect(db TEXT DEFAULT NULL)
RETURNS VOID
LANGUAGE sql
AS $$
SELECT
    dblink_exec('pgbouncer', pg_catalog.format('%s%s', 'reconnect', COALESCE(' ' || pg_catalog.quote_ident(db), '')));
$$;
COMMENT ON FUNCTION pgbouncer.reconnect(db TEXT) IS $$Close each open server connection for the given database, or all databases,
after it is released (according to the pooling mode), even if its lifetime is
not up yet. New server connections can be made immediately and will connect as
necessary according to the pool size settings.

This command is useful when the server connection setup has changed, for example
to perform a gradual switchover to a new server. It is not necessary to run this
command when the connection string in pgbouncer.ini has been changed and
reloaded (see RELOAD) or when DNS resolution has changed, because then the
equivalent of this command will be run automatically. This command is only
necessary if something downstream of PgBouncer routes the connections.

After this command is run, there could be an extended period where some server
connections go to an old destination and some server connections go to a new
destination. This is likely only sensible when switching read-only traffic
between read-only replicas, or when switching between nodes of a multimaster
replication setup. If all connections need to be switched at the same time,
PAUSE is recommended instead. To close server connections without waiting (for
example, in emergency failover rather than gradual switchover scenarios),
also consider KILL.$$;

/* RELOAD */
CREATE FUNCTION pgbouncer.reload()
RETURNS VOID
LANGUAGE sql
AS $$
    SELECT dblink_exec('pgbouncer', 'reload');
$$;
COMMENT ON FUNCTION pgbouncer.reload() IS $$The PgBouncer process will reload its configuration file and update changeable settings.

PgBouncer notices when a configuration file reload changes the connection
parameters of a database definition. An existing server connection to the old
destination will be closed when the server connection is next released
(according to the pooling mode), and new server connections will immediately use
the updated connection parameters.$$;

/* RESUME [db] */
CREATE FUNCTION pgbouncer.resume(db TEXT DEFAULT NULL)
RETURNS VOID
LANGUAGE sql
AS $$
SELECT
    dblink_exec('pgbouncer', pg_catalog.format('%s%s', 'resume', COALESCE(' ' || pg_catalog.quote_ident(db), '')));
$$;
COMMENT ON FUNCTION pgbouncer.resume(db TEXT) IS $$Resume work from previous KILL, PAUSE, or SUSPEND command.$$;

/* SHUTDOWN */
CREATE FUNCTION pgbouncer.shutdown()
RETURNS VOID
LANGUAGE sql
AS $$
    SELECT dblink_exec('pgbouncer', 'shutdown');
$$;
COMMENT ON FUNCTION pgbouncer.shutdown() IS $$The PgBouncer process will exit.$$;

/* SUSPEND */
CREATE FUNCTION pgbouncer.suspend()
RETURNS VOID
LANGUAGE sql
AS $$
    SELECT dblink_exec('pgbouncer', 'suspend');
$$;
COMMENT ON FUNCTION pgbouncer.suspend() IS $$All socket buffers are flushed and PgBouncer stops listening for data on them.
The command will not return before all buffers are empty. To be used at the time
of PgBouncer online reboot.

New client connections to a suspended database will wait until RESUME is called.$$;

/* WAIT_CLOSE [db] */
CREATE FUNCTION pgbouncer.wait_close(db TEXT DEFAULT NULL)
RETURNS VOID
LANGUAGE sql
AS $$
SELECT
    dblink_exec('pgbouncer', pg_catalog.format('%s%s', 'wait_close', COALESCE(' ' || pg_catalog.quote_ident(db), '')));
$$;
COMMENT ON FUNCTION pgbouncer.wait_close(db TEXT) IS $$Wait until all server connections, either of the specified database or of all
databases, have cleared the “close_needed” state (see SHOW SERVERS). This can be
called after aRECONNECT** or RELOAD to wait until the respective configuration
change has been fully activated, for example in switchover scripts.$$;

/* SET key = value */
CREATE FUNCTION pgbouncer."set"(key TEXT, value TEXT)
RETURNS VOID
LANGUAGE SQL
AS $$
SELECT
    dblink_exec('pgbouncer', pg_catalog.format('SET %s=%L', key, value));
$$;
COMMENT ON FUNCTION pgbouncer."set"(key TEXT, value TEXT) IS $$Changes a configuration setting (see also the config VIEW).$$;
