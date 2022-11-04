#sub query example 1
select e.first_name,e.last_name,de.dept_no from employees e 
	join dept_emp de on e.emp_no=de.emp_no
    WHERE de.dept_no in (select dept_no from departments
    where dept_name in('Human Resourses','Marketing'));

-- sub query example 2
select t.*,s.salary from 
(select e.emp_no,e.first_name,e.last_name,de.dept_no from employees e 
	join dept_emp de on e.emp_no=de.emp_no
    WHERE de.dept_no in (select dept_no from departments
    where dept_name in('Human Resourses','Marketing'))) t 
    join salaries s on s.emp_no=t.emp_no;
    
#correlated query
select e.emp_no,e.first_name,(
	select dept_name from departments d where de.dept_no=d.dept_no) department_name,
    de.from_date,de.to_date from employees e 
    join dept_emp de on e.emp_no=de.emp_no
    where dept_no in (
    select dept_no from departments where dept_name in ('Human Resourses','Marketing'));
    
#temporary table
create temporary table if not exists employee
select e.emp_no,e.first_name,(
	select dept_name from departments d where de.dept_no=d.dept_no) department_name,
    de.from_date,de.to_date from employees e 
    join dept_emp de on e.emp_no=de.emp_no
    where dept_no in (
    select dept_no from departments where dept_name in ('Human Resourses','Marketing'));
select * from employee;
--------------------------------------------------------------
#use employeedb

# 1. Display salary and first name of all employees
select first_name,salary from employees order by salary desc;

# 2. Display all the unique job names in the organization
select distinct JOB_TITLE from jobs;

# 3. Display employees’ name and their salary (increase their salary by 5% and show)
select concat(first_name,' ',last_name) fullname,salary salary_before_increment,
	salary*1.05 salary_after_increment from employees order by salary; 
    
# 4. Display all unique salaries.
select distinct salary from employees;

# 5. Display employee name and square of their name length. Do not include the spaces`
select first_name,length(first_name) length,last_name,length(last_name) length,
	length(first_name)+length(last_name) total_length,
    pow(length(first_name)+length(last_name),2) square_of_fullname from employees;
   
# 6. Display the details of the employee with maximum salary
select first_name,max(salary) from employees;
select max_salary from jobs order by max_salary desc;

# 7. Display the average salary of all the employees
select avg(salary) from employees;

# 8. Display all employes who work in cities which start with 'S'
select first_name,department_name,city from employees e 
	join departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
    join locations l on d.LOCATION_ID=l.LOCATION_ID
    where city like 's%';
    
# 9. Display all employees whose salary is greater than 5000 and work in locations
  # whose address length is greater than 10
select first_name,last_name,salary,street_address from employees e 
	join departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
    join locations l on d.LOCATION_ID=l.LOCATION_ID
    where salary>5000 and length(street_address)>10;
   #using subquery
select first_name,last_name,salary,
	(select street_address from locations l where d.LOCATION_ID=l.LOCATION_ID) address
    from employees e 
	join departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
    where salary>5000;

# 10. Employee with max salary  in Europe
select * from
(select t.*,row_number() over(order by t.salary desc) rno from
(select first_name,last_name,salary from employees e 
	join departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
    join locations l on d.LOCATION_ID=l.LOCATION_ID
    join countries c on l.COUNTRY_ID=c.COUNTRY_ID
    join regions r on c.REGION_ID=r.REGION_ID
    where r.REGION_ID=1) t) t2 where t2.rno=1;
    
  # 11. Find all employees whose salary is greater than the maximum salary of employees in Americas.
 select t2.* from
 (select t.*,row_number() over(order by t.salary desc) rno from
  (select first_name,last_name,salary from employees e 
	join departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
    join locations l on d.LOCATION_ID=l.LOCATION_ID
    join countries c on l.COUNTRY_ID=c.COUNTRY_ID
    join regions r on c.REGION_ID=r.REGION_ID
    where r.REGION_ID=1) t)t2 where t2.rno=1;

select * from employees e 
	join departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
    join locations l on d.LOCATION_ID=l.LOCATION_ID
    join countries c on l.COUNTRY_ID=c.COUNTRY_ID
    join regions r on c.REGION_ID=r.REGION_ID
    where r.REGION_ID=1 and salary=
(select max(salary) from employees e 
	join departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
    join locations l on d.LOCATION_ID=l.LOCATION_ID
    join countries c on l.COUNTRY_ID=c.COUNTRY_ID
    join regions r on c.REGION_ID=r.REGION_ID
    where r.REGION_ID=1);
  # 12. find salaries of all employees whose salary is greater than the average salary of all employees
  select FIRST_NAME, LAST_NAME,salary from employees where salary>
	(select avg(salary) from employees)
	order by salary desc;
# 13. Find all employees whose salary is less than the largest location id
select FIRST_NAME,LAST_NAME,salary from employees where salary<(
select max(location_id) from locations)
order by salary;

# 14. Find the lowest paid employee in Shipping department
select first_name,last_name,salary from employees where DEPARTMENT_ID=(
select department_id from departments where DEPARTMENT_NAME='Shipping')
order by salary limit 1 ;
select first_name,last_name,salary from employees e 
	join departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
    order by salary limit 1;

# 15.Find the sum of salaries of all the employees whose salary is greater than Alberto
select sum(salary) from employees where salary>(
select salary from employees where FIRST_NAME='Alberto');

# 16. Number of countries in each region. Display region name and corresponding countries
select r.region_id,r.REGION_NAME,count(c.COUNTRY_ID) no_of_countries from regions r
	join countries c on r.REGION_ID=c.REGION_ID
    group by r.REGION_ID;
# 17. Average salary of each department. Display dept name and its average salary
select d.department_id,department_name,avg(salary) from departments d 
join employees e on d.DEPARTMENT_ID=e.DEPARTMENT_ID
group by DEPARTMENT_ID order by salary ;
# 18. Maximum salary of all employees under each manager.
SELECT e.first_name emp_name,m.FIRST_NAME manger_name from employees e 
	join employees m on e.EMPLOYEE_ID=m.MANAGER_ID
    group by e.EMPLOYEE_ID;
select e.first_name manager_name,m.MANAGER_ID,max(m.salary) from employees e 
	join employees m on e.EMPLOYEE_ID=m.MANAGER_ID
    group by m.MANAGER_ID
    order by m.MANAGER_ID;
select m.first_name manager_name,m.MANAGER_ID,max(m.salary) from employees e 
	join employees m on e.MANAGER_ID=m.EMPLOYEE_ID
    group by m.MANAGER_ID
    order by m.MANAGER_ID;

# 19. Average salary of all employees in every region. 
#Display region id and its corresponding average salary
select r.REGION_ID,avg(salary) from employees e 
	join departments d on e.DEPARTMENT_ID=d.DEPARTMENT_ID
    join locations l on d.LOCATION_ID=l.LOCATION_ID
    join countries c on l.COUNTRY_ID=c.COUNTRY_ID
    join regions r on c.REGION_ID=r.REGION_ID
    group by r.REGION_ID;
    
# Display manager name and the max salary employee under him.
select m.MANAGER_ID,e.first_name manager_name,max(e.SALARY) from employees e 
	join employees m on e.EMPLOYEE_ID=m.MANAGER_ID
    group by m.MANAGER_ID;
select m.MANAGER_ID,e.first_name manager_name,max(m.SALARY) from employees e 
	join employees m on e.EMPLOYEE_ID=m.MANAGER_ID
    group by m.MANAGER_ID