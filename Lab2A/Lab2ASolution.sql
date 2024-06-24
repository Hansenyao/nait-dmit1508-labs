/*
 * The SQL script for Lab 2A:Stuff B Gone
 * Term: DMIT1508 - Database Fundamentals - 2023/2024 Spring Term (1233) (E01)
 * Date: June 6, 2024
 *
 * Student: Youfang Yao
 * Student ID: 200582794
 * 
 * Key Steps: 1. Create tables
 *            2. Add primary key constraints
 *            3. Add forgein key constraints
 *            4. Add check constraints
 *			  5. Alter tables
 *            6. Create indexes
 *
*/
DROP TABLE If Exists ConsignmentDetails
DROP TABLE If Exists Consignment
DROP TABLE If Exists Category
DROP TABLE If Exists StaffTraining
Drop TABLE If Exists Training
Drop TABLE If Exists Staff
Drop TABLE If Exists StaffType
Drop TABLE If Exists Customer
Drop TABLE If Exists Reward
Drop TABLE If Exists CustomerType
GO

/* Create tables */
CREATE TABLE CustomerType (
	CustomerTypeID CHAR(1) CONSTRAINT PK_CustomerType_CustomerTypeID PRIMARY KEY CLUSTERED NOT NULL,
	CustomerTypeDescription VARCHAR(30) NOT NULL
)

CREATE TABLE Reward (
	RewardID CHAR(4) CONSTRAINT PK_Reward_RewardID PRIMARY KEY CLUSTERED NOT NULL,
	RewardDescription VARCHAR(30) NOT NULL,
	DiscountPercentage TINYINT NOT NULL
)

CREATE TABLE Customer(
	CustomerID INT IDENTITY(100,1) CONSTRAINT PK_Customer_CustomerID PRIMARY KEY CLUSTERED NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	StreetAddress VARCHAR(30),
	City VARCHAR(20),
	Province CHAR(2) CONSTRAINT CK_Province CHECK (Province LIKE '[A-Z][A-Z]'),
	PostalCode CHAR(6) CONSTRAINT CK_PostalCode CHECK (PostalCode LIKE '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	Phone CHAR(14) CONSTRAINT CK_Phone CHECK (PHONE LIKE '[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	CustomerTypeID CHAR(1) CONSTRAINT FK_CustomerToCustomerType REFERENCES CustomerType (CustomerTypeID) NOT NULL,
	RewardID CHAR(4) CONSTRAINT FK_CustomerToReward REFERENCES Reward (RewardID) NOT NULL
)

CREATE TABLE StaffType (
	StaffTypeID SMALLINT IDENTITY(1,1) CONSTRAINT PK_StaffType_StaffTypeID PRIMARY KEY CLUSTERED NOT NULL,
	StaffTypeDescription VARCHAR(30) NOT NULL
)

CREATE TABLE Staff(
	StaffID CHAR(6) CONSTRAINT PK_Staff_StaffID PRIMARY KEY CLUSTERED NOT NULL,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	Active CHAR(1) NOT NULL,
	Wage SMALLMONEY NOT NULL,
	StaffTypeID SMALLINT CONSTRAINT FK_StaffToStaffType REFERENCES StaffType (StaffTypeID) NOT NULL
)

CREATE TABLE Training (
	TrainingID INT IDENTITY(100,10) CONSTRAINT PK_Training_TrainingID PRIMARY KEY CLUSTERED NOT NULL,
	StartDate SMALLDATETIME NOT NULL,
	EndDate SMALLDATETIME NOT NULL,
	TrainingDescription VARCHAR(70) NOT NULL,
	CONSTRAINT CK_EndDate CHECK (EndDate > StartDate) 
)

CREATE TABLE StaffTraining (
	StaffID CHAR(6) CONSTRAINT FK_StaffTrainingToStaff REFERENCES Staff (StaffID) NOT NULL,
	TrainingID INT CONSTRAINT FK_StaffTrainingToTraining REFERENCES Training (TrainingID) NOT NULL,
	PassOrFail CHAR(1),
	CONSTRAINT	PK_StaffId_TrainingId PRIMARY KEY CLUSTERED (StaffID, TrainingID)
)

CREATE TABLE Category (
	CategoryCode CHAR(3) CONSTRAINT PK_Category_CategoryCode PRIMARY KEY CLUSTERED NOT NULL,
	CategoryDescription VARCHAR(50) NOT NULL,
	Cost SMALLMONEY CONSTRAINT CK_Cost CHECK (Cost >= 0) NOT NULL
)

CREATE TABLE Consignment (
	ConsignmentID INT IDENTITY(1,1) CONSTRAINT PK_Consignment_ConsignmentID PRIMARY KEY CLUSTERED NOT NULL,
	Date DATETIME NOT NULL,
	Subtotal SMALLMONEY NOT NULL,
	GST SMALLMONEY NOT NULL,
	Total SMALLMONEY NOT NULL,
	RewardsDiscount DECIMAL(9,2) NOT NULL,
	CustomerID INT CONSTRAINT FK_ConsignmentToCustomer REFERENCES Customer (CustomerID) NOT NULL,
	StaffID CHAR(6) CONSTRAINT FK_ConsignmentToStaff REFERENCES Staff (StaffID) NOT NULL
)

CREATE TABLE ConsignmentDetails (
	ConsignmentID INT CONSTRAINT FK_ConsignmentsDetailsToConsignment REFERENCES Consignment (ConsignmentID) NOT NULL,
	LineID INT NOT NULL,
	ItemDescription VARCHAR(40) NOT NULL,
	StartPrice SMALLMONEY NOT NULL,
	LowestPrice SMALLMONEY NOT NULL,
	CategoryCode CHAR(3) CONSTRAINT FK_ConsignmentToCategory REFERENCES Category (CategoryCode) NOT NULL,
	CONSTRAINT	PK_ConsignmentID_LineID PRIMARY KEY CLUSTERED (ConsignmentID, LineID)
)
GO

/* Alter table Customer: A 30 character attribute called email. Email addresses must match the following format:
 * 1.At least 3 letters/numbers before and after @ 
 * 2.At least 2 letters/numbers after the period.
 */
ALTER TABLE Customer ADD Email VARCHAR(30) CONSTRAINT CK_Customer_Email CHECK (Email LIKE '___%@___%.__%')

/* Alter table Staff:
 * A one character attribute called active that is required and has a default of ‘y’
 */
ALTER TABLE Staff ADD CONSTRAINT DF_Staff_Active DEFAULT 'y' FOR Active
ALTER TABLE Staff ALTER COLUMN Active CHAR(1) NOT NULL 
GO

/* Create non clustered indexes on all foreign keys. */
CREATE NONCLUSTERED INDEX IX_CustomerTypeID_RewardID ON Customer (CustomerTypeID, RewardID)
CREATE NONCLUSTERED INDEX IX_StaffTypeID ON Staff (StaffTypeID)
CREATE NONCLUSTERED INDEX IX_StaffID_TrainingID ON StaffTraining (StaffID, TrainingID)
CREATE NONCLUSTERED INDEX IX_CustomerID_StaffID ON Consignment (CustomerID, StaffID)
CREATE NONCLUSTERED INDEX IX_ConsignmentID_CategoryCode ON ConsignmentDetails (ConsignmentID, CategoryCode)
