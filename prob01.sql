-- 1
select concat(first_name, ' ', last_name)
from employees
where emp_no = '10944';

-- 2
select concat(first_name, ' ', last_name) as '이름', 
	gender as '성별', 
    hire_date as '입사일'
from employees
order by 이름 asc, gender asc, hire_date asc;

-- 3 
select gender, count(gender)
from employees
group by gender;

-- 4
select count(emp_no) as '직원 수'
from salaries;

-- 5
select count(dept_no) as '부서 수'
from departments;

-- 6 
select count(title) as '부서 매니저'
from titles
where title like '%Manager';

-- 7 
select dept_name
from departments
order by length(dept_name) desc;


-- 8
select count(emp_no) as '급여가 120,000 이상인 사람'
from salaries
where salary > 120000;

-- 9
select distinct title
from titles
order by length(title) desc ;

-- 10

select count(*)
from titles
where title like '%Engineer%'and to_date like '9999%';

-- 11
select *
from titles
where emp_no = 13250
order by from_date asc;




