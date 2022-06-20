SELECT ABS(CHECKSUM(NEWID()) % 1000000) -- for each row (some value less than 6 digit)
SELECT CAST((RAND() * (899999) + 100000) AS INT) -- for each row (some value less than 6 digit)
SELECT FLOOR(RAND()*1000000-1) -- for each row (some value less than 6 digit)
SELECT 100000 + (CONVERT(INT, CRYPT_GEN_RANDOM(3)) % 100000);


DECLARE @Counter INT=1000000
	, @number1 INT
	, @number2 INT

WHILE @Counter>0
	BEGIN
    SET @number1= CAST((RAND() * (899999) + 100000) AS INT)
    SET @number2= 100000 + (CONVERT(INT, CRYPT_GEN_RANDOM(3)) % 100000)
	PRINT FLOOR(RAND()*1000000-1)
	SET @Counter = @Counter - 1
	END
