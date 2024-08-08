CREATE OR REPLACE FUNCTION CalculateAge (
    p_dob DATE
) RETURN NUMBER
IS
    v_age NUMBER;
BEGIN
    -- Calculate the age
    v_age := TRUNC(MONTHS_BETWEEN(SYSDATE, p_dob) / 12);

    RETURN v_age;
END CalculateAge;
/
SET SERVEROUTPUT ON;


DECLARE
    v_dob DATE := TO_DATE('1990-07-20', 'YYYY-MM-DD');
    v_age NUMBER;
BEGIN
    v_age := CalculateAge(v_dob);
    DBMS_OUTPUT.PUT_LINE('Age: ' || v_age);
END;
/


SELECT Name, DOB, CalculateAge(DOB) AS Age
FROM Customers;
