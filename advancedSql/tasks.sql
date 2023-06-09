-- dbscript
CREATE TABLE student
(
    id               int,
    name             varchar(255),
    surname          varchar(255),
    dob              date,
    primary_skill    varchar(255),
    created_datetime timestamp,
    updated_datetime timestamp,
    CONSTRAINT 'student_pk' PRIMARY KEY (id)
);

CREATE TABLE phone
(
    id         int,
    student_id int,
    number     varchar(50),
    CONSTRAINT 'phone_pk' PRIMARY KEY (id),
    CONSTRAINT phone_to_student_rel FOREIGN KEY (student_id)
        REFERENCES student(id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
);

CREATE TABLE subject
(
    id    int GENERATED BY DEFAULT AS IDENTITY,
    name  varchar(255),
    tutor varchar(255),
    CONSTRAINT 'subject_pk' PRIMARY KEY (id)
);

CREATE TABLE exam_result
(
    id         int GENERATED BY DEFAULT AS IDENTITY,
    student_id int,
    subject_id int,
    mark       smallint,
    CONSTRAINT 'exam_result_pk' PRIMARY KEY (id),
    CONSTRAINT result_to_student_rel FOREIGN KEY (student_id)
        REFERENCES student(id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT result_to_subject_rel FOREIGN KEY (subject_id)
        REFERENCES subject (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);
-- queries
-- 1
SELECT primary_skill
FROM student
WHERE primary_skill LIKE '%-%' OR primary_skill LIKE '% %';
-- 2
SELECT *
FROM student
WHERE surname IS NULL OR surname REGEXP '^[A-Za-z]\.?$';
-- 3
SELECT subject.name, COUNT(exam_result.student_id) AS num_students_passed
FROM subject
LEFT JOIN exam_result ON subject.id = exam_result.subject_id
WHERE exam_result.mark >= 50
GROUP BY subject.id, subject.name
ORDER BY num_students_passed DESC;
-- 4
SELECT subject.name, exam_result.mark, COUNT(exam_result.student_id) AS num_students
FROM subject
JOIN exam_result ON subject.id = exam_result.subject_id
GROUP BY subject.id, subject.name, exam_result.mark
ORDER BY subject.name, exam_result.mark;
-- 5
SELECT student.id, student.name, student.surname
FROM student
JOIN exam_result ON student.id = exam_result.student_id
GROUP BY student.id, student.name, student.surname
HAVING COUNT(DISTINCT exam_result.subject_id) >= 2;
-- 6
SELECT student.id, student.name, student.surname
FROM student
JOIN exam_result ON student.id = exam_result.student_id
GROUP BY student.id, student.name, student.surname, exam_result.subject_id
HAVING COUNT(*) >= 2;
-- 7
SELECT subject.id, subject.name
FROM subject
JOIN exam_result ON subject.id = exam_result.subject_id
JOIN student ON exam_result.student_id = student.id
GROUP BY subject.id, subject.name
HAVING MIN(student.primary_skill) = MAX(student.primary_skill);
-- 8
SELECT subject.id, subject.name
FROM subject
JOIN exam_result ON subject.id = exam_result.subject_id
JOIN student ON exam_result.student_id = student.id
GROUP BY subject.id, subject.name
HAVING COUNT(DISTINCT student.primary_skill) = COUNT(student.primary_skill);
-- 9(1)
SELECT student.id, student.name, student.surname
FROM student
LEFT JOIN exam_result ON student.id = exam_result.student_id
WHERE exam_result.id IS NULL;
-- 9(2)
SELECT id, name, surname
FROM student
WHERE id NOT IN (SELECT DISTINCT student_id FROM exam_result);
-- 9(3)
SELECT id, name, surname
FROM student
WHERE id <> ANY (SELECT DISTINCT student_id FROM exam_result);
-- numbers of students/exams:
-- For 1000 exams and 10 students: all approaches perform well and have similar performance
-- For 10,000 exams and 1,000 students: outer join and 'NOT IN' subquery are still efficient, while 'ANY' subquery may have some performance impact
-- For 100,000 exams and 100,000 students: 'NOT IN' subquery may have performance issues due to its result size. Outer join and 'ANY' subquery are more efficient in this case

-- 10
SELECT student.id, student.name, student.surname
FROM student
JOIN exam_result ON student.id = exam_result.student_id
GROUP BY student.id, student.name, student.surname
HAVING AVG(exam_result.mark) > (SELECT AVG(mark) FROM exam_result);
-- 11
SELECT student.id, student.name, student.surname, exam_result.mark
FROM student
JOIN exam_result ON student.id = exam_result.student_id
WHERE exam_result.mark > (SELECT AVG(mark) FROM exam_result)
ORDER BY exam_result.mark DESC
LIMIT 5;
-- 12
SELECT student.id, student.name, student.surname,
       COALESCE(
         CASE
           WHEN MAX(exam_result.mark) IS NULL THEN 'not passed'
           WHEN MAX(exam_result.mark) <= 3 THEN 'BAD'
           WHEN MAX(exam_result.mark) <= 6 THEN 'AVERAGE'
           WHEN MAX(exam_result.mark) <= 8 THEN 'GOOD'
           ELSE 'EXCELLENT'
         END, 'not passed'
       ) AS mark_description
FROM student
LEFT JOIN exam_result ON student.id = exam_result.student_id
GROUP BY student.id, student.name, student.surname;
-- 13
SELECT mark_description, COUNT(*) AS count_marks
FROM (
    SELECT
        CASE
            WHEN mark <= 3 THEN 'BAD'
            WHEN mark <= 6 THEN 'AVERAGE'
            WHEN mark <= 8 THEN 'GOOD'
            ELSE 'EXCELLENT'
        END AS mark_description
    FROM exam_result
) AS subquery
GROUP BY mark_description;