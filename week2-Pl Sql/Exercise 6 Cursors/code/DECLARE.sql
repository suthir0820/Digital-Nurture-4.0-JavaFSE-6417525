DECLARE
  CURSOR cur_transactions IS
    SELECT c.CustomerID, c.Name, t.TransactionID, t.TransactionDate, t.Amount, t.TransactionType
    FROM Customers c
    JOIN Accounts a ON c.CustomerID = a.CustomerID
    JOIN Transactions t ON a.AccountID = t.AccountID
    WHERE EXTRACT(MONTH FROM t.TransactionDate) = EXTRACT(MONTH FROM SYSDATE)
      AND EXTRACT(YEAR FROM t.TransactionDate) = EXTRACT(YEAR FROM SYSDATE)
    ORDER BY c.CustomerID, t.TransactionDate;

  CURSOR cur_accounts IS
    SELECT AccountID, Balance FROM Accounts;

  CURSOR cur_loans IS
    SELECT LoanID, InterestRate FROM Loans;

  v_cust_id   NUMBER;
  v_name      VARCHAR2(100);
  v_trx_id    NUMBER;
  v_trx_date  DATE;
  v_amount    NUMBER;
  v_type      VARCHAR2(10);
  v_last_cust NUMBER := NULL;
  v_account_id Accounts.AccountID%TYPE;
  v_balance    Accounts.Balance%TYPE;
  v_fee        NUMBER := 100; 
  v_loan_id     Loans.LoanID%TYPE;
  v_interest    Loans.InterestRate%TYPE;
  v_new_rate    NUMBER;
 
  v_fee_savings   NUMBER := 50;  
  v_fee_checking  NUMBER := 150; 
  v_policy_rate   NUMBER := 0.75; 
  v_trx_count     NUMBER;
  v_total_amount  NUMBER;
  v_account_type Accounts.AccountType%TYPE;
BEGIN
  OPEN cur_transactions;
  LOOP
    FETCH cur_transactions INTO v_cust_id, v_name, v_trx_id, v_trx_date, v_amount, v_type;
    EXIT WHEN cur_transactions%NOTFOUND;
    IF v_last_cust IS NULL OR v_last_cust != v_cust_id THEN
      DBMS_OUTPUT.PUT_LINE('--- Statement for ' || v_name || ' (Customer ID: ' || v_cust_id || ') ---');
      v_last_cust := v_cust_id;
    END IF;
    DBMS_OUTPUT.PUT_LINE('  ' || TO_CHAR(v_trx_date, 'YYYY-MM-DD') || ' | ' || v_type || ' | Amount: ' || v_amount);
  END LOOP;
  CLOSE cur_transactions;

  
  FOR cust IN (SELECT CustomerID, Name FROM Customers) LOOP
    SELECT COUNT(*), NVL(SUM(Amount),0)
      INTO v_trx_count, v_total_amount
      FROM Accounts a JOIN Transactions t ON a.AccountID = t.AccountID
      WHERE a.CustomerID = cust.CustomerID
        AND EXTRACT(MONTH FROM t.TransactionDate) = EXTRACT(MONTH FROM SYSDATE)
        AND EXTRACT(YEAR FROM t.TransactionDate) = EXTRACT(YEAR FROM SYSDATE);
    DBMS_OUTPUT.PUT_LINE('Customer: ' || cust.Name || ' | Transactions: ' || v_trx_count || ' | Total: ' || v_total_amount);
  END LOOP;

  OPEN cur_accounts;
  LOOP
    FETCH cur_accounts INTO v_account_id, v_balance;
    EXIT WHEN cur_accounts%NOTFOUND;
    SELECT AccountType INTO v_account_type FROM Accounts WHERE AccountID = v_account_id;
    IF v_account_type = 'Savings' THEN
      UPDATE Accounts SET Balance = Balance - v_fee_savings WHERE AccountID = v_account_id;
      DBMS_OUTPUT.PUT_LINE('Savings account annual fee of ' || v_fee_savings || ' applied to Account ID: ' || v_account_id);
    ELSE
      UPDATE Accounts SET Balance = Balance - v_fee_checking WHERE AccountID = v_account_id;
      DBMS_OUTPUT.PUT_LINE('Checking account annual fee of ' || v_fee_checking || ' applied to Account ID: ' || v_account_id);
    END IF;
  END LOOP;
  CLOSE cur_accounts;

  OPEN cur_loans;
  LOOP
    FETCH cur_loans INTO v_loan_id, v_interest;
    EXIT WHEN cur_loans%NOTFOUND;
    v_new_rate := v_policy_rate;
    UPDATE Loans SET InterestRate = v_new_rate WHERE LoanID = v_loan_id;
    DBMS_OUTPUT.PUT_LINE('Loan ID ' || v_loan_id || ' interest rate set to new policy rate: ' || v_new_rate);
  END LOOP;
  CLOSE cur_loans;
END;
/