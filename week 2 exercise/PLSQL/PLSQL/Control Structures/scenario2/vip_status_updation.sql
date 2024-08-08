/* firstly we need to a column that denotes the vip status of a customer*/

ALTER TABLE Customers
ADD (IsVIP CHAR(1) DEFAULT 'N');

/* update the customers vip status based on their current balance */

DECLARE
    v_customer_id Customers.CustomerID%TYPE;
    v_balance Customers.Balance%TYPE;
BEGIN
    -- Iterate through all customers
    FOR rec IN (SELECT CustomerID, Balance FROM Customers) LOOP
        v_customer_id := rec.CustomerID;
        v_balance := rec.Balance;
        
        -- Determine if the customer should be a VIP
        IF v_balance > 10000 THEN
            UPDATE Customers
            SET IsVIP = 'Y'
            WHERE CustomerID = v_customer_id;
        ELSE
            UPDATE Customers
            SET IsVIP = 'N'
            WHERE CustomerID = v_customer_id;
        END IF;
    END LOOP;
    COMMIT;
END;
/



