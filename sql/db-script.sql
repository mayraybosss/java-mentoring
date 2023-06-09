CREATE SEQUENCE students_id_seq START 1;
CREATE TABLE students (
    id INTEGER PRIMARY KEY DEFAULT nextval('students_id_seq'),
    name VARCHAR(255) NOT NULL,
    surname VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_numbers VARCHAR(255) NOT NULL,
    primary_skill VARCHAR(255) NOT NULL,
    created_datetime TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_datetime TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE SEQUENCE subjects_id_seq START 1;
CREATE TABLE subjects (
    id INTEGER PRIMARY KEY DEFAULT nextval('subjects_id_seq'),
    subject_name VARCHAR(255) NOT NULL,
    tutor VARCHAR(255) NOT NULL
);

CREATE TABLE exam_results (
    id SERIAL PRIMARY KEY,
    student_id INTEGER NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    subject_id INTEGER NOT NULL REFERENCES subjects(id) ON DELETE CASCADE,
    mark INTEGER NOT NULL,
    CONSTRAINT unique_exam_result UNIQUE (student_id, subject_id)
);

CREATE OR REPLACE FUNCTION update_students_updated_datetime()
RETURNS TRIGGER AS
BEGIN
  NEW.updated_datetime = NOW();
  RETURN NEW;
END;

CREATE OR REPLACE TRIGGER update_students_trigger
BEFORE UPDATE ON students
FOR EACH ROW
EXECUTE FUNCTION update_students_updated_datetime();

CREATE OR REPLACE FUNCTION validate_student_name()
RETURNS TRIGGER AS
BEGIN
  IF NEW.name ~ '[@#$]' THEN
    RAISE EXCEPTION 'InvalidName: %', NEW.name;
  END IF;
  RETURN NEW;
END;
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER validate_student_name_trigger
BEFORE INSERT OR UPDATE ON students
FOR EACH ROW
EXECUTE FUNCTION validate_student_name();

CREATE OR REPLACE VIEW exam_results_snapshot AS
SELECT s.name AS student_name, s.surname AS student_surname,
       sub.subject_name, e.mark
FROM exam_results e
JOIN students s ON s.id = e.student_id
JOIN subjects sub ON sub.id = e.subject_id;

CREATE OR REPLACE FUNCTION get_average_mark_for_student(student_id INTEGER)
RETURNS NUMERIC AS
$$
BEGIN
  RETURN (SELECT AVG(mark)
          FROM exam_results
          WHERE student_id = $1);
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_students_in_red_zone()
RETURNS TABLE (student_name VARCHAR(255), student_surname VARCHAR(255)) AS
$$
BEGIN
  RETURN QUERY
  SELECT s.name, s.surname
  FROM students s
  JOIN exam_results e ON s.id = e.student_id
  WHERE e.mark <= 3
  GROUP BY s.id
  HAVING COUNT(e.mark <= 3) >= 2;
END;
$$
LANGUAGE plpgsql;

CREATE INDEX students_name_index ON students USING btree (name);
CREATE INDEX students_surname_index ON students USING hash (surname);
CREATE INDEX subjects_tutor_index ON subjects USING gin (tutor);
CREATE INDEX exam_results_mark_index ON exam_results USING gist (mark);
