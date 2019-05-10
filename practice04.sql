-- 서브쿼리(SUBQUERY) SQL 문제입니다.

-- 문제1.
-- 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?
select count(*)
from salaries
where to_date = '9999-01-01'
  and salary > (select avg(salary) from salaries where to_date = '9999-01-01');

-- 문제2. 
-- 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서 연봉을 조회하세요. 
-- 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다. 


select a.emp_no "사번", (select concat(last_name, ' ', first_name) from employees where emp_no = a.emp_no ) "이름", (select dept_name from departments where dept_no = b.dept_no) "부서", a.salary "연봉"
from salaries a, dept_emp b
where a.emp_no = b.emp_no
  and (b.dept_no, a.salary) in 
				(
					select b.dept_no, max(a.salary)
					from salaries a, dept_emp b
					where a.emp_no = b.emp_no
					  and a.to_date = '9999-01-01'
					group by b.dept_no
				);

-- 문제3.
-- 현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요
select X.emp_no "사번", (select concat(last_name, ' ', first_name) from employees where emp_no = X.emp_no ) "이름", X.salary "연봉"
from 
(select A.emp_no, B.dept_no, A.salary
from salaries A, dept_emp B
where A.emp_no = B.emp_no
  and A.to_date = '9999-01-01') X, -- 직원 부서와 연봉 조회
(
	select b.dept_no, avg(a.salary) avg_salary
	from salaries a, dept_emp b
	where a.emp_no = b.emp_no
	group by b.dept_no		) Y -- 각 부서별 평균 연봉 조회
where X.dept_no = Y.dept_no
  and X.salary > Y.avg_salary
;

-- 문제4.
-- 현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요.

select X.emp_no "사번", (select concat(last_name, ' ', first_name) from employees where emp_no = X.emp_no ) "이름"
, (select concat(last_name, ' ', first_name) from employees where emp_no = (select emp_no from dept_manager where to_date = '9999-01-01' and dept_no = X.dept_no)) "매니저 이름"
, (select dept_name from departments where dept_no = X.dept_no)"부서 이름"
from (
	select a.emp_no, b.dept_no
	from employees a, dept_emp b
	where a.emp_no = b.emp_no
	) X; -- 사원, 부서 조회

-- 문제5.
-- 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.

select a.emp_no "사번", (select concat(last_name, ' ', first_name) from employees where emp_no = a.emp_no ) "이름"
	, (select title from titles where emp_no = a.emp_no and to_date = '9999-01-01') "직책"
    , a.salary "연봉"
from salaries a, dept_emp b
where a.emp_no = b.emp_no
  and a.to_date = '9999-01-01'
  and b.to_date = '9999-01-01'
  and b.dept_no = (
					select b.dept_no
					from salaries a, dept_emp b
					where a.emp_no = b.emp_no
                      and a.to_date = '9999-01-01'
					group by b.dept_no
					order by avg(a.salary) desc
					limit 1
				  ); -- 평균연봉이 가장 높은 부서 조회

-- 문제6.
-- 평균 연봉이 가장 높은 부서는?

select (select dept_name from departments where dept_no = b.dept_no) "부서"
from salaries a, dept_emp b
where a.emp_no = b.emp_no
  and a.to_date = '9999-01-01'
group by b.dept_no
order by avg(a.salary) desc
limit 1;

-- 문제7.
-- 평균 연봉이 가장 높은 직책?

select b.title
from salaries a, titles b
where a.emp_no = b.emp_no
  and a.to_date = '9999-01-01'
  and b.to_date = '9999-01-01'
group by b.title
order by avg(a.salary) desc
limit 1;

-- 문제8.
-- 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.

select (select dept_name from departments where dept_no = X.dept_no) "부서이름"
, (select concat(last_name, ' ', first_name) from employees where emp_no = X.emp_no ) "사원이름"
, X.salary "사원연봉"
, (select concat(last_name, ' ', first_name) from employees where emp_no = Y.emp_no ) "매니저이름"
, Y.salary "매니저연봉"
from (
select A.emp_no, B.dept_no, A.salary
from salaries A, dept_emp B
where A.emp_no = B.emp_no
  and A.to_date = '9999-01-01') X,
(select a.salary, b.dept_no, a.emp_no
	from salaries a, (
		select dept_no, emp_no
		from dept_manager
		where to_date = '9999-01-01') b
	where a.emp_no = b.emp_no
	  and a.to_date = '9999-01-01') Y
where X.dept_no = Y.dept_no
  and X.salary > Y.salary


