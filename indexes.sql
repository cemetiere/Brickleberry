CREATE INDEX person_id_index ON Inspectors(person_id) USING HASH; 
CREATE INDEX brigade_id_index ON Inspectors(brigade_id) USING HASH; 
CREATE INDEX animal_count_index ON Animal_type_territory(animal_count) USING BTREE;
CREATE INDEX warehouse_id_index ON Resourse(warehouse_id) USING HASH;
CREATE INDEX resource_count_index ON Resource(count) USING BTREE; 