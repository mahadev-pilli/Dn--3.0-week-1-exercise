DECLARE
    v_customer_id Customers.CustomerID%TYPE;
    v_dob Customers.DOB%TYPE;
    v_age_years NUMBER;
    v_new_interest_rate Loans.InterestRate%TYPE;
BEGIN
    FOR rec IN (SELECT CustomerID, DOB FROM Customers) LOOP
        v_customer_id := rec.CustomerID;
        v_dob := rec.DOB;

        -- Calculate the age in years
        v_age_years := TRUNC(MONTHS_BETWEEN(SYSDATE, v_dob) / 12);

        IF v_age_years > 60 THEN
            -- Update the loan interest rate for customers above 60
            FOR loan_rec IN (SELECT LoanID, InterestRate FROM Loans WHERE CustomerID = v_customer_id) LOOP
                v_new_interest_rate := loan_rec.InterestRate * 0.99; -- Apply 1% discount

                UPDATE Loans
                SET InterestRate = v_new_interest_rate
                WHERE LoanID = loan_rec.LoanID;
            END LOOP;
        END IF;
    END LOOP;
    COMMIT;
END;
/
