#SQL степ-проект

#Дизайн бази даних:
#1. Створіть базу даних для управління курсами. База має включати наступні таблиці:
#- students: student_no, teacher_no, course_no, student_name, email, birth_date.
#- teachers: teacher_no, teacher_name, phone_no
#- courses: course_no, course_name, start_date, end_date

drop database if exists course;
create database if not exists course;
use course;

create table if not exists courses(
	course_no int auto_increment,
    course_name varchar(255) not null,
    start_date date,
    end_date date,
    primary key (course_no));
    
create table if not exists teachers(
	teacher_no int auto_increment,
    teacher_name varchar(255) not null,
    phone_no varchar(15),
    primary key (teacher_no));

create table if not exists students(
	student_no int auto_increment,
    teacher_no int not null,
    course_no int not null,
    student_name varchar(255),
    email varchar(255) not null,
    birth_date date,
    primary key (student_no),
    foreign key (teacher_no) references teachers(teacher_no) on delete set null,
	foreign key (course_no) references courses(course_no) on delete cascade);

show tables;

#2. Додайте будь-які данні (7-10 рядків) в кожну таблицю.

start transaction;

insert into courses (course_name, start_date, end_date) values
('SQL', '2024-01-01', '2024-03-01'),
('Python', '2024-02-02', '2024-05-02'),
('Math', '2024-03-01', '2024-06-01'),
('Statistics', '2024-03-05', '2024-04-01'),
('Excel', '2024-06-01', '2024-08-01'),
('AI', '2024-07-01', '2024-09-01'),
('PowerBI', '2024-09-01', '2024-11-01');

insert into teachers (teacher_name, phone_no) values
('Alex Sql', '024-010-03-01'),
('John Python', '024-020-05-02'),
('Andy Math', '024-031-06-01'),
('Helena Stat', '024-035-04-01'),
('Alan Excel', '024-060-08-01'),
('Jojo AI', '024-071-09-01'),
('Steven Powerbi', '024-901-11-01');

insert into students (teacher_no, course_no, student_name, email, birth_date) values
(1, 1, 'Alexander Seqele', 'alex@gmail.com', '2001-03-01'),
(2, 2, 'Emma Pytiothon', 'emma@gmail.com', '2001-05-02'),
(3, 3, 'Oliver Stovn', 'oliver@gmail.com', '2001-06-01'),
(4, 4, 'Lada Setata', 'lada@gmail.com', '2000-04-01'),
(5, 5, 'Micke Exachel', 'mck@gmail.com', '2000-08-01'),
(6, 6, 'Jorge Afetty', 'jrg@gmail.com', '1999-09-01'),
(7, 7, 'Sven Bidron', 'sven@gmail.com', '2002-11-01');

commit;
select * from courses;
select * from teachers;
select * from students;

#3. По кожному викладачу покажіть кількість студентів, з якими він працював

select t.teacher_name, count(s.student_no) as amount_students from teachers as t
join students as s
	on s.teacher_no = t.teacher_no
group by t.teacher_name;

#4. Спеціально зробіть 3 дубляжі в таблиці students (додайте ще 3 однакові рядки)

insert into course.students (teacher_no, course_no, student_name, email, birth_date)
select teacher_no, course_no, student_name, email, birth_date from course.students
limit 3;

#5. Напишіть запит який виведе дублюючі рядки в таблиці students

select teacher_no, course_no, student_name, email, birth_date, count(teacher_no) as amount
from students
group by teacher_no, course_no, student_name, email, birth_date;

