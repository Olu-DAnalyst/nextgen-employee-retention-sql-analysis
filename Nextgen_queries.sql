select * from attendance
select * from department
select * from employee
select * from performance
select * from salary
select * from turnover

---- Emplpoyee Retention Analysis

--1.Who are the top 5 highest serving employees?
select employee_id, concat(first_name, '', last_name) As full_name, hire_date, 
age(current_date,hire_date) as service_duration
from employee
order by hire_date 
limit 5

--2.What is the turnover rate for each department?
select d.department_name, 
round(cast(count(t.turnover_id)as decimal)/ count(e.employee_id)* 100,2) as turnover_rate_percent
from department d
join employee e on d.department_id=e.department_id
left join turnover t on e.employee_id = t.employee_id
group by d.department_name
order by turnover_rate_percent desc

--3.Which employees are at risk of leaving based on their performance?
SELECT e.employee_id, CONCAT(e.first_name, ' ', e.last_name) AS full_name, d.department_name, 
COUNT(p.performance_id) AS performance_review_frequency, 
ROUND(AVG(p.performance_score), 2) AS avg_performance_score, 
CASE 
WHEN AVG(p.performance_score) <= 3.0 THEN 'High Risk' 
WHEN AVG(p.performance_score) <= 3.5 THEN 'Moderate Risk' 
ELSE 'Low Risk' 
END AS risk_level
FROM employee e
JOIN performance p ON p.employee_id = e.employee_id
JOIN department d ON e.department_id = d.department_id
GROUP BY e.employee_id, full_name, d.department_name
HAVING AVG(p.performance_score) <= 3.5
ORDER BY avg_performance_score;

--4.What are the main reasons employees are leaving the company?
SELECT t.reason_for_leaving, COUNT(*) AS number_of_exits,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (), 2) AS percentage_of_total_exits,
    STRING_AGG(DISTINCT CONCAT(e.first_name, ' ', e.last_name), ', ') AS employees_who_left
FROM turnover t
JOIN employee e ON t.employee_id = e.employee_id
GROUP BY t.reason_for_leaving
ORDER BY number_of_exits DESC;


--Performance Analysis
--1. How many employees has left the company?
SELECT COUNT(*) AS employees_left
FROM turnover;

--2. How many employees have a performance score of 5.0 / below 3.5?
SELECT COUNT(DISTINCT employee_id) AS employee_count
FROM performance
WHERE performance_score = 5 OR performance_score < 3.5

--3. Which department has the most employees with a performance of 5.0 / below 3.5?
SELECT d.department_name, COUNT(DISTINCT p.employee_id) AS employee_count
FROM performance p
JOIN department d ON p.department_id = d.department_id
WHERE p.performance_score = 5.0 OR p.performance_score < 3.5
GROUP BY d.department_name
ORDER BY employee_count DESC
LIMIT 2;

--4. What is the average performance score by department?
SELECT d.department_name, 
	ROUND(AVG(p.performance_score), 2) AS avg_performance_score
FROM employee e
JOIN performance p ON e.employee_id = p.employee_id
JOIN department d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_performance_score DESC;

--Salary Analysis
--1. What is the total salary expense for the company?
SELECT COUNT(employee_id) AS no_of_employees, 
	TO_CHAR(SUM(salary_amount):: numeric, 'FM$999,999,999.00') AS total_salary_expense
FROM salary;

--2. What is the average salary by job title?
SELECT e.job_title, 
	TO_CHAR(AVG(s.salary_amount):: numeric, 'FM$999,999,999.00') AS avg_salary
FROM employee e
LEFT JOIN salary s ON s.employee_id = e.employee_id
GROUP BY job_title
ORDER BY avg_salary DESC;

--3. HOW MANY EMPLOYEES EARN ABOVE 80,000?
SELECT COUNT(DISTINCT s.employee_id) AS high_earners
FROM salary s
WHERE s.salary_amount > 80000;

--4.How does performance correlate with salary across departments?
SELECT d.department_name,
  ROUND(AVG(p.performance_score), 2) AS avg_performance_score,
  ROUND(AVG(s.salary_amount), 2) AS avg_salary
FROM employee e
LEFT JOIN performance p ON e.employee_id = p.employee_id
LEFT JOIN salary s ON e.employee_id = s.employee_id
LEFT JOIN department d ON e.department_id = d.department_id
GROUP BY d.department_name
ORDER BY avg_performance_score DESC;



SELECT * from employee 
select * from salary

SELECT e.employee_id, e.first_name, s.salary_id, s.salary_amount
from employee e
left join salary s on e.employee_id = s.employee_id









