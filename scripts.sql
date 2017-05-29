-- Adopt-A-Pet DB Scripts
-- 6 stored procedures to populate transactional tables
-- 3 definition of a business rule
-- 1 user-defined functions to enforce the each of business rule defined above (3 total)
-- 3 computed columns

--****************INSERT STATMENTS****************
-- Insert 8 to 10 rows into lookup tables: Measurement, Supplier_Type, Employee_Type, 
-- Employee_Position, Medication_Type, Breed, Animal_Type, ect.



--*****************STORED PROCEDURES*****************
-- Create stored procecures for associative entities : Animal_Medication, Animal_Measurement, Store_Supplier
-- Also create procudures for Order, Animal, and Employee




--***********BUSINESS RULES AND FUNCTIONS***********

-- 1. Adopt-A-Pet will only accept cats and dogs, no other animals

CREATE FUNCTION OnlyCatsAndDogs (@AnimalTypeName VARCHAR(50))
RETURNS INT
AS
BEGIN
  DECLARE @RET INT
    SET @RET = (SELECT CASE WHEN @AnimalTypeName = 'Dog'
                  OR @AnimalTypeName = 'Cat'
                  THEN 0 ELSE 1 END)
    FROM ANIMAL_TYPE
    WHERE AnimalTypeName = @AnimalTypeName
  RETURN @RET
END;
GO

ALTER TABLE ANIMAL_TYPE
  ADD CONSTRAINT chkAnimalType
  CHECK (dbo.OnlyCatsAndDogs(AnimalTypeName) = 0);

-- 2. Adopt-A-Pet will not accept any cats or dogs over 100 pounds

CREATE FUNCTION NoLargeAnimals (@Weight VARCHAR(50))
RETURNS INT
AS
BEGIN
  DECLARE @RET INT
    SET @RET = (SELECT CASE WHEN @Weight < 100
                  THEN 0 ELSE 1 END)
    FROM MEASUREMENTS
    WHERE Weight = @Weight
  RETURN @RET
END;
GO

ALTER TABLE ANIMAL_TYPE
  ADD CONSTRAINT chkAnimalWeight
  CHECK (dbo.NoLargeAnimals(Weight) = 0);

-- 3. ShipDate must come after OrderDate

CREATE FUNCTION OrderBeforeShip (@OrderDate DATE, @ShipDate DATE))
RETURNS INT
AS
BEGIN
  DECLARE @RET INT
    SET @RET = (SELECT CASE WHEN @OrderDate < @ShipDate
                  THEN 0 ELSE 1 END)
    FROM ORDER
    WHERE OrderDate = @OrderDate
    AND ShipDate = @ShipDate
  RETURN @RET
END;
GO

ALTER TABLE ORDER
  ADD CONSTRAINT chkDates
  CHECK (dbo.OrderBeforeShip(OrderDate, ShipDate) = 0);

--*****************COMPUTED COLUMNS*****************
