###create database and create tables###

create database e12117;
use e12117;

create table employees
(
	emp_no int,
	birth_date date,
	first_name varchar(14),
	last_name varchar(16),
	sex enum('M','F'),
	hire_date date,
	primary key (emp_no)
);

create table departments
(
	dept_no char(4),
	dept_name varchar(40),
	primary key (dept_no)
);

create table dept_manager
(
	emp_no int,
	dept_no char(4),
	from_date date,
	to_date date,
	foreign key (dept_no) references departments (dept_no),
	foreign key (emp_no) references employees (emp_no)
);

create table dept_emp
(
	emp_no int,
	dept_no char(4),
	from_date date,
	to_date date,
	foreign key (dept_no) references departments (dept_no),
	foreign key (emp_no) references employees (emp_no)
);

create table salaries
(
	emp_no int,
	salary int,
	from_date date,
	to_date date,
	foreign key (emp_no) references employees (emp_no)
);

create table titles
(
	emp_no int,
	title varchar(50),
	from_date date,
	to_date date,
	foreign key (emp_no) references employees (emp_no)
);

### Entering the database ###

I had used 
source path/to/the/file/ file.sql to upload the databases with the use of given files
	ex: source C:/xampp/mysql/bin/load_employees.sql 

### Problems ###
2.) select last_name, COUNT(emp_no) as num_emp
    from employees
    group by last_name
    order by num_emp DESC
    limit 10;
	
3.) select d.dept_name, count(de.emp_no) as num_eng
   from dept_emp de 
   inner join titles t 
   on de.emp_no = t.emp_no
   inner join departments d   
   on de.dept_no = d.dept_no
   where t.title = "Engineer" and year(t.to_date) = "9999"
   group by de.dept_no
   order by num_eng DESC;
   
4.) select e.first_name,e.last_name 
	from employees e
	inner join dept_manager dm
	on e.emp_no = dm.emp_no
	inner join titles t
	on e.emp_no = t.emp_no
	where e.sex = "F" and year(dm.to_date) = "9999" and year(dm.from_date) = year(t.to_date) and t.title = "Senior Engineer";
	
	
5.)	part_1:
	select d.dept_name,t.title
	from departments d
	inner join dept_emp de
	on d.dept_no = de.dept_no
	inner join titles t
	on t.emp_no = de.emp_no
	inner join salaries s
	on s.emp_no = de.emp_no
	where s.salary > "115000" and year(t.to_date) = "9999" and year(s.to_date) = "9999" and year(de.to_date) = "9999";
	
	part_2
	select d.dept_name, COUNT(s.emp_no) as num_emp
	from salaries s
	inner join dept_emp de
	on s.emp_no = de.emp_no
	inner join departments d
	on d.dept_no = de.dept_no
	where s.salary > "115000" and year(s.to_date) = "9999" and year(de.to_date) = "9999"
	group by d.dept_name
	order by num_emp DESC;
	
6.) select Distinct e.first_name, e.last_name, "2016"-year(e.birth_date) as age, "2016"-year(e.hire_date) as contribute
	from employees e
	inner join dept_emp de
	on e.emp_no = de.emp_no
	where "2016"-year(e.birth_date) > 50 and "2016"-year(e.hire_date) > 10
	order by "2016"-year(e.birth_date) desc;
	
7.) select concat(e.first_name, " " , e.last_name) as Name
	from employees e
	inner join dept_emp de
	on de.emp_no = e.emp_no
	inner join departments d
	on d.dept_no = de.dept_no
	where d.dept_name != "Human Resources";
	
8.) select concat(e.first_name, " " , e.last_name) as Name
	from employees e
	inner join dept_emp de
	on e.emp_no=de.emp_no
	inner join salaries s
	on e.emp_no=s.emp_no
	where s.salary > any
	(
	select max(s.salary)
	from salaries s
	inner join dept_emp de
	on s.emp_no=de.emp_no
	inner join departments d
 	on d.dept_no=de.dept_no
	where d.dept_name ="Finance"
	)
	group by Name;
	
9.) select concat(e.first_name, " " , e.last_name) as Name
	from employees e
	inner join salaries s
	on e.emp_no = s.emp_no
	where s.salary > any
	(
	select avg(s.salary)
	from salaries s
	)
	group by Name;
	
10.)
	select avg(s.salary)-
	(
	select avg(s.salary)
	from salaries s
	inner join titles t
	on t.emp_no = s.emp_no
	where t.title="Senior Engineer"
	)
	as difference
	from salaries s;
	
11.)
	create view current_dept_emp as
	select e.emp_no , de.from_date , de.to_date
	from employees e
	inner join dept_emp de
	on e.emp_no = de.emp_no;
	
12.) 
	select e.emp_no, de.from_date, de.to_date
	from employees e
	inner join dept_emp de
	on de.emp_no = e.emp_no;
	
13.)
	create table emp_salary_change
	(
		old_salary int,
		new_salary int,
		difference int,
		action VARCHAR(50) DEFAULT NULL
	);
	
	delimiter $
	create trigger after_salaries_update
	after update on salaries
	for each row
	begin 
	insert into emp_salary_change
	SET action = 'update',
    old_Salary = old.salary,
    new_Salary = new.salary,
    difference = new.salary-old.salary; 
	end $
	delimiter ;
	
14.)
	delimiter $
	
	create trigger error_salary_update
	before update on salaries
	for each row
	begin
	declare msg varchar(50);
	if(new.salary-old.salary)>(old.salary*0.1)then
		set msg ="Error : Salary increment > 10%";
		signal sqlstate '45000' set message_text = msg;
	end if;
	end $
	delimiter ;