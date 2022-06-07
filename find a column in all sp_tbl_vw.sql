
-- Find all tables containing column with specified name

-- Search Tables:

SELECT      c.name  AS 'ColumnName' ,t.name AS 'TableName'
FROM        sys.columns c
JOIN        sys.tables  t   ON c.object_id = t.object_id
WHERE       c.name LIKE '%MyName%'
ORDER BY    TableName, ColumnName;

-- Search Tables and Views:

SELECT      COLUMN_NAME AS 'ColumnName',TABLE_NAME AS  'TableName'
FROM        INFORMATION_SCHEMA.COLUMNS
WHERE       COLUMN_NAME LIKE '%MyName%'
ORDER BY    TableName, ColumnName;


-- Search SP
SELECT OBJECT_NAME(OBJECT_ID),
DEFINITION
FROM sys.sql_modules
WHERE DEFINITION LIKE '%mycolumnname%'
GO