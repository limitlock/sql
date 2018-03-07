-- 1. 현재 평균 연봉보다 많은 월급을 받는 직원은 몇 명이나 있습니까?

select count(a.emp_no)
  from employees a, salaries b
 where a.emp_no = b.emp_no
   and b.salary > (select avg(salary)
					   from salaries
					  where to_date = '9999-01-01')
   and to_date = '9999-01-01';


-- 2. 현재, 각 부서별로 최고의 급여를 받는 사원의 사번, 이름, 부서 연봉을 조회하세요. 단 조회결과는 연봉의 내림차순으로 정렬되어 나타나야 합니다. 

  select a.emp_no as '사번', concat(a.first_name, ' ',a.last_name) as '이름', b.dept_no as '부서', max(c.salary) as '연봉'
    from employees a, dept_emp b, salaries c
   where a.emp_no = b.emp_no
     and a.emp_no = c.emp_no
     and b.to_date = '9999-01-01'
group by dept_no
  having max(c.salary)
order by max(c.salary) desc;



-- 3. 현재, 자신의 부서 평균 급여보다 연봉(salary)이 많은 사원의 사번, 이름과 연봉을 조회하세요 

select a.emp_no as '사번', concat(a.first_name, ' ',a.last_name) as '이름', b.salary as '연봉'
from employees a, salaries b, dept_emp c, (select avg(c.salary) as 'avg_salary', b.dept_no as 'b_no'
											 from employees a, dept_emp b, salaries c
											where a.emp_no = b.emp_no
											  and a.emp_no = c.emp_no
											  and b.to_date = '9999-01-01'
										 group by dept_no) d
where a.emp_no = b.emp_no
and a.emp_no = c.emp_no
and b.to_date = '9999-01-01'
and c.dept_no = d.b_no
and b.salary > d.avg_salary;



-- 4. 현재, 사원들의 사번, 이름, 매니저 이름, 부서 이름으로 출력해 보세요.

select a.emp_no as '사번', concat(a.first_name, ' ',a.last_name) as '이름',e.manager_name as '매니저 이름', d.dept_name as '부서명'
  from employees a , titles b, dept_emp c, departments d, (select concat(a.first_name, ' ',a.last_name) as 'manager_name', 
																  d.dept_name as 'm_dept_name'
														     from employees a, titles b, dept_emp c, departments d
															where a.emp_no = b.emp_no
                                                              and a.emp_no = c.emp_no
                                                              and c.dept_no = d.dept_no
															  and b.title = 'Manager'
															  and b.to_date = '9999-01-01') e
where a.emp_no = b.emp_no
and a.emp_no = c.emp_no
and c.dept_no = d.dept_no
and d.dept_name = e.m_dept_name
and b.to_date = '9999-01-01';


-- 5. 현재, 평균연봉이 가장 높은 부서의 사원들의 사번, 이름, 직책, 연봉을 조회하고 연봉 순으로 출력하세요.

  select a.emp_no as '사번',concat(a.first_name, ' ',a.last_name) as '이름', e.title as '직책', b.salary as '연봉' , d.dept_name as '부서명'
    from employees a, salaries b, dept_emp c, departments d, titles e, (select d.dept_name as 'department'
																		from employees a, salaries b, dept_emp c, departments d
																	   where a.emp_no = b.emp_no
																		 and a.emp_no = c.emp_no
																		 and c.dept_no = d.dept_no
																	group by dept_name
																	having round(avg(b.salary)) >= round((select max(a.avg_salary)
																							  from (select avg(b.salary) as 'avg_salary'
																									  from employees a, salaries b, dept_emp c, departments d
																									 where a.emp_no = b.emp_no
																									   and a.emp_no = c.emp_no
																									   and c.dept_no = d.dept_no
																								  group by dept_name) a))) g
   where a.emp_no = b.emp_no
     and a.emp_no = c.emp_no
     and a.emp_no = e.emp_no
     and c.dept_no = d.dept_no
     and b.to_date = '9999-01-01'
     and e.to_date = '9999-01-01'
     and d.dept_name = g.department
order by b.salary desc;


-- 6. 평균 연봉이 가장 높은 부서는? 
  select avg(b.salary) as '연봉', d.dept_name as '부서명'
    from employees a, salaries b, dept_emp c, departments d
   where a.emp_no = b.emp_no
     and a.emp_no = c.emp_no
     and c.dept_no = d.dept_no
group by dept_name
having round(avg(b.salary)) >= round((select max(a.avg_salary)
						  from (select avg(b.salary) as 'avg_salary'
								  from employees a, salaries b, dept_emp c, departments d
								 where a.emp_no = b.emp_no
								   and a.emp_no = c.emp_no
								   and c.dept_no = d.dept_no
							  group by dept_name) a));
                              


-- 7. 평균 연봉이 가장 높은 직책?
select avg(b.salary) as '연봉', c.title as '직책'
    from employees a, salaries b, titles c
   where a.emp_no = b.emp_no
     and a.emp_no = c.emp_no
group by title
having avg(b.salary) >= (select max(a.avg_salary)
						   from (select avg(b.salary) as 'avg_salary'
								   from employees a, salaries b, titles c
								  where a.emp_no = b.emp_no
									and a.emp_no = c.emp_no
							   group by title) a);




-- 8. 현재 자신의 매니저보다 높은 연봉을 받고 있는 직원은?
-- 부서이름, 사원이름, 연봉, 매니저 이름, 메니저 연봉 순으로 출력합니다.

select e.dept_name as '부서이름', concat(first_name, ' ',last_name) as '사원이름', b.salary as '연봉', g.manager_name as'매니저 이름', g.manager_salary as '매니저 연봉'
from employees a, salaries b, titles c, dept_emp d, departments e, (select concat(a.first_name, ' ',a.last_name) as 'manager_name', b.salary as 'manager_salary', d.dept_no as 'manager_department'
																	  from employees a, salaries b, titles c, dept_emp d
																	 where a.emp_no = b.emp_no
																	   and a.emp_no = c.emp_no
                                                                       and a.emp_no = d.emp_no
																	   and c.title = 'manager'
																	   and b.to_date = '9999-01-01') g 
where a.emp_no = b.emp_no
  and a.emp_no = d.emp_no
  and d.dept_no = e.dept_no
  and b.salary > g.manager_salary
  and b.to_date = '9999-01-01'
  and d.dept_no = g.manager_department;












