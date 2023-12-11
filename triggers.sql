CREATE OR REPLACE FUNCTION check_animal_count()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (EXISTS (SELECT animal_count
                FROM Animal_type_territory
                WHERE (Animal_type_territory.animal_count + new.change < 0 and
                       Animal_type_territory.animal_type_id = new.animal_type))) THEN
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

CREATE OR REPLACE FUNCTION update_square()
    RETURNS TRIGGER AS
$$
BEGIN
    IF (new.diagonal > 0) THEN
        UPDATE Territory SET square=POWER(new.diagonal, 2) WHERE coordinates = new.id;
    ELSE
        RAISE EXCEPTION 'Territory diagonal must be positive';
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_square_on_coordinates_change_trigger
    AFTER INSERT OR UPDATE
    ON Territory_coordinates
    FOR EACH ROW
EXECUTE PROCEDURE update_square();

CREATE OR REPLACE FUNCTION update_inspectors_count()
    RETURNS TRIGGER AS
$$
BEGIN
    UPDATE Brigade
    SET inspectors_count=(select count(*) from Inspectors Where brigade_id = new.brigade_id)
    WHERE id = new.brigade_id;
    UPDATE Brigade
    SET inspectors_count=(select count(*) from Inspectors Where brigade_id = old.brigade_id)
    WHERE id = old.brigade_id;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_square_on_coordinates_change_trigger
    AFTER INSERT OR UPDATE OR DELETE
    ON Inspectors
    FOR EACH ROW
EXECUTE PROCEDURE update_inspectors_count();