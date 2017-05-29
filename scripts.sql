-- Adopt-A-Pet DB Scripts
-- 6 stored procedures to populate transactional tables
-- 3 definition of a business rule
-- 1 user-defined functions to enforce the each of business rule defined above (3 total)
-- 3 computed columns

USE AdoptAPet
GO

--****************INSERT STATMENTS****************
-- Insert rows into lookup tables: Measurement, Supplier_Type, Employee_Type, 
-- Employee_Position, Medication_Type, Breed, Animal_Type, ect.

-- Inserts into Measurement
INSERT INTO MEASUREMENT (MeasurementName, MeasurementDesc) VALUES ('Height', 'Height of the animal from front paw to top of the head')
INSERT INTO MEASUREMENT (MeasurementName, MeasurementDesc) VALUES ('Weight', 'Weight of the animal in lbs')
INSERT INTO MEASUREMENT (MeasurementName, MeasurementDesc) VALUES ('Length', 'Length of the animal from front nose to tip of tail')
GO

--Inserts into Supplier_Type
INSERT INTO SUPPLIER_TYPE (


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
  CHECK (dbo.OnlyCatsAndDogs() = 0);

-- 2. Adopt-A-Pet will not accept any cats or dogs over 100 pounds

CREATE FUNCTION NoLargeAnimals()
RETURNS INT
AS
BEGIN
   DECLARE @RET INT = 0
   IF EXISTS = (SELECT Weight FROM MEASUREMENTS
               WHERE Weight < 100)
   SET @RET = 1
   RETURN @RET
END;
GO

ALTER TABLE MEASUREMENTS
  ADD CONSTRAINT chkAnimalWeight
  CHECK (dbo.NoLargeAnimals() = 0);

-- 3. ShipDate must come after OrderDate

CREATE FUNCTION OrderBeforeShip()
RETURNS INT
AS
BEGIN
   DECLARE @RET INT = 0
   IF EXISTS = (SELECT OrderDate, ShipDate FROM ORDER
               WHERE @OrderDate < @ShipDate)
   SET @RET = 1
   RETURN @RET
END;
GO

ALTER TABLE ORDER
  ADD CONSTRAINT chkDates
  CHECK (dbo.OrderBeforeShip() = 0);

--*****************COMPUTED COLUMNS*****************
