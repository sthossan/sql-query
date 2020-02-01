SELECT STUFF((SELECT ',' + ColumnName FROM [SCS].[PrdOrdSetting] WHERE PlantId=@plantId ORDER BY ColumnSequence FOR XML PATH('')),1,1,'')
SELECT STUFF((SELECT ''',''' + ProcessId FROM [MST].[OperationProcess] WHERE OperationId='8' FOR XML PATH('')),1,2,'')
