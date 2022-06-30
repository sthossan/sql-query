SELECT ABS(CHECKSUM(NEWID()) % 1000000) -- for each row (some value less than 6 digit)
SELECT CAST((RAND() * (899999) + 100000) AS INT) -- for each row (some value less than 6 digit)
SELECT FLOOR(RAND()*1000000-1) -- for each row (some value less than 6 digit)
SELECT 100000 + (CONVERT(INT, CRYPT_GEN_RANDOM(3)) % 100000);


DECLARE @code VARCHAR(10)
		, @count INT=1000000
WHILE @count>0
	BEGIN
		TryAgain:
		---- Method: 1
        SELECT @code=(100000 + (CONVERT(INT, CRYPT_GEN_RANDOM(3)) % 100000))
        ---- Method :2
        -- SELECT @code=SUBSTRING(CONVERT(varchar(255), NEWID()), 0, 7)

		IF LEN(@code)<>6
			BEGIN
				GOTO TryAgain:;
			END
		IF EXISTS(SELECT TOP(1) [CouponCode] FROM [dbo].[ShadhinCoupon] WITH (NOLOCK) WHERE [CouponCode]=@code)
			BEGIN
				GOTO TryAgain:;
			END

		INSERT INTO [dbo].[ShadhinCoupon] ([Vendor], [CouponCode], [ServiceId]) VALUES('bkash', @code, 3)
		SET @count = @count-1
	END

/*  Random 8 digit 
    Random two letter
    Random one letter
*/
/*
    SELECT SUBSTRING(CONVERT(varchar(40), NEWID()),0,9)
    SELECT CHAR((RAND()*25 + 65))+CHAR((RAND()*25 + 65))
    SELECT SUBSTRING('ABCDEFGHIJKLMNOPQRSTUVWXYZ', (ABS(CHECKSUM(NEWID())) % 26)+1, 1)
    SELECT CONVERT(NUMERIC(12,0),RAND() * 99999999) + 10000000
*/