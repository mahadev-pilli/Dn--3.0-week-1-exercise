CREATE OR REPLACE PROCEDURE SafeTransferFunds(
    p_SourceAccountID IN NUMBER,
    p_DestinationAccountID IN NUMBER,
    p_Amount IN NUMBER
) IS
    -- Variables to hold current balances
    v_SourceBalance NUMBER;
    v_DestinationBalance NUMBER;

    -- Exception for insufficient funds
    insufficient_funds EXCEPTION;
    PRAGMA EXCEPTION_INIT(insufficient_funds, -20001);

BEGIN
    -- Check for sufficient funds in the source account
    SELECT Balance INTO v_SourceBalance
    FROM Accounts
    WHERE AccountID = p_SourceAccountID;

    IF v_SourceBalance < p_Amount THEN
        RAISE insufficient_funds;
    END IF;

    -- Retrieve the current balance of the destination account
    SELECT Balance INTO v_DestinationBalance
    FROM Accounts
    WHERE AccountID = p_DestinationAccountID;

    -- Perform the transfer
    UPDATE Accounts
    SET Balance = Balance - p_Amount
    WHERE AccountID = p_SourceAccountID;

    UPDATE Accounts
    SET Balance = Balance + p_Amount
    WHERE AccountID = p_DestinationAccountID;

    -- Commit the transaction
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Funds transferred successfully.');

EXCEPTION
    WHEN insufficient_funds THEN
        -- Log the insufficient funds error and rollback
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: Insufficient funds for the transfer.');

    WHEN OTHERS THEN
        -- Handle any other exceptions and rollback
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);

END SafeTransferFunds;
/

BEGIN
    -- Example of a successful transfer
    SafeTransferFunds(1, 2, 500);
    
    -- Example of a transfer that will fail due to insufficient funds
    SafeTransferFunds(1, 2, 10000);
END;
/

SET SERVEROUTPUT ON;
