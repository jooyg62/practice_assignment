-- 테이블간 조인(JOIN) SQL 문제입니다.

-- 문제 1. o
-- 현재 급여가 많은 직원부터 직원의 사번, 이름, 그리고 연봉을 출력 하시오.

select a.emp_no "사번", concat(b.last_name, ' ', b.first_name) "이름", a.salary "연봉"
from salaries a, employees b
where a.emp_no = b.emp_no
  and a.to_date = '9999-01-01'
order by salary desc;

-- 문제2.
-- 전체 사원의 사번, 이름, 현재 직책을 이름 순서로 출력하세요.
select a.emp_no "사번", concat(a.last_name, ' ', a.first_name) "이름", b.title "직책"
from employees a, titles b
where a.emp_no = b.emp_no
  and b.to_date = '9999-01-01'
order by concat(a.last_name, ' ', a.first_name);

-- 문제3.
-- 전체 사원의 사번, 이름, 현재 부서를 이름 순서로 출력하세요..
select a.emp_no "사번", concat(a.last_name, ' ', a.first_name) "이름", (select dept_name from departments where dept_no = b.dept_no) "부서"
from (select x.* from employees x, salaries y where x.emp_no = y.emp_no and y.to_date = '9999-01-01') a -- 현재 재직자
left join dept_emp b
on a.emp_no = b.emp_no
where b.to_date = '9999-01-01'
order by concat(a.last_name, ' ', a.first_name);

-- 문제4. x
-- 전체 사원의 사번, 이름, 연봉, 직책, 부서를 모두 이름 순서로 출력합니다.
select 	a.emp_no "사번",
		concat(a.last_name, ' ', a.first_name) "이름", 
        e.salary "연봉",
        d.title "직책",
        c.dept_name "부서"
from employees a -- 전체 재직자
left join dept_emp b
on a.emp_no = b.emp_no
left join departments c
on b.dept_no = c.dept_no
left join titles d
on a.emp_no = d.emp_no
left join salaries e
on d.emp_no = e.emp_no
where b.to_date = '9999-01-01'
  and d.to_date = '9999-01-01'
  and e.to_date = '9999-01-01'
order by concat(a.last_name, ' ', a.first_name)
;

select * from dept_emp where emp_no = 407793;
-- 문제5.
-- ‘Technique Leader’의 직책으로 과거에 근무한 적이 있는 모든 사원의 사번과 이름을 출력하세요. (현재 ‘Technique Leader’의 직책(으로 근무하는 사원은 고려하지 않습니다.) 이름은 first_name과 last_name을 합쳐 출력 합니다.
select emp_no, concat(last_name, ' ', first_name) "이름"
from employees 
where emp_no in (
select distinct emp_no
from titles
where title = 'Technique Leader'
  and to_date != '9999-01-01');

-- 문제6.
-- 직원 이름(last_name) 중에서 S(대문자)로 시작하는 직원들의 이름, 부서명, 직책을 조회하세요.
select 
	concat(a.last_name, ' ', a.first_name) "이름",
	(select dept_name from departments where dept_no = b.dept_no) "부서명",
	c.title "직책"
from (select x.* from employees x, salaries y where x.emp_no = y.emp_no and y.to_date = '9999-01-01') a -- 현재 재직자
left join (select * from dept_emp where to_date = '9999-01-01') b -- 현재 가지고 있는 부서
on a.emp_no = b.emp_no
left join (select * from titles where to_date = '9999-01-01') c -- 현재 있는 직책
on b.emp_no = c.emp_no
where a.last_name like 'S%';

-- 문제7.
-- 현재, 직책이 Engineer인 사원 중에서 현재 급여가 40000 이상인 사원을 급여가 큰 순서대로 출력하세요.
select (select concat(last_name, ' ', first_name) from employees where  emp_no = a.emp_no) "사원명", b.salary
from (select * from titles where to_date = '9999-01-01' and title = 'Engineer') a -- 현재 있는 직책
left join (select * from salaries where to_date = '9999-01-01') b
on a.emp_no = b.emp_no
where b.salary > 40000
order by b.salary desc;

-- 문제8.
-- 현재 급여가 50000이 넘는 직책을 직책, 급여로 급여가 큰 순서대로 출력하시오
select a.title "직책", b.salary "급여"
from titles a, salaries b
where a.emp_no = b.emp_no
  and a.to_date = '9999-01-01'
  and b.to_date = '9999-01-01'
  and b.salary > 50000
order by b.salary desc;

-- 문제9.
-- 현재, 부서별 평균 연봉을 연봉이 큰 부서 순서대로 출력하세요.
select c.dept_name, avg(a.salary)
from 	(select * from salaries where to_date = '9999-01-01') a, -- 현재 재직자 연봉
		(select * from dept_emp where to_date = '9999-01-01') b,
        departments c
where a.emp_no = b.emp_no
  and b.dept_no = c.dept_no
group by c.dept_name
order by avg(a.salary) desc;

-- 문제10.
-- 현재, 직책별 평균 연봉을 연봉이 큰 직책 순서대로 출력하세요.
select b.title, avg(a.salary)
from (select * from salaries where to_date = '9999-01-01') a,
	 (select * from titles where to_date = '9999-01-01') b
where a.emp_no = b.emp_no
group by b.title
order by avg(a.salary) desc;


