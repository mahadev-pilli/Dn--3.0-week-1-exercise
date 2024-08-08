SET SERVEROUTPUT ON;


CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest
IS
    v_account_id Accounts.AccountID%TYPE;
    v_balance Accounts.Balance%TYPE;
    v_interest_rate CONSTANT NUMBER := 0.01;
BEGIN
    -- Cursor to select all savings accounts
    FOR rec IN (SELECT AccountID, Balance FROM Accounts WHERE AccountType = 'Savings') LOOP
        v_account_id := rec.AccountID;
        v_balance := rec.Balance;
        
        -- Calculate new balance with interest
        v_balance := v_balance + (v_balance * v_interest_rate);
        
        -- Update the account balance
        UPDATE Accounts
        SET Balance = v_balance,
            LastModified = SYSDATE
        WHERE AccountID = v_account_id;
    END LOOP;
    
    -- Commit the transaction
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Monthly interest processed for all savings accounts.');
END ProcessMonthlyInterest;
/
