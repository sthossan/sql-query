	TryAgain:
	SET @userCode = CHAR((RAND()*25 + 65))+CHAR((RAND()*25 + 65))+CAST((CONVERT(NUMERIC(12,0),RAND() * 99999999) + 10000000) AS VARCHAR(8))
	IF LEN(@userCode)<>10
		GOTO TryAgain
	IF EXISTS(SELECT 1 FROM [dbo].[AppUsers] WHERE [UserCode]=@userCode)
		GOTO TryAgain