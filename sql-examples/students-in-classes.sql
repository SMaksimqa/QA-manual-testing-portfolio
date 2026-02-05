-- students-in-classes.sql
-- Студенты и их классы (JOIN с Class и Student_in_class)
SELECT 
    s.first_name,
    s.last_name,
    c.name AS class_name
FROM Student s
INNER JOIN Student_in_class sic ON s.id = sic.student
INNER JOIN Class c ON sic.class = c.id
ORDER BY c.name, s.last_name;
