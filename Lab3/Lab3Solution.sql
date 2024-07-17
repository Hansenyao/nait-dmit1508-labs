/*
 * The SQL script for Lab 3:Stuff B Gone
 * Term: DMIT1508 - Database Fundamentals - 2023/2024 Spring Term (1233) (E01)
 * Date: July 20, 2024
 *
 * Student: Youfang Yao
 * Student ID: 200582794
 * 
 *
*/
DROP PROCEDURE IF EXISTS AddStaffType
DROP PROCEDURE IF EXISTS UpdateReward
DROP PROCEDURE IF EXISTS DeleteConsignmentDetail
DROP PROCEDURE IF EXISTS LookUpCustomerHistory
DROP PROCEDURE IF EXISTS UnusedCategories
DROP PROCEDURE IF EXISTS LookUpStaffType
DROP PROCEDURE IF EXISTS AddConsignmentItem
GO

-- =====================================================================================================================
-- Create the following stored procedures in the database. Each stored procedure should be created in a separate batch.
-- Ensure your stored procedures meet the following requirements:  Failing to do these checks will result a decrease in marks.
--   - Validate the presence of required parameters and raise an error if they are not present.
--   - DML statements should be checked for and raise a 'user-friendly' error message if they fail
--   - Updates or deletes must check for the existence of the record to be updated or deleted and raise an error if it does not exist.
--   - Use Transactions when necessary to ensure data integrity.
--   - Use consistent formatting and indentation.

-- =====================================================================================================================
-- 1.	Write a stored procedure called AddStaffType that will add a new StaffType to the StaffType table. 
--      Duplicate Descriptions are not allowed! If the Description being added is already in the StaffType '
--      table give an appropriate error message. Otherwise, add the new StaffType to the StaffType table 
--      and select the new StaffTypeID.
--      (3 Marks)
CREATE PROCEDURE AddStaffType (@TypeDescription VARCHAR(30) = NULL)
AS
BEGIN
	/* Check parameters for stored procedure */
	IF @TypeDescription IS NULL
		BEGIN
			RaisError('You must privode a staff type description!', 16, 1)
		END
	ELSE
		BEGIN
			/* Check the new type description exists or not */
			IF EXISTS (SELECT * FROM StaffType WHERE StaffType.StaffTypeDescription = @TypeDescription)
				BEGIN
					RaisError('Staff type description: %s already exists!', 16, 2, @TypeDescription)
				END
			ELSE
				BEGIN
					/* Insert the new type description to tablt StaffType */
					INSERT INTO StaffType (StaffTypeDescription) Values (@TypeDescription)
					/* Select the type id of new record */
					SELECT StaffType.StaffTypeID FROM StaffType WHERE StaffType.StaffTypeDescription = @TypeDescription
				END
		END
END
RETURN
GO
-- Test
EXEC AddStaffType
EXEC AddStaffType 'Sales'
EXEC AddStaffType 'aaaddSalesss'
GO

-- =====================================================================================================================
-- 2.	Write a stored procedure called UpdateReward that accepts the RewardID, Description and DiscountPercentage.
--      If no errors are raised update the record for that Reward.
--      (2 Marks)
CREATE PROCEDURE UpdateReward(@RewardID CHAR(4) = NULL, 
							  @Description VARCHAR(30) = NULL, 
							  @DiscountPercentage TINYINT = NULL)
AS
BEGIN
	/* Check parameters for stored procedure */
	IF @RewardID IS NULL 
		BEGIN
			RaisError('You must privode the reward ID value!', 16, 1)
		END
	ELSE IF  @Description IS NULL 
		BEGIN
			RaisError('You must privode the reward description!', 16, 2)
		END
	ELSE IF @DiscountPercentage IS NULL 
		BEGIN
			RaisError('You must privode the reward discount percentage value!', 16, 3)
		END
	ELSE
		BEGIN
			/* Raise an error if the reward ID does not exists */
			IF NOT EXISTS (SELECT * FROM Reward WHERE Reward.RewardID = @RewardID)
				BEGIN
					RaisError('The reward ID: %s does not exists!', 16, 4, @RewardID)
				END
			/* Otherwise, update this record */
			ELSE
				BEGIN
					UPDATE Reward
						SET Reward.RewardDescription = @Description, Reward.DiscountPercentage = @DiscountPercentage
					WHERE Reward.RewardID = @RewardID
				END
		END
END
RETURN
Go
-- Test
EXEC UpdateReward
EXEC UpdateReward 'A00', 'bbb', 10
GO

-- =====================================================================================================================
-- 3.	Write a stored procedure called DeleteConsignmentDetail that will delete a single ConsignmentDetail record.
--      If no errors are raised, delete the record from the ConsignmentDetail table.
--      (4 Marks)
CREATE PROCEDURE DeleteConsignmentDetail (@ConsignmentID INT = NULL, 
										  @LineID INT = NULL)
AS
BEGIN
	/* Check parameters for stored procedure */
	IF @ConsignmentID IS NULL 
		BEGIN
			RaisError('You must privode the consignment ID value!', 16, 1)
		END
	ELSE IF  @LineID IS NULL 
		BEGIN
			RaisError('You must privode the line ID value!', 16, 2)
		END
	ELSE
		BEGIN
			/* Raise an error if this record does not exists */
			IF NOT EXISTS(SELECT * FROM ConsignmentDetail 
						  WHERE ConsignmentDetail.ConsignmentID = @ConsignmentID AND ConsignmentDetail.LineID = @LineID)
				BEGIN
					RaisError('This record identified by ConsignmentID: %s and LineID: %s does not exists!', 16, 3, @ConsignmentID, @LineID)
				END
			/* Otherwsie, delete this record*/
			ELSE
				BEGIN
					DELETE ConsignmentDetail
					WHERE ConsignmentDetail.ConsignmentID = @ConsignmentID AND ConsignmentDetail.LineID = @LineID
				END
		END
END
RETURN
GO
-- Test
EXEC DeleteConsignmentDetail 1, 1

-- =====================================================================================================================
-- 4.	Write a stored procedure called LookUpCustomerHistory that will return the Customer Full Name, Consignment
--      dates and Totals, and Descriptions of the Consignment Items for a single customer.
--      (2 Marks)
CREATE PROCEDURE LookUpCustomerHistory (@FirstName VARCHAR(30) = NULL,
										@LastName VARCHAR(30) = NULL)
AS
BEGIN
	/* Check parameters for stored procedure */
	IF @FirstName IS NULL OR @LastName IS NULL
		BEGIN
			RaisError('You must privode a customer name!', 16, 1)
		END
	ELSE
		BEGIN
			/* Raise an error if this record does not exists */
			IF NOT EXISTS (SELECT * FROM Customer 
						   WHERE Customer.FirstName = @FirstName AND Customer.LastName = @LastName)
				BEGIN
					RaisError('This customer: %s %s does not exists!', 16, 3,  @FirstName, @LastName)
				END
			/* Otherwise, select the consignment history items for this customer */
			ELSE
				BEGIN
					SELECT Customer.FirstName + ' ' + Customer.LastName AS 'Customer', 
						Consignment.Date, 
						Consignment.Total,
						ConsignmentDetail.ItemDescription
					FROM Customer
						INNER JOIN Consignment
						ON Customer.CustomerID = Consignment.CustomerID
						INNER JOIN ConsignmentDetail
						ON Consignment.ConsignmentID = ConsignmentDetail.ConsignmentID
					WHERE Customer.FirstName = @FirstName AND Customer.LastName = @LastName
				END
		END
END
RETURN
GO
-- Test
EXEC LookUpCustomerHistory
EXEC LookUpCustomerHistory 'aa', 'bb'
EXEC LookUpCustomerHistory 'Fred', 'Flinstone'
EXEC LookUpCustomerHistory 'Homer', 'Simpson'
EXEC LookUpCustomerHistory 'Luke', 'Skywalker'
EXEC LookUpCustomerHistory 'Sue', 'Sampson'
GO

-- =====================================================================================================================
-- 5.	Write a stored procedure called UnusedCategories that returns the CategoryCode and CategoryDescription of
--      all the Categories that have not been used on any consignments. Do not use a join.
--      (2 Marks)
BEGIN
	SELECT Category.CategoryCode, Category.CategoryDescription
	FROM Category
	WHERE Category.CategoryCode NOT IN (SELECT ConsignmentDetail.CategoryCode 
										FROM ConsignmentDetail)
END
RETURN
GO
-- Test
EXEC UnusedCategories
GO

-- =====================================================================================================================
-- 6.	Write a stored procedure called LookUpStaffType that accepts any part of a Staff Type Description to search
--      for. Return all the StaffType data for those StaffTypes that have that part in their Description.
--      (2 Marks)
CREATE PROCEDURE LookUpStaffType (@PartDescription VARCHAR(30) = NULL)
AS
BEGIN
	/* Check parameters for stored procedure */
	IF @PartDescription IS NULL
		BEGIN
			RaisERROR('You must privode a part of staff type description!', 16, 1)
		END
	ELSE
		BEGIN
			SELECT *
			FROM StaffType
			WHERE StaffType.StaffTypeDescription LIKE '%' + @PartDescription + '%'
		END
END
RETURN
GO
-- Test
EXEC LookUpStaffType 'Re'
GO

-- =====================================================================================================================
-- 7.	Write a stored procedure called AddConsignmentItem that will accept ConsignmentID, Description, StartPrice,
--      LowPrice and CategoryCode, to perform the following:
--      (8 marks)

--      A) Add a record to the ConsignmentDetail table. Assume that the Consignment record already exists in the 
--         Consignment table. The Line ID will start at 1 for each consignment and increment by 1 for each additional
--         item added on to that consignment.

--      B) Update the appropriate Consignment table data to reflect the added the ConsignmentDetail record. Remember the following:
--       - The cost to consign an item is determined by the Category the consigned item is in. 
--       - Subtotal is calculated and recorded after any Reward Program discounts have been subtracted
--       - GST is calculated after the Reward Program discounts are subtracted
--       - Total = SubTotal + GST
CREATE PROCEDURE AddConsignmentItem(@ConsignmentID INT = NULL,
								    @Description VARCHAR(40) = NULL,
									@StartPrice SMALLMONEY = NULL,
									@LowPrice SMALLMONEY = NULL,
									@CategoryCode CHAR(3) = NULL)
AS
BEGIN
	/* Check parameters for stored procedure */
	IF @ConsignmentID IS NULL
		BEGIN
			RaisError('You must privode a ConsignmentID value!', 16, 1)
		END
	ELSE IF @Description IS NULL
		BEGIN
			RaisError('You must privode a Description value!', 16, 2)
		END
	ELSE IF @StartPrice IS NULL
		BEGIN
			RaisError('You must privode a StartPrice value!', 16, 3)
		END
	ELSE IF @LowPrice IS NULL
		BEGIN
			RaisError('You must privode a LowPrice value!', 16, 4)
		END
	ELSE IF @CategoryCode IS NULL
		BEGIN
			RaisError('You must privode a CategoryCode value!', 16, 5)
		END
	ELSE
		BEGIN
			/* Check @ConsignmentID exists in table Consignment or not */
			IF NOT EXISTS (SELECT * FROM Consignment WHERE Consignment.ConsignmentID = @ConsignmentID)
				BEGIN
					RaisError('The ConsignmentID: %s does not exists in table Consignment!', 16, 6, @ConsignmentID)
					RETURN
				END
			/* Check @CategoryCode exists in table Category or not */
			IF NOT EXISTS (SELECT * FROM Category WHERE Category.CategoryCode = @CategoryCode)
				BEGIN
					RaisError('The CategoryCode: %s does not exists in table Category!', 16, 7, @CategoryCode)
					RETURN
				END
			/* Get the line ID for the new record */
			DECLARE @LineID AS INT
			IF NOT EXISTS (SELECT * FROM ConsignmentDetail WHERE ConsignmentDetail.ConsignmentID = @ConsignmentID)
				BEGIN
					SET @LineID = 1
				END
			ELSE
				BEGIN
					SELECT @LineID = MAX(ConsignmentDetail.LineID) + 1 FROM ConsignmentDetail WHERE ConsignmentDetail.ConsignmentID = @ConsignmentID
				END
			/* Use transcation to update tables ConsignmentDetail and Consignment integrity */
			BEGIN TRANSACTION
				/* At first, try to insert the new recor into table ConsignmentDetail*/
				INSERT INTO ConsignmentDetail
					(ConsignmentID, LineID, ItemDescription, StartPrice, LowestPrice, CategoryCode)
				VALUES
					(@ConsignmentID, @LineID, @Description, @StartPrice, @LowPrice, @CategoryCode)
				IF @@ERROR <> 0
					BEGIN
						RaisError('Insert this new record to table ConsignmentDetail failed!', 16, 8)
						ROLLBACK TRANSACTION
					END
				/* Then, update the relevant record table Consignment */
				ELSE
					BEGIN
						/* Get the discount percent for this customer */
						DECLARE @DiscountPercent AS TINYINT
						SELECT @DiscountPercent = Reward.DiscountPercentage 
						FROM Reward
							INNER JOIN Customer
							ON Reward.RewardID = Customer.RewardID
							INNER JOIN Consignment
							ON Customer.CustomerID = Consignment.CustomerID
						WHERE Consignment.ConsignmentID = @ConsignmentID
						IF @@ERROR <> 0
							BEGIN
								RaisError('Search reward discount percent for this customer failed!', 16, 9)
								ROLLBACK TRANSACTION
								RETURN
							END
						
						/* Get the new SubTotal and discount for this item */
						DECLARE @NewDisCount AS SMALLMONEY
						DECLARE @NewSubTotal AS SMALLMONEY						
						SELECT @NewSubTotal = SUM(Category.Cost) 
						FROM ConsignmentDetail
							INNER JOIN Category
							ON ConsignmentDetail.CategoryCode = Category.CategoryCode
						WHERE ConsignmentDetail.ConsignmentID = @ConsignmentID
						IF @@ERROR <> 0
							BEGIN
								RaisError('Search subtotals for this consignment failed!', 16, 10)
								ROLLBACK TRANSACTION
								RETURN
							END
						ELSE
							BEGIN
								SET @NewDisCount = @NewSubTotal * (@DiscountPercent / 100.0)
								SET @NewSubTotal = @NewSubTotal - @NewDisCount
							END

						/* Calculate new GST and total */
						DECLARE @NewGST AS SMALLMONEY
						DECLARE @NewTotal AS SMALLMONEY
						SET @NewGST = @NewSubTotal * 0.05
						SET @NewTotal = @NewSubTotal + @NewGST

						/* Update the relevant record */
						UPDATE Consignment
						SET Consignment.SubTotal = @NewSubTotal, 
							Consignment.GST = @NewGST, 
							Consignment.Total = @NewTotal, 
							Consignment.RewardsDiscount = @NewDisCount,
							Consignment.Date = GETDATE()
						WHERE Consignment.ConsignmentID = @ConsignmentID
						IF @@ERROR <> 0
							BEGIN
								RaisError('Update table Consignment failed!', 16, 11)
								ROLLBACK TRANSACTION
								RETURN
							END
						ELSE
							BEGIN
								COMMIT TRANSACTION
							END
					END
		END
END
RETURN
GO
-- Test
EXEC AddConsignmentItem 6, 'Test', 10, 5, 'AAA'
GO