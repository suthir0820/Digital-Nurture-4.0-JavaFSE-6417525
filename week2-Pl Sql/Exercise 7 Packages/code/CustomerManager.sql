CREATE OR REPLACE PACKAGE EmployeeManagement AS
  PROCEDURE HireEmployee(
    p_employee_id IN NUMBER,
    p_name        IN VARCHAR2,
    p_position    IN VARCHAR2,
    p_salary      IN NUMBER,
    p_department  IN VARCHAR2,
    p_hiredate    IN DATE
  );
  PROCEDURE UpdateEmployee(
    p_employee_id IN NUMBER,
    p_name        IN VARCHAR2,
    p_position    IN VARCHAR2,
    p_salary      IN NUMBER,
    p_department  IN VARCHAR2
  );
  FUNCTION GetAnnualSalary(p_employee_id IN NUMBER) RETURN NUMBER;
END EmployeeManagement;
/

CREATE OR REPLACE PACKAGE BODY EmployeeManagement AS
  PROCEDURE HireEmployee(
    p_employee_id IN NUMBER,
    p_name        IN VARCHAR2,
    p_position    IN VARCHAR2,
    p_salary      IN NUMBER,
    p_department  IN VARCHAR2,
    p_hiredate    IN DATE
  ) IS
  BEGIN
    INSERT INTO Employees (EmployeeID, Name, Position, Salary, Department, HireDate)
    VALUES (p_employee_id, p_name, p_position, p_salary, p_department, p_hiredate);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Employee already exists.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END;

  PROCEDURE UpdateEmployee(
    p_employee_id IN NUMBER,
    p_name        IN VARCHAR2,
    p_position    IN VARCHAR2,
    p_salary      IN NUMBER,
    p_department  IN VARCHAR2
  ) IS
  BEGIN
    UPDATE Employees
    SET Name = p_name, Position = p_position, Salary = p_salary, Department = p_department
    WHERE EmployeeID = p_employee_id;
    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Employee not found.');
    END IF;
  END;

  FUNCTION GetAnnualSalary(p_employee_id IN NUMBER) RETURN NUMBER IS
    v_salary NUMBER;
  BEGIN
    SELECT Salary INTO v_salary FROM Employees WHERE EmployeeID = p_employee_id;
    RETURN v_salary * 12;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END;
END EmployeeManagement;
/


CREATE OR REPLACE PACKAGE AccountOperations AS
  PROCEDURE OpenAccount(
    p_account_id   IN NUMBER,
    p_customer_id  IN NUMBER,
    p_account_type IN VARCHAR2,
    p_balance      IN NUMBER
  );
  PROCEDURE CloseAccount(p_account_id IN NUMBER);
  FUNCTION GetTotalBalance(p_customer_id IN NUMBER) RETURN NUMBER;
END AccountOperations;
/

CREATE OR REPLACE PACKAGE BODY AccountOperations AS
  PROCEDURE OpenAccount(
    p_account_id   IN NUMBER,
    p_customer_id  IN NUMBER,
    p_account_type IN VARCHAR2,
    p_balance      IN NUMBER
  ) IS
  BEGIN
    INSERT INTO Accounts (AccountID, CustomerID, AccountType, Balance, LastModified)
    VALUES (p_account_id, p_customer_id, p_account_type, p_balance, SYSDATE);
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Account already exists.');
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
  END;

  PROCEDURE CloseAccount(p_account_id IN NUMBER) IS
  BEGIN
    DELETE FROM Accounts WHERE AccountID = p_account_id;
    IF SQL%ROWCOUNT = 0 THEN
      DBMS_OUTPUT.PUT_LINE('Account not found.');
    END IF;
  END;

  FUNCTION GetTotalBalance(p_customer_id IN NUMBER) RETURN NUMBER IS
    v_total NUMBER;
  BEGIN
    SELECT NVL(SUM(Balance),0) INTO v_total FROM Accounts WHERE CustomerID = p_customer_id;
    RETURN v_total;
  END;
END AccountOperations;
/