/*CREATE DATABASE AND SCHEMAS
=======================================
Script Purpose:
 This script creates a new database DataWarehouse after checking if it already exists.
 if the database exists, it is dropped and recreated.Additionally, the script sets up three schemas
 wihtin the database: 'Bronze','Silver','Gold'.

 --WARNING__

 Running this script will delete the ENTIRE DATAWAREHOUSE after checking it already exists.
 ALL DATA WILL BE PERMANENTLY DELETED.
 ENSURE BACKUP BEFORE RUNNING THIS SCRIPT
*/

--CREATE DATABASE 'DATAWAREHOUSE'--
USE MASTER;
go

IF EXISTS (SELECT 1 FROM sys.databases WHERE name='DataWarehouse')
begin
  alter database Datawarehouse SET Single_user with rollback immediate;
  drop database DataWarehouse
end;
go

create database DataWarehouse;

use DataWarehouse;

--here go act as a separator while executing multiple commands
create Schema Bronze;
go
create Schema Silver
go
create Schema Gold;
go
