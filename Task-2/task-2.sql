select* from employees;
select* from departments;
select* from job_history;
select* from jobs;
select * from regions;

select first_name from employees where first_name like '%even';


/*remove the details of an employee whose first name ends in ‘even’*/
delete from employees where first_name like '%even';

/*SQL to show the three minimum values of the salary from the table*/
select salary from employees order by salary limit 3;


/*SQL query to remove the employees table from the database*/
drop table employees;


/*query to copy the details of this table into a new table with table name as Employee table and to delete the records in employees table*/
create table employee as select* from employees;
delete from employee;
select* from employee;


/*query to remove the column Age from the table*/
alter table employees drop column age;


/*list of employees (their full name, email, hire_year) where they have joined the firm before 2000*/
select concat(first_name,' ',last_name) ,email,hire_date from employees where hire_date < '01-JAN-2000';


/*employee_id and job_id of those employees whose start year lies in the range of 1990 and 1999*/
select employee_id, job_id from employees where hire_date between '01-JAN-1990' and '31-DEC-1998';


/* first occurrence of the letter 'A' in each employees Email ID Return the employee_id, email id and the letter position*/
select email,employee_id ,charindex('A',email) as "POSITION OF A" from employees ;


/*list of employees(Employee_id, full name, email) whose full name holds characters less than 12*/
select employee_id,concat(first_name,' ',last_name) as "FULL_NAME", email from employees where length(concat(first_name,' ',last_name))<12;


/*unique string by hyphenating the first name, last name , and email of the employees to obtain a new field named UNQ_ID Return the employee_id, and their corresponding UNQ_ID;*/
select employee_id,concat(first_name,'-',last_name,'-',email) as "UNIQUE_ID" from employees;


/*SQL query to update the size of email column to 30*/
alter table employees modify email varchar(30);


/*employees with their first name , email , phone (without extension part) and extension (just the extension)*/
select first_name,email,reverse(substr(reverse(phone_number),charindex('.',reverse(phone_number))+1,length(phone_number)))   as "phone_number",reverse(substr(reverse(phone_number),0,charindex('.',reverse(phone_number))-1))as "EXTENSION" from employees;
select first_name, email, left(phone_number, length(phone_number) - charindex('.', REVERSE(phone_number))) as phone_number_NO_EXT,
    right(phone_number, charindex('.',reverse(phone_number))-1) as extension
    from employees;

select first_name, email, phone_number, split_part(phone_number,'.',-1) as extension,
case 
when length(phone_number) = 12 then substr(phone_number, 1, 7)
when length(phone_number) = 14 then substr(phone_number, 1, 9)
when length(phone_number) = 18 then substr(phone_number, 1, 11)
end as number_only
from employees;    


/*query to find the employee with second and third maximum salary*/
select * from employees where salary in (select distinct salary from employees order by salary desc limit 2 offset 1 );
select employees.salary , departments.department_name from employees,departments;


/*all details of top 3 highly paid employees who are in department Shipping and IT */
select employees.* from employees inner join departments on employees.department_id = departments.department_id where (department_name='IT' or department_name='Shipping')
order by salary desc limit 3 ;


/*employee id and the positions(jobs) held by that employee*/
select * from (
(select employees.employee_id , jobs.job_title from employees inner join jobs on jobs.job_id=employees.job_id)union
(select job_history.employee_id,jobs.job_title from job_history inner join jobs on jobs.job_id=job_history.job_id)) order by employee_id;


/*Employee first name and date joined as WeekDay, Month Day, Year*/
select 
  first_name, 
  concat(dayname(hire_date),',',monthname(hire_date),' ',day(hire_date),',',year(hire_date)) 
from employees;


/*company holds a new job opening for Data Engineer (DT_ENGG) */
alter session set autocommit=false;
select * from jobs;
INSERT INTO jobs
VALUES ('DT_ENGG', 'Data Engineer', 12000, 30000);
commit;

UPDATE jobs
SET max_salary = 50000
WHERE job_id = 'DT_ENGG';
rollback;


/*the average salary of all the employees who got hired after 8th January 1996 but before 1st January 2000 and round the result to 3 decimals*/
select round(avg(salary),3) from employees where hire_date between '09-JAN-1996' and '31-DEC-2000';


/*Display Australia, Asia, Antarctica, Europe along with the regions in the region table*/
(select region_name from regions) union all (select $1  from (values('Australia'),('Asia'),('Antartica'),('Europe')));
(select region_name from regions) union (select $1  from (values('Australia'),('Asia'),('Antartica'),('Europe')));

