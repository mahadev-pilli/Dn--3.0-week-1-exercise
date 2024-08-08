CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
    -- Update the LastModified column to the current date and time
    :NEW.LastModified := SYSDATE;
END;
/


-- Update a customer's record
UPDATE Customers
SET Name = 'Johnathan Doe'
WHERE CustomerID = 1;

-- Check if LastModified column is updated
SELECT CustomerID, Name, LastModified
FROM Customers
WHERE CustomerID = 1;
