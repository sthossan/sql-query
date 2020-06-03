-- https://app.pluralsight.com/guides/querying-and-manipulating-json-data-with-t-sql
-- here 4 things
-- ISJSON, JSON_VALUE,J SON_QUERY, JSON_MODIFY

SELECT EmployeeID,
		FullName,
		Title,
		HireDate,
		JSON_QUERY(Notes, '$.education') AS Education,
		JSON_VALUE(Notes, '$.field') AS Field,
		JSON_VALUE(Notes, '$.bilingual') AS Bilingual,
		NewField=(SELECT TOP 10 			 
								c.CompanyName, 
								c.City, 
								c.Country,
								COUNT(o.OrderID) AS CountOrders
					FROM		Customers c 
					JOIN		Orders o 
					ON			c.CustomerID = o.CustomerID
					GROUP BY	c.CompanyName, c.City, c.Country
					ORDER BY	COUNT(o.OrderId) DESC
					FOR			JSON PATH, ROOT('Top10Customers'))
FROM	NewestHires

-- ISJSON(JSON_QUERY(Notes, '$.education'))
-- https://www.codeproject.com/Articles/1166099/Entity-Framework-Storing-complex-properties-as-JSO
