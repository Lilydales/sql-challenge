----DATA ENGINEERING----

CREATE TABLE Departments (
    dept_no char(10)   NOT NULL,
    dept_name char(30)   NOT NULL,
    CONSTRAINT pk_Departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE Employee_Departments (
    emp_no char(6)   NOT NULL,
    dept_no char(4)   NOT NULL
);

CREATE TABLE Manager_Departments (
    dept_no char(10)   NOT NULL,
    emp_no char(6)   NOT NULL,
    CONSTRAINT pk_Manager_Departments PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Employee (
    emp_no char(6)   NOT NULL,
    emp_title_id char(15)   NOT NULL,
    birth_date char(30)   NOT NULL,
    first_name char(30)   NOT NULL,
    last_name char(30)   NOT NULL,
    sex char(5)   NOT NULL,
    hire_date char(30)   NOT NULL,
    CONSTRAINT pk_Employee PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Salaries (
    emp_no char(6)   NOT NULL,
    salary int   NOT NULL,
    CONSTRAINT pk_Salaries PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE Titles (
    title_id char(15)   NOT NULL,
    title char(30)   NOT NULL,
    CONSTRAINT pk_Titles PRIMARY KEY (
        title_id
     )
);

ALTER TABLE Employee_Departments ADD CONSTRAINT fk_Employee_Departments_emp_no FOREIGN KEY(emp_no)
REFERENCES Employee (emp_no);

ALTER TABLE Employee_Departments ADD CONSTRAINT fk_Employee_Departments_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE Manager_Departments ADD CONSTRAINT fk_Manager_Departments_dept_no FOREIGN KEY(dept_no)
REFERENCES Departments (dept_no);

ALTER TABLE Manager_Departments ADD CONSTRAINT fk_Manager_Departments_emp_no FOREIGN KEY(emp_no)
REFERENCES Employee (emp_no);

ALTER TABLE Employee ADD CONSTRAINT fk_Employee_emp_no FOREIGN KEY(emp_no)
REFERENCES Salaries (emp_no);

ALTER TABLE Employee ADD CONSTRAINT fk_Employee_emp_title_id FOREIGN KEY(emp_title_id)
REFERENCES Titles (title_id);

-- Add a composite primary key on emp_no and dept_no
ALTER TABLE Employee_Departments
ADD CONSTRAINT pk_employee_department
PRIMARY KEY (emp_no, dept_no);

select * from employee
----DATA ANALYSIS----
--List the employee number, 
--last name, first name, sex, and salary of each employee.
select e.emp_no,e.last_name,e.first_name,e.sex, s.salary
from employee e
inner join salaries s on e.emp_no=s.emp_no;

--Convert to date type for hire date
alter table employee
alter column hire_date type date using to_date(hire_date,'MM/DD/YYYY');

--List the first name, last name, and hire date 
--for the employees who were hired in 1986.
select e.first_name,e.last_name,e.hire_date
from employee e
where extract(year from e.hire_date)=1986;

--List the manager of each department along with 
--their department number, department name, employee number, 
--last name, and first name.
select m.dept_no,d.dept_name,m.emp_no,e.last_name,e.first_name
from manager_departments m
inner join departments d on m.dept_no=d.dept_no
inner join employee e on m.emp_no=e.emp_no;

--List the department number for each employee along with 
--that employee’s employee number, last name, first name, 
--and department name.
select ed.dept_no,d.dept_name,ed.emp_no,e.last_name,e.first_name
from employee_departments ed
inner join departments d on ed.dept_no=d.dept_no
inner join employee e on ed.emp_no=e.emp_no;

--List the first name, last name, and sex of each employee whose 
--first name is Hercules and whose last name begins with the letter B.
select first_name, last_name,sex
from employee
where first_name='Hercules' and last_name like 'B%';

--List each employee in the Sales department, 
--including their employee number, last name, and first name.
select ed.emp_no,e.last_name,e.first_name
from employee_departments ed
inner join employee e on ed.emp_no=e.emp_no
inner join departments d on ed.dept_no=d.dept_no
where d.dept_name='Sales';

--List each employee in the Sales and Development departments, including 
--their employee number, last name, first name, and department name.
select ed.emp_no,e.last_name,e.first_name,d.dept_name
from employee_departments ed
inner join employee e on ed.emp_no=e.emp_no
inner join departments d on ed.dept_no=d.dept_no
where d.dept_name='Sales' or d.dept_name='Development';

--List the frequency counts, in descending order, of all 
--the employee last names 
--(that is, how many employees share each last name).
select last_name, count(*) as frequency
from employee
group by last_name
order by frequency desc;