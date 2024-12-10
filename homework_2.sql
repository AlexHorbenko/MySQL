#Домашнє завдання 2
#1. Для поточної максимальної річної заробітної плати в компанії ПОКАЗАТИ ПІБ працівника, департамент, поточну посаду, тривалість перебування на поточній посаді та загальний стаж роботи в компанії.
/*
select
	s.salary as max_salary,
    e.first_name,
    e.last_name,
    dep.dept_name,
    t.title,
    timestampdiff(year, t.from_date, curdate()) as position_duration,
    timestampdiff(year, e.hire_date, curdate()) as total_year
from
	salaries as s
join
	employees as e
	on e.emp_no = s.emp_no
join
	dept_emp as d
	on s.emp_no = d.emp_no
join
	departments as dep
	on dep.dept_no = d.dept_no
join
	titles as t
	on t.emp_no = d.emp_no
where
	s.to_date = '9999-01-01' and t.to_date = '9999-01-01'
order by s.salary desc
limit 1;
*/
#2. Для кожного департамента покажіть його назву, ім’я та прізвище поточного керівника та його поточну зарплату.
/*
select d.dept_no, d.dept_name, em.first_name, em.last_name, s.salary
from (
	select * 
    from dept_manager
	where to_date = '9999-01-01'
) as dm
join
	departments as d
	on dm.dept_no = d.dept_no
join
	employees as em
    on em.emp_no = dm.emp_no
join salaries as s
	on dm.emp_no = s.emp_no
    where s.to_date = '9999-01-01';
*/

SELECT ed.dept_no, dept_name, ee.first_name, ee.last_name, es.salary
FROM employees.departments AS ed
INNER JOIN employees.dept_manager AS edm 
	ON (ed.dept_no = edm.dept_no)
INNER JOIN employees.employees AS ee 
	ON (edm.emp_no = ee.emp_no)
INNER JOIN employees.salaries AS es 
	ON (ee.emp_no = es.emp_no)
WHERE NOW() BETWEEN edm.from_date AND edm.to_date 
AND NOW() BETWEEN es.from_date AND es.to_date;

#3. Покажіть для кожного працівника їхню поточну зарплату та поточну зарплату поточного керівника
/*
select s.emp_no as workers,
	s.salary,
	de.dept_no as 'departments number',
	dm.emp_no as managers,
	sel.salary as 'managers salary'
from salaries as s
join dept_emp as de
	on s.emp_no = de.emp_no
join dept_manager as dm
	on de.dept_no = dm.dept_no
join salaries as sel
	on dm.emp_no = sel.emp_no and sel.to_date = '9999-01-01'
where de.to_date = '9999-01-01' and s.to_date = '9999-01-01' and dm.to_date = '9999-01-01'
order by workers asc;
*/
#4. Покажіть всіх співробітників, які зараз заробляють більше, ніж їхні керівники
/*
select 
    e.emp_no as employee_no,
    e.first_name,
    e.last_name,
    de.dept_no as employee_dept_no,
    s.salary as employee_salary,
    dm.emp_no as manager_no,
    dm.dept_no as manager_dept_no,
    sm.salary as manager_salary
from  employees as e
join salaries as s
    on e.emp_no = s.emp_no and s.to_date = '9999-01-01'
join dept_emp as de
    on e.emp_no = de.emp_no and de.to_date = '9999-01-01'
join dept_manager as dm
    on de.dept_no = dm.dept_no and dm.to_date = '9999-01-01'
join salaries as sm
    on dm.emp_no = sm.emp_no and sm.to_date = '9999-01-01'
where s.salary > sm.salary
order by de.dept_no, e.emp_no;
*/
#5. Покажіть, скільки співробітників зараз мають кожну посаду. Відсортуйте в порядку спадання за кількістю співробітників.
/*
select t.title as title, count(t.emp_no) as count from titles as t
where t.to_date = '9999-01-01'
group by t.title
order by count desc;
*/
#6. Покажіть повні імена всіх співробітників, які працювали більш ніж в одному відділі.
/*
select e.emp_no, e.first_name, e.last_name from employees as e
join
	dept_emp as de
	on de.emp_no = e.emp_no
group by e.emp_no
having count(distinct(de.dept_no)) > 1;
*/
#7. Покажіть середню та максимальну зарплату в тисячах доларів за кожен рік
/*
select extract(year from s.from_date) as salary_year, round(avg(salary)/1000, 2) as average_salary, round(max(salary)/1000, 2) as max_salary from salaries as s
group by salary_year
order by salary_year;
*/
#8. Покажіть, скільки працівників було найнято у вихідні дні (субота + неділя), розділивши за статтю

select count(emp_no) as amount,
case gender
	when 'M' then 'masculin'
    when 'F' then 'feminin'
    else 'others'
end as gender_group
from employees
where weekday(hire_date) between 5 and 6
group by gender_group;
