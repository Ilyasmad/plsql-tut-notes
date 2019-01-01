--82
SET SERVEROUTPUT ON;
DECLARE
    sql_qry VARCHAR2(150);
    emp_tot NUMBER(3);
BEGIN
    sql_qry := 'SELECT COUNT(*) FROM employees';
    EXECUTE IMMEDIATE sql_qry INTO emo_tot;
    DBMS_OUTPUT.PUT_LINE ('Total employees are: '||emp_tot);
END;
/
--83
DECLARE
    ddl_qry VARCHAR2(150);
BEGIN
    ddl_qry :=  'CREATE TABLE tut_82(
                    tut_num NUMBER(3),
                    tut_name VARCHAR2(50)
                )';
    EXECUTE IMMEDIATE ddl_qry;
END;

DESCRIBE tut_82;
/
--84
DECLARE
    ddl_qry VARCHAR2(150);
BEGIN
    ddl_qry :=  'CREATE TABLE tut_83('||
                    'tut_num NUMBER(3),'||
                    'tut_name VARCHAR2(50),'||
                    'CONSTRAINT consl_coll_pk PRIMARY KEY (tut_num)'||
                ')';
    EXECUTE IMMEDIATE ddl_qry;
END;

DESCRIBE tut_83;
/
--85
DECLARE
    ddl_qry VARCHAR2(50);
BEGIN
    ddl_qry := 'ALTER TABLE tut_83
                ADD tut_date DATE';
    EXECUTE IMMEDIATE ddl_qry;
END;

DECLARE
    ddl_qry VARCHAR2 (100);
BEGIN
    ddl_qry := 'DROP TABLE tut_83';
    EXECUTE IMMEDIATE ddl_qry;
END;
/
--86
CREATE TABLE stu_info(
    student_name VARCHAR(20)
);

DECLARE
    sql_smt VARCHAR2(150);
BEGIN
    sql_smt := 'INSERT INTO stu_info (student_name) VALUES (:stu_name)';
    EXECUTE IMMEDIATE sql_smt USING 'Steve';
END;

SELECT * FROM stu_info;
/
--87
INSERT INTO stu_info (student_name) VALUES ('Tony');
INSERT INTO stu_info (student_name) VALUES ('Banner');
INSERT INTO stu_info (student_name) VALUES ('Leo'); 
INSERT INTO stu_info (student_name) VALUES ('Rocket');
INSERT INTO stu_info (student_name) VALUES ('Steve');

SELECT student_name FROM stu_info;

DECLARE
    sql_smt VARCHAR2(150);
BEGIN
    sql_smt := 'UPDATE stu_info SET student_name = :new_name 
                WHERE student_name = :old_name ';
    EXECUTE IMMEDIATE sql_smt USING 'Strange','Leo';            -- cannot use SCHEMA objects for bind variables
END;
/
--88
DECLARE
    TYPE nt_fname IS TABLE OF VARCHAR2(60);     --bulk collect only works by storing into collections
    fname nt_fname;
    sql_qry VARCHAR2(150);                      --bulk collect does not work as an sql query in EXECUTE IMMEDIATE
BEGIN
    sql_qry := 'SELECT first_name FROM employees';
    EXECUTE IMMEDIATE sql_qry BULK COLLECT INTO fname;
    FOR idx IN 1..fname.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE(idx||' - '||fname(idx));
    END LOOP;
END;
/
--89


DECLARE
    plsql_blk VARCHAR2(250);
BEGIN
    plsql_blk :=   'DECLARE
                        var_user VARCHAR2(10);
                    BEGIN
                        SELECT user INTO var_user FROM dual;
                        DBMS_OUTPUT.PUT_LINE(''Current User is ''||var_user);
                    END;';
    EXECUTE IMMEDIATE plsql_blk;
END;
/