# DROP DATABASE IF EXIST salondb; --entfernen(#) falls database schon vorhanden ist
CREATE DATABASE salondb;
USE salondb;
CREATE TABLE Customer (
    CustomerID INT AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    DateOfBirth DATE,
    PRIMARY KEY (CustomerID)
);

CREATE TABLE Employee (
    EmployeeID INT AUTO_INCREMENT,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    HireDate DATE NOT NULL,
    Specialization VARCHAR(50),
    PRIMARY KEY (EmployeeID)
);

CREATE TABLE Service (
    ServiceID INT AUTO_INCREMENT,
    ServiceName VARCHAR(100) NOT NULL,
    Description TEXT,
    Duration INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (ServiceID)
);

CREATE TABLE Product (
    ProductID INT AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Brand VARCHAR(50) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    StockQuantity INT NOT NULL,
    PRIMARY KEY (ProductID)
);

CREATE TABLE Appointment (
    AppointmentID INT AUTO_INCREMENT,
    CustomerID INT NOT NULL,
    EmployeeID INT NOT NULL,
    ServiceID INT NOT NULL,
    Date DATE NOT NULL,
    StartTime TIME NOT NULL,
    Status VARCHAR(20) DEFAULT 'Scheduled',
    PRIMARY KEY (AppointmentID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (ServiceID) REFERENCES Service(ServiceID)
);

CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT,
    AppointmentID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PaymentMethod VARCHAR(50) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Pending',
    PRIMARY KEY (PaymentID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID)
);

CREATE TABLE PaymentProduct (
    PaymentID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    PRIMARY KEY (PaymentID, ProductID),
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID),
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);



-- reiheenfolge : Customer
			--    Employee
			--    Service
			--    Product
			--    Apointment (depends on Customer, Employee, Service)
			--    Payment (depends on Appointment)
			--    PaymentProduct (depends on Payment and Product)

-- um sicherzustellen das die initialisierung bei 1 beginnt und ausführen damit die abfragen usw. richtig funktionieren
ALTER TABLE Customer AUTO_INCREMENT = 1;
ALTER TABLE Employee AUTO_INCREMENT = 1;
ALTER TABLE Service AUTO_INCREMENT = 1;
ALTER TABLE Product AUTO_INCREMENT = 1;
ALTER TABLE Appointment AUTO_INCREMENT = 1;
ALTER TABLE Payment AUTO_INCREMENT = 1;

-- inset customer
INSERT INTO Customer (FirstName, LastName, Email, Phone, DateOfBirth) VALUES
('Emma', 'Schmidt', 'emma.s@email.com', '+49-176-1234567', '1990-05-15'),
('Thomas', 'Weber', 'thomas.w@email.com', '+49-176-2345678', '1985-08-22'),
('Sophie', 'Meyer', 'sophie.m@email.com', '+49-176-3456789', '1992-03-10'),
('Michael', 'Wagner', 'michael.w@email.com', '+49-176-4567890', '1988-11-28'),
('Laura', 'Fischer', 'laura.f@email.com', '+49-176-5678901', '1995-07-03');

-- Insert Employees
INSERT INTO Employee (FirstName, LastName, Email, Phone, HireDate, Specialization) VALUES
('Maria', 'Becker', 'maria.b@salon.com', '+49-176-1111111', '2022-01-15', 'Hair Stylist'),
('David', 'Schulz', 'david.s@salon.com', '+49-176-2222222', '2022-03-01', 'Colorist'),
('Anna', 'Koch', 'anna.k@salon.com', '+49-176-3333333', '2022-06-10', 'Nail Artist'),
('Julia', 'Hoffmann', 'julia.h@salon.com', '+49-176-4444444', '2023-01-20', 'Massage Therapist'),
('Felix', 'Schäfer', 'felix.s@salon.com', '+49-176-5555555', '2023-04-05', 'Hair Stylist');
-- Insert Services
INSERT INTO Service (ServiceName, Description, Duration, Price) VALUES
('Haircut & Styling', 'Professional haircut and styling service', 60, 55.00),
('Color Treatment', 'Full hair coloring service', 120, 120.00),
('Manicure', 'Basic manicure service', 45, 35.00),
('Massage', 'Full body relaxation massage', 90, 85.00),
('Hair Styling', 'Professional styling for special occasions', 45, 45.00);
-- Insert Products
INSERT INTO Product (Name, Brand, Description, Price, StockQuantity) VALUES
('Shampoo Plus', 'HairPro', 'Professional grade shampoo', 24.99, 50),
('Styling Gel', 'StyleMaster', 'Strong hold styling gel', 18.99, 35),
('Nail Polish Set', 'NailArt', 'Set of 3 seasonal colors', 29.99, 25),
('Massage Oil', 'RelaxPlus', 'Natural massage oil', 34.99, 20),
('Hair Mask', 'HairPro', 'Deep conditioning treatment', 39.99, 30);

-- insert Appointments
INSERT INTO Appointment (CustomerID, EmployeeID, ServiceID, Date, StartTime, Status) VALUES
(1, 1, 1, CURDATE(), '10:00:00', 'Scheduled'),
(2, 2, 2, CURDATE(), '11:00:00', 'Scheduled'),
(3, 3, 3, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '14:00:00', 'Scheduled'),
(4, 4, 4, DATE_ADD(CURDATE(), INTERVAL 1 DAY), '15:00:00', 'Scheduled'),
(5, 5, 5, DATE_ADD(CURDATE(), INTERVAL 2 DAY), '13:00:00', 'Scheduled');

-- insert Payment
INSERT INTO Payment (AppointmentID, Amount, PaymentMethod, Status) VALUES
(1, 55.00, 'Credit Card', 'Completed'),
(2, 120.00, 'Cash', 'Completed'),
(3, 35.00, 'Debit Card', 'Completed'),
(4, 85.00, 'Credit Card', 'Completed'),
(5, 45.00, 'Cash', 'Pending');

-- insert PaymentProduct
INSERT INTO PaymentProduct (PaymentID, ProductID, Quantity) VALUES
(1, 1, 1),  
(2, 2, 1),  
(3, 3, 2), 
(4, 4, 1),  
(5, 5, 1); 

