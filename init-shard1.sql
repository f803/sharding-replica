CREATE USER replicator WITH REPLICATION ENCRYPTED PASSWORD 'replication';
SELECT pg_create_physical_replication_slot('replication_slot');

CREATE TABLE dlya_FSB (
    id SERIAL,
    fname VARCHAR(100) NOT NULL,
    sname VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL,
    region VARCHAR(100) NOT NULL,
    registration_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id, region), 
    UNIQUE (email, region),    
    CONSTRAINT check_region CHECK (region = 'RU')
);