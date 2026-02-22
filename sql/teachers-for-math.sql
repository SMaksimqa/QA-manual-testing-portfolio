-- teachers-for-math.sql
-- Учителя, которые ведут математику (JOIN + фильтр по предмету)
SELECT DISTINCT 
    t.first_name,
    t.last_name
FROM Teacher t
INNER JOIN Schedule sc ON t.id = sc.teacher
INNER JOIN Subject sub ON sc.subject = sub.id
WHERE sub.name = 'Math'
ORDER BY t.last_name;
