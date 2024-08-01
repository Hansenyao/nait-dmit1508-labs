/*
 * The SQL script for Lab 4:Stuff B Gone
 * Term: DMIT1508 - Database Fundamentals - 2023/2024 Spring Term (1233) (E01)
 * Date: July 2031, 2024
 *
 * Student: Youfang Yao
 * Student ID: 200582794
 * 
 *
*/
DROP TRIGGER IF EXISTS Lab4Q1
DROP TRIGGER IF EXISTS Lab4Q2
DROP TRIGGER IF EXISTS Lab4Q3
DROP TRIGGER IF EXISTS Lab4Q4
DROP TRIGGER IF EXISTS Lab4Q5
GO

-- 1.Create a trigger called Lab4Q1 to ensure that the category cost will not increase by more than 15%. 
-- If this happens raise an error and do not allow the increase. (3.5 Marks)
CREATE TRIGGER Lab4Q1
ON Category
FOR Update
AS
	IF @@ROWCOUNT > 0 AND Update(Cost)
		BEGIN
			IF EXISTS(SELECT * FROM inserted
						INNER JOIN deleted
						ON inserted.CategoryCode = deleted.CategoryCode
					  WHERE inserted.Cost > 1.15 * deleted.Cost)
				BEGIN
					RaisError('You cannot update Cost with the new Cost, it is too much!', 16, 1)
					ROLLBACK TRANSACTION
				END
		END
RETURN
GO
-- Test
/*
UPDATE Category
	SET Cost = 2*Cost
WHERE CategoryCode = 'COL'
GO
*/

-- 2.Create a trigger called Lab4Q2 to ensure that a staff member cannot be assigned to a consignment agreement 
-- unless that staff member is in the 'Sales' StaffType. 
-- If this happens, raise an error, and do not allow the transaction to proceed. (3 Marks)
CREATE TRIGGER Lab4Q2
ON Consignment
FOR Insert, Update
AS
	IF @@ROWCOUNT > 0 AND Update(StaffID)
		BEGIN
			IF NOT EXISTS(SELECT * FROM Staff
							INNER JOIN Inserted
							ON Staff.StaffID = Inserted.StaffID
							INNER JOIN StaffType
							ON Staff.StaffTypeID = StaffType.StaffTypeID
						  WHERE StaffType.StaffTypeDescription = 'Sales')
				BEGIN
					RaisError('You cannot add a staff who is not sales to consignment.', 16, 1)
					ROLLBACK TRANSACTION
				END
		END
RETURN
GO
-- Test
/*
INSERT INTO Consignment
	(Date,SubTotal, GST, Total, RewardsDiscount,CustomerID,StaffID)
Values
	(GETDATE(), 3.00, 0.15, 3.15, 0, 1, 222222)

UPDATE Consignment
	SET StaffID = 222222
WHERE StaffID = 111111
GO
*/

-- 3.Create a trigger called Lab4Q3 on the ConsignmentDetails that prevents any modifications to the composite PK. 
-- In other words, do not allow a ConsignmentID or LineID to be changed and raise an error if it is attempted. 
-- This restriction should not prevent the deleting of rows in ConsignmentDetails. (3 Marks)
CREATE TRIGGER Lab4Q3
ON ConsignmentDetail
FOR Update
AS
	IF @@ROWCOUNT > 0 AND (Update(ConsignmentID) OR Update(LineID))
		BEGIN
			RaisError('You cannot change ConsignmentID or LineID.', 16, 1)
			ROLLBACK TRANSACTION
		END
RETURN
GO
-- Test
/*
UPDATE ConsignmentDetail
	SET ConsignmentID = 11
WHERE ConsignmentID = 1

UPDATE ConsignmentDetail
	SET LineID = 11
WHERE ConsignmentID = 1
GO
*/

-- 4.Create a trigger called Lab4Q4 to add record(s) to the LogDiscountChange table when the DiscountPercentage of customer Reward changes. 
-- It will record the date and time of the change, the RewardID, the old DiscountPercentage and the new DiscountPercentage. 
-- Only add records where the DiscountPercentage value changes. 
-- The LogDiscountChange table has been included in the Lab4.sql file.     (3 Marks)
CREATE TRIGGER Lab4Q4
ON Reward
FOR Update
AS
	IF @@ROWCOUNT > 0 AND Update(DiscountPercentage)
		BEGIN
			INSERT INTO LogDiscountChange
				(RewardID, DateChanged, OldDiscountPercentage, NewDiscountPercentage)
			SELECT inserted.RewardID, GETDATE(), deleted.DiscountPercentage, inserted.DiscountPercentage
				FROM inserted
				INNER JOIN deleted
				ON inserted.RewardID = deleted.RewardID
			IF @@ERROR <> 0
				BEGIN
					RaisError('Insert discount change log failed.', 16, 1)
					ROLLBACK TRANSACTION
				END
		END
RETURN
GO
-- Test
/*
Update Reward
	SET DiscountPercentage = 20
WHERE RewardID = 'A000'
GO
*/

-- 5.Create a trigger called Lab4Q5 to ensure that StartPrice and the LowPrice cannot be the same on a new ConsignmentDetail record. 
-- If this happens, raise an error, and do not allow the insert. (3 Marks) 
CREATE TRIGGER Lab4Q5
ON ConsignmentDetail
FOR Insert
AS
	IF @@ROWCOUNT > 0
		BEGIN
			IF EXISTS (SELECT * FROM inserted WHERE inserted.StartPrice = inserted.LowPrice)
				BEGIN
					RaisError('The start price cannot be same as the low price.', 16, 1)
					ROLLBACK TRANSACTION
				END
		END
RETURN
GO
-- Test
/*
INSERT INTO ConsignmentDetail
	(ConsignmentID, LineID,ItemDescription, StartPrice, LowPrice, CategoryCode)
VALUES 
	(10, 5, 'IPhone15', 500, 500, 'ELT')
GO
*/

