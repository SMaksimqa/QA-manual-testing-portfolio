-- select-all-students.sql
-- Выбрать всех студентов с сортировкой по фамилии
SELECT 
  last_name,
  first_name,
  birthday
FROM Student
ORDER BY last_name ASC;
