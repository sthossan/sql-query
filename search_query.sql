SET NOCOUNT ON;
DECLARE @FirstRow int = ((@PageNum - 1) * @pageSize) + 1
DECLARE @LastRow int = @FirstRow + @PageSize - 1
-- Insert statements for procedure here
    SELECT *
FROM
    (SELECT		
            case @keyword when '' then  ROW_NUMBER()OVER (Order BY (CONVERT(INT, i.Id))) 
            else ROW_NUMBER()OVER (Order BY i.ID ) 
            end as RowNumber
            ,COUNT(1) OVER() AS Total
            ,i.[Id]
            ,isnull(i.Code,'') as ItemCodeSeq
            ,i.[Name]
            ,i.[UnitPrice]
            ,i.[OpeningQty]
            ,itm.TypeName
            ,isnull(u.Name,'') UOM
            ,t.TariffName
            ,i.Active
            ,i.Accept
FROM [dbo].[Items] i 
    left outer join ItemTypes itm 
    on i.ItemTypeId=itm.Id
    left outer join UOMs u on i.UomId =isnull(u.Id,0)
    left outer join TariffTypes t on i.TariffTypeId=t.Id
    WHERE (Convert(varchar(20),i.Id) +  Convert(varchar(20),i.ItemCodeSeq) + 
    Convert(varchar(20),i.Name) + Convert(varchar(20),itm.TypeName) + 
    Convert(varchar(20),t.TariffName)) LIKE '%' + @keyword + '%'  ) AS a
WHERE RowNumber BETWEEN @FirstRow AND @LastRow
ORDER BY RowNumber
