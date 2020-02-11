-- Method 1
DECLARE @time INT=392171

DECLARE @hour  INT
	, @min  INT
	, @secs INT
	, @retVal VARCHAR(20)
 
SET @hour = @time/3600
SET @min  =  (@time % 3600 )/60
SET @secs = @time %3600%60

--SET @retval = REVERSE(CAST(@hour*10000 + @min * 100 + @secs AS VARCHAR(40)))
--SET @retval =  REVERSE(ISNULL(LEFT(@retval, 2), 0) +':'+ SUBSTRING(@retval, 3 , 2) +':' + ISNULL(SUBSTRING(@retval,5,40), 0))

SET @retval = CAST(ISNULL(@hour, 0) AS VARCHAR(10))+':'
			 +CAST(ISNULL(@min, 0) AS VARCHAR(10))+':'
			 +CAST(ISNULL(@secs, 0) AS VARCHAR(10))

SELECT @retval

-- Method 2

	DECLARE @returnval VARCHAR(20)
	SET @returnval=(SELECT STUFF(CONVERT(CHAR(8), DATEADD(SECOND, @TimeCountSecond % 86400, '00:00:00'), 108), 1, 2, CAST(@TimeCountSecond / 3600 AS VARCHAR(12)))) 
	
