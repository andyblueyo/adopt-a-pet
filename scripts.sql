-- Adopt-A-Pet DB Scripts
-- 6 stored procedures to populate transactional tables
-- 3 definition of a business rule
-- 1 user-defined functions to enforce the each of business rule defined above (3 total)
-- 3 computed columns

USE AdoptAPetDBO
GO

--****************INSERT STATMENTS****************
-- Insert rows into lookup tables: Measurement, Supplier_Type, Employee_Type,
-- Employee_Position, Medication_Type, Breed, Animal_Type, ect.

-- Inserts into Measurement
INSERT INTO MEASUREMENT (MeasurementName, MeasurementDesc) VALUES ('Height', 'Height of the animal from front paw to top of the head')
INSERT INTO MEASUREMENT (MeasurementName, MeasurementDesc) VALUES ('Weight', 'Weight of the animal in lbs')
INSERT INTO MEASUREMENT (MeasurementName, MeasurementDesc) VALUES ('Length', 'Length of the animal from front nose to tip of tail')
GO

INSERT INTO SUPPLIER_TYPE (SupplierTypeName, SupplierTypeDesc) VALUES ('Cat Food', 'Food for kitties') 
INSERT INTO SUPPLIER_TYPE (SupplierTypeName, SupplierTypeDesc) VALUES ('Toiletries', 'For employee restrooms and sinks') 
INSERT INTO SUPPLIER_TYPE (SupplierTypeName, SupplierTypeDesc) VALUES ('Dog Food', 'Food for pups') 
INSERT INTO SUPPLIER_TYPE (SupplierTypeName, SupplierTypeDesc) VALUES ('Cleaning', 'Detergents, mops, other supplies for cleaning kennels') 
INSERT INTO SUPPLIER_TYPE (SupplierTypeName, SupplierTypeDesc) VALUES ('Office', 'Supplies for administrative staff') 
INSERT INTO SUPPLIER_TYPE (SupplierTypeName, SupplierTypeDesc) VALUES ('Pet Toys', 'Toys for pets')
GO

INSERT INTO EMPLOYEE_TYPE (EmployeeTypeName, EmployeeTypeDesc) VALUES ('Volunteer', 'Works a minimum of 3 hrs a week, max 10 hrs')
INSERT INTO EMPLOYEE_TYPE (EmployeeTypeName, EmployeeTypeDesc) VALUES ('Full Time', 'Works a minimum of 40 hrs a week, max 60 hrs')
INSERT INTO EMPLOYEE_TYPE (EmployeeTypeName, EmployeeTypeDesc) VALUES ('Part Time', 'Works a minimum of 25 hrs a week, max 38 hrs')
GO

INSERT INTO EMPLOYEE_POSITION (EmployeePositionName, EmployeePositionDesc) VALUES ('Vet', 'Performs medical examinations on pets')
INSERT INTO EMPLOYEE_POSITION (EmployeePositionName, EmployeePositionDesc) VALUES ('Front Desk', 'Interacts with customers')
INSERT INTO EMPLOYEE_POSITION (EmployeePositionName, EmployeePositionDesc) VALUES ('Janitor', 'Cleans kennels')
INSERT INTO EMPLOYEE_POSITION (EmployeePositionName, EmployeePositionDesc) VALUES ('Pet care', 'Plays with pets, feeds them')
INSERT INTO EMPLOYEE_POSITION (EmployeePositionName, EmployeePositionDesc) VALUES ('Shift manager', 'Manages all staff on duty at the time of their shift')
INSERT INTO EMPLOYEE_POSITION (EmployeePositionName, EmployeePositionDesc) VALUES ('Admin', 'Oversees all managers, schedules shifts and orders supplies')
INSERT INTO EMPLOYEE_POSITION (EmployeePositionName, EmployeePositionDesc) VALUES ('HR', 'Oversees human resource needs, distributes paychecks')
INSERT INTO EMPLOYEE_POSITION (EmployeePositionName, EmployeePositionDesc) VALUES ('Accountant', 'Manages taxes, wages, and budgets pet costs')
GO

INSERT INTO MEDICATION_TYPE(MedicationTypeName, MedicationTypeDesc) VALUES ('Aspirin', 'For pain management')
INSERT INTO MEDICATION_TYPE(MedicationTypeName, MedicationTypeDesc) VALUES ('Probiotics', 'For digestive issues')
INSERT INTO MEDICATION_TYPE(MedicationTypeName, MedicationTypeDesc) VALUES ('Antibiotics', 'For bacterial infections')
INSERT INTO MEDICATION_TYPE(MedicationTypeName, MedicationTypeDesc) VALUES ('Lice shampoo', 'To treat lice')
INSERT INTO MEDICATION_TYPE(MedicationTypeName, MedicationTypeDesc) VALUES ('Steroids', 'To treat skin conditions')
GO

INSERT INTO BREED (BreedName, BreedDesc, Pedigree) VALUES ('', '', '')
INSERT INTO BREED (BreedName, BreedDesc, Pedigree) VALUES ('', '', '')
INSERT INTO BREED (BreedName, BreedDesc, Pedigree) VALUES ('', '', '')
INSERT INTO BREED (BreedName, BreedDesc, Pedigree) VALUES ('', '', '')
INSERT INTO BREED (BreedName, BreedDesc, Pedigree) VALUES ('', '', '')
GO

INSERT INTO ANIMAL_TYPE (AnimalTypeName, AnimalTypeDesc)VALUES ('','')
INSERT INTO ANIMAL_TYPE (AnimalTypeName, AnimalTypeDesc)VALUES ('','')
GO



--*****************STORED PROCEDURES*****************
-- Create stored procecures for associative entities : Animal_Medication, Animal_Measurement, Store_Supplier
-- Also create procudures for Order, Animal, and Employee




--***********BUSINESS RULES AND FUNCTIONS***********

-- 1. Adopt-A-Pet will only accept cats and dogs, no other animals

CREATE FUNCTION OnlyCatsAndDogs()
RETURNS INT
AS
BEGIN
   DECLARE @RET INT = 0
   IF EXISTS (SELECT AnimalTypeName FROM Animal_TYPE
               WHERE AnimalTypeName = 'Dog'
               OR AnimalTypeName = 'Cat')
   SET @RET = 1
   RETURN @RET
END;
GO

ALTER TABLE ANIMAL_TYPE
  ADD CONSTRAINT chkAnimalType
  CHECK (dbo.OnlyCatsAndDogs() = 0)
GO

-- 2. Adopt-A-Pet will not accept any cats or dogs over 100 pounds


CREATE FUNCTION NoLargeAnimals()
RETURNS INT
AS
BEGIN
   DECLARE @RET INT = 0
   IF EXISTS (SELECT AM.MeasurementValue FROM ANIMAL_MEASUREMENT AM
				JOIN MEASUREMENT M
				ON AM.MeasurementID = M.MeasurementID
				WHERE M.MeasurementDesc = 'Weight'
				AND AM.MeasurementValue < 100)
   SET @RET = 1
   RETURN @RET
END
GO

ALTER TABLE ANIMAL_MEASUREMENT
  ADD CONSTRAINT chkAnimalWeight
  CHECK (dbo.NoLargeAnimals() = 0)
  GO

-- 3. ShipDate must come after OrderDate

CREATE FUNCTION OrderBeforeShip()
RETURNS INT
AS
BEGIN
   DECLARE @RET INT = 0
   IF EXISTS (SELECT OrderDate, ShipDate FROM [ORDER]
               WHERE OrderDate < ShipDate)
   SET @RET = 1
   RETURN @RET
END
GO

ALTER TABLE [ORDER]
  ADD CONSTRAINT chkDates
  CHECK (dbo.OrderBeforeShip() = 0);
GO

--*****************COMPUTED COLUMNS*****************

-- 1. Difference in time between OrderDate and ShipDate
CREATE FUNCTION fnShipOrderDiff(@OrderDate DATE, @ShipDate DATE)
RETURNS INT
AS
BEGIN
   DECLARE @RET INT
   SET @RET = DateDiff(day,
               (SELECT ShipDate FROM [ORDER] WHERE ShipDate = @ShipDate),
               (SELECT OrderDate FROM [ORDER] WHERE OrderDate = @OrderDate))
   RETURN @RET
END
GO

ALTER TABLE [ORDER]
ADD timeDiff AS fnShipOrderDiff(OrderDate, ShipDate)

-- 2.
