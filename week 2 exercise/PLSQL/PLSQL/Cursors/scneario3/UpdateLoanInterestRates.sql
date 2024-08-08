DECLARE
    -- Define the new interest rate policy
    v_NewInterestRate NUMBER := 6.5;  -- New interest rate policy; adjust as needed
    
    -- Define a cursor to retrieve all loans
    CURSOR c_Loans IS
        SELECT LoanID
        FROM Loans;
    
    -- Record type for the cursor
    v_Loan c_Loans%ROWTYPE;
    
BEGIN
    -- Open the cursor
    OPEN c_Loans;
    
    -- Fetch each record from the cursor
    LOOP
        FETCH c_Loans INTO v_Loan;
        
        EXIT WHEN c_Loans%NOTFOUND;
        
        -- Update the interest rate for the loan based on the new policy
        UPDATE Loans
        SET InterestRate = v_NewInterestRate
        WHERE LoanID = v_Loan.LoanID;
        
    END LOOP;
    
    -- Commit the transaction to save changes
    COMMIT;
    
    -- Close the cursor
    CLOSE c_Loans;
    
    -- Print a message indicating the process is complete
    DBMS_OUTPUT.PUT_LINE('Interest rates have been updated for all loans based on the new policy.');
    
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions
        ROLLBACK;  -- Rollback changes if any error occurs
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/
