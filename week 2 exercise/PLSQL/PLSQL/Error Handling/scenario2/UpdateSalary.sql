CREATE OR REPLACE PROCEDURE UpdateSalary(
    p_EmployeeID IN NUMBER,
    p_Percentage IN NUMBER
) IS
    -- Variable to hold the current salary
    v_CurrentSalary NUMBER;

    -- Exception for employee not found
    employee_not_found EXCEPTION;

BEGIN
    BEGIN
        -- Check if the employee exists and get the current salary
        SELECT Salary INTO v_CurrentSalary
        FROM Employees
        WHERE EmployeeID = p_EmployeeID;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Handle the case where the employee ID does not exist
            RAISE employee_not_found;
    END;

    -- Update the salary by the given percentage
    UPDATE Employees
    SET Salary = Salary + (Salary * (p_Percentage / 100)),
        LastModified = SYSDATE
    WHERE EmployeeID = p_EmployeeID;

    -- Commit the transaction
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Salary updated successfully for employee ID ' || p_EmployeeID || '.');

EXCEPTION
    WHEN employee_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee ID ' || p_EmployeeID || ' does not exist.');
        
    WHEN OTHERS THEN
        -- Handle any other exceptions
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);

END UpdateSalary;
/


BEGIN
    -- Example of a successful salary update
    UpdateSalary(1, 10);
    
    -- Example of a salary update for a non-existing employee
    UpdateSalary(99, 10);
END;
/

SET SERVEROUTPUT ON;
