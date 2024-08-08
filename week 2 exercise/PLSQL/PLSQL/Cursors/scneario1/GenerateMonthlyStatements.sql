SET SERVEROUTPUT ON;


DECLARE
    -- Define a cursor to retrieve transactions for the current month
    CURSOR c_Transactions IS
        SELECT t.TransactionID, t.AccountID, t.TransactionDate, t.Amount, t.TransactionType,
               a.CustomerID, c.Name, a.Balance
        FROM Transactions t
        JOIN Accounts a ON t.AccountID = a.AccountID
        JOIN Customers c ON a.CustomerID = c.CustomerID
        WHERE EXTRACT(MONTH FROM t.TransactionDate) = EXTRACT(MONTH FROM SYSDATE)
          AND EXTRACT(YEAR FROM t.TransactionDate) = EXTRACT(YEAR FROM SYSDATE);
    
    -- Record type for the cursor
    v_Transaction c_Transactions%ROWTYPE;
    
    -- Variables to track statement details
    v_PreviousCustomerID NUMBER := NULL;
    v_StatementLine VARCHAR2(4000);
    
BEGIN
    -- Open the cursor
    OPEN c_Transactions;
    
    -- Fetch each record from the cursor
    LOOP
        FETCH c_Transactions INTO v_Transaction;
        
        EXIT WHEN c_Transactions%NOTFOUND;
        
        -- Check if we are still processing the same customer
        IF v_PreviousCustomerID IS NULL OR v_PreviousCustomerID != v_Transaction.CustomerID THEN
            -- Print a statement header for a new customer
            IF v_PreviousCustomerID IS NOT NULL THEN
                DBMS_OUTPUT.PUT_LINE('End of Statement for Customer ' || v_PreviousCustomerID);
            END IF;
            DBMS_OUTPUT.PUT_LINE('Statement for Customer ' || v_Transaction.CustomerID || ': ' || v_Transaction.Name);
            DBMS_OUTPUT.PUT_LINE('---------------------------------------');
            v_PreviousCustomerID := v_Transaction.CustomerID;
        END IF;
        
        -- Print transaction details
        v_StatementLine := 'Transaction ID: ' || v_Transaction.TransactionID || 
                            ', Date: ' || TO_CHAR(v_Transaction.TransactionDate, 'YYYY-MM-DD') ||
                            ', Type: ' || v_Transaction.TransactionType ||
                            ', Amount: ' || v_Transaction.Amount ||
                            ', Balance: ' || v_Transaction.Balance;
                            
        DBMS_OUTPUT.PUT_LINE(v_StatementLine);
    END LOOP;
    
    -- Print end of statement for the last customer
    IF v_PreviousCustomerID IS NOT NULL THEN
        DBMS_OUTPUT.PUT_LINE('End of Statement for Customer ' || v_PreviousCustomerID);
    END IF;
    
    -- Close the cursor
    CLOSE c_Transactions;
    
END;
/
