-- Insert 100K students
INSERT INTO students (name, surname, date_of_birth, phone_numbers, primary_skill)
SELECT
    'Name' || i,
    'Surname' || i,
    DATE '1990-01-01' + (i % 365) * INTERVAL '1 DAY',
    '+777',
    'Skill' || (i % 10)
FROM generate_series(1, 100000) i;

-- Insert 1K subjects
INSERT INTO subjects (name, tutor)
SELECT
    'Subject' || i,
    'Tutor' || (i % 10)
FROM generate_series(1, 1000) i;

-- Insert 1M exam results
INSERT INTO exam_results (student_id, subject_id, mark)
SELECT
    (random()*100000)::integer + 1,
    (random()*1000)::integer + 1,
    (random()*100)::integer + 1
FROM generate_series(1, 1000000) i;

-- EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM students WHERE name = 'John';

EXPLAIN ANALYZE SELECT * FROM students WHERE surname = 'Doe';

EXPLAIN ANALYZE SELECT * FROM subjects WHERE tutor = 'Jane Smith';

-- size of indexes
SELECT pg_size_pretty(pg_indexes_size('students'));
SELECT pg_size_pretty(pg_indexes_size('subjects'));
SELECT pg_size_pretty(pg_indexes_size('exam_results'));

-- creating and index after inserting data can be slower, even if the table is large.