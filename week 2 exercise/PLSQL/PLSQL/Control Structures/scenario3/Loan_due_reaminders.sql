DECLARE
    CURSOR loan_cursor IS
        SELECT l.LoanID, l.CustomerID, l.EndDate, c.Name
        FROM Loans l
        JOIN Customers c ON l.CustomerID = c.CustomerID
        WHERE l.EndDate BETWEEN SYSDATE AND SYSDATE + 30;
        
    v_loan_id Loans.LoanID%TYPE;
    v_customer_id Customers.CustomerID%TYPE;
    v_end_date Loans.EndDate%TYPE;
    v_customer_name Customers.Name%TYPE;
BEGIN
    OPEN loan_cursor;
    
    LOOP
        FETCH loan_cursor INTO v_loan_id, v_customer_id, v_end_date, v_customer_name;
        EXIT WHEN loan_cursor%NOTFOUND;
        
        -- Print reminder message
        DBMS_OUTPUT.PUT_LINE('Reminder: Loan ID ' || v_loan_id || ' for Customer ' || v_customer_name ||
                             ' (Customer ID ' || v_customer_id || ') is due on ' || v_end_date || '.');
                             
    END LOOP;
    
    CLOSE loan_cursor;
END;
/

