DECLARE @stringSql VARCHAR(MAX)
	, @tableName VARCHAR(200)='" + referencedTable + @"'
	, @columnValue VARCHAR(150)='" + referencedColumnValue + @"';
SELECT @stringSql=STUFF((
SELECT ' SELECT '+ COL_NAME(fc.PARENT_OBJECT_ID, fc.PARENT_COLUMN_ID) + ' AS FKId FROM ['+ SCHEMA_NAME(f.schema_id)+'].['+OBJECT_NAME(f.PARENT_OBJECT_ID)+'] UNION ALL ' FROM sys.foreign_keys AS f
INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID=fc.CONSTRAINT_OBJECT_ID
WHERE f.REFERENCED_OBJECT_ID=OBJECT_ID(@tableName) FOR XML PATH('')), 1, 1,'');
SELECT @stringSql=LEFT(@stringSql, LEN(@stringSql)-9);
DECLARE @Qry varchar(max)='IF EXISTS(SELECT 1 FROM('+@stringSql+') AS TBA WHERE FKId='''+@columnValue+''') SELECT 1 ELSE SELECT 0 RETURN ';
EXEC (@Qry); 

---------------Another---------

DECLARE @stringSql VARCHAR(MAX)
    , @tableName VARCHAR(200)='tableName'
    , @columnValue VARCHAR(150)='columnValue';
SELECT @stringSql=STUFF((
	SELECT ' SELECT '+ COL_NAME(fc.PARENT_OBJECT_ID, fc.PARENT_COLUMN_ID) + ' AS FKId FROM ['+ SCHEMA_NAME(f.schema_id)+'].['+OBJECT_NAME(f.PARENT_OBJECT_ID)+'] UNION ALL ' FROM SYS.FOREIGN_KEYS AS f
	INNER JOIN sys.foreign_key_columns AS fc ON f.OBJECT_ID=FC.CONSTRAINT_OBJECT_ID
	WHERE f.REFERENCED_OBJECT_ID=OBJECT_ID(@tableName) AND f.PARENT_OBJECT_ID NOT IN(OBJECT_ID('fk_table')) FOR XML PATH('')), 1, 1,'');
	SELECT @stringSql=LEFT(@stringSql, LEN(@stringSql)-9);
DECLARE @Qry varchar(max)='IF EXISTS(SELECT 1 FROM(' + @stringSql + ') AS TBA WHERE FKId='''+@columnValue+''') SELECT 1 ELSE SELECT 0 RETURN ';
EXEC (@Qry);
