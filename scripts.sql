-- Adopt-A-Pet DB Scripts
-- 6 stored procedures to populate transactional tables
-- 3 definition of a business rule
-- 1 user-defined functions to enforce the each of business rule defined above (3 total)
-- 3 computed columns

--*****************STORED PROCEDUES*****************



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
    FROM ANIMAL A
    JOIN ANIMAL_TYPE AT
    ON A.AnimalTypeID = AT.AnimalTypeID
    WHERE AnimalTypeName = @AnimalTypeName
  RETURN @RET
END;
GO

ALTER TABLE ANIMAL_TYPE
  ADD CONSTRAINT chkAnimalType
  CHECK (dbo.OnlyCatsAndDogs(AnimalTypeName) = 0);

-- 2. Adopt-A-Pet will not accept any cats or dogs over 100 pounds

-- 3. ShipDate must come after OrderDate


--*****************COMPUTED COLUMNS*****************
