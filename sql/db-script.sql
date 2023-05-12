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