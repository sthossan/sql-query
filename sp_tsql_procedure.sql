IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = 
	OBJECT_ID(N'[dbo].[sp_tsql_procedure]') AND type in (N'P', N'PC'))

BEGIN

	EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[sp_tsql_procedure]
						@param1 NVARCHAR(MAX)
						, @param2 NVARCHAR(MAX)
						AS
						--if need tem tbl then un-comments
						--IF OBJECT_ID(''tempdb..#tempTable'') IS NOT NULL
						--BEGIN DROP TABLE #tempTable END
						
						BEGIN		
							-- do somethings
						END

						--DROP TABLE #tempTable;'

END
