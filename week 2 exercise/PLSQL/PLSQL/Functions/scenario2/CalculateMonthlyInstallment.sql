SET SERVEROUTPUT ON;



CREATE OR REPLACE FUNCTION CalculateMonthlyInstallment (
    p_loan_amount NUMBER,
    p_annual_interest_rate NUMBER,
    p_start_date DATE,
    p_end_date DATE
) RETURN NUMBER
IS
    v_monthly_interest_rate NUMBER;
    v_total_payments NUMBER;
    v_loan_duration_years NUMBER;
    v_monthly_installment NUMBER;
BEGIN
    -- Calculate the loan duration in years
    v_loan_duration_years := MONTHS_BETWEEN(p_end_date, p_start_date) / 12;

    -- Calculate the monthly interest rate
    v_monthly_interest_rate := p_annual_interest_rate / 12 / 100;
    
    -- Calculate the total number of monthly payments
    v_total_payments := v_loan_duration_years * 12;
    
    -- Calculate the monthly installment using the formula
    v_monthly_installment := (p_loan_amount * v_monthly_interest_rate * POWER(1 + v_monthly_interest_rate, v_total_payments)) /
                             (POWER(1 + v_monthly_interest_rate, v_total_payments) - 1);
    
    RETURN v_monthly_installment;
END CalculateMonthlyInstallment;
/



DECLARE
    v_loan_amount NUMBER := 50000;
    v_annual_interest_rate NUMBER := 5;
    v_start_date DATE := TO_DATE('2020-01-01', 'YYYY-MM-DD');
    v_end_date DATE := TO_DATE('2030-01-01', 'YYYY-MM-DD');
    v_monthly_installment NUMBER;
BEGIN
    v_monthly_installment := CalculateMonthlyInstallment(v_loan_amount, v_annual_interest_rate, v_start_date, v_end_date);
    DBMS_OUTPUT.PUT_LINE('Monthly Installment: ' || TO_CHAR(v_monthly_installment, 'FM999999.00'));
END;
/


SELECT LoanID, LoanAmount, InterestRate, StartDate, EndDate,
       CalculateMonthlyInstallment(LoanAmount, InterestRate, StartDate, EndDate) AS MonthlyInstallment
FROM Loans;

