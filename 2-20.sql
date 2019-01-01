--2
SET SERVEROUTPUT ON;
DECLARE
    v_test VARCHAR2(15);
BEGIN
    v_test := 'Ilyas';
    DBMS_OUTPUT.PUT_LINE(v_test);
END;

--3
DECLARE
    v_salary NUMBER(8);
BEGIN
    SELECT salary INTO v_salary FROM employees
    WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(v_salary);
END;
/
DECLARE
    v_salary NUMBER(8);
    v_fname VARCHAR2(20);
BEGIN
    SELECT salary, first_name INTO v_salary, v_fname FROM employees
    WHERE employee_id = 100;
    DBMS_OUTPUT.PUT_LINE(v_fname ||' Has Salary '||v_salary);
END;

--4
CREATE TABLE Students(
    STU_ID NUMBER(2),
    FIRST_NAME VARCHAR(8)
);
INSERT INTO Students VALUES(1, 'Clark');
INSERT INTO Students VALUES(2, 'Tony');

DESC Students;
SELECT * FROM Students;

SET SERVEROUTPUT ON;
DECLARE
    v_fname Students.first_name%TYPE;
BEGIN
    SELECT first_name INTO v_fname FROM Students WHERE stu_id = 1;
    DBMS_OUTPUT.PUT_LINE(v_fname);
END;

--5
SET SERVEROUTPUT ON;
DECLARE
    v_pi CONSTANT NUMBER(7,6) := 3.141592;
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_pi);
END;
/
DECLARE
    v_pi CONSTANT NUMBER(7,6) NOT NULL DEFAULT 3.141592;
BEGIN
   DBMS_OUTPUT.PUT_LINE(v_pi);
END;

--6
VARIABLE v_bind1 VARCHAR2(10);
EXEC :v_bind1 := 'Ilyas';
SET SERVEROUTPUT ON;
BEGIN
   DBMS_OUTPUT.PUT_LINE(:v_bind1);
END;
/

SET AUTOPRINT ON;
VARIABLE v_bind2 VARCHAR2(30);
EXEC :v_bind2 := 'Manish';

--8
DECLARE
    v_num NUMBER := 9;
BEGIN
    IF v_num <10 THEN
        DBMS_OUTPUT.PUT_LINE('Inside the IF');
    END IF;
        DBMS_OUTPUT.PUT_LINE('Outside The IF');
END;
/

--9
DECLARE
    v_num NUMBER := &enter_a_number;
BEGIN
    IF MOD(v_num,2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE(v_num ||' Is Even');
    ELSE
        DBMS_OUTPUT.PUT_LINE(v_num ||' Is Odd');
    END IF;
        DBMS_OUTPUT.PUT_LINE('If Then Else Construct Complete');
END;
/
--10
DECLARE
    v_place VARCHAR2(30) := '&enter_place';
BEGIN
    IF v_place = 'Metropolis' THEN
        DBMS_OUTPUT.PUT_LINE('City is protected by Superman');
    ELSIF v_place = 'Gotham' THEN
        DBMS_OUTPUT.PUT_LINE('City is protected by Batman');
    ELSIF v_place = 'Amazon' THEN
        DBMS_OUTPUT.PUT_LINE('City is protected by Wonder Woman');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Please call Avengers');
    END IF;
        DBMS_OUTPUT.PUT_LINE('Thanks for contacting us');
END;
/
--11
DECLARE
    v_counter NUMBER :=0;
    v_result NUMBER;
BEGIN
    LOOP
        v_counter := v_counter + 1;
        v_result := 19 * v_counter;
        DBMS_OUTPUT.PUT_LINE('19'||' x '||v_counter||' = '||v_result);
        EXIT WHEN v_counter >=10;
    END LOOP;
END;
/
--12
DECLARE
    v_test BOOLEAN := TRUE;
    v_counter NUMBER := 0;
BEGIN
    WHILE v_counter <= 10 LOOP
        v_counter := v_counter + 1;
        DBMS_OUTPUT.PUT_LINE(v_counter);
    IF v_counter = 10 THEN
        v_test := FALSE;
    END IF;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Outside the Loop');
END;
/
--13
BEGIN
    FOR v_counter IN REVERSE 1 .. 10 LOOP
        DBMS_OUTPUT.PUT_LINE(v_counter);
    END LOOP;
END;
/
--15
CREATE TABLE superheroes (
    sh_name VARCHAR2(20)
);

CREATE OR REPLACE TRIGGER bi_superheroes
BEFORE INSERT OR DELETE OR UPDATE ON superheroes
FOR EACH ROW
ENABLE
DECLARE
    v_user VARCHAR2(20);
BEGIN
    SELECT user INTO v_user FROM dual;
    IF INSERTING THEN
        DBMS_OUTPUT.PUT_LINE('One row inserted by Mr. '||v_user);
    ELSIF UPDATING THEN
        DBMS_OUTPUT.PUT_LINE('One row updated by Mr. '||v_user);
    ELSIF DELETING THEN
        DBMS_OUTPUT.PUT_LINE('One row deleted by Mr. '||v_user);
    END IF;
END;

INSERT INTO superheroes VALUES ('Ironman');
/
--16
CREATE TABLE sh_audit(
    new_name VARCHAR2(30),
    old_name VARCHAR2(30),
    user_name VARCHAR2(30),
    entry_date VARCHAR2(30),
    operation VARCHAR(30)
);

CREATE OR REPLACE trigger superheroes_audit
BEFORE INSERT OR DELETE OR UPDATE ON superheroes
FOR EACH ROW
ENABLE
DECLARE
    v_user VARCHAR2(30);
    v_date VARCHAR2(30);
BEGIN
    SELECT user, TO_CHAR(sysdate, 'DD/MON/YYY HH24:MI:SS') INTO v_user, v_date FROM dual;
    IF INSERTING THEN
        INSERT INTO sh_audit(new_name, old_name, user_name, entry_date, operation)
        VALUES(:NEW.sh_name, NULL, v_user, v_date, 'Insert');
    ELSIF DELETING THEN
        INSERT INTO sh_audit(new_name, old_name, user_name, entry_date, operation)
        VALUES(NULL, :OLD.sh_name, v_user, v_date, 'Delete');
    ELSIF UPDATING THEN
        INSERT INTO sh_audit(new_name, old_name, user_name, entry_date, operation)
        VALUES(:NEW.sh_name, :OLD.sh_name, v_user, v_date, 'Update');
    END IF;
END;    
/    
--17
CREATE TABLE superheroes_backup AS SELECT * FROM superheroes WHERE 1=2;

CREATE OR REPLACE trigger sh_backup
BEFORE INSERT OR DELETE OR UPDATE ON superheroes
FOR EACH ROW
ENABLE
BEGIN
    IF INSERTING THEN
        INSERT INTO superheroes_backup(sh_name) VALUES(:NEW.sh_name);
    ELSIF DELETING THEN
        DELETE FROM superheroes_backup WHERE sh_name = :OLD.sh_name;
    ELSIF UPDATING THEN
        UPDATE superheroes_backup SET sh_name = :NEW.sh_name WHERE sh_name = :OLD.sh_name;
    END IF;
END;

INSERT INTO superheroes VALUES('Batman');
INSERT INTO superheroes VALUES('Superman');
UPDATE superheroes SET sh_name = 'Ironman' WHERE sh_name = 'Batman';
DELETE FROM superheroes WHERE sh_name = 'Superman';

SELECT * FROM superheroes;
SELECT * FROM superheroes_backup;
/
--18
SHOW user;
CREATE TABLE schema_audit(
    ddl_date DATE,
    ddl_user VARCHAR2(15),
    ddl_created VARCHAR2(15),
    ddl_name VARCHAR2(15),
    ddl_operation VARCHAR2(15)
);

CREATE OR REPLACE TRIGGER hr_audit_tr
AFTER DDL ON SCHEMA
BEGIN
    INSERT INTO schema_audit VALUES(
        sysdate,
        sys_context('USERENV', 'CURRENT_USER'),
        ora_dict_obj_type,
        ora_dict_obj_name,
        ora_sysevent
    );
END;

SELECT * FROM schema_audit;
SELECT * FROM rebellionRider;

CREATE TABLE rebellionRider(r_num NUMBER);
INSERT INTO rebellionRider VALUES (8);
TRUNCATE TABLE rebellionRider;
DROP TABLE rebellionRider;
/
--19
CREATE TABLE hr_evnt_audit(
    event_type VARCHAR2(30),
    logon_date DATE,
    logon_time VARCHAR2(15),
    logof_date DATE,
    logof_time VARCHAR2(15)
);

CREATE OR REPLACE TRIGGER hr_lgon_audit
AFTER LOGON ON SCHEMA
BEGIN
    INSERT INTO hr_evnt_audit VALUES(
        ora_sysevent,
        sysdate,
        TO_CHAR(sysdate, 'hh24:mi:ss'),
        NULL,
        NULL
    );
    COMMIT;
END;

SELECT * FROM hr_evnt_audit;

DISC;
conn SYSTEM/system;
/
--20
CREATE OR REPLACE TRIGGER hr_lgoff_audit
BEFORE LOGOFF ON SCHEMA
BEGIN
    INSERT INTO hr_evnt_audit VALUES(
        ora_sysevent,
        NULL,
        NULL,
        sysdate,
        TO_CHAR(sysdate, 'hh24:mi:ss')
    );
    COMMIT;
END;
-- below only in sys database since it has the dual table that contains all users.
CREATE TABLE db_evnt_audit(
    user_name VARCHAR2(15),
    event_type VARCHAR2(30),
    logon_date DATE,
    logon_time VARCHAR2(15),
    logof_date DATE,
    logof_time VARCHAR2(15)
);

CREATE OR REPLACE TRIGGER db_lgoff_audit
BEFORE LOGOFF ON DATABASE
BEGIN
    INSERT INTO db_evnt_audit VALUES(
        user,
        ora_sysevent,
        NULL,
        NULL,
        sysdate,
        TO_CHAR(sysdate, 'hh24:mi:ss')
    );
    COMMIT;
END;
/