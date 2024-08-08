CREATE OR REPLACE FUNCTION HasSufficientBalance (
    p_account_id NUMBER,
    p_amount NUMBER
) RETURN NUMBER
IS
    v_balance NUMBER;
BEGIN
    -- Get the balance of the account
    SELECT Balance INTO v_balance
    FROM Accounts
    WHERE AccountID = p_account_id;

    -- Check if the balance is sufficient
    IF v_balance >= p_amount THEN
        RETURN 1; -- TRUE
    ELSE
        RETURN 0; -- FALSE
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- If no account is found with the given ID, return FALSE
        RETURN 0; -- FALSE
    WHEN OTHERS THEN
        -- Handle other exceptions
        RETURN 0; -- FALSE
END HasSufficientBalance;
/


SELECT AccountID, Balance,
       HasSufficientBalance(AccountID, 500) AS HasSufficientBalance
FROM Accounts;
