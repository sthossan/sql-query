SELECT name,company, power
	, RANK() OVER(ORDER BY power DESC) AS [Rank]
	, DENSE_RANK() OVER(ORDER BY power DESC) AS [Dense Rank]
	, ROW_NUMBER() OVER(ORDER BY power DESC) AS [Row Number]
FROM Cars



SELECT name,company, power
	, RANK() OVER(PARTITION BY company ORDER BY power DESC) AS DensePowerRank
	, DENSE_RANK() OVER(PARTITION BY company ORDER BY power DESC) AS DensePowerRank
	, ROW_NUMBER() OVER(PARTITION BY company ORDER BY power DESC) AS DensePowerRank
FROM Cars


--The RANK functions skips the next N-1 positions before incrementing the counter
--The DENSE_RANK function is similar to RANK function however the DENSE_RANK function does not skip any ranks if there is a tie between the ranks of the preceding records. Take a look at the following script
--Unlike the RANK and DENSE_RANK functions, the ROW_NUMBER function simply returns the row number of the sorted records starting with 1. For example, if RANK and DENSE_RANK functions of the first two records in the ORDER BY column are equal, both of them are assigned 1 as their RANK and DENSE_RANK. However, the ROW_NUMBER function will assign values 1 and 2 to those rows without taking the fact that they are equally into account. Execute the following script to see the ROW_NUMBER function in action.
