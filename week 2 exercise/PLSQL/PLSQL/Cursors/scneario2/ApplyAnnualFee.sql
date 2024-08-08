DECLARE
    -- Define the annual maintenance fee
    v_AnnualFee NUMBER := 50;  -- You can set this to the appropriate fee amount
    
    -- Define a cursor to retrieve all accounts
    CURSOR c_Accounts IS
        SELECT AccountID, Balance
        FROM Accounts;
    
    -- Record type for the cursor
    v_Account c_Accounts%ROWTYPE;
    
BEGIN
    -- Open the cursor
    OPEN c_Accounts;
    
    -- Fetch each record from the cursor
    LOOP
        FETCH c_Accounts INTO v_Account;
        
        EXIT WHEN c_Accounts%NOTFOUND;
        
        -- Deduct the annual fee from the account balance
        UPDATE Accounts
        SET Balance = Balance - v_AnnualFee,
            LastModified = SYSDATE  -- Update LastModified to current date and time
        WHERE AccountID = v_Account.AccountID;
        
    END LOOP;
    
    -- Commit the transaction to save changes
    COMMIT;
    
    -- Close the cursor
    CLOSE c_Accounts;
    
    -- Print a message indicating the process is complete
    DBMS_OUTPUT.PUT_LINE('Annual fees have been applied to all accounts.');
    
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions
        ROLLBACK;  -- Rollback changes if any error occurs
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
/
