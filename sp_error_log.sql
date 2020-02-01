CREATE PROCEDURE [dbo].[SqlErrorLog]
	@Text AS VARCHAR(5000)
AS
DECLARE @isFileExists INT
	, @Cmd AS VARCHAR(100)
EXEC master..xp_fileexist 'D:\SqlLog.txt', @isFileExists OUTPUT 
IF(@isFileExists=0)
BEGIN 
	SET @Cmd ='echo Date: '+ CONVERT(VARCHAR(24),GETDATE(),113)+ ' Error : ' + @Text + ' > D:\SqlLog.txt'
	EXEC master..xp_cmdshell @Cmd
END
ELSE 
BEGIN 
	SET @Cmd ='echo Date : '+ CONVERT(VARCHAR(24),GETDATE(),113)+ ' Error : ' + @Text + ' >> D:\SqlLog.txt'
	EXEC master..xp_cmdshell @Cmd
	SELECT @Cmd
END 
