	/*
	=============================================================
	Create Database and Schemas
	=============================================================
	Script Purpose:
		This script creates a new database named 'DataWarehouse' after checking if it already exists. 
		If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
		within the database: 'bronze', 'silver', and 'gold'.
	
	WARNING:
		Running this script will drop the entire 'DataWarehouse' database if it exists. 
		All data in the database will be permanently deleted. Proceed with caution 
		and ensure you have proper backups before running this script.
	*/



	-- Create Database 'DataWareHouse'

	USE master
	Go

	--Drop and recreate the 'DataWareHouse' database
	IF EXISTS (SELECT 1 FROM sys.database WHERE name = 'DataWareHouse')
	BEGIN
		ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		DROP DATABASE DataWareHouse;
	END;
	GO

	--Create the 'DataWareHouse' database
	CREATE DATABASE DataWarehouse;
	GO

	USE DataWarehouse
	GO

	CREATE SCHEMA bronze;
	GO
	CREATE SCHEMA silver;
	GO
	CREATE SCHEMA gold;
	GO
