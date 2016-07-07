use e12117

#Problem 01
select first_name from employees order by first_name;

/* 
 * Excution time without indexing
 * 300024 total, Query took 0.9359 sec
 */

#Problem 02
create index fname_index on e12117.employees(first_name);
select first_name from employees order by first_name;

/* 
 * Excution time without indexing
 * 300024 total, Query took 0.0417 sec
 * reduce time by 0.8942 sec
 * good improvement
 */

#Problem 03
/* 
 * The above created index is non-unique index because,
 * we use first_name of employees as the indexing attribute
 * There are so many same first names
 * so it is a non unique index
 */

#Problem 04
create unique index emp_index on e12117.employees(emp_no,first_name,last_name);
select emp_no,first_name,last_name
from employees;

/* 
 * Excution time without indexing
 * 300024 total, Query took 0.1012 sec
 * reduce time by 0.8347 sec
 * good improvemnet occured because of the unique indexing
 */

#Problem 05
#Part i
create index empNo on e12117.dept_manager(emp_no);

/* 
 * All three quaries project emp_no attribute.
 * So by having index to that attribute
 * it improve the performances
 */

#Part ii
##Query A
EXPLAIN EXTENDED select distinct emp_no from dept_manager where from_date>='1985-01-01' and dept_no >= 'd005';

/* 
 * Result Set
 **
 ** +----+-------------+--------------+-------+---------------+-------+---------+------+------+----------+-------------+
 ** | id | select_type | table        | type  | possible_keys | key   | key_len | ref  | rows | filtered | Extra       |
 ** +----+-------------+--------------+-------+---------------+-------+---------+------+------+----------+-------------+
 ** |  1 | SIMPLE      | dept_manager | index | dept_no,empNo | empNo | 4       | NULL |   24 |    58.33 | Using where |
 ** +----+-------------+--------------+-------+---------------+-------+---------+------+------+----------+-------------+
 ** 1 row in set, 1 warning (0.00 sec)
 **
 * Acccording to the result set this query has been used empNo index
 */

##Query B
EXPLAIN EXTENDED select distinct emp_no from dept_manager where from_date>= '1996-01-03' and dept_no >= 'd005';

/* Result set
 **
 ** +----+-------------+--------------+-------+---------------+-------+---------+------+------+----------+-------------+
 ** | id | select_type | table        | type  | possible_keys | key   | key_len | ref  | rows | filtered | Extra       |
 ** +----+-------------+--------------+-------+---------------+-------+---------+------+------+----------+-------------+
 ** |  1 | SIMPLE      | dept_manager | index | dept_no,empNo | empNo | 4       | NULL |   24 |    58.33 | Using where |
 ** +----+-------------+--------------+-------+---------------+-------+---------+------+------+----------+-------------+
 ** 1 row in set, 1 warning (0.00 sec)
 ** 
 * According to the result set this query also used the empNo index
 */

##Query C
EXPLAIN EXTENDED select distinct emp_no from dept_manager where from_date>='1985-01-01' and dept_no <= 'd009';

/*
 ** 
 ** +----+-------------+--------------+-------+---------------+-------+---------+------+------+----------+-------------+
 ** | id | select_type | table        | type  | possible_keys | key   | key_len | ref  | rows | filtered | Extra       |
 ** +----+-------------+--------------+-------+---------------+-------+---------+------+------+----------+-------------+
 ** |  1 | SIMPLE      | dept_manager | index | dept_no,empNo | empNo | 4       | NULL |   24 |   100.00 | Using where |
 ** +----+-------------+--------------+-------+---------------+-------+---------+------+------+----------+-------------+
 ** 1 row in set, 1 warning (0.00 sec)
 **
 * According to the result set we can see that this query also used the empNo index
 */

 /* 
  * We can see that all the queries used the implemented indexing.
  * So we can consider it as a good index
  */

#Problem 06
