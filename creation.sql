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
    square      REAL    NOT NULL,
    coordinates INTEGER NOT NULL,
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
    date          TIMESTAMP NOT NULL,
    person_id     INTEGER   NOT NULL,
    FOREIGN KEY (person_id) REFERENCES Person (id),
    inv_result_id INTEGER   NOT NULL,
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

CREATE OR REPLACE FUNCTION check_animal_count()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (EXISTS (SELECT animal_count
                FROM Animal_type_territory
                WHERE (Animal_type_territory.animal_count + new.change < 0))) THEN
        RAISE EXCEPTION 'Animal_count must be not negative';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER positive_animal_count_after_inventarization
    AFTER INSERT OR UPDATE
    ON InventarizationResult
    FOR EACH ROW
EXECUTE PROCEDURE check_animal_count();