-- count-classes-per-teacher.sql
-- Количество классов у каждого учителя (GROUP BY + JOIN)

SELECT 
    t.first_name,
    t.last_name,
    COUNT(DISTINCT sc.class) AS class_count
FROM Teacher t
INNER JOIN Schedule sc ON t.id = sc.teacher
GROUP BY t.id, t.first_name, t.last_name
HAVING COUNT(DISTINCT sc.class) > 1
ORDER BY class_count DESC;
