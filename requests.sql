SELECT * FROM Inspectors  
JOIN Person ON Person.id = Inspectors.person_id
JOIN Brigade ON Brigade.id = Inspectors.brigade_id;
WHERE Brigade.name = X;

SELECT * FROM Animal_type_territory 
JOIN Animal_type ON Animal_type.id = Animal_type_territory.animal_type_id
JOIN Territory ON Territory.id = Animal_type_territory.territory_id
WHERE Territory.name = X;

SELECT * FROM Territory 
JOIN Territory_coordinates ON Territory.coordinates = coordinates.id;

SELECT * FROM Warehouse
JOIN Resource ON Resource.warehouse_id = Warehouse.id
WHERE Warehouse.name = X;