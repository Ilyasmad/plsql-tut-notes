--21
CREATE TABLE startup_audit(
    event_type VARCHAR(30),
    event_date DATE,
    event_time VARCHAR2(15)
);

CREATE OR REPLACE TRIGGER tr_startup_audit
AFTER STARTUP ON DATABASE
BEGIN
    INSERT INTO startup_audit VALUES(
        ora_sysevent,
        SYSDATE,
        TO_CHAR(sysdate, 'hh24:mm:ss')
    );
END;
/
--22
CREATE TABLE trainer(
    full_name VARCHAR2(20)
);
CREATE TABLE subject(
    subject_name VARCHAR2(20)
);

INSERT INTO trainer VALUES('Manish Sharma');
INSERT INTO subject VALUES('Oracle');

CREATE VIEW vw_RRider AS
SELECT full_name, subject_name FROM trainer, subject;

INSERT INTO vw_RRider VALUES ('Manish', 'Java');                    --not updateable view, so error.

CREATE OR REPLACE TRIGGER tr_io_insert
INSTEAD OF INSERT ON vw_RRider
FOR EACH ROW
BEGIN
    INSERT INTO trainer(full_name) VALUES(:new.full_name);
    INSERT INTO subject(subject_name) VALUES(:new.subject_name);    -- can create a trigger: instead of to pass it.
END;
/
--23
UPDATE vw_RRider SET full_name = 'Tony Stark' WHERE subject_name = 'Java';

CREATE OR REPLACE TRIGGER tr_io_update
INSTEAD OF UPDATE ON vw_RRider
FOR EACH ROW
BEGIN
    UPDATE trainer SET full_name = :new.full_name WHERE full_name = :old.full_name;
    UPDATE subject SET subject_name = :new.subject_name WHERE subject_name = :old.subject_name;
END;
/
--24
DELETE FROM vw_RRider WHERE subject_name = 'Java';

CREATE OR REPLACE TRIGGER tr_io_delete
INSTEAD OF DELETE ON vw_RRider
FOR EACH ROW
BEGIN
    DELETE FROM trainer WHERE full_name = :old.full_name;
    DELETE FROM subject WHERE subject_name = :old.subject_name;
END;
/
--28
SET SERVEROUTPUT ON;
DECLARE
    v_name VARCHAR2(30);
    CURSOR cur_RRider IS
    SELECT first_name FROM employees
    WHERE employee_id<105;
BEGIN
    OPEN cur_RRider;
    LOOP
        FETCH cur_RRider INTO v_name;
        DBMS_OUTPUT.PUT_LINE(v_name);
        EXIT WHEN cur_RRider%NOTFOUND;
    END LOOP;
    CLOSE cur_RRider;
END;
/
--29
SET SERVEROUTPUT ON;
DECLARE
    v_name VARCHAR2(30);
    CURSOR p_cur_RRider (var_e_id VARCHAR2) IS
    SELECT first_name FROM employees
    WHERE employee_id< var_e_id;
BEGIN
    OPEN p_cur_RRider(105);
    LOOP
        FETCH p_cur_RRider INTO v_name;
        DBMS_OUTPUT.PUT_LINE(v_name);
        EXIT WHEN p_cur_RRider%NOTFOUND;
    END LOOP;
    CLOSE p_cur_RRider;
END;
/
--30;
SET SERVEROUTPUT ON;
DECLARE
    v_name VARCHAR2(30);
    v_eid NUMBER(10);
    CURSOR cur_RRider (var_e_id NUMBER := 190) IS
    SELECT first_name, employee_id FROM employees
    WHERE employee_id > var_e_id;
BEGIN
    OPEN p_cur_RRider;
    LOOP
        FETCH cur_RRider INTO v_name, v_eid;
        DBMS_OUTPUT.PUT_LINE(v_name ||' '||v_eid);
        EXIT WHEN cur_RRider%NOTFOUND;
    END LOOP;
    CLOSE cur_RRider;
END;
/
--31
DECLARE 
    CURSOR cur_RRider IS
    SELECT first_name, last_name FROM employees WHERE employee_id > 200;
BEGIN
    FOR L_IDX IN cur_RRider
    LOOP
        DBMS_OUTPUT.PUT_LINE(L_IDX.first_name||' '||L_IDX.last_name);
    END LOOP;
END;
/
--32
DECLARE 
    CURSOR cur_RRider (var_e_id NUMBER) IS
    SELECT employee_id, first_name FROM employees WHERE employee_id > var_e_id;
BEGIN
    FOR L_IDX IN cur_RRider(200)
    LOOP
        DBMS_OUTPUT.PUT_LINE(L_IDX.employee_id||' '||L_IDX.first_name);
    END LOOP;
END;
/
--34
DECLARE
    v_emp employees%ROWTYPE;
BEGIN
    SELECT * INTO v_emp
    FROM employees WHERE employee_id = 200;
    DBMS_OUTPUT.PUT_LINE(v_emp.first_name||' '||v_emp.salary);
    DBMS_OUTPUT.PUT_LINE(v_emp.hire_date);
END;
/
--35
SET SERVEROUTPUT ON;
DECLARE
    v_emp employees%ROWTYPE;
BEGIN
    SELECT first_name, hire_date INTO v_emp.first_name, v_emp.hire_date FROM employees
    WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(v_emp.first_name);
    DBMS_OUTPUT.PUT_LINE(v_emp.hire_date);
END;
/
--36
DECLARE
    CURSOR cur_RRider IS
    SELECT first_name, Salary FROM employees
    WHERE employee_id = 100;
    var_emp cur_RRider%ROWTYPE;
BEGIN
    OPEN cur_RRider;
    FETCH cur_RRider INTO var_emp;
    DBMS_OUTPUT.PUT_LINE(var_emp.first_name);
    DBMS_OUTPUT.PUT_LINE(var_emp.emp_salary);
    CLOSE cur_RRider;
END;
/
--37
DECLARE
    CURSOR cur_RRider IS
    SELECT first_name, salary FROM employees
    WHERE employee_id > 200;
    var_emp cur_RRider%ROWTYPE;
BEGIN
    FOR L_IDX IN cur_RRider
    LOOP
        DBMS_OUTPUT.PUT_LINE(var_emp.first_name||' '||var_emp.salary);
    END LOOP;
END;
/
--38
DECLARE
    TYPE rv_dept IS RECORD(
        f_name VARCHAR2(20),
        d_name DEPARTMENTS.department_name%TYPE
    );
    var1 rv_dept;
BEGIN
    SELECT first_name, department_name INTO var1.f_name, var1.d_name
    FROM employees JOIN departments USING (department_id) WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(var1.f_name||' '||var1.d_name);
END;
/
--40
CREATE OR REPLACE FUNCTION circle_area (radius NUMBER)
RETURN NUMBER IS
pi CONSTANT NUMBER(7,3) := 3.141;
area NUMBER(7,3);
BEGIN
    area := pi * (radius * radius);
    RETURN area;
END;

BEGIN
    DBMS_OUTPUT.PUT_LINE(circle_area (25));
END;
/