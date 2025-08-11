/*
===========================================================
Create Database and Schemas
===========================================================

This scripts creates new database 'datawarehouse' after checking if it already exists or not.
If exists then it drop and recreate new database. 
The script create three schemas : 'bronze', 'silver','gold'

WARNING:
	Running this script will drop entire database if it exists.
	All datasets, views and other components will be permanently deleted.
	Process with caution and ensure proper backups before running.
*/
USE master;
GO

-- Drop and recreate the 'datawarehouse' database

IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'DataWarehouse')
BEGIN 
	ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
	DROP DATABASE DataWarehouse;
END;
GO


-- Create Database 'DataWarehouse'
CREATE DATABASE DataWarehouse;
GO

USE DataWarehouse;
GO

-- Create schemas
CREATE SCHEMA bronze;
GO
CREATE SCHEMA silver;
GO
CREATE SCHEMA gold;
GO
