#SQL степ-проект

#Запити
#1. Покажіть середню зарплату співробітників за кожен рік, до 2005 року.

select year(from_date) as period, avg(salary) as mid_salary from salaries
#where year(from_date) < 2005
group by period
having period between min(period) and 20005;

#2. Покажіть середню зарплату співробітників по кожному відділу. Примітка: потрібно розрахувати по поточній зарплаті, та поточному відділу співробітників

select de.dept_no, round(avg(s.salary), 2) as mid_salary from salaries as s
join dept_emp as de
	on de.emp_no = s.emp_no
where curdate() between s.from_date and s.to_date
and curdate() between de.from_date and de.to_date
group by de.dept_no;

#3. Покажіть середню зарплату співробітників по кожному відділу за кожний рік

select year(s.to_date) as years, de.dept_no, round(avg(s.salary), 2) as mid_salary from salaries as s
join dept_emp as de
	on de.emp_no = s.emp_no
group by de.dept_no, years
order by years;

#4. Покажіть відділи в яких зараз працює більше 15000 співробітників.

select count(emp_no) as amount_employees, dept_no from dept_emp
where curdate() between from_date and to_date
group by dept_no
having amount_employees > 15000;

#5. Для менеджера який працює найдовше покажіть його номер, відділ, дату прийому на роботу, прізвище

select e.emp_no, dm.dept_no, e.hire_date, e.last_name from employees as e
join dept_manager as dm
	on dm.emp_no = e.emp_no
where curdate() between dm.from_date and dm.to_date
order by timestampdiff(day, e.hire_date, curdate()) desc
limit 1;

#6. Покажіть топ-10 діючих співробітників компанії з найбільшою різницею між їх зарплатою і середньою зарплатою в їх відділі.

with mid_salary as (
					select de.dept_no, avg(s.salary) avgs from salaries s
					join dept_emp de
						on de.emp_no = s.emp_no
					where curdate() between s.from_date and s.to_date
					group by de.dept_no
)
select s.emp_no, abs(ms.avgs - s.salary) as differ_salary, s.salary, ms.avgs from salaries s
join dept_emp de
	on de.emp_no = s.emp_no
join mid_salary ms
	on ms.dept_no = de.dept_no
where curdate() between s.from_date and s.to_date
and curdate() between de.from_date and de.to_date
order by differ_salary desc
limit 10;

#7. Для кожного відділу покажіть другого по порядку менеджера. Необхідно вивести відділ, прізвище ім’я менеджера, дату прийому на роботу менеджера і дату коли він став менеджером відділу

with second_manager as (select *,
						row_number() over (partition by dept_no order by from_date) as department_ranking
						from dept_manager)
select sm.dept_no, concat(e.first_name, ' ', e.last_name) as name_manager, e.hire_date, sm.from_date from employees as e
join second_manager as sm
	on sm.emp_no = e.emp_no
where sm.department_ranking = 2
