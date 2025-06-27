ALTER TABLE Customers ADD (IsVIP CHAR(1) DEFAULT 'N');

BEGIN
  FOR cust IN (SELECT CustomerID, DOB FROM Customers) LOOP
    IF MONTHS_BETWEEN(SYSDATE, cust.DOB) / 12 > 60 THEN
      UPDATE Loans
      SET InterestRate = InterestRate - 1
      WHERE CustomerID = cust.CustomerID;
    END IF;
  END LOOP;
END;
/

BEGIN
  FOR cust IN (SELECT CustomerID, Balance FROM Customers) LOOP
    IF cust.Balance > 10000 THEN
      UPDATE Customers
      SET IsVIP = 'Y'
      WHERE CustomerID = cust.CustomerID;
    END IF;
  END LOOP;
END;
/

DECLARE
  v_name VARCHAR2(100);
BEGIN
  FOR loan IN (
    SELECT LoanID, CustomerID, EndDate
    FROM Loans
    WHERE EndDate BETWEEN SYSDATE AND SYSDATE + 30
  ) LOOP
    SELECT Name INTO v_name FROM Customers WHERE CustomerID = loan.CustomerID;
    DBMS_OUTPUT.PUT_LINE('Reminder: Loan ' || loan.LoanID || ' for customer ' || v_name || ' is due on ' || TO_CHAR(loan.EndDate, 'YYYY-MM-DD'));
  END LOOP;
END;
/