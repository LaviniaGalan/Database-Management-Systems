# Database-Management-Systems
My projects for the DBMS course at university

#### Lab 1
Create a C# Windows Forms application that uses ADO.NET to interact with a database. 

The application contains a form allowing the user to manipulate data in 2 tables that are in a 1:n relationship (parent table and child table). 

The application provides the following functionalities:
- display all the records in the parent table;
- display the child records for a specific (i.e., selected) parent record;
- add / remove / update child records for a specific parent record.


The DataSet and SqlDataAdapter classes were used.

----

#### Lab 2
Transform the first lab to dynamically create the master-detail windows form. The form caption and stored procedures / queries used to access and manipulate data are set in a configuration file.

The form is generic enough such that switching between scenarios (i.e., updating the application to handle data from another 1:n relationship) can be achieved by simply updating the configuration file.

----

#### Lab 3
1. Create a stored procedure that inserts data in tables that are in a m:n relationship; if one insert fails, all the operations performed by the procedure must be rolled back.

2. Create a stored procedure that inserts data in tables that are in a m:n relationship; if an insert fails, try to recover as much as possible from the entire operation: for example, if the user wants to add a book and its authors, succeeds creating the authors, but fails with the book, the authors should remain in the database.

3. Reproduce the following concurrency issues under pessimistic isolation levels: dirty reads, non-repeatable reads, phantom reads, and a deadlock (4 different scenarios); you can use stored procedures and / or stand-alone queries; find solutions to solve / workaround the concurrency issues.

4. Reproduce the update conflict under an optimistic isolation level.
