CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest AS
BEGIN
  UPDATE Accounts
  SET Balance = Balance + (Balance * 0.01)
  WHERE AccountType = 'Savings';
  DBMS_OUTPUT.PUT_LINE('Monthly interest applied to all savings accounts.');
END;
/

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus(
  p_department IN VARCHAR2,
  p_bonus_pct  IN NUMBER
) AS
BEGIN
  UPDATE Employees
  SET Salary = Salary + (Salary * p_bonus_pct / 100)
  WHERE Department = p_department;
  DBMS_OUTPUT.PUT_LINE('Bonus applied to employees in department: ' || p_department);
END;
/

CREATE OR REPLACE PROCEDURE TransferFunds(
  p_from_account IN NUMBER,
  p_to_account   IN NUMBER,
  p_amount       IN NUMBER
) AS
  v_balance NUMBER;
BEGIN
  SELECT Balance INTO v_balance FROM Accounts WHERE AccountID = p_from_account FOR UPDATE;
  IF v_balance < p_amount THEN
    DBMS_OUTPUT.PUT_LINE('Insufficient funds in source account.');
    RETURN;
  END IF;

  UPDATE Accounts SET Balance = Balance - p_amount WHERE AccountID = p_from_account;
  UPDATE Accounts SET Balance = Balance + p_amount WHERE AccountID = p_to_account;

  DBMS_OUTPUT.PUT_LINE('Transfer successful.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error during transfer: ' || SQLERRM);
END;
/