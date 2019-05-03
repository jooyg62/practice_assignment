-- 문제1.
select concat(last_name, ' ', first_name) as 이름 from employees where emp_no = 10944;

-- 문제2.
select 
	concat(last_name, ' ', first_name) as 이름,
    gender as 성별,
    hire_date as 입사일
from employees
order by hire_date;

-- 문제3.
select
	(select count(*) from employees where gender = 'm') as '남 직원수',
    (select count(*) from employees where gender = 'f') as '여 직원수';
    
-- 문제4.
select 
	count(distinct emp_no)
from 
	salaries
where 
	to_date > curdate();

-- 문제5.
select count(dept_no) from departments;

-- 문제6.
select dept_no, count(emp_no)
from dept_manager 
where from_date <= curdate() and to_date >= curdate() 
group by dept_no;

-- 문제7.
select * from departments order by length(dept_name) desc;

-- 문제8.
select count(*) 
from salaries
where from_date <= curdate() and to_date >= curdate()
and salary > 120000
;

-- 문제9.
select distinct title
from titles
order by length(title) desc
;

-- 문제10.
select count(*)
from titles
where from_date <= curdate() and to_date >= curdate()
and title like '%engineer%'
;

-- 문제11.
select title
from titles
where emp_no = 13250
order by from_date
;
    
