--- Creating a cursor
-- SERVEROUTPUT ON IS USED TO SEE OUTPUT ON DISPLAY SCREEN
SET SERVEROUTPUT ON;
DECLARE
        v_name VARCHAR2(30);
        --DECLARE THE CURSOR
        CURSOR cur_first IS SELECT first_name FROM employees 
        WHERE employee_id <105;
        
--EXECUTION SECTION
BEGIN
    OPEN cur_first ;
    LOOP
       FETCH cur_first INTO v_name;
        dbms_output.put_line(v_name);
        EXIT WHEN cur_first%notfound;
    END LOOP;
        CLOSE cur_first;
    END;


--- PARAMETERISED CURSOR
SET SERVEROUTPUT ON;
DECLARE
    v_name VARCHAR2(30);
    CURSOR parameterised_cursor (var_id VARCHAR2) IS
        SELECT first_name FROM employees WHERE employee_id < var_id;
BEGIN
    OPEN parameterised_cursor(105);
    LOOP
        FETCH parameterised_cursor INTO v_name;
        EXIT WHEN parameterised_cursor%notfound;
        dbms_output.put_line(v_name);
    END LOOP;
    CLOSE parameterised_cursor;
END;
/
 

---DEFAULT PARAMETERISED CURSOR

SET SERVEROUTPUT ON;
DECLARE
    v_name VARCHAR2(30);
    v_id NUMBER(10);
    CURSOR parameterised_cursor (var_id NUMBER := 190) IS
        SELECT first_name, employee_id FROM employees WHERE employee_id > var_id;
BEGIN
    OPEN parameterised_cursor;
    LOOP
        FETCH parameterised_cursor INTO v_name,v_id;
        EXIT WHEN parameterised_cursor%notfound;
        dbms_output.put_line(v_name ||' '|| v_id);
    END LOOP; 
    CLOSE parameterised_cursor;
END;
/

--- CURSOR FOR LOOP

SET SERVEROUTPUT ON;
DECLARE 
    CURSOR for_loop_cursor  IS
        SELECT first_name, last_name FROM employees 
        WHERE employee_id >200;
BEGIN
    FOR l_idx IN for_loop_cursor
    LOOP
        dbms_output.put_line(l_idx.first_name ||' ' ||l_idx.last_name);
    END LOOP;
  END;
/


--PARAMETRISED FOR LOOP
SET SERVEROUTPUT ON;
DECLARE
    CURSOR para_cursor (var_id NUMBER) IS
    SELECT employee_id, first_name FROM employees
    WHERE employee_id > var_id;
BEGIN
    FOR l_idx IN para_cursor(200)
    LOOP
        dbms_output.put_line(l_idx.employee_id ||' '|| l_idx.first_name);
    END LOOP;
END;
/

-- TABLE based RECORD datatype
SET SERVEROUTPUT ON;
DECLARE 
     v_emp  employees%rowtype;
BEGIN 
    SELECT first_name, hire_date INTO v_emp.first_name, v_emp.hire_date FROM employees
    WHERE employee_id = 100;
    
    dbms_output.put_line(v_emp.first_name);
    dbms_output.put_line(v_emp.hire_date);
END;
/

--- CURSOR BASED RECORD VARIABLE

SET SERVEROUTPUT ON;
DECLARE 
    CURSOR cursor_rec_var IS 
    SELECT first_name , salary FROM employees
    WHERE employee_id = 100;
    
    var_emp cursor_rec_var%rowtype;
    
BEGIN 
    OPEN cursor_rec_var;
    FETCH cursor_rec_var INTO var_emp;
    Dbms_Output.Put_Line(Var_Emp.First_Name);
    Dbms_Output.Put_Line(Var_Emp.Salary);
 
    CLOSE cursor_rec_var;
END;
/


--- cursor BASED record DATATYPE variable 
SET SERVEROUTPUT ON;
DECLARE 
    CURSOR cursor_rec_var1 IS 
    SELECT first_name , salary FROM employees
    WHERE employee_id > 200;
    
    var_emp cursor_rec_var1%rowtype;
    
BEGIN 
    OPEN cursor_rec_var1;
    LOOP
        FETCH cursor_rec_var1 INTO var_emp;
        EXIT WHEN cursor_rec_var1%notfound;
        DBMS_OUTPUT.PUT_LINE(VAR_EMP.FIRST_NAME||' '||VAR_EMP.SALARY);
    END LOOP;
        CLOSE cursor_rec_var1;
END;
/ 

--user defined record datatype

SET SERVEROUTPUT ON;
DECLARE
    TYPE rv_dept IS RECORD(
    f_name VARCHAR2(20),
    d_name departments.department_name%TYPE);
    
    var1 rv_dept;
BEGIN
    SELECT first_name , department_name INTO var1.f_name,var1.d_name
    FROM employees JOIN departments USING(department_id) WHERE employee_id=100;
    
    dbms_output.put_line(var1.f_name|| ' ' || var1.d_name);
END;
/



---- Cursor attributes
-- SQL%FOUND

CREATE TABLE DEPT_TEMP AS SELECT * FROM DEPARTMENTS;

DECLARE 
    DEPT_NO NUMBER(4):= 270;
BEGIN 
    DELETE FROM DEPT_TEMP WHERE DEPARTMENT_ID = DEPT_NO;
    IF SQL%FOUND THEN 
            INSERT INTO DEPT_TEMP VALUES (270 ,'PERSONNEL',200,1700);
    END IF;
END;
/


---------------------------------------------------------
--- PL/SQL   FUNCTIONN

CREATE OR REPLACE FUNCTION AREA_CIRCLE(RADIUS NUMBER)
RETURN NUMBER IS

PI CONSTANT NUMBER (7,3):=3.14;
AREA NUMBER(7,3);

BEGIN
    AREA := PI*(RADIUS*RADIUS);
    RETURN AREA;
END;
/

set SERVEROUTPUT ON;
declare 
    vr_area number(7,3);
begin
    vr_area:= area_circle(12);
    dbms_output.put_line(vr_area);
end;
/
----------------
create or replace function addition(n1 in number, n2 in number)
return number
is
    n3 number(8);
begin
    n3:= n1 + n2;
    return n3;
    end;
    /

declare 
    n3 number(2);
begin
    n3 := addition(1,4);
    dbms_output.put_line('Addition is '|| n3);
end;
/


-----------

declare  
    a number;
    b number;
    c number;

FUNCTION findMax(x in number, y in number)
    return number 
        is
            z number;
begin
    if x> y then
        z:=x;
    else
     z:=y;
     end if;
return z;
end;

begin 
    a:=23;
    b:=34;

    c:= findMax(a,b);
    dbms_output.put_line('Maximum of (23,34) is '|| c);
end;
/
    

----- RECURSIVE FUNCTION

DECLARE
    NUMBR NUMBER;
    FACTORIAL NUMBER;
FUNCTION FACTO(X NUMBER)
RETURN NUMBER
IS
    F NUMBER;
BEGIN 
    IF X=0 THEN
        F:= 1;
    ELSE 
        F:=X * FACTO(X-1);
    END IF ;
RETURN F;
END;

BEGIN 
    NUMBR:=6;
    FACTORIal :=facto(numbr);
    dbms_output.put_line('factorail '||' is '|| factorial);
    end;
    /
    
    
    
    
---------------------------------------------
--STORED PROCEDURE

CREATE OR REPLACE procedure pr_f IS
    var_name VARCHAR2(20):='FIRDOS';
    var_web VARCHAR2(20):='WWW.GOOGLE.COM';
BEGIN
    dbms_output.put_line(' HEYYYY.....  ' || var_name ||' FROM '|| var_web);
END pr_f;
/

--------------------------------------
--- Calling notation

--1: POSITIONAL NOTATION
CREATE PROCEDURE EMP_SAL
       (DEPT_ID NUMBER ,SAL_RAISE NUMBER) 
      IS
    BEGIN
        UPDATE EMPLOYEES SET SALARY = SALARY * SAL_RAISE WHERE DEPARTMENT_ID = DEPT_ID; 
        DBMS_OUTPUT.PUT_LINE('SALARY UPDATEDE');
END;
/
      
EXECUTE EMP_SAL(40,2);

---------------------------
--2: NAMED NOTATION
 CREATE OR REPLACE FUNCTION ADD_NUM (VAR1 NUMBER,VAR2 NUMBER DEFAULT 0 , VAR3 NUMBER) RETURN NUMBER
 IS
  BEGIN
        DBMS_OUTPUT.PUT_LINE('var1 ->'|| var1);
        DBMS_OUTPUT.PUT_LINE('var2 ->'|| var2);
        DBMS_OUTPUT.PUT_LINE('var3 ->'|| var3);
        RETURN var1+var2+var3;
end;
/

----------------
