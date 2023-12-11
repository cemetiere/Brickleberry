CREATE INDEX person_id_index ON Inspectors USING HASH(person_id); 
CREATE INDEX brigade_id_index ON Inspectors USING HASH(brigade_id); 
CREATE INDEX animal_count_index ON Animal_type_territory USING BTREE(animal_count);
CREATE INDEX warehouse_id_index ON Resourse USING HASH(warehouse_id);
CREATE INDEX resource_count_index ON Resource USING BTREE(count); 