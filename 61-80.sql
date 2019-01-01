--61
SET SERVEROUTPUT ON;
DECLARE
    TYPE my_nested_table IS TABLE OF VARCHAR2 (20);
    col_var_1 my_nested_table := my_nested_table ('Superman', 'Ironman', 'Batman');
BEGIN
    IF col_var_1.EXISTS (4) THEN
        DBMS_OUTPUT.PUT_LINE('Hey! we found '|| col_var_1(4));
    ELSE
        DBMS_OUTPUT.PUT_LINE('This index is empty. Inserting new data...');
        col_var_1.EXTEND;
        col_var_1(4) := 'Spiderman';
    END IF;
    DBMS_OUTPUT.PUT_LINE('New Data at Index 4 is '|| col_var_1(4));
END;
/
--62
DECLARE
    TYPE nt_tab IS TABLE OF NUMBER;
    col_var nt_tab := nt_tab(10,20,30,40,50);
BEGIN
    col_var.TRIM;
    DBMS_OUTPUT.PUT_LINE('Last index after DELETE is ['|| col_var.LAST ||'] : '|| col_var(col_var.LAST));
END;
/
--63
DECLARE
    TYPE inBlock_vry IS VARRAY (5) OF NUMBER;
    vry_obj inBlock_vry := inBlock_vry();
BEGIN
    vry_obj.EXTEND;
    vry_obj(1) := 10;
    DBMS_OUTPUT.PUT_LINE('Total Indexes '||vry_obj.LIMIT);
    DBMS_OUTPUT.PUT_LINE('Total Number of Non-empty indexes '||vry_obj.COUNT);
END;
/
--64
DECLARE
    TYPE my_nested_table IS TABLE OF NUMBER;
    var_nt my_nested_table := my_nested_table(9,18,27,36,45,54,63,72,81,90);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Index before 3rd Index is '||var_nt.PRIOR(3));
    DBMS_OUTPUT.PUT_LINE('Value before 3rd Index is '||var_nt(var_nt.PRIOR(3)));
    DBMS_OUTPUT.PUT_LINE('Index after 3rd Index is '||var_nt.AFTER(3));
    DBMS_OUTPUT.PUT_LINE('Value after 3rd Index is '||var_nt(var_nt.AFTER(3)));
END;
/
--65
DECLARE
    TYPE my_nested_table IS TABLE OF NUMBER;
    var_nt my_nested_table := my_nested_table(2,4,6,8,10,12,14,16,18,20);
BEGIN
    DBMS_OUTPUT.PUT_LINE('Value at undex [5] before DELETE is '||var_nt(5));
    var_nt.DELETE(5);                                                           --no paramaters deletes all indexes.
    IF var_nt.EXISTS(5) THEN
        DBMS_OUTPUT.PUT_LINE('Value at undex [5] after DELETE is '||var_nt(5));
    ELSE
        DBMS_OUTPUT.PUT_LINE('Data is Deleted');
    END IF;
END;

DECLARE
    TYPE my_nested_table IS TABLE OF NUMBER;
    var_nt my_nested_table := my_nested_table(2,4,6,8,10,12,14,16,18,20);
BEGIN
--Range Delete
    var_nt.DELETE(2,6);
    FOR i IN 1..var_nt.LAST 
    LOOP
        IF var_nt.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE('Value at Index ['||i||'] is '|| var_nt(i));
        END IF;
    END LOOP;
END;
/
--66
DECLARE
    TYPE my_nestedTable IS TABLE OF number;
    nt_obj my_nestedTable := my_nestedTable();
BEGIN
    nt_obj.EXTEND;
    nt_obj(1) := 10;
    DBMS_OUTPUT.PUT_LINE ('Data at index 1 is '||nt_obj(1));
END;

DECLARE
    TYPE my_nestedTable IS TABLE OF number;
    nt_obj my_nestedTable := my_nestedTable();
BEGIN
    nt_obj.EXTEND(3);
    nt_obj(1) := 10;
    nt_obj(2) := 20;
    nt_obj(3) := 30;
    DBMS_OUTPUT.PUT_LINE ('Data at index 1 is '||nt_obj(1));
    DBMS_OUTPUT.PUT_LINE ('Data at index 2 is '||nt_obj(2));
    DBMS_OUTPUT.PUT_LINE ('Data at index 3 is '||nt_obj(3));
END;

DECLARE
    TYPE my_nestedTable IS TABLE OF number;
    nt_obj my_nestedTable := my_nestedTable();
BEGIN
    nt_obj.EXTEND;
    nt_obj(1) := 28;
    DBMS_OUTPUT.PUT_LINE ('Data at index 1 is '||nt_obj(1));
    nt_obj.EXTEND(5,1);
    DBMS_OUTPUT.PUT_LINE ('Data at index 4 is '||nt_obj(4));
END;
/
--67
DECLARE
    TYPE my_nestedTable IS TABLE OF number;
    nt_obj my_nestedTable := my_nestedTable(1,2,3,4,5);
BEGIN
    nt_obj.TRIM;
    DBMS_OUTPUT.PUT_LINE ('After TRIM procedure');
    FOR i IN 1..nt_obj.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE (nt_obj (i));
    END LOOP;
END;

DECLARE
    TYPE my_nestedTable IS TABLE OF number;
    nt_obj my_nestedTable := my_nestedTable(1,2,3,4,5);
BEGIN
    nt_obj.TRIM(3);
    DBMS_OUTPUT.PUT_LINE ('After TRIM procedure');
    FOR i IN 1..nt_obj.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE (nt_obj (i));
    END LOOP;
END;
/
--69
DECLARE
    TYPE my_RefCur IS REF CURSOR RETURN employees%ROWTYPE;
    cur_var my_RefCur;
    rec_var employees%ROWTYPE;
BEGIN
    OPEN cur_var FOR SELECT * FROM employees WHERE employee_id = 100;
    FETCH cur_var INTO rec_var;
    CLOSE cur_var;
    DBMS_OUTPUT.PUT_LINE('Employee '||rec_var.first_name||' has salary '||rec_var.salary);
END;
/
--70
DECLARE
    --Create User-Defined Record Datatype
    TYPE my_rec IS RECORD (
        emp_sal employees.salary%TYPE
    );
    --Declare Strong Ref Cursor
    TYPE RefCur IS REF CURSOR RETURN my_rec;
    cur_var RefCur;
    --Another anchored datatype variable for holding data
    at_var employees.salary%TYPE;
BEGIN
    OPEN cur_var FOR SELECT salary FROM employees WHERE employee_id = 100;
    FETCH cur_var INTO at_var;
    CLOSE cur_var;
    DBMS_OUTPUT.PUT_LINE ('Salary of the employee is '||at_var);
END;
/
--71
DECLARE
    TYPE wk_RefCur IS REF CURSOR;
    cur_var wk_RefCur;
    f_name employees.first_name%TYPE;
    emp_sal employees.salary%TYPE;
BEGIN
    OPEN cur_var FOR SELECT first_name, salary FROM employees WHERE employee_id = 100;
    FETCH cur_var INTO f_name, emp_sal;
    CLOSE cur_var;
    BDMS_OUTPUT.PUT_LINE(f_name ||' '||emp_sal);
END;
/
--72
DECLARE
    cur_var SYS_REFCURSOR;
    f_name employees.first_name%TYPE;
    emp_sal employees.salary%TYPE;
BEGIN
    OPEN cur_var FOR SELECT first_name, salary FROM employees WHERE employee_id = 100;
    FETCH cur_var INTO f_name, emp_sal;
    CLOSE cur_var;
    BDMS_OUTPUT.PUT_LINE(f_name ||' '||emp_sal);
END;
/
--74
DECLARE
    TYPE nt_fname IS TABLE OF VARCHAR2(20);
    fname nt_fname;
    
BEGIN
    SELECT first_name BULK COLLECT INTO fName FROM employees;
    FOR idx IN 1..fname.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE(idx||' - '||fname(idx));
    END LOOP;
END;
/
--75
DECLARE
--Create an explicit cursor
    CURSOR exp_cur IS
    SELECT first_name FROM employees;
--Declare collection for holding the data 
    TYPE nt_fName IS TABLE OF VARCHAR2 (20);
    fname nt_fName;
BEGIN
    OPEN exp_cur;
    LOOP
        FETCH exp_cur BULK COLLECT INTO fname;
        EXIT WHEN fname.COUNT=0;
        --Print data
        FOR idx IN fname.FIRST.. fname.LAST
        LOOP
            DBMS_OUTPUT.PUT_LINE (idx||' '||fname(idx) );
        END LOOP; 
    END LOOP;
    CLOSE exp_cur;
END;
/
--76
SET SERVEROUTPUT ON;
DECLARE
    CURSOR exp_cur IS
    SELECT first_name FROM employees;    
    TYPE nt_fname IS TABLE OF VARCHAR2(20);
    fname nt_fname;
BEGIN
    OPEN exp_cur;
    FETCH exp_cur BULK COLLECT INTO fname LIMIT 10;
    CLOSE exp_cur;
    FOR idx IN 1..fname.COUNT
    LOOP
        DBMS_OUTPUT.PUT_LINE(idx||' '||fname(idx));
    END LOOP;
END;
/
--78
CREATE TABLE tut_77(
    mul_tab NUMBER(5)
);

DECLARE
    TYPE My_Array IS TABLE OF NUMBER INDEX BY PLS_INTEGER;
    col_var My_Array;
    tot_rec NUMBER;
BEGIN
    FOR i IN 1..10 LOOP
        col_var (i) := 9*i;
    END LOOP;
    FORALL idx IN 1..10
        INSERT INTO tut_77 (mul_tab)
        VALUES (col_var(idx));
    SELECT COUNT(*) INTO tot_rec FROM tut_77;
    DBMS_OUTPUT.PUT_LINE('Total records inserted are '||tot_rec);
END;
/
--79
CREATE TABLE tut_78(
    mul_tab NUMBER(5)
);

DECLARE
    TYPE my_nested_table IS TABLE OF number;
    var_nt my_nested_table := my_nested_table (9,18,27,36,45,54,63,72,81,90);
    tot_rec NUMBER;
BEGIN
    var_nt.DELETE(3, 6);
    FORALL idx IN INDICES OF var_nt
        INSERT INTO tut_78 (mul_tab) VALUES (var_nt(idx));
    SELECT COUNT(*) INTO tot_rec FROM tut_78;
    DBMS_OUTPUT.PUT_LINE('Total records inserted are '||tot_rec);
END;
/
--80
CREATE TABLE tut_79 (
    selected_data NUMBER(5)
);

DECLARE
    --Source collection
    TYPE My_NestedTable IS TABLE OF NUMBER;
    source_col My_NestedTable := My_NestedTable (9,18,27,36,45,54,63,72,81,90);

    --Indexing collection
    TYPE My_Array IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
    index_col My_Array;
    
BEGIN
    --Initializing indexing collection with the index numbers.
    index_col (1) := 3;
    index_col (5) := 7;
    index_col (12):= 8;
    index_col (28):= 10;
    --FORALL statement 
    FORALL idx IN VALUES OF index_col
        INSERT INTO tut_79 VALUES (source_col (idx));
END;

SELECT * FROM tut_79;
/
    