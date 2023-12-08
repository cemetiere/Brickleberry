INSERT INTO Person(name, surname, lastname, date_of_birth) VALUES 
    ("Андрей", "Кириллов", "Андреевич", "07-08-2003"),
    ("Александр", "Григорьев", "Алексеевич", "01-02-2003"),
    ("Мария", "Муськина", "Андреевна", "09-05-2005"),
    ("Дария", "Пуськина", "Андреевна", "07-11-2003"),
    ("Вария", "Буськина", "Андреевна", "08-05-2002"),
    ("Сария", "Руськина", "Андреевна", "07-12-2001"),
    ("Шария", "Дуськина", "Андреевна", "03-09-2000"),
    ("Петр", "Руськин", "Сергеевич", "07-12-2001"),
    ("Василий", "Дуськин", "Кириллович", "03-09-2000");
INSERT INTO Role(role_name) VALUES
    ("Управляющий"), ("Инспектор"), ("Научный отдел"), ("Хозотдел");
INSERT INTO Person_role(person-id, role-id) VALUES
    (1, 1),(2, 1),(3, 2),(4, 2),(5, 2),(6, 3),(7, 4),(8,2),(9,2);
INSERT INTO Brigade(name, inspectors_count) VALUES
    ("Домбыта", 3),
    ("Универсам", 2);
INSERT INTO Inspectors(Person_id, Brigade_id) VALUES
    (3, 1), (4,1), (5, 1), (8, 2), (9, 2);
INSERT INTO Territory_coordinates(X, Y, diagonal) VALUES
    (1, 1, 4),(4, 1, 5), (1, 4, 9) ;
INSERT INTO Territory(name, square, coordinates) VALUES
    ("Домбыта", 8, 1),
    ("Универсам", 12.5, 2),
    ("Разъезд", 40.5, 3);
INSERT INTO Territory_brigade(territory_id, brigade_id) VALUES
    (1, 1), (2, 2), (3, 1), (3, 2);
INSERT INTO Warehouse(territory_id, name, responsible_person) VALUES
    (1, "Склад 1", 4),
    (2, "Склад 2", 3),
    (3, "Склад 3", 5);
INSERT INTO Resourse(name, count, warehouse_id) VALUES
    ("Сено", 10, 1),
    ("Сено", 20, 2),
    ("Сено", 30, 3),
    ("Лопата", 5,1),
    ("Лопата", 7,2),
    ("Лопата", 9,3);
INSERT INTO Animal_type(type_name, endangered) VALUES
    ("Лось", false),
    ("Тигр", false),
    ("Медведь", false),
    ("Косуля" false),
    ("Кошка", false);
INSERT INTO Animal_type_territory(animal_type_id, territory_id, animal_count) VALUES
    (1, 1, 15),
    (2, 1, 5),
    (3, 1, 2),
    (5, 2, 142),
    (4, 3, 12),
    (3, 3, 9);
INSERT INTO InventarizationResult(animal_type, change, territory_id) VALUES
    (2, 1, 1),
    (5, 2, 5);
INSERT INTO Report(person_id, inv_result_id, date, description) VALUES 
    (3, 1, "08-12-2023", "Тигрица родила"),
    (4, 2, "08-12-2023", "Котята плодятся");