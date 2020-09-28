	DECLARE @pass CHAR(6)
			, @string VARCHAR(200)

	SET @string = 'abcdefghijklmnopqrstuvwxyz' + --lower letters
				  'ABCDEFGHIJKLMNOPQRSTUVWXYZ' + --upper letters
				  '0123456789'+ --number characters
				  '!@#&?'; --number characters
	TryAgain:
	SELECT @pass = (SELECT TOP 6 SUBSTRING(@String, 1 + Number, 1) AS [text()]
					FROM [master]..spt_values WHERE number < DATALENGTH(@string) AND TYPE = 'P'
					ORDER BY NEWID() FOR XML PATH(''))

	IF @pass NOT LIKE '%[0-9]%' AND @pass NOT LIKE '%[A-Z]%' AND @pass NOT LIKE '%[a-z]%' AND @pass NOT LIKE '%[!@#$&?%]%'
	   GOTO TryAgain
	SELECT @pass
