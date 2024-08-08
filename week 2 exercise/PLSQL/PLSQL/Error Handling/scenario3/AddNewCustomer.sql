CREATE OR REPLACE PROCEDURE AddNewCustomer(
    p_CustomerID IN NUMBER,
    p_Name IN VARCHAR2,
    p_DOB IN DATE,
    p_Balance IN NUMBER
) IS
    -- Exception for customer ID already exists
    customer_exists EXCEPTION;
BEGIN
    BEGIN
        -- Check if the customer ID already exists
        DECLARE
            v_Count NUMBER;
        BEGIN
            SELECT COUNT(*)
            INTO v_Count
            FROM Customers
            WHERE CustomerID = p_CustomerID;
            
            IF v_Count > 0 THEN
                -- If customer ID already exists, raise an exception
                RAISE customer_exists;
            END IF;
        END;
        
        -- Insert the new customer
        INSERT INTO Customers (CustomerID, Name, DOB, Balance, LastModified)
        VALUES (p_CustomerID, p_Name, p_DOB, p_Balance, SYSDATE);

        -- Commit the transaction
        COMMIT;

        DBMS_OUTPUT.PUT_LINE('Customer added successfully with ID ' || p_CustomerID || '.');
    
    EXCEPTION
        WHEN customer_exists THEN
            DBMS_OUTPUT.PUT_LINE('Error: Customer with ID ' || p_CustomerID || ' already exists.');
            
        WHEN OTHERS THEN
            -- Handle any other exceptions
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
    END;
END AddNewCustomer;
/

BEGIN
    -- Example of a successful customer insertion
    AddNewCustomer(3, 'Alice Wonderland', TO_DATE('1992-03-12', 'YYYY-MM-DD'), 1200);
    
    -- Example of a customer insertion with an existing ID
    AddNewCustomer(1, 'Charlie Brown', TO_DATE('1980-09-23', 'YYYY-MM-DD'), 5000);
END;
/

SET SERVEROUTPUT ON;
