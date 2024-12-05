CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replication';
SELECT pg_create_physical_replication_slot('replication_slot');

CREATE EXTENSION IF NOT EXISTS postgres_fdw; 

-- Подключение к шардам (сервера и юзеры)
CREATE SERVER ru FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'RU_shard', dbname 'db');

CREATE USER MAPPING FOR db SERVER ru
    OPTIONS (user 'db', password 'db');

CREATE SERVER eu FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'EU_shard', dbname 'db');

CREATE USER MAPPING FOR db SERVER eu
    OPTIONS (user 'db', password 'db');

CREATE SERVER ww FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'WW_shard', dbname 'db');

CREATE USER MAPPING FOR db SERVER ww
    OPTIONS (user 'db', password 'db');





-- Создаем табличку для мейна
CREATE TABLE all_users (
    id SERIAL,
    fname VARCHAR(100) NOT NULL,
    sname VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    registration_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    region VARCHAR(100) NOT NULL
) PARTITION BY LIST (region);


-- Подкидываем шардовые таблички
CREATE FOREIGN TABLE dlya_FSB
    PARTITION OF all_users
        FOR VALUES IN ('RU')
    SERVER ru;

CREATE FOREIGN TABLE GDPR
    PARTITION OF all_users
        FOR VALUES IN ('EU')
    SERVER eu;

CREATE FOREIGN TABLE WORLD
    PARTITION OF all_users
        DEFAULT  
    SERVER ww;