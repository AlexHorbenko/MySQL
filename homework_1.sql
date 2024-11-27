#Завдання 1
#1.     Виведіть список усіх співробітниць, які приєдналися 01.01.1990 або після 01.01.2000
/*select * from employees
where gender = 'F'
and (hire_date = '1990-01-01' or hire_date > '2000-01-01');
*/
#2.     Покажіть імена всіх співробітників, які мають однакові ім’я та прізвище
/*select first_name, last_name from employees
where first_name = last_name
*/
#3.     Покажіть номери співробітників 10001, 10002, 10003 і 10004. Виберіть стовпці: first_name, last_name, gender, hire_date.
select emp_no, first_name, last_name, gender, hire_date from employees
where emp_no between 10001 and 10004;

#4.     Виберіть назви всіх департаментів, назви яких мають букву «а» на будь-якій позиції або «е» на другому місці.
/*select dept_name from departments
where dept_name like('%a%')
or dept_name like('_e%');
*/
#5.     Покажіть співробітників, які відповідають наступному опису: Йому було 45 років, коли його прийняли на роботу, він народився в жовтні і був прийнятий на роботу в неділю
/*select * from employees
where gender = 'M'
and timestampdiff(year, date(birth_date), date(hire_date)) = 45
and birth_date like '%-10-%'
and dayofweek(hire_date) = 1;
*/
#6.     Покажіть максимальну річну зарплату в компанії після 01.06.1995.
/*select max(salary) from salaries
where from_date > '1995-06-01';
*/
#7.     У таблиці dept_emp покажіть кількість співробітників за департаментами (dept_no). To_date має бути більшим за current_date. Покажіть департаменти з понад 13 000 співробітників. Відсотртуйте за кількістю працівників.
select count(emp_no), dept_no from dept_emp
where current_date() between from_date and to_date
group by dept_no
having count(emp_no) > 13000
order by count(emp_no) desc;

#8.     Покажіть мінімальну та максимальну зарплати по працівникам.
select emp_no, max(salary), min(salary) from salaries
group by emp_no;