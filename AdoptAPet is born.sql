
--CREATE DATABASE AdoptAPet
--GO

DROP DATABASE AdoptAPet
GO

USE AdoptAPet
GO 


CREATE TABLE BREED (
	BreedID int IDENTITY(1,1) primary key not null , 
	BreedName varchar(50) null, 
	BreedDesc varchar(100) null,
	Pedigree varchar(100) null
)
GO

CREATE TABLE ANIMAL_TYPE (
	AnimalTypeID int IDENTITY(1,1) primary key not null, 
	AnimalTypeName varchar(50) not null,
	AnimalTypeDesc varchar(100) null
)
GO

CREATE TABLE ANIMAL (
	AnimalID int IDENTITY(1,1) primary key not null, 
	AnimalTypeID int not null,
	StoreID int not null,
	OrderID int not null,
	BreedID int not null,
	AnimalName varchar(50) not null,
	AnimalDesc varchar(200) null,
	EyeColor varchar(50) null,
	FurColor varchar(50) null,
	AnimalDOB date null
)
GO

CREATE TABLE MEDICATION_TYPE (
	MedicationTypeID int IDENTITY(1,1) primary key not null,
	MedicationTypeDesc varchar(100) null,
	MedicationTypeName varchar(100) null
)
GO

CREATE TABLE MEDICATION (
	MedicationID int IDENTITY(1,1) primary key not null,
	MedicationTypeID int not null,
	MedicationName varchar(100) null,
	MedicationDesc varchar(100) null,
	
)
GO

CREATE TABLE ANIMAL_MEDICATION (
	AnimalMedicationID int IDENTITY(1,1) primary key not null,
	MedicationID int not null,
	AnimalID int not null,
	PrescribingVetName varchar(50) null,
	Dosage int null,
	DatePrescribed date null,
)
GO

CREATE TABLE [ORDER] (
	OrderID int IDENTITY(1,1) primary key not null,
	CustomerID int not null,
	OrderDesc varchar(100) null,
	OrderName varchar(50) not null,
	ShipDate date null,
	OrderDate date null
)
GO

CREATE TABLE CUSTOMER (
	CustomerID int IDENTITY(1,1) primary key not null,
	CustomerDesc varchar(100) null,
	FName varchar(50) null,
	LName varchar(50) null,
	PhoneNumber int null,
	StreetAddress varchar(100) null,
	State varchar(50) null,
	ZIP int null
)
GO

CREATE TABLE EMPLOYEE (
	EmployeeID int IDENTITY(1,1) primary key not null,
	EmployeeTypeID int not null,
	EmployeePositionID int not null,
	StoreID int not null,
	EmployeeDesc varchar(100) null,
	FName varchar(50) null,
	LName varchar(50) null,
	StartDate date null ,
	EndDate date null,
	EmployeeDOB date null
)
GO


CREATE TABLE STORE (
	StoreID int IDENTITY(1,1) primary key not null,
	StoreName varchar(50) null,
	StoreDesc varchar(50) null,
	StreetAddress varchar(100) null,
	[State] varchar(50) null,
	ZIP int null,
	PhoneNumber int null
)
GO

CREATE TABLE STORE_SUPPLIER (
	StoreSupplierID int IDENTITY(1,1) primary key not null,
	SupplierID int not null,
	StoreID int not null
)
GO

CREATE TABLE EMPLOYEE_POSITION (
	EmployeePositionID int IDENTITY(1,1) primary key not null,
	EmployeePositionDesc varchar(100) null,
	EmployeePositionName varchar(50) null
)
GO

CREATE TABLE EMPLOYEE_TYPE (
	EmployeeTypeID int IDENTITY(1,1) primary key not null,
	EmployeeTypeDesc varchar(50) null,
	EmployeeTypeName varchar(50) null
)
GO

CREATE TABLE SUPPLIER (
	SupplierID int IDENTITY(1,1) primary key not null,	
	SupplierTypeID int not null,
	SupplierName varchar(50) null,
	SupplierDesc varchar(100) null
	
)
GO

CREATE TABLE SUPPLIER_TYPE (
	SupplierTypeID int IDENTITY(1,1) primary key not null,
	SupplierTypeDesc varchar(100) null,
	SupplierTypeName varchar(50) null
)
GO


CREATE TABLE MEASUREMENT (
	MeasurementID int IDENTITY(1,1) primary key not null,
	/*AnimalID int not null,
	Height int null,
	[Weight] int null, */
	MeasurementName varchar(50) not null,
	MeasurementDesc varchar(100) null,
	/*[Date] date null,*/
)
GO

CREATE TABLE ANIMAL_MEASUREMENT (
	AnimalMeasurementID int IDENTITY(1,1) primary key not null,
	AnimalID int not null,
	MeasurementID int not null,
	[Date] date null,
	MeasurementValue int null,
)
GO

/*
ALTER TABLE MEASUREMENTS 
ADD CONSTRAINT FK_MEASUREMENTS_AnimalID
FOREIGN KEY (AnimalID)
REFERENCES ANIMAL (AnimalID)
GO
*/

ALTER TABLE ANIMAL_MEASUREMENT
ADD CONSTRAINT FK_ANIMALS_AnimalID
FOREIGN KEY (AnimalID)
REFERENCES ANIMAL (AnimalID)
GO

ALTER TABLE ANIMAL_MEASUREMENT
ADD CONSTRAINT FK_MEASUREMENT_MeasurementID
FOREIGN KEY (MeasurementID)
REFERENCES MEASUREMENT (MeasurementID)
GO


ALTER TABLE ANIMAL 
ADD CONSTRAINT FK_ANIMALS_AnimalTypeID
FOREIGN KEY (AnimalTypeID)
REFERENCES ANIMAL_TYPE (AnimalTypeID)
GO

ALTER TABLE ANIMAL
ADD CONSTRAINT FK_ANIMALS_StoreID
FOREIGN KEY (StoreID)
REFERENCES STORE (StoreID)
GO

ALTER TABLE ANIMAL
ADD CONSTRAINT FK_ANIMAL_BreedID
FOREIGN KEY (BreedID)
REFERENCES BREED (BreedID)
GO

ALTER TABLE ANIMAL
ADD CONSTRAINT FK_ANIMALS_OrderID
FOREIGN KEY (OrderID)
REFERENCES [ORDER] (OrderID)
go


ALTER TABLE MEDICATION
ADD CONSTRAINT FK_MEDICATION_MedicationTypeID
FOREIGN KEY	(MedicationTypeID)
REFERENCES MEDICATION_TYPE (MedicationTypeID)
GO

ALTER TABLE ANIMAL_MEDICATION
ADD CONSTRAINT FK_ANIMAL_MEDICATION_MedicationID
FOREIGN KEY (MedicationID)
REFERENCES MEDICATION (MedicationID)
GO

ALTER TABLE ANIMAL_MEDICATION
ADD CONSTRAINT FK_ANIMAL_MEDICATION_AnimalID
FOREIGN KEY (AnimalID)
REFERENCES ANIMAL (AnimalID)
GO

ALTER TABLE [ORDER]
ADD CONSTRAINT FK_ORDER_CustomerID
FOREIGN KEY (CustomerID)
REFERENCES CUSTOMER (CustomerID)
GO

ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_EMPLOYEE_EmployeeTypeID
FOREIGN KEY (EmployeeTypeID)
REFERENCES EMPLOYEE_TYPE (EmployeeTypeID)
GO

ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_EMPLOYEE_EmployeePositionID
FOREIGN KEY (EmployeePositionID)
REFERENCES EMPLOYEE_POSITION (EmployeePositionID)
GO

ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_EMPLOYEE_StoreID
FOREIGN KEY (StoreID)
REFERENCES STORE (StoreID)
GO

ALTER TABLE STORE_SUPPLIER
ADD CONSTRAINT FK_STORE_SUPPLIER_SupplierID
FOREIGN KEY (SupplierID)
REFERENCES SUPPLIER (SupplierID)
GO

ALTER TABLE STORE_SUPPLIER
ADD CONSTRAINT FK_STORE_SUPPLIER_StoreID
FOREIGN KEY (StoreID)
REFERENCES STORE (StoreID)
GO

ALTER TABLE SUPPLIER
ADD CONSTRAINT FK_SUPPLIER_SupplierTypeID
FOREIGN KEY (SupplierTypeID)
REFERENCES SUPPLIER_TYPE (SupplierTypeID)
GO

