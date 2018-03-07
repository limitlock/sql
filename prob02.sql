

-- 1. 최고임금(salary)과  최저임금을 “최고임금, “최저임금”프로젝션 타이틀로 함께 출력해 보세요. 두 임금의 차이는 얼마인가요? 
-- 함께 “최고임금 – 최저임금”이란 타이틀로 출력해 보세요.
select abs(s.최고임금-s.최저임금) as '최고임금-최저임금', 최고임금,최저임금
  from (select max(salary) as '최고임금', min(salary) as '최저임금'
          from salaries) s;

-- 2. 마지막으로 신입사원이 들어온 날은 언제 입니까? 다음 형식으로 출력해주세요.
-- 예) 2014년 07월 10일
select DATE_FORMAT(hire_date, '%x년 %m월 %d일') as '입사일'
  from employees
 where hire_date = (select max(hire_date)
					 from employees);

-- 3. 가장 오래 근속한 직원의 입사일은 언제인가요? 다음 형식으로 출력해주세요.  ????????????????
select emp_no, DATE_FORMAT(hire_date, '%x년 %m월 %d일') as '입사일'
  from employees
 where period_diff( DATE_FORMAT(CURDATE(), '%x%m'),  
				    DATE_FORMAT(hire_date, '%x%m') ) = (select max(period_diff( DATE_FORMAT(CURDATE(), '%x%m'),  
																				DATE_FORMAT(hire_date, '%x%m') ))
														  from employees);
	


-- 4. 현재 이 회사의 평균 연봉은 얼마입니까?
select avg(salary)
  from salaries
 where to_date = '9999-01-01';
 
-- 5. 현재 이 회사의 최고/최저 연봉은 얼마입니까?
select max(salary), min(salary)
  from salaries
 where to_date = '9999-01-01';

-- 6. 최고 어린 사원의 나이와 최 연장자의 나이는?
select max(a.age) as 'OLD', min(a.age) as 'YOUNG'
  from (select year(curdate())-year(birth_date) as 'age'
		  from employees) a;






