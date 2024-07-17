# Lab3: Stuff B Gone!

## Objectives:

1.Create, execute, and test stored procedures involving queries and DML statements

2.Demonstrate error checking and RaisError

3.SQL Transactions

## Requirements:

Create the following store procedures as described. 

- Do not add any functionality or validation not asked for. 

- Make your procedures as maintainable and efficient as possible (avoid selecting the same data more than once from the DB, clear logic, etc.). 

- Ensure that transactions are used where required. 

- Raise a user friendly error if

  - Required parameters were not passed to the procedure (3 marks)
  - A DML statement fails (3 marks) 
  - Records to be updated or deleted do not exist (3 marks)

An ERD has been provided for you as well as the relevant table create statements and some sample date in Lab3.sql. You may wish to add/remove/update the data in the tables to fully test your stored procedures.


1.Write a stored procedure called AddStaffType that will add a new StaffType to the StaffType table. Duplicate Descriptions are not allowed! If the Description being added is already in the StaffType table give an appropriate error message. Otherwise, add the new StaffType to the StaffType table and select the new StaffTypeID. (3 Marks)

2.Write a stored procedure called UpdateReward that accepts the RewardID, Description and DiscountPercentage. If no errors are raised update the record for that Reward.(2 Marks)



3.Write a stored procedure called DeleteConsignmentDetail that will delete a single ConsignmentDetail record. If no errors are raised, delete the record from the ConsignmentDetail table.(4 Marks)

4.Write a stored procedure called LookUpCustomerHistory that will return the Customer Full Name, Consignment dates and Totals, and Descriptions of the Consignment Items for a single customer. (2 Marks)

5.Write a stored procedure called UnusedCategories that returns the CategoryCode and CategoryDescription of all the Categories that have not been used on any consignments. Do not use a join. (2 Marks)

6.Write a stored procedure called LookUpStaffType that accepts any part of a Staff Type Description to search for. Return all the StaffType data for those StaffTypes that have that part in their Description.
(2 Marks)

7.Write a stored procedure called AddConsignmentItem that will accept ConsignmentID, Description, StartPrice, LowPrice and CategoryCode, to perform the following:
(8 marks)

- Add a record to the ConsignmentDetail table. Assume that the Consignment record already exists in the Consignment table. The Line ID will start at 1 for each consignment and increment by 1 for each additional item added on to that consignment.

- Update the appropriate Consignment table data to reflect the added the ConsignmentDetail record. Remember the following:

  - The cost to consign an item is determined by the Category the consigned item is in. 

  - Subtotal is calculated and recorded after any Reward Program discounts have been subtracted

  - GST is calculated after the Reward Program discounts are subtracted

  - Total = SubTotal + GST

## Lab Submission is to include the following:

- Create a single script file called Lab3Solution.sql that contains all the stored procedures and drop procedure statements at the top of your script. Use SQL comments to label and separate each stored procedure clearly. No testing data should be included or other statements. Your script will be submitted in a location specified by your instructor.

- If there are any known errors in your solution you must identify them in your discussion. Errors you have identified and simply could not find a solution for are more acceptable than undocumented errors. Failure to document known errors will result in mark ½ mark deduction for each undocumented error up to 2 marks.

- Any additional requirements as specified by your instructor.

- Do not make assumptions. If you have questions about the company, ask your instructor (client). This is not a group project. Working with another student on lab material may result in a grade of 0 for this lab. Up to 2 Marks may be deducted for incomplete lab submission requirements, undocumented errors, or poor client communication (check the provided documentation for the answer before asking the client). 

## ERD
<img src="img/ERD.png">