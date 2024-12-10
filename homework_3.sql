#Домашнє завдання 3

#1. Всіх діючих співробітників розбийте на сегменти залежно від віку в момент прийому на роботу:
#до 25, 25-44, 45-54, 55 і старше, для кожного сегменту виведіть максимальну зарплату.
#В результаті потрібно отримати два поля сегмент, максимальну зарплату в сегменті.

with salary_hiring_age_group as (
select ha.emp_no, s.salary,
 case
	when Age < 25 then '< 25 y.o'
    when Age between 25 and 44 then '25-44 y.o'
    when Age between 45 and 54 then '45-54 y.o'
    when Age >= 55 then '55 and more'
    else NULL
end as Hiring_age
from (select emp_no, timestampdiff(year, birth_date, hire_date) as Age from employees) as ha
join salaries as s
	on s.emp_no = ha.emp_no)
select Hiring_age as 'Hiring age', max(salary) as 'Max salary by segment' from salary_hiring_age_group
group by Hiring_age
order by Hiring_age;

#2. Покажіть посаду та зарплату працівника з найвищою зарплатою більше не працюючого в компанії.
# !!! в лекціях не було СТЕ, тому зробила два варіанти, через підзапит та через СТЕ як зрозуміла з прикладів до документації My SQL !!!
# ------------------------------------------------------------ Варіант 1 -------------------------------------------------
/*
select t.title as title, max(s.salary) as salary from salaries as s
join titles as t
on t.emp_no = s.emp_no
join dept_emp as de
on de.emp_no = t.emp_no
where t.to_date = (select max(to_date) from titles as t1
					where t1.emp_no = t.emp_no)
and s.to_date = (select max(to_date) from salaries as s1
					where s1.emp_no = s.emp_no)
and de.to_date = (select max(to_date) from dept_emp as de1
					where de1.emp_no = de.emp_no)
and t.to_date < current_date()
and s.to_date < current_date()
and de.to_date < current_date()
group by t.title
order by salary desc
limit 1;
*/
# ------------------------------------------------------------ Варіант 2 -------------------------------------------------
/*
with last_workers as (
    select t.title as title, max(s.salary) as salary
    from salaries as s
    join titles as t
        on t.emp_no = s.emp_no
    join dept_emp as de
        on de.emp_no = t.emp_no
    where t.to_date = (
        select max(to_date) 
        from titles as t1 
        where t1.emp_no = t.emp_no
    )
    and s.to_date = (
        select max(to_date) 
        from salaries as s1 
        where s1.emp_no = s.emp_no
    )
    and de.to_date = (
        select max(to_date) 
        from dept_emp as de1 
        where de1.emp_no = de.emp_no
    )
    and t.to_date < current_date()
    and s.to_date < current_date()
    and de.to_date < current_date()
    group by t.title
)
select title, salary from last_workers
order by salary desc
limit 1;
*/

#3. Покажіть ТОР-10 діючих співробітників з найбільшою зарплатою
/*
select e.emp_no, concat(e.first_name, ' ', e.last_name) as full_name, max(s.salary) as salary from salaries as s
join employees as e
on e.emp_no = s.emp_no
where s.to_date > current_date()
group by e.emp_no, e.last_name
order by salary desc
limit 10;
*/

#4. Покажіть діючих співробітників зарплата яких вища ніж середня зарплата по діючим співробітникам.
/*
select e.emp_no, concat(e.first_name, ' ', e.last_name) as full_name, s.salary from salaries as s
join employees as e
	on e.emp_no = s.emp_no and current_date() between s.from_date and s.to_date
where s.salary > (select avg(salary) from salaries
					where current_date() between from_date and to_date);
*/

#5. Покажіть співробітників, які працюють у відділах де працює більш ніж 20000 співробітників.
/*
with amount as (select count(emp_no) en, dept_no from dept_emp
				where current_date() between from_date and to_date
                group by dept_no
				having en > 20000)
select e.emp_no, concat(e.first_name, ' ', e.last_name) as full_name, d.dept_name from employees as e
join dept_emp as de
	on de.emp_no = e.emp_no
    and current_date() between de.from_date and de.to_date
join departments as d
	on d.dept_no = de.dept_no
join amount as a
	on a.dept_no = d.dept_no
order by emp_no;
*/

#6. Покажіть співробітників, які заробляють більше, ніж будь-який інший працівник відділу Finance
/*
with finance_salary as (
	select s.salary from dept_emp as de
		join departments as d
			on d.dept_no = de.dept_no and current_date() between from_date and to_date and d.dept_name = 'Finance'
		join salaries as s
			on s.emp_no = de.emp_no and
			current_date() between s.from_date and s.to_date
		order by s.salary desc)
select emp_no, salary from salaries
where current_date() between from_date and to_date
and salary > (select max(salary) from finance_salary);
*/

#7. Покажіть назви відділів, де колись працював хоча б один співробітник з зарплатою більше $150K
/*
select d.dept_name from salaries as s
join dept_emp as de
	on de.emp_no = s.emp_no
join departments as d
	on d.dept_no = de.dept_no
where s.salary > 150000
group by d.dept_name;
*/