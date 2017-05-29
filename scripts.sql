-- Adopt-A-Pet DB Scripts
-- 6 stored procedures to populate transactional tables
-- 3 definition of a business rule
-- 1 user-defined functions to enforce the each of business rule defined above (3 total)

--*****************STORED PROCEDUES*****************



--***********BUSINESS RULES AND FUNCTIONS***********

-- 1. Adopt-A-Pet will only accept cats and dogs, no other animals

CREATE FUNCTION CheckPageNumbers (@pages int, @capacity int)
RETURNS int
AS
BEGIN
  DECLARE @retval int
    SET @retval = (SELECT CASE WHEN pages < @capacity THEN 0 ELSE 1 END)
    FROM BOOK
    WHERE pages = @pages
  RETURN @retval
END;
GO

ALTER TABLE Book
  ADD CONSTRAINT chkPageNumbers
  CHECK (dbo.CheckPageNumbers(pages, 300) = 0);

-- 2. Adopt-A-Pet will not accept any cats or dogs over 100 pounds

-- 3. ShipDate must come after OrderDate
