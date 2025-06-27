CREATE OR REPLACE TRIGGER UpdateCustomerLastModified
BEFORE UPDATE ON Customers
FOR EACH ROW
BEGIN
  :NEW.LastModified := SYSDATE;
END;
/

CREATE TABLE AuditLog (
  AuditID NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  TransactionID NUMBER,
  AccountID NUMBER,
  TransactionDate DATE,
  Amount NUMBER,
  TransactionType VARCHAR2(10),
  LogDate DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER LogTransaction
AFTER INSERT ON Transactions
FOR EACH ROW
BEGIN
  INSERT INTO AuditLog (TransactionID, AccountID, TransactionDate, Amount, TransactionType)
  VALUES (:NEW.TransactionID, :NEW.AccountID, :NEW.TransactionDate, :NEW.Amount, :NEW.TransactionType);
END;
/

CREATE OR REPLACE TRIGGER CheckTransactionRules
BEFORE INSERT ON Transactions
FOR EACH ROW
DECLARE
  v_balance NUMBER;
BEGIN

  IF :NEW.TransactionType = 'Deposit' AND :NEW.Amount <= 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Deposit amount must be positive.');
  END IF;

  
  IF :NEW.TransactionType = 'Withdrawal' THEN
    SELECT Balance INTO v_balance FROM Accounts WHERE AccountID = :NEW.AccountID;
    IF :NEW.Amount > v_balance THEN
      RAISE_APPLICATION_ERROR(-20002, 'Withdrawal amount exceeds account balance.');
    END IF;
    IF :NEW.Amount <= 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Withdrawal amount must be positive.');
    END IF;
  END IF;
END;