ALTER TABLE Employees ADD (LastModified DATE);

SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    p_department_name IN VARCHAR2,
    p_bonus_percentage IN NUMBER
)
IS
BEGIN
    -- Update the salary of all employees in the given department
    UPDATE Employees
    SET Salary = Salary + (Salary * (p_bonus_percentage / 100)),
        LastModified = SYSDATE
    WHERE Department = p_department_name;

    -- Commit the transaction
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Salaries updated with bonus for department ' || p_department_name || '.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END UpdateEmployeeBonus;
/
BEGIN
    UpdateEmployeeBonus('HR', 10);
END;
/
