CREATE DATABASE e12117
USE e12117

// Creating the table employee

create table employees(
	emp_no int,
	birth_date date,
	first_name varchar(14),
	last_name varchar(16),
	sex ENUM('M','F'),
	hire_date date,
	primary key (emp_no)
);

// Creating the table departments

create table departments(
	dept_no char(4),
	dept_name varchar(40),
	primary key (dept_no)
);

// Creating the table dept_manager

create table dept_manager(
	dept_no char(4),
	emp_no int,
	from_date date,
	to_date date,
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

// Creating the table titles

create table titles(
	emp_no int,
	title varchar(50),
	from_date date,
	to_date date,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

// Creating the table salaries

create table salaries(
	emp_no int,
	salary int,
	from_date date,
	to_date date,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no)
);

// Creating the table dept_emp

create table dept_emp(
	emp_no int,
	dept_no char(4),
	from_date date,
	to_date date,
	FOREIGN KEY (emp_no) REFERENCES employees(emp_no),
	FOREIGN KEY (dept_no) REFERENCES departments(dept_no)
);