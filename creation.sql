CREATE TABLE Territory_coordinates
(
    id       SERIAL PRIMARY KEY,
    x        REAL    NOT NULL,
    y        REAL    NOT NULL,
    diagonal INTEGER NOT NULL
);

CREATE TABLE Territory
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(64),
    square      REAL           NOT NULL,
    coordinates INTEGER UNIQUE NOT NULL,
    FOREIGN KEY (Coordinates) REFERENCES Territory_coordinates (id)
);

CREATE TABLE Animal_type
(
    id         SERIAL PRIMARY KEY,
    type_name  VARCHAR(32) NOT NULL,
    endangered BOOLEAN
);

CREATE TABLE InventarizationResult
(
    id           SERIAL PRIMARY KEY,
    change       INTEGER NOT NULL,
    animal_type  INTEGER NOT NULL,
    FOREIGN KEY (animal_type) REFERENCES Animal_type (id),
    territory_id INTEGER NOT NULL,
    FOREIGN KEY (territory_id) REFERENCES Territory (id)
);

CREATE TABLE Animal_type_territory
(
    id             SERIAL PRIMARY KEY,
    animal_count   INTEGER NOT NULL,
    animal_type_id INTEGER NOT NULL,
    FOREIGN KEY (animal_type_id) REFERENCES Animal_type (id),
    territory_id   INTEGER NOT NULL,
    FOREIGN KEY (territory_id) REFERENCES Territory (id)
);

CREATE TABLE Person
(
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(20) NOT NULL,
    surname       VARCHAR(20) NOT NULL,
    lastname      VARCHAR(20),
    date_of_birth TIMESTAMP
);

CREATE TABLE Report
(
    id            SERIAL PRIMARY KEY,
    description   VARCHAR(1000),
    date          TIMESTAMP,
    person_id     INTEGER NOT NULL,
    FOREIGN KEY (person_id) REFERENCES Person (id),
    inv_result_id INTEGER NOT NULL,
    FOREIGN KEY (inv_result_id) REFERENCES InventarizationResult (id)
);

CREATE TABLE Warehouse
(
    id                 SERIAL PRIMARY KEY,
    name               VARCHAR(50) NOT NULL,
    responsible_person INTEGER,
    FOREIGN KEY (responsible_person) REFERENCES Person (id),
    territory_id       INTEGER     NOT NULL,
    FOREIGN KEY (territory_id) REFERENCES Territory (id)
);

CREATE TABLE Resource
(
    id           SERIAL PRIMARY KEY,
    name         VARCHAR(20) NOT NULL,
    count        INTEGER,
    warehouse_id INTEGER     NOT NULL,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse (id)
);

CREATE TABLE Role
(
    id        SERIAL PRIMARY KEY,
    role_name VARCHAR(20) NOT NULL
);

CREATE TABLE Person_role
(
    person_id INTEGER,
    FOREIGN KEY (person_id) REFERENCES Person (id),
    role_id   INTEGER,
    FOREIGN KEY (role_id) REFERENCES Role (id)
);

CREATE TABLE Brigade
(
    id               SERIAL PRIMARY KEY,
    inspectors_count INTEGER,
    name             VARCHAR(20)
);

CREATE TABLE Inspectors
(
    person_id  INTEGER,
    FOREIGN KEY (person_id) REFERENCES Person (id),
    brigade_id INTEGER,
    FOREIGN KEY (brigade_id) REFERENCES Brigade (id)
);

CREATE TABLE Territory_brigade
(
    territory_id INTEGER,
    FOREIGN KEY (territory_id) REFERENCES Territory (id),
    brigade_id   INTEGER,
    FOREIGN KEY (brigade_id) REFERENCES Brigade (id)
);

CREATE OR REPLACE FUNCTION inventarization(expected_count INTEGER, change INTEGER, type integer, ter_id integer,
                                           creator_id INTEGER) RETURNS VOID AS
$$
DECLARE
    inv_id INTEGER;
BEGIN
    IF (NOT (EXISTS (SELECT * FROM Resource WHERE (name = 'rfid' and count > expected_count)))) THEN
        RAISE EXCEPTION 'Недостаточно меток';
    end if;


    INSERT INTO InventarizationResult (change, animal_type, territory_id) VALUES (change, type, ter_id);
    inv_id := LASTVAl();
    UPDATE Animal_type_territory
    SET animal_count = (select animal_count
                        from Animal_type_territory
                        WHERE (animal_type_id = type and territory_id = ter_id)) + change
    WHERE (animal_type_id = type and territory_id = ter_id);

    INSERT INTO Report (description, date, person_id, inv_result_id) VALUES ('ZXC', NULL, creator_id, inv_id);
END ;
$$ language plpgsql;



CREATE OR REPLACE FUNCTION regulation(responsible_person INTEGER) RETURNS VOID AS
$$
DECLARE
    type_id INTEGER;
    ter_id  INTEGER;
    count   INTEGER;
    brig_id INTEGER;
BEGIN
    LOOP
        SELECT animal_type_id, territory_id, animal_count
        into type_id, ter_id, count
        from Animal_type_territory
        WHERE animal_count < 10
        LIMIT 1;
        INSERT INTO Brigade (inspectors_count, name) VALUES (0, 'regulation brigade');
        brig_id := LASTVAl();
        INSERT INTO Inspectors(person_id, brigade_id) VALUES (responsible_person, brig_id);
        UPDATE Animal_type_territory
        SET animal_count = 10
        WHERE (animal_type_id = type_id and territory_id = ter_id);
        DELETE FROM Inspectors WHERE (person_id = responsible_person and brigade_id = brig_id);
        DELETE FROM Brigade WHERE id = brig_id;
        EXIT WHEN (NOT (EXISTS (SELECT * FROM Animal_type_territory WHERE animal_count < 10)));
    END LOOP;
END ;
$$ language plpgsql;


