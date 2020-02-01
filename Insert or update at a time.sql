DECLARE @lastNumber AS BIGINT=0;
SELECT @lastNumber=MaxNumber FROM [tableName] WHERE FieldName='1'
IF @lastNumber > 0
BEGIN
   UPDATE [tableName] SET MaxNumber=@lastNumber + 1 WHERE FieldName='1'
END
ELSE
   INSERT INTO [tableName](FieldName, MaxNumber) VALUES('1', 1);
SELECT @lastNumber + 1 AS MaxNumber
