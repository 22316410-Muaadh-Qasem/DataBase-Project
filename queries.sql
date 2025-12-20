
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FullName VARCHAR(100) NOT NULL,
    Phone VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    City VARCHAR(50) DEFAULT 'Unknown' ,
    Address VARCHAR(200)
);

CREATE TABLE RegularCustomer (
    CustomerID INT PRIMARY KEY,
    DiscountRate DECIMAL(5,2),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE VIPCustomer (
    CustomerID INT PRIMARY KEY,
    MembershipLevel VARCHAR(30),
    BonusPoints INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(100),
    Country VARCHAR(50),
    Rating INT
);

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50) UNIQUE
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2),
    StockQuantity INT DEFAULT 0,
    SupplierID INT,
    CategoryID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(30) DEFAULT 'Pending' ,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE OrderItems (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10,2),
    Total DECIMAL(10,2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY,
    ProductID INT UNIQUE,
    QuantityIn INT,
    QuantityOut INT,
    CurrentStock INT,
    LastUpdated DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY,
    OrderID INT,
    PaymentDate DATE,
    Amount DECIMAL(10,2),
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(30)  DEFAULT 'Pending',
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

CREATE TABLE Shipments (
    ShipmentID INT PRIMARY KEY,
    OrderID INT,
    ShipmentDate DATE,
    DeliveryStatus VARCHAR(30),
    Carrier VARCHAR(50),
    TrackingNumber VARCHAR(100),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

INSERT INTO Customers (CustomerID, FullName, Phone, Email, City, Address)
VALUES
(1, 'Omar Hassan', '0503333333', 'omar@mail.com', 'Makkah', 'Street 3'),
(2, 'Sara Khaled', '0502222222', 'sara@mail.com', 'Jeddah', 'Street 2');
INSERT INTO RegularCustomer VALUES
(1, 5.00);

INSERT INTO VIPCustomer VALUES
(2, 'Gold', 120);

INSERT INTO Suppliers VALUES
(1, 'Tech Supplier', '0551234567', 'tech@supplier.com', 'Saudi Arabia', 5),
(2, 'Office Supplier', '0557654321', 'office@supplier.com', 'UAE', 4);

INSERT INTO Categories VALUES
(1, 'Electronics'),
(2, 'Office Supplies');

INSERT INTO Products VALUES
(1, 'Laptop', 3500.75, 20, 1, 1),
(2, 'Printer', 1200.75, 10, 2, 2);

INSERT INTO Products (ProductID, ProductName, Price, StockQuantity, SupplierID, CategoryID)
VALUES
(3, 'Mouse', 120.75, 50, 1, 1),
(4, 'Keyboard', 180.75, 40, 1, 1),
(5, 'Desk Chair', 450.75, 15, 2, 2);


INSERT INTO Orders VALUES
(1, 1, '2025-01-10', 3500.75, 'Completed'),
(2, 2, '2025-01-12', 1200.75, 'Pending');

INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount, Status)
VALUES
(3, 1, '2025-01-15', 1200.75, 'Completed'),
(4, 1, '2025-01-18', 450.75, 'Completed'),
(5, 2, '2025-01-20', 180.75, 'Completed');


INSERT INTO OrderItems VALUES
(1, 1, 1, 3500.75, 3500.75),
(2, 2, 1, 1200.75, 1200.75);

INSERT INTO Inventory VALUES
(1, 1, 20, 1, 19, '2025-01-10'),
(2, 2, 10, 1, 9, '2025-01-12');

INSERT INTO Payments VALUES
(1, 1, '2025-01-10', 3500.75, 'Credit Card', 'Paid'),
(2, 2, '2025-01-12', 1200.75, 'Cash', 'Pending');

INSERT INTO Shipments VALUES
(1, 1, '2025-01-11', 'Delivered', 'DHL', 'TRK123'),
(2, 2, '2025-01-13', 'In Transit', 'Aramex', 'TRK456');

UPDATE Customers
SET City = 'Riyadh',
    Address = 'New Street 10'
WHERE CustomerID = 1;

UPDATE Orders
SET Status = 'Completed'
WHERE OrderID = 2;

DELETE FROM Shipments
WHERE ShipmentID = 2;

DELETE FROM OrderItems
WHERE OrderID = 2
AND ProductID = 2;


-- 1) LENGTH + LOWER
SELECT 
    FullName,
    LENGTH(FullName) AS NameLength,
    LOWER(Email) AS LowerEmail
FROM Customers;

-- 2) INSTR
SELECT 
    Email,
    INSTR(Email, '@') AS AtPosition
FROM Customers;

-- 3) SUBSTRING
SELECT 
    ProductName,
    SUBSTRING(ProductName, 1, 3) AS ShortName
FROM Products;

SELECT
    ProductName,
    ROUND(Price, 0) AS Rounded0
FROM Products;
-- 5) TRUNC numbers
SELECT 
    ProductName,
    TRUNCATE(Price, 1) AS TruncatedPrice
FROM Products;

-- 6) SUBDATE
SELECT 
    OrderID,
    SUBDATE(OrderDate, INTERVAL 7 DAY) AS OneWeekBefore
FROM Orders;

-- 7) ADD MONTHS (MySQL)
SELECT 
    OrderID,
    DATE_ADD(OrderDate, INTERVAL 3 MONTH) AS WarrantyEndDate
FROM Orders;

-- 8) MONTHS BETWEEN (MySQL)
SELECT 
    OrderID,
    TIMESTAMPDIFF(MONTH, OrderDate, CURDATE()) AS MonthsSinceOrder
FROM Orders;

-- 9) INNER JOIN
SELECT 
    c.CustomerID,
    o.OrderID
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE TotalAmount >= 3000;

-- 10) LEFT JOIN
SELECT 
    s.SupplierName,
    p.ProductName
FROM Suppliers s
LEFT JOIN Products p ON s.SupplierID = p.SupplierID;

-- 11) GROUP BY + AVG()
SELECT 
    SupplierID,
    AVG(Price) AS AvgProductPrice
FROM Products
GROUP BY SupplierID;

-- 12) GROUP BY + SUM()
SELECT 
    CustomerID,
    SUM(TotalAmount) AS TotalSpent
FROM Orders
GROUP BY CustomerID;

-- 13) SUBQUERY (AVG in WHERE)
SELECT *
FROM Products
WHERE Price > (
    SELECT AVG(Price)
    FROM Products
);

-- 14) SUBQUERY (IN)
SELECT FullName
FROM Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Orders
    WHERE Status = 'Completed'
);

-- 15) GROUP BY + HAVING + JOIN
SELECT 
    c.FullName,
    SUM(o.TotalAmount) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FullName
HAVING SUM(o.TotalAmount) > 2000;


