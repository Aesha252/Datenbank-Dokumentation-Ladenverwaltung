-- abfragen
-- Welche Kunden haben im Salon am häufigsten Termine wahrgenommen?
SELECT CustomerID, COUNT(AppointmentID) AS AnzahlTermine
FROM Appointment
GROUP BY CustomerID
ORDER BY AnzahlTermine DESC; -- in diesem Fall alle Kunden kamen nur 1 mal in Salon

-- Was ist der beliebteste Service basierend auf der Anzahl der Termine?
SELECT ServiceID, COUNT(AppointmentID) AS AnzahlTermine
FROM Appointment
GROUP BY ServiceID
ORDER BY AnzahlTermine DESC
LIMIT 1; -- da nur 5 testdaten drinnen sind für 5 verschiedene service, häufigkeit bei allen ist 1.

-- Aktualisierung Eintrag & Trigger
UPDATE Employee -- to update, turn off safe update mode in preferences (rad oben rechts)
SET Specialization = 'Senior Colorist'
WHERE FirstName = 'David' AND LastName = 'Schulz';

CREATE TABLE ChangeLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    ActionType VARCHAR(50),
    TableName VARCHAR(50),
    ChangedData TEXT,
    ActionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);  -- um die einträge bzw. updates zu loggen

DELIMITER $$

CREATE TRIGGER AfterPaymentCompleted
AFTER UPDATE ON Payment
FOR EACH ROW
BEGIN
    IF OLD.Status != 'Completed' AND NEW.Status = 'Completed' THEN
        INSERT INTO ChangeLog (ActionType, TableName, ChangedData)
        VALUES ('UPDATE', 'Payment', CONCAT('Payment ID: ', NEW.PaymentID, ', Amount: ', NEW.Amount, ', Status: Completed, Appointment ID: ', NEW.AppointmentID));
    END IF;
END$$ -- trigger that logs changes to the Payment table whenever a payment's status is updated to "Completed"

DELIMITER ;

-- beispiel
-- Status einer Zahlung von "Pending" auf "Completed" ändern
UPDATE Payment
SET Status = 'Completed'
WHERE PaymentID = 5;

-- Überprüfen Sie die ChangeLog-Tabelle, um den Eintrag zu sehen
SELECT * FROM ChangeLog;


-- zusätzliche spalte hinzufügen bsp in der tabelle APPOINTMENT
ALTER TABLE Employee
ADD COLUMN Salary DECIMAL(10, 2);

UPDATE Employee
SET Salary = 2500.00
WHERE EmployeeID = 1;





