ALTER PROCEDURE [dbo].[CashinDashboardReport] 
AS
SELECT 
     CONVERT(VARCHAR(11), COALESCE(t1.DATE, t2.DATE, t3.DATE, t4.DATE), 6) AS DATE,
    COALESCE(t1.Totalcashin, 0) AS WaveCashin,
    COALESCE(t1.Totalcashout, 0) AS WaveCashout,
    COALESCE(t2.Totalcashin, 0) AS KbzCashin,
    COALESCE(t2.Totalcashout, 0) AS KbzCashout,
    COALESCE(t3.Totalcashin, 0) AS KbzBankCashin,
    COALESCE(t3.Totalcashout, 0) AS KbzBankCashout,
	COALESCE(t4.Totalcashin, 0) AS AyaBankCashin,
    COALESCE(t4.Totalcashout, 0) AS AyaBankCashout
FROM 
	(SELECT DATE
			, SUM(cashin)  AS Totalcashin
			, SUM(cashout) AS Totalcashout
	FROM   (SELECT CONVERT(DATE, [ProcessTime]) AS DATE
				, SUM(amount) AS cashin
				, 0 AS cashout
			FROM   [VMG].[dbo].[tbl_MT_CashinHistory]
			WHERE  DATEDIFF(DAY, [ProcessTime], GETDATE()) BETWEEN 0 AND 29
			GROUP  BY CONVERT(DATE, [ProcessTime])
			UNION
			SELECT CONVERT(DATE, TimeStamp) AS DATE
				, 0 AS cashin
				, SUM(amount) AS cashout
			FROM   [VMG].[dbo].[tbl_MT_Account_CashOut]
			WHERE  Tag = 'wave' AND DATEDIFF(DAY, [TimeStamp], GETDATE()) BETWEEN 0 AND 29
			GROUP  BY CONVERT(DATE, TimeStamp)) AS tt
	GROUP  BY tt.DATE) t1
LEFT JOIN 
	(SELECT  DATE
			, SUM(cashin) AS Totalcashin
			, SUM(cashout) AS Totalcashout
	FROM   (SELECT CONVERT(DATE, [ProcessTime]) AS DATE
					, SUM(amount) AS cashin
					, 0 AS cashout
			FROM   [VMG].[dbo].[tbl_kbz_CashinHistory]
			WHERE  DATEDIFF(DAY, [ProcessTime], GETDATE()) BETWEEN 0 AND 29
			GROUP  BY CONVERT(DATE, [ProcessTime])
			UNION
			SELECT CONVERT(DATE, TimeStamp) AS DATE
					, 0 AS cashin
					, SUM(amount) AS cashout
			FROM   [VMG].[dbo].[tbl_MT_Account_CashOut]
			WHERE  (Tag = '' OR Tag = 'kbz') AND DATEDIFF(DAY, [TimeStamp], GETDATE()) BETWEEN 0 AND 29
			GROUP  BY CONVERT(DATE, TimeStamp)) AS tt
	GROUP  BY tt.date)
	t2 ON t1.DATE = t2.DATE
LEFT JOIN 
	(SELECT DATE
			, Sum(cashin) AS Totalcashin
			, Sum(cashout) AS Totalcashout
	FROM   (SELECT CONVERT(DATE, [ProcessTime]) AS DATE
				, SUM(amount) AS cashin
				, 0 AS cashout
			FROM   [VMG].[dbo].[tbl_MT_BankHistory]
			WHERE  Bank = 'KBZBANK' AND DATEDIFF(DAY, [ProcessTime], GETDATE()) BETWEEN 0 AND 29
			GROUP  BY CONVERT(DATE, [ProcessTime])
			-- order by  Convert(date,[ProcessTime])
			UNION
			SELECT CONVERT(DATE, TimeStamp) AS DATE
					, 0 AS cashin
					, SUM(amount) AS cashout
			FROM   [VMG].[dbo].[tbl_MT_Account_CashOut]
			WHERE  Tag = 'KBZBANK' AND DATEDIFF(DAY, [TimeStamp], GETDATE()) BETWEEN 0 AND 29
			GROUP  BY CONVERT(DATE, TimeStamp)) AS tt
	GROUP  BY tt.DATE)
	t3 ON COALESCE(t1.DATE, t2.DATE) = t3.DATE
LEFT JOIN 
	(SELECT DATE
			, SUM(cashin)  AS Totalcashin
			, SUM(cashout) AS Totalcashout
	FROM (SELECT CONVERT(DATE, [ProcessTime]) AS DATE
					, SUM(amount) AS cashin
					, 0 AS cashout
			FROM   [VMG].[dbo].[tbl_MT_BankHistory]
			WHERE  Bank = 'AYABANK' AND DATEDIFF(DAY, [ProcessTime], GETDATE()) BETWEEN 0 AND 29
			GROUP  BY CONVERT(DATE, [ProcessTime])
			UNION
			SELECT CONVERT(DATE, TimeStamp) AS DATE
					, 0 AS cashin
					, SUM(amount) AS cashout
			FROM   [VMG].[dbo].[tbl_MT_Account_CashOut]
			WHERE  Tag = 'AYABANK' AND DATEDIFF(DAY, [TimeStamp], GETDATE()) BETWEEN 0 AND 29
			GROUP  BY CONVERT(DATE, TimeStamp)) AS tt
	GROUP  BY tt.date)
	t4 ON COALESCE(t1.DATE, t2.DATE, t3.DATE) = t4.DATE
ORDER BY COALESCE(t1.DATE, t2.DATE, t3.DATE, t4.DATE)










ALTER PROCEDURE [dbo].[GetFinancialDashboardReport]
@reportType VARCHAR(1)
AS
BEGIN
	IF @reportType='d' OR @reportType IS NULL
		BEGIN
			SELECT CONVERT(VARCHAR(11), [Date], 6) AS [Date]
				 , [CashIn]
				 , [Cashout]
				 , [Balance]
				 , [Fee]
				 , [Transfer]
				 , [TransferFee]
				 , [KbzBalance]
				 , [KbzTransfer]
			FROM [VMG].[dbo].[tbl_Report_Sum]
			WHERE CAST([Date] AS DATE) >= CAST(DATEADD(DAY, -30, GETDATE()) AS DATE)
				AND CAST([Date] AS DATE) <= CAST(GETDATE() AS DATE)
			ORDER BY CAST([Date] AS DATE)
		END
	ELSE IF @reportType='m'
		BEGIN
			SELECT FORMAT(DATEADD(MONTH, DATEDIFF(MONTH, 0, [Date]), 0),'MMM yyyy')  AS [Date]
				 , SUM([CashIn]) AS [CashIn]
				 , SUM([Cashout]) AS [Cashout]
				 , SUM([Balance]) AS [Balance]
				 , SUM([Fee]) AS [Fee]
				 , SUM([Transfer]) AS [Transfer]
				 , SUM([TransferFee]) AS [TransferFee]
				 , SUM([KbzBalance]) AS [KbzBalance]
				 , SUM([KbzTransfer]) AS [KbzTransfer]
			FROM [VMG].[dbo].[tbl_Report_Sum]
			WHERE CAST([Date] AS DATE) >= CAST(DATEADD(MONTH, -11, GETDATE()) AS DATE)
			  AND CAST([Date] AS DATE) <= CAST(GETDATE() AS DATE)
			GROUP BY DATEADD(MONTH, DATEDIFF(MONTH, 0, [Date]), 0)
			ORDER BY DATEADD(MONTH, DATEDIFF(MONTH, 0, [Date]), 0)
		END
	ELSE IF @reportType='y'
		BEGIN
			SELECT CONVERT(VARCHAR(11), [Date], 6) AS [Date]
				 , [CashIn]
				 , [Cashout]
				 , [Balance]
				 , [Fee]
				 , [Transfer]
				 , [TransferFee]
				 , [KbzBalance]
				 , [KbzTransfer]
			FROM [VMG].[dbo].[tbl_Report_Sum]
			WHERE  CAST([Date] AS DATE) >= CAST(DATEADD(YEAR, -1, GETDATE()) AS DATE)
				AND CAST([Date] AS DATE) <= CAST(GETDATE() AS DATE)
			GROUP BY [Date], [CashIn], [Cashout], [Balance], [Fee], [Transfer], [TransferFee], [KbzBalance], [KbzTransfer]
			ORDER BY CAST([Date] AS DATE)
		END
END