
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
('Fred','Flinstone', '1234 Boulder Street','Bedrock City','AB','T9E1H1','555-123-4567','I','A000'),
('Homer','Simpson', '742 Evergreen Terrace','Springfield','AB','T9S9L1','555-234-5678','I','A110'),
('Luke','Skywalker', '800 The Resistance Drive','Alderaan','BC','D1D1D1','555-000-0000','B','A115'),
('Sue','Sampson', '443 Somewhere Street','MooseJaw','SK','M4L1D2','111-222-3333','I','A120')

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
('111111',100,'P'),
('111111',110,'P'),
('222222',120,'P'),
('333333',110,'F'),
('222222',110,'P')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('Dec 3 2019',3.00,0.15,3.15,0,100,111111)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(1,1,'Stephen King Collection',20,15,'BKS'),
(1,2,'Cooking for Dummies',5,4,'BKS'),
(1,3,'PlayStation 2',50,40,'ELT')


Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('dec 20 2019',103.00,5.15,108.15,0,100,111111)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(2,1,'Nissan King Cab Truck',5000,4000,'VHC'),
(2,2,'Stamp Collection',100,90,'COL')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('feb 5 2020',5.00,0.25,5.25,0,100,111111)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(3,1,'Fur Coat',5000,4000,'CLO'),
(3,2,'Gold Ring',100,90,'VAL')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('feb 6 2020',5.50,0.28,5.78,0,100,444444)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(4,1,'FootBall',10,8,'SPT'),
(4,2,'Signed Wayne Gretzky Jersey',500,400,'SPT'),
(4,3,'Cooking With Yan',5,4,'BKS'),
(4,4,'Diamond Necklace',1000,900,'VAL')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('March 3 2020',102,4.59,106.59,10.2,101,555555)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(5,1,'Dash Cam',100,90,'ELT'),
(5,2,'Ford Truck',2000,1900,'VHC')


Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('April 7 2020',6.00,0.27,6.27,0.60,101,666666)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(6,1,'32" TV',100,80,'ELT'),
(6,2,'Pencil Sharpener',5,4,'HLD'),
(6,3,'Lawn Mower',150,140,'HLD'),
(6,4,'Camera',50,40,'ELT')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('April 8 2020',2.00,0.09,1.79,0.30,102,555555)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(7,1,'Bed Frame',50,40,'HLD'),
(7,2,'Soccer Ball',10,8,'SPT')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('July 21 2020',4.00,0.17,3.57,0.60 ,102,444444)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(8,1,'Lamp',10,8,'HLD'),
(8,2,'Printer',80,70,'ELT'),
(8,3,'Bookcase',20,18,'HLD')


Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('August 5 2020',4.50,0.18,3.78,0.90,103,111111)
Insert into ConsignmentDetails(ConsignmentID, LineID,ItemDescription, StartPrice, LowestPrice, CategoryCode)
values 
(9,1,'Couch',50,48,'HLD'),
(9,2,'Plate Collection',100,90,'COL'),
(9,3,'SQL For Dummies',5,4,'BKS')

Insert into Consignment(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
values ('Sep 25 2020',6.5,0.33,6.83,0,101,444444)
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






