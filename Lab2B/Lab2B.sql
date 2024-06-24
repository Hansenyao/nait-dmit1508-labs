DROP TABLE IF EXISTS ConsignmentDetails
DROP TABLE IF EXISTS Consignment
DROP TABLE IF EXISTS StaffTraining
DROP TABLE IF EXISTS Staff
DROP TABLE IF EXISTS Customer
DROP TABLE IF EXISTS Category
DROP TABLE IF EXISTS StaffType
DROP TABLE IF EXISTS Training
DROP TABLE IF EXISTS Reward
DROP TABLE IF EXISTS CustomerType
Drop View IF EXISTS  CustomerSummary


CREATE TABLE CustomerType
(
	CustomerTypeID char(1) not null 
	Constraint pk_CustomerType Primary Key clustered,
	CustomerTypeDescription varchar(30) not null
)

CREATE TABLE Reward
(
	RewardID char(4) not null 
	Constraint pk_Reward Primary Key clustered,
	RewardDescription varchar(30) null,
	DiscountPercentage tinyint not null
)

CREATE TABLE Training
(
	TrainingID int identity(1,1) not null 
	Constraint pk_Training Primary Key clustered,
	StartDate smalldatetime not null,
	EndDate smalldatetime not null, 
	TrainingDescription varchar(70) not null,
	Constraint ck_ValidEndDate check (EndDate > StartDate)
)

CREATE TABLE StaffType
(
	StaffTypeID smallint identity(1,1) not null 
	Constraint pk_StaffType Primary Key clustered,
	StaffTypeDescription varchar(30) not null	
)

CREATE TABLE Category
(
	CategoryCode char(3) not null 
	Constraint pk_Category Primary Key clustered,
	CategoryDescription varchar(50) not null,
	Cost smallmoney not null 
	Constraint ck_ValidCost check (Cost >= 0 )
	
)

CREATE TABLE Customer
(
	CustomerID int identity(1,1) not null 
	Constraint pk_Customer Primary Key clustered,
	FirstName varchar(30) not null,
	LastName varchar(30) not null,
	StreetAddress varchar(30) null,
	City varchar(20) null,
	Province char(2) null 
	constraint ck_ValidProvince check (Province like '[A-Z][A-Z]')
	constraint df_Province default 'AB',
	PostalCode char(6) null 
	Constraint ck_ValidPostalCode check (PostalCode like '[A-Z][0-9][A-Z][0-9][A-Z][0-9]'),
	Phone char(14) null 
	Constraint ck_ValidPhone check (Phone like '[0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9]-[0-9][0-9][0-9][0-9]'),
	CustomerTypeID char(1) not null 
	Constraint FK_CustomerToCustomerType references CustomerType(CustomerTypeID),
	RewardID char(4) not null
	Constraint FK_CustomerToReward references Reward(RewardID)
)

CREATE TABLE Staff
(
	StaffID char(6) not null 
	Constraint pk_Staff Primary Key clustered,
	FirstName varchar(30) not null,
	LastName varchar(30) not null,
	Active char(1) not null,
	wage smallmoney not null,
	StaffTypeID smallint not null 
	Constraint FK_StaffToStaffType references StaffType(StaffTypeID)
)

CREATE TABLE StaffTraining
(
	StaffID char(6) not null 
	Constraint FK_StaffTrainingToStaff references Staff(StaffID),
	TrainingID int not null 
	Constraint FK_StaffTrainingToTraining references Training(TrainingID),
	PassOrFail char(1) null,
	Constraint pk_StaffTraining Primary Key clustered (StaffID, TrainingID)
)

CREATE TABLE Consignment
(
	ConsignmentID int identity(1,1) not null 
	Constraint pk_Consignment Primary Key clustered,
	Date datetime not null,
	Subtotal smallmoney not null,
	GST smallmoney not null,
	Total smallmoney not null,
	RewardsDiscount decimal(9,2) not null,
	CustomerID int not null 
	Constraint FK_ConsignmentToCustomer references Customer(CustomerID),
	StaffID char(6) not null 
	Constraint FK_ConsignmentToStaff references Staff(StaffID)
)

CREATE TABLE ConsignmentDetails
(
	ConsignmentID int not null 
	Constraint FK_ConsignmentDetailsToConsignment references Consignment(ConsignmentID),
	LineID int not null,
	ItemDescription varchar(40) not null,
	StartPrice smallmoney not null,
	LowestPrice smallmoney not null,
	CategoryCode char(3) not null 
	Constraint FK_ConsignmentDetailsToCategory references Category(CategoryCode),
	Constraint pk_ConsignmentDetails Primary Key clustered (ConsignmentID, LineID)
)
go
--INSERT DATA
Insert into CustomerType (CustomerTypeID,CustomerTypeDescription)
values
('B','Business Client'),
('I','Individual'),
('N','Non Profit')

Insert into Reward(RewardID,RewardDescription,DiscountPercentage)
values
('A000','No Reward',0),
('A120','Exclusive Customer',20),
('A115','Preferred Customer',15),
('A110','Exclusive',10)

Insert into Training(StartDate,EndDate,TrainingDescription)
values
('jan 1 2020', 'jan 3 2020','Customer Retention'),
('jan 20 2020', 'jan 25 2020','Sales For Dummies'),
('jan 25 2020', 'jan 26 2020','How To Sell')

Insert into StaffType(StaffTypeDescription)
values
('Sales'),
('Promotion'),
('Human Resources'),
('Payroll')


Insert into Category(CategoryCode,CategoryDescription,Cost)
values
('ELT','Electronics',2),
('VAL','Valuables',3),
('SPT','Sports',1),
('BKS','Books',0.5),
('COL','Collectables',3),
('CLO','Clothing',2),
('VHC','Vehicles',100),
('HLD','Household',1)


Insert into Customer(FirstName,LastName,StreetAddress,City,Province,PostalCode,Phone,CustomerTypeID,RewardID)
values
('Fred','Flinstone', '1234 Boulder Street','Bedrock City','AB','T9E1H1','1-555-123-4567','I','A000'),
('Homer','Simpson', '742 Evergreen Terrace','Springfield','AB','T9S9L1','1-555-234-5678','I','A110'),
('Luke','Skywalker', '800 The Resistance Drive','Alderaan','BC','D1D1D1','1-555-000-0000','B','A115'),
('Sue','Sampson', '443 Somewhere Street','MooseJaw','SK','M4L1D2','1-111-222-3333','I','A120')

Insert into Staff(StaffID,FirstName,LastName,Active,wage,StaffTypeID)
values
('111111','Bob','Marley','Y',20,1),
('222222','Elvis','Presley','Y',15,2),
('333333','Patti','Page','Y',25,3),
('444444','Doris','Day','Y',15,1),
('555555','Buddy','Holly','Y',18,1),
('666666','Faith','Hill','Y',15,1),
('777777','Chuck','Barry','Y',25,1),
('888888','Harry','Bellafonte','Y',19,1)

Insert into StaffTraining(StaffID,TrainingID,PassOrFail)
values
('111111',1,'P'),
('111111',2,'P'),
('222222',3,'P'),
('333333',2,'F'),
('222222',2,'P')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('Jan 3 2023',3.00,0.15,3.15,0,1,111111)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(1,1,'Stephen King Collection',20,15,'BKS'),
(1,2,'Cooking for Dummies',5,4,'BKS'),
(1,3,'PlayStation 2',50,40,'ELT')


Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('Jan 20 2023',103.00,5.15,108.15,0,1,111111)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(2,1,'Nissan King Cab Truck',5000,4000,'VHC'),
(2,2,'Stamp Collection',100,90,'COL')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('feb 5 2023',5.00,0.25,5.25,0,1,111111)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(3,1,'Fur Coat',5000,4000,'CLO'),
(3,2,'Gold Ring',100,90,'VAL')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('feb 6 2023',5.50,0.28,5.78,0,1,444444)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(4,1,'FootBall',10,8,'SPT'),
(4,2,'Signed Wayne Gretzky Jersey',500,400,'SPT'),
(4,3,'Cooking With Yan',5,4,'BKS'),
(4,4,'Diamond Necklace',1000,900,'VAL')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('March 3 2024',102,4.59,106.59,10.2,2,555555)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(5,1,'Dash Cam',100,90,'ELT'),
(5,2,'Ford Truck',2000,1900,'VHC')


Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('April 7 2024',6.00,0.27,6.27,0.60,2,666666)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(6,1,'32" TV',100,80,'ELT'),
(6,2,'Pencil Sharpener',5,4,'HLD'),
(6,3,'Lawn Mower',150,140,'HLD'),
(6,4,'Camera',50,40,'ELT')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('April 8 2024',2.00,0.09,1.79,0.30,3,555555)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(7,1,'Bed Frame',50,40,'HLD'),
(7,2,'Soccer Ball',10,8,'SPT')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('April 21 2024',4.00,0.17,3.57,0.60 ,3,444444)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(8,1,'Lamp',10,8,'HLD'),
(8,2,'Printer',80,70,'ELT'),
(8,3,'Bookcase',20,18,'HLD')


Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('June 5 2024',4.50,0.18,3.78,0.90,4,111111)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(9,1,'Couch',50,48,'HLD'),
(9,2,'Plate Collection',100,90,'COL'),
(9,3,'SQL For Dummies',5,4,'BKS')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('June 25 2024',6.5,0.33,6.83,0,1,444444)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(10,1,'IPhone',500,400,'ELT'),
(10,2,'Baseball Shoes',15,12,'SPT'),
(10,3,'How To Play Checkers',5,4,'BKS'),
(10,4,'Gold Crown',10000,9000,'VAL')


Select * from  ConsignmentDetails
Select * from Consignment
Select * from StaffTraining
Select * from Staff
Select * from Customer
Select * from Category
Select * from StaffType
Select * from Training
Select * from Reward
Select * from CustomerType






