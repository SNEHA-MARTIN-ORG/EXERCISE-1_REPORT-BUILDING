----1st QUESTION--------
---a)Display a list of all property names and their property id’s for Owner Id: 1426
SELECT OP.OwnerId,P.Id,P.Name
FROM DBO.Property AS P
INNER JOIN DBO.OwnerProperty AS OP
ON P.Id=OP.Id
WHERE OwnerId=1426


----------2nd question
---b)Display the current home value for each property in question a). 
SELECT OP.OwnerId,P.Name,OP.PropertyId, PHV.Value
FROM DBO.Property AS P
INNER JOIN DBO.OwnerProperty AS OP
ON P.Id=OP.PropertyId
 JOIN DBO.PropertyHomeValue AS PHV
ON P.Id=PHV.PropertyId 
WHERE OwnerId=1426 AND PHV.IsActive=1
ORDER BY P.Name

-----3rd QUESTION
---when calculating total amount according to month, we need to add a day to the end date 
---to get the result
---c)For each property in question a), return the following:    
---i)Using rental payment amount, rental payment frequency, tenant start date and tenant end date 
---to write a query that returns the sum of all payments from start date to end date. 
---ii)Display the yield. 
SELECT OP.OwnerId,P.Name,OP.PropertyId,
PHV.Value,
TP.PaymentFrequencyId,TP.PaymentAmount, 
trp.Name,TP.StartDate,TP.EndDate,
CASE 
WHEN TP.PaymentFrequencyId=1 THEN DATEDIFF(WEEK,tp.StartDate,tp.EndDate)*TP.paymentamount
WHEN TP.PaymentFrequencyId=2 THEN DATEDIFF(WEEK,tp.StartDate,tp.EndDate)*TP.paymentamount/2
WHEN TP.PaymentFrequencyId=3 THEN DATEDIFF(MONTH,tp.StartDate,tp.EndDate+1)*TP.paymentamount
END PaymentSum

FROM DBO.Property AS P
INNER JOIN DBO.OwnerProperty AS OP
ON P.Id=OP.PropertyId
INNER JOIN DBO.PropertyHomeValue AS PHV
ON P.Id=PHV.PropertyId 
INNER JOIN DBO.TenantProperty AS TP
ON P.Id=TP.PropertyId
INNER JOIN DBO.TargetRentType AS TRP
ON P.TargetRentTypeId=TRP.Id
WHERE OwnerId=1426 AND PHV.IsActive=1
ORDER BY P.Name

---------4th Question--------
---d)Display all the jobs available in the marketplace 
---(jobs that owners have advertised for service suppliers). 

select DISTINCT TJR.JobDescription ,J.PropertyId,J.OwnerId,J.ProviderId
,C.Name AS COMPANY_NAME
from Job AS J
INNER JOIN TenantJobRequest AS TJR
ON J.PropertyId=TJR.PropertyId
INNER JOIN JobQuote AS JQ
ON J.ProviderId=JQ.ProviderId
INNER JOIN ServiceProvider AS SP
ON  JQ.ProviderId=SP.Id
INNER JOIN Company AS C
ON SP.CompanyId=C.Id




--------5 th Question--------
---Display all property names, current tenants first and last names and rental payments
---per week/ fortnight/month for the properties in question a). 
SELECT OP.OwnerId,P.Name AS Property_Name,OP.PropertyId,
PHV.Value,PER.FirstName+' '+PER.LastName AS Tenant_Name,
TP.PaymentFrequencyId,
TP.PaymentAmount,
trp.Name AS Payment_Interval
FROM DBO.Property AS P
INNER JOIN DBO.OwnerProperty AS OP
ON P.Id=OP.PropertyId
INNER JOIN DBO.PropertyHomeValue AS PHV
ON P.Id=PHV.PropertyId 
INNER JOIN DBO.TenantProperty AS TP
ON P.Id=TP.PropertyId
INNER JOIN DBO.TargetRentType AS TRP
ON P.TargetRentTypeId=TRP.Id
INNER JOIN Person AS PER
ON TP.TenantId=PER.ID----(1)
----------OP.Id=PER.Id------(2)
---how to know if we have to use the join condition (1) or (2),because it both gives result --------
WHERE OwnerId=1426 AND PHV.IsActive=1
ORDER BY P.Name