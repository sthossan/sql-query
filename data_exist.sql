IF EXISTS(SELECT 1 FROM(
          SELECT A.CheckingColumn1, B.CheckingColumn2 FROM [table_Name]
) AA WHERE CheckingColumn1 ='Value1' AND CheckingColumn2 IN ('Value2')) SELECT 1 ELSE SELECT 0 RETURN
