-- SQL Server Row Count for all Tables in a Database

--Approach 1: sys.partitions Catalog View
-- sys.partitions is an Object Catalog View and contains one row for each partition of each of the tables and most types of indexes (Except Fulltext, Spatial, and XML indexes). Every table in SQL Server contains at least one partition (default partition) even if the table is not explicitly partitioned.
-- The T-SQL query below uses the sys.partitions catalog view to capture the row counts for all tables in a database.

SELECT
      QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [TableName]
      , SUM(sPTN.Rows) AS [RowCount]
FROM 
      sys.objects AS sOBJ
      INNER JOIN sys.partitions AS sPTN
            ON sOBJ.object_id = sPTN.object_id
WHERE
      sOBJ.type = 'U'
      AND sOBJ.is_ms_shipped = 0x0
      AND index_id < 2 -- 0:Heap, 1:Clustered
GROUP BY 
      sOBJ.schema_id
      , sOBJ.name
ORDER BY [TableName]
GO

-- Approach 2: sys.dm_db_partition_stats Dynamic Management View (DMV)

-- sys.dm_db_partition_stats is a Dynamic Management View (DMV) which contains one row per partition and displays the information about the space used to store and manage different data allocation unit types - IN_ROW_DATA, LOB_DATA and ROW_OVERFLOW_DATA.
-- The T-SQL query below uses the sys.dm_db_partition_stats DMV to capture the row counts for all tables in a database.
SELECT
      QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [TableName]
      , SUM(sdmvPTNS.row_count) AS [RowCount]
FROM
      sys.objects AS sOBJ
      INNER JOIN sys.dm_db_partition_stats AS sdmvPTNS
            ON sOBJ.object_id = sdmvPTNS.object_id
WHERE 
      sOBJ.type = 'U'
      AND sOBJ.is_ms_shipped = 0x0
      AND sdmvPTNS.index_id < 2
GROUP BY
      sOBJ.schema_id
      , sOBJ.name
ORDER BY [TableName]
GO


-- Approach 3: sp_MSforeachtable System Stored Procedure
-- sp_MSforeachtable is an undocumented system stored procedure which can be used to iterate through each of the tables in a database. In this approach we will get the row counts from each of the tables in a given database in an iterative fashion and display the record counts for all the tables at once.
-- The T-SQL query below uses the sp_MSforeachtable system stored procedure to iterate through each of the tables to capture the row count for all the tables in a database.

DECLARE @TableRowCounts TABLE ([TableName] VARCHAR(128), [RowCount] INT) ;
INSERT INTO @TableRowCounts ([TableName], [RowCount])
EXEC sp_MSforeachtable 'SELECT ''?'' [TableName], COUNT(*) [RowCount] FROM ?' ;
SELECT [TableName], [RowCount]
FROM @TableRowCounts
ORDER BY [TableName]
GO

-- Approach 4: COALESCE() Function
-- The COALESCE() function is used to return the first non-NULL value/expression among its arguments. In this approach we will build a query to get the row count from each of the individual tables with UNION ALL to combine the results and run the entire query.
-- The T-SQL query below uses the COALESCE() function to iterate through each of the tables to dynamically build a query to capture the row count from each of the tables (individual COUNT queries combined using UNION ALL) and provides the row counts for all the tables in a database.

DECLARE @QueryString NVARCHAR(MAX) ;
SELECT @QueryString = COALESCE(@QueryString + ' UNION ALL ','')
                      + 'SELECT '
                      + '''' + QUOTENAME(SCHEMA_NAME(sOBJ.schema_id))
                      + '.' + QUOTENAME(sOBJ.name) + '''' + ' AS [TableName]
                      , COUNT(*) AS [RowCount] FROM '
                      + QUOTENAME(SCHEMA_NAME(sOBJ.schema_id))
                      + '.' + QUOTENAME(sOBJ.name) + ' WITH (NOLOCK) '
FROM sys.objects AS sOBJ
WHERE
      sOBJ.type = 'U'
      AND sOBJ.is_ms_shipped = 0x0
ORDER BY SCHEMA_NAME(sOBJ.schema_id), sOBJ.name ;
EXEC sp_executesql @QueryString
GO


















