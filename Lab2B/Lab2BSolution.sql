/*
 * The SQL script for Lab 2B:Stuff B Gone
 * Term: DMIT1508 - Database Fundamentals - 2023/2024 Spring Term (1233) (E01)
 * Date: June 20, 2024
 *
 * Student: Youfang Yao
 * Student ID: 200582794
 * 
 *
*/

/* 1.Select the full name and city for the customer with customer ID 4. Show first name and last name as one column. */
SELECT Customer.FirstName + ' ' + Customer.LastName AS 'Customer Name', Customer.City
FROM Customer
WHERE Customer.CustomerID = 4
GO

/* 2.For all staff, select the staff first name, last name, and the number of consignments they have. */
SELECT Staff.FirstName, Staff.LastName, COUNT(*) AS 'Number of Consignments'
FROM Staff, Consignment 
WHERE Staff.StaffID = Consignment.StaffID
GROUP BY Staff.FirstName, Staff.LastName
ORDER BY [Number of Consignments] DESC
GO

/* 3.Select the average Category Cost. */
SELECT AVG(Cost) AS 'Average Cost'
FROM Category
GO

/* 4.Select the customer first name and last name for all customers whose total consignment subtotals are more than $20.00. */
SELECT Customer.FirstName, Customer.LastName, Consignment.Subtotal
FROM Customer, Consignment
WHERE Customer.CustomerID = Consignment.CustomerID AND Consignment.Subtotal > 20
GO

/* 5.Select all the staff full names with the customer full names of the consignments they have worked on. Include staff that have not worked on any consignments */
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Staff Name', Customer.FirstName + ' ' + Customer.LastName AS 'Customer Name' 
FROM Staff
	LEFT JOIN Consignment
	ON Staff.StaffID = Consignment.StaffID
	LEFT JOIN Customer
	ON Consignment.CustomerID = Customer.CustomerID
GO

/* 6.Select the first name and last name of all the customers whose last name starts with ‘S’ */
SELECT Customer.FirstName, Customer.LastName 
FROM Customer
WHERE Customer.LastName LIKE 'S%'
GO

/* 7.Select the amount of money that was made each month this year. Show the month name and amount. List the months in chronological order by month. Do not include GST in the totals */
SELECT DATEPART(mm, Consignment.Date) AS 'Month', SUM(Consignment.Subtotal) AS 'Amount'
FROM Consignment
GROUP BY MONTH(Consignment.Date)
GO

/* 8.Select the StaffTypeDescriptions of the staff types that have no staff in them. */
SELECT StaffType.StaffTypeDescription
FROM StaffType
	LEFT JOIN Staff
	ON StaffType.StaffTypeID = Staff.StaffTypeID
WHERE Staff.StaffTypeID IS NULL
/* Or */
SELECT StaffType.StaffTypeDescription 
FROM StaffType
WHERE StaffType.StaffTypeID 
	NOT IN (SELECT Staff.StaffTypeID FROM Staff)
GO

/* 9.Select the full names of all the people in the database whose lastname is between 5 and 8 characters long. */
SELECT Staff.FirstName + ' ' + Staff.LastName AS 'Full Name'
FROM Staff
WHERE LEN(Staff.LastName) >= 5 AND LEN(Staff.LastName) <= 8
UNION
SELECT Customer.FirstName + ' ' + Customer.LastName AS 'Full Name'
FROM Customer
WHERE LEN(Customer.LastName) >= 5 AND LEN(Customer.LastName) <= 8
GO

/* 10.Create a view called CustomerSummary that contains CustomerID, FirstName, LastName, and the Descriptions of the items they are selling. Assume all customers have at least one item on consignment. */
CREATE VIEW CustomerSummary AS
SELECT Customer.CustomerID, Customer.FirstName, Customer.LastName, Category.CategoryDescription
FROM Customer
	INNER JOIN Consignment
	ON Customer.CustomerID = Consignment.CustomerID
	INNER JOIN ConsignmentDetails
	ON Consignment.ConsignmentID = ConsignmentDetails.ConsignmentID
	INNER JOIN Category
	ON ConsignmentDetails.CategoryCode = Category.CategoryCode
GO

/* 11.Using the CustomerSummary view select the Customerid, fullname, and the number of items they have on consignment. */
SELECT CustomerSummary.CustomerID, CustomerSummary.FirstName + ' ' + CustomerSummary.LastName AS 'Customer Name', COUNT(*) AS 'Amount'
FROM CustomerSummary
GROUP BY CustomerSummary.CustomerID, CustomerSummary.FirstName, CustomerSummary.LastName
GO

/* a)Insert the following records into the Staff table given the following data: */
INSERT INTO Staff
VALUES('999999', 'John', 'Denver', 'Y', 23.0, 3)
INSERT INTO Staff
VALUES('123456', 'Cindy', 'Lauper', 'N', (SELECT AVG(Staff.wage) FROM Staff), 2)
GO

/* Increase the DiscountPercentage of the Reward that has a RewardDescription of “Exclusive” by 2. */
UPDATE Reward 
SET Reward.DiscountPercentage = Reward.DiscountPercentage + 2
FROM Reward
WHERE Reward.RewardDescription = 'Exclusive'
GO

/* The sales department is getting a raise! Increase the wage of all the sales staff by 15%. */
UPDATE Staff
SET Staff.wage = Staff.wage * (1 + 0.15)
FROM Staff
GO

/* Remove all the StaffTypes that have no Staff. */
DELETE FROM StaffType
WHERE StaffType.StaffTypeID 
	NOT IN (SELECT Staff.StaffTypeID FROM Staff)
GO
