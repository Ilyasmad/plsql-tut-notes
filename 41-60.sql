--42
SET SERVEROUTPUT ON;
CREATE OR REPLACE PROCEDURE pr_RRider IS
    var_name VARCHAR(20) := 'Manish';
    var_web VARCHAR(20) := 'RebellionRider.com';
BEGIN
    DBMS_OUTPUT.PUT_LINE('whats up internet? I am ' ||var_name|| ' from '||var_web);
END pr_RRider;

EXEC pr_RRider;
BEGIN
    pr_RRider;
END;
/
--43
CREATE OR REPLACE PROCEDURE emp_sal (dep_id NUMBER, sal_raise NUMBER)
IS
BEGIN
    UPDATE employees SET salary = salary * sal_raise WHERE department_id = dep_id;
END;

CREATE OR REPLACE PROCEDURE pr_third_sal(var_third number)
IS
var_salary employees.salary%type;
BEGIN
    SELECT salary INTO var_salary FROM employees 
    ORDER BY salary DESC
    OFFSET 2 ROWS FETCH NEXT 1 ROWS ONLY;
END;
/
--44
CREATE OR REPLACE PROCEDURE emp_sal (dep_id NUMBER, sal_raise NUMBER)
IS
BEGIN
    UPDATE employees SET salary = salary * sal_raise WHERE department_id = dep_id;
    DBMS_OUTPUT.PUT_LINE('Salary update successfully');
END;

EXEC emp_sal(40, 2);

CREATE OR REPLACE FUNCTION add_num
(var_1 NUMBER, var_2 NUMBER DEFAULT 0, var_3 NUMBER) RETURN NUMBER
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE('var_1 -> '||var_1);
    DBMS_OUTPUT.PUT_LINE('var_2 -> '||var_2);
    DBMS_OUTPUT.PUT_LINE('var_3 -> '||var_3);
    RETURN var_1 + var_2 + var_3;
END;

EXEC DBMS_OUTPUT.PUT_LINE(add_num(var_3 => 5, var_1 => 2));
/
--46
CREATE OR REPLACE PACKAGE pkg_RRider IS
    FUNCTION prnt_strng RETURN VARCHAR2;
    PROCEDURE proc_superhero (f_name VARCHAR2, l_name VARCHAR2);
END pkg_RRider;

CREATE OR REPLACE PACKAGE BODY pkg_RRider IS
    FUNCTION prnt_strng RETURN VARCHAR2 IS
        BEGIN
            RETURN 'RebellionRider.com';
        END prnt_strng;
    PROCEDURE proc_superhero (f_name VARCHAR2, l_name VARCHAR2) IS
        BEGIN
            INSERT INTO new_superheroes(f_name, l_name) VALUES(f_name, l_name);
        END;
END pkg_RRider;

EXEC DBMS_OUTPUT.PUT_LINE (pkg_RRider.prnt_strng);
BEGIN
    pkg_RRider.proc_superhero('Black', 'Panther');
END;

SELECT * FROM new_superheroes;
/
--48
DECLARE
    var_divident NUMBER := 24;
    var_divisor NUMBER := 0;
    var_result NUMBER;
    ex_DivZero EXCEPTION;
BEGIN
    IF var_Divisor = 0 THEN
        RAISE ex_DivZero;
    END IF;
    var_result := var_divident/var_divisor;
    DBMS_OUTPUT.PUT_LINE('Result = '|| var_result);
    EXCEPTION WHEN ex_DivZero THEN
        DBMS_OUTPUT.PUT_LINE('Error - Your Divisor is Zero');  
END;
/
--49
ACCEPT var_age NUMBER PROMPT 'What is your AGE?';
DECLARE
    age NUMBER := &var_age;
BEGIN
    IF age<18 THEN
        RAISE_APPLICATION_ERROR(-20008, 'You should be 18 or above for the DRINKS!');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Sure, What would you like to have?');
    EXCEPTION WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
--50
DECLARE
    ex_age EXCEPTION;
    age NUMBER := 17;
    PRAGMA EXCEPTION_INIT(ex_age, -20008);
BEGIN
    IF age<18 THEN
        RAISE_APPLICATION_ERROR(-20008, 'You should be 18 or above for the drinks!');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Sure, What would you like to have?');
    EXCEPTION WHEN ex_age THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
--52
DECLARE
    TYPE my_nested_table IS TABLE OF NUMBER;
    var_nt my_nested_table := my_nested_table(9,18,27,36,45,54,63,72,81,90);
BEGIN
    FOR i IN 1..var_nt.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE('Value Stored at Index '||i||' is '|| var_nt(i));
    END LOOP;
END;
/
--53
CREATE OR REPLACE TYPE my_nested_table IS TABLE OF VARCHAR2(10);

CREATE TABLE my_subject(
    sub_id NUMBER,
    sub_name VARCHAR2(20),
    sub_schedule_day my_nested_table
)NESTED TABLE sub_schedule_d STORE AS nested_tab_space;

DESC my_subject;
INSERT INTO my_subject(sub_id, sub_name, sub_schedule_d) VALUES(101, 'Maths', my_nested_table('mon', 'fri'));
/
--54
CREATE OR REPLACE TYPE object_type AS OBJECT(
    obj_id NUMBER,
    obj_name VARCHAR2(10)
);

CREATE OR REPLACE TYPE my_nt IS TABLE OF object_type;

CREATE TABLE base_table(
    tab_id  NUMBER,
    tab_ele my_nt
) NESTED TABLE tab_ele STORE AS store_tab_1;
/
--56
DECLARE
    TYPE inBlock_vry IS VARRAY (5) OF NUMBER;
    vry_obj inBlock_vry := inBlock_vry();
BEGIN
    FOR i IN 1..vry_obj.LIMIT
    LOOP
        vry_obj.EXTEND;
        vry_obj(i) := 10*i;
        DBMS_OUTPUT.PUT_LINE(vry_obj(i));
    END LOOP;
END;
/
--57
CREATE OR REPLACE TYPE dbObj_vry IS VARRAY(5) OF NUMBER;

CREATE TABLE calendar(
    day_name VARCHAR2(25),
    day_date dbObj_vry
);                                              -- nested table requires store, varray does not.

INSERT INTO calendar (day_name, day_date) VALUES ('Sunday', dbObj_vry(7,14,21,28));

SELECT
    tab1.day_name,
    vry.column_value
FROM calendar tab1, TABLE (tab1.day_date) vry;
/
--58
DECLARE                                         -- assoc array cannot be made into db objects, and works like
    TYPE books IS TABLE OF NUMBER               -- objects in other programming languages; key-value pairs
        INDEX BY VARCHAR2(20);
    isbn books;
    flag VARCHAR2(20);
BEGIN
    isbn('Oracle Database') := 1234;
    isbn('MySQL') := 9876;
    isbn('MySQL') := 1001;
    flag := isbn.FIRST;
    WHILE flag IS NOT NULL
    LOOP
        DBMS_OUTPUT.PUT_LINE(flag||': '||isbn(flag));
        flag := isbn.NEXT(flag);
    END LOOP;
END;
/
--60
--difference between count and limit, is that limit is bounded, and count counts the non-empty values.
SET SERVEROUTPUT ON;
DECLARE
    TYPE my_nested_table IS TABLE OF number;
    var_nt my_nested_table := my_nested_table (9,18,27,36,45,54,63,72,81,90);
BEGIN
    DBMS_OUTPUT.PUT_LINE ('The Size of the Nested Table is ' ||var_nt.count);
END;

DECLARE
    TYPE my_nested_table IS TABLE OF NUMBER;
    var_nt my_nested_table := my_nested_table (9,18,27,36,45,54,63,72,81,90);
BEGIN
    IF var_nt.count >= 10 THEN
        DBMS_OUTPUT.PUT_LINE ('you have already inserted 10 elements in your Nested table.');
        DBMS_OUTPUT.PUT_LINE ('Are you sure you want to insert more?');
    END IF;
END;
/