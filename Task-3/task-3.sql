select* from locations;
select* from departments;
select* from employees;
select* from job_history;
select* from regions;
select* from countries;
select* from jobs;

/*SQL query to find the total salary of employees who is in Tokyo excluding whose first name is Nancy*/
select sum(salary) from  employees 
join (select * from (select locations.city, departments.department_id from departments join locations on departments.location_id=locations.location_id) where city='London') loc on employees.department_id= loc.department_id  where employees.first_name !='Nancy';

select sum(e.salary) from employees e 
join departments d on d.department_id=e.department_id 
join locations l on l.location_id=d.location_id 
where city='Seattle' and e.first_name !='Nancy';


select * from (select locations.city, departments.department_id from departments join locations on departments.location_id=locations.location_id) where city='Tokyo';

/*all details of employees who has salary more than the avg salary by each department*/
select e.first_name, e.department_id,e.salary , d.avg_salary from employees e
join
(select department_id, avg(salary) as avg_salary
from employees
group by department_id) d
on e.department_id = d.department_id and e.salary > d.avg_salary;

/*details of employees who has salary more than the avg salary by each department*/

select emp.*
from employees emp
where emp.salary > (
    select AVG(salary)
    from employees
    where department_id = emp.department_id
);

/*query to find the number of employees and its location whose salary is greater than or equal to 7000 and less than 10000*/

select COUNT(e.employee_id) as num_employees, l.city
from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where e.salary >= 7000 and e.salary < 10000
group by l.city;

/*Fetch max salary, min salary and avg salary by job and department.Info: grouped by department id and job id ordered by department id and max salary*/

select d.department_id, e.job_id, MAX(e.salary) as max_salary, MIN(e.salary) as min_salary,floor (AVG(e.salary)) as avg_salary
from employees e
inner join departments d on e.department_id = d.department_id
group by d.department_id, e.job_id
order by d.department_id , max_salary desc;
select floor(1.5);
/*SQL query to find the total salary of employees whose country_id is ‘US’ excluding whose first name is Nancy*/
                                                                                                            
select 
  sum(salary) as total_salary from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
where l.country_id = 'US' and e.first_name != 'Nancy';

/*Fetch max salary, min salary and avg salary by job id and department id but only for folks who worked in more than one role(job) in a department*/
select 
  jh.department_id, 
  jh.job_id,
  max(e.salary) as max_salary,
  min(e.salary) as min_salary,
  avg(e.salary) as avg_salary
from job_history jh
join employees e on jh.employee_id = e.employee_id
where jh.department_id in (
    select department_id from job_history group by department_id, employee_id having  count(distinct job_id) > 1)
group by jh.department_id, jh.job_id;

/*the employee count in each department*/
select coalesce(d.department_name, '-') as department_name,
       count(e.employee_id) as employee_count
from employees e
left join departments d on e.department_id = d.department_id
group by d.department_name;

/*the jobs held and the employee count*/
select j.job_id as jobsheld, count(e.employee_id) as empcount
from employees e
join job_history jh on e.employee_id = jh.employee_id
join jobs j on jh.job_id = j.job_id
group by j.job_id;

select jobs_held, count(c.employee_id) as employees_count from
(select e1.employee_id,count(e1.employee_id) as jobs_held from employees e1
left outer join job_history  e2
on e1.employee_id=e2.employee_id
group by  e1.employee_id) c
group by c.jobs_held;

select e1.employee_id,count(e1.employee_id) as jobs_held from employees e1
left outer join job_history  e2
on e1.employee_id=e2.employee_id
group by  e1.employee_id;
/* average salary by department and country*/

select d.department_name, l.country_id, avg(e.salary) as avg_salary
from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
group by d.department_name, l.country_id;

/*manager names and the number of employees reporting to them by countries (each employee works for only one department, and each department belongs to a country)*/
select concat(m.first_name,' ',m.last_name) as manager_name, l.country_id, count(e.employee_id) as num_employees
from employees e
join departments d on e.department_id = d.department_id
join locations l on d.location_id = l.location_id
join employees m on e.manager_id = m.employee_id
group by m.first_name, m.last_name, l.country_id;

/*salaries of employees in 4 buckets eg: 0-10000, 10000-20000*/
select department_id as "dept id",
       count(case when salary between 0 and 10000 then 1 else null end) as "0-10000",
       count(case when salary between 10000 and 20000 then 1 else null end) as "10000-20000",
       count(case when salary between 20000 and 30000 then 1 else null end) as "20000-30000",
       count(case when salary > 30000 then 1 else null end) as "30000+"
from employees
group by department_id;

/*employee count by country and the avg salary*/
select c.country_name as "Country", count(e.employee_id) as "Emp Count", avg(e.salary) as "Avg Salary"
from employees e 
inner join departments d on e.department_id = d.department_id 
inner join locations l on d.location_id = l.location_id 
inner join countries c on l.country_id = c.country_id 
group by c.country_name;

/*region and the number off employees by department*/

select d.department_id as "Dept ID",
       coalesce(nullif(cast(count(case when c.region_id = 1 then 1  end) as string), '0'),'-') as "Euroope",
       coalesce(nullif(cast(count(case when c.region_id = 2 then 1  end) as string), '0'),'-') as "America",
       coalesce(nullif(cast(count(case when c.region_id = 3 then 1  end) as string), '0'),'-') as "Asia",
       coalesce(nullif(cast(count(case when c.region_id = 4 then 1  end) as string), '0'),'-') as "Middle East and Africa"
from locations l
join departments d on l.location_id = d.location_id
join employees e on d.department_id = e.department_id
join countries c on l.country_id = c.country_id
group by d.department_id;

/* list of all employees who work either for one or more departments or have not yet joined / allocated to any department*/

select * 
from employees 
where department_id is NULL or department_id in (select department_id from departments);

/*Find the employees and their respective managers. Return the first name, last name of the employees and their managers*/

select e.first_name as employee_first_name, e.last_name as employee_last_name, 
       m.first_name as manager_first_name, m.last_name as manager_last_name
from employees e
left join employees m on e.manager_id = m.employee_id;

/* query to display the department name, city, and state province for each department  */

select d.department_name, l.city, l.state_province
from departments d
join locations l on d.location_id = l.location_id;

/*query to list the employees (first_name , last_name, department_name) who belong to a department or don't*/

select e.first_name, e.last_name, d.department_name 
from employees e 
left join departments d on e.department_id = d.department_id
where e.department_id is NULL or d.department_id is not NULL;

/* avg salaary employee count with department_id and department_name*/

select d.department_id, d.department_name, AVG(e.salary) as avg_salary, COUNT(*) as num_employees
from employees e 
join departments d on e.department_id = d.department_id
group by d.department_id, d.department_name;

/*every possible combination of rows from the employees and the jobs relation*/
select * from employees cross join jobs;

/* display first_name, last_name, and email of employees who are from Europe and Asia */
select first_name, last_name, email
from employees e join departments  d on e.department_id=d.department_id
join locations l on d.location_id=d.location_id
join countries c on c.country_id=l.country_id
join regions r on r.region_id=c.region_id
where (r.region_name='Europe') or (r.region_name='Asia');

/*fullname who is from oxford city and their second last character of their last name is 'e' and are not from finance and shipping department.*/
select concat(e.first_name, ' ', e.last_name) as FULL_NAME
from employees e
join departments d on d.department_id=e.department_id
join locations l on l.location_id=d.location_id
where city = 'Oxford'
  and substr(last_name, -2, 1) = 'e'
  and d.department_id not in (select department_id from departments  where department_name in ('Finance', 'Shipping'));

/*the first name and phone number of employees who have less than 50 months of experience*/
select first_name, phone_number
from employees
where months_between(sysdate(), hire_date) < 50;

/*Display Employee id, first_name, last name, hire_date and salary for employees who has the highest salary for each hiring year.*/

select e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary
from employees e
where e.salary = (
  select MAX(salary)
  from employees
  where YEAR (hire_date) =YEAR ( e.hire_date)
)
order by employee_id;

  




