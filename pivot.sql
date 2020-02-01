SELECT [Index], [Create], [Edit], [Delete]
FROM
(
   SELECT  * 
   FROM [table_Name] as m 
   WHERE m.ModuleId = '1' AND m.MenuFrameId = '1' AND m.Archive = 0
)P 
PIVOT 
( 
   MAX([Target_Field]) 
   FOR COLUMNSEQ IN([Index],[Create],[Edit],[Delete]) 
)PIV

-----2
DECLARE @cols AS NVARCHAR(MAX),
	@query  AS NVARCHAR(MAX)

SELECT @cols = STUFF((SELECT DISTINCT ',' + QUOTENAME(ColumnName) 
					FROM [table_Name]
			FOR XML PATH(''), TYPE
			).value('.', 'NVARCHAR(MAX)') ,1,1,'')
--PRINT @cols
set @query = N'SELECT ' + @cols + N' FROM 
			(
				SELECT * FROM  [table_Name] AS A
			) x
			pivot 
			(
				max(ColumnName)
				for ColumnName in (' + @cols + N')
			) p '

exec sp_executesql @query;
