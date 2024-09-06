hile loading the data and apply the appropriate date format

CREATE TABLE IF NOT EXISTS marketing (
ID	INT ,
Year_Birth	DATE ,
Education	VARCHAR (255) ,
Marital_Status	VARCHAR (255) ,
Income	REAL ,
Kidhome	INT ,
Teenhome	INT ,
Dt_Customer	DATE ,
Recency	INT ,
MntWines	INT ,
MntFruits	INT ,
MntMeatProducts	INT ,
MntFishProducts	INT ,
MntSweetProducts	INT ,
MntGoldProds	INT ,
NumDealsPurchases	INT ,
NumWebPurchases	INT ,
NumCatalogPurchases	INT ,
NumStorePurchases	INT ,
NumWebVisitsMonth	INT ,
AcceptedCmp3	INT ,
AcceptedCmp4	INT ,
AcceptedCmp5	INT ,
AcceptedCmp1	INT ,
AcceptedCmp2	INT ,
Complain	INT ,
Z_CostContact	INT , 
Z_Revenue	INT ,
Response	INT ,
Age	INT ,
date2	DATE ,
PRIMARY KEY (ID)

);

SELECT * FROM 
marketing m 

--  Calculate the total number of customer encounters in the marketing campaign dataset


SELECT COUNT(NumWebVisitsMonth)  +
COUNT(NumCatalogPurchases) +
COUNT(NumStorePurchases) AS total_encounters
FROM marketing m 







--COMPLETED SUM for yes's and count is how many total fields
--Find the count of response values
SELECT SUM(Response) AS yes_response,
COUNT(Response) - SUM(Response) AS no_response,
COUNT(Response) AS total_responses,
round((sum(Response) *100.0)  / count(Response *1.0),2) AS pct_yes_response
from marketing m 


--Determine the distribution of customers based on their education level and marital status


SELECT Education ,
Marital_Status ,
COUNT(Marital_Status) AS combined,
ROUND((COUNT(Marital_Status)* 100.0) / SUM(COUNT(*)) OVER (),2) AS percent_of_customers
FROM marketing m 
GROUP BY Education , Marital_Status 



--Identify the average income of customers who participated in the marketing campaign

SELECT ROUND(avg(Income),2) AS participant_income
FROM marketing m 
WHERE Response = 1



--Calculate the total number of promotions accepted by customers in each campaign

SELECT SUM(AcceptedCmp1) AS Totalcmp1,
SUM(AcceptedCmp2) AS Totalcmp2,
SUM(AcceptedCmp3) AS Totalcmp3,
SUM(AcceptedCmp4) AS Totalcmp4,
SUM(AcceptedCmp5) AS Totalcmp5
FROM marketing m 




--Identify the distribution of customers' responses to the last campaign

SELECT (sum(100.0 * Response) / count(ID))  AS yes_pct_last,
(100 - (sum(100.0 * Response) / count(ID)))  AS no_pct_last
FROM marketing m 



--Calculate the average number of children and teenagers in customers' households

SELECT AVG(Kidhome) AS avg_num_kids,
AVG(Teenhome) AS avg_num_teens
FROM marketing m 


--Create an Age column by subtracting year_birth from the current year 


ALTER TABLE marketing 
ADD  COLUMN Age INT


Update marketing 
SET Age =
strftime('%Y',date('now')) - Year_Birth 

SELECT Age, Year_Birth 
FROM marketing m 


--Create Age_group columns based on the below condition:


ALTER TABLE marketing 
ADD Age_group as
       (
       CASE 
	       WHEN Age BETWEEN 18 AND 25 THEN '18-25'
	       WHEN Age BETWEEN 26 AND 35 THEN '26-35'
            WHEN Age BETWEEN 36 AND 45 THEN '36-45'
            WHEN Age BETWEEN 46 AND 55 THEN '46-55'
           
          
            ELSE  '56+' 
            END )

select *
from marketing m 
  

--Determine the average number of visits per month for customers in each age group
            
  SELECT Age_group, 
  ROUND(AVG(NumWebVisitsMonth),1) AS avg_web_visits
  FROM marketing m 
  group by Age_group

 
  
  

  --_What IS the average purchase based ON age
  SELECT Age_group, 
  ROUND(AVG(MntWines),1) AS avg_wine_purchase,
  ROUND(AVG(MntFruits),1) AS avg_fruits_purchase,
  ROUND(AVG(MntMeatProducts),1) AS avg_meat_purchase,
  ROUND(AVG(MntFishProducts),1) AS avg_fish_purchase,
  ROUND(AVG(MntSweetProducts),1) AS avg_sweets_purchase,
  ROUND(AVG(MntGoldProds),1) AS avg_gold_purchase
  FROM marketing m 
  group by Age_group
  

 --Total amount of purchases by age group
SELECT Age_group ,
SUM(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + 
MntGoldProds) AS TotalPurchases
FROM marketing m 
group by Age_group
  
  --How many customers do we have in each age group?
  SELECT count(ID),
  Age_group 
  FROM marketing m 
  Group BY Age_group
  
  
  
  --Age groups who accepted promotions
SELECT Age_group ,
SUM(AcceptedCmp1 + AcceptedCmp2 + AcceptedCmp3 +
AcceptedCmp4 + AcceptedCmp5) AS total_accepted
FROM marketing m 
Group BY Age_group

--Age groups who respond
SELECT Age_group, SUM(Response) AS yes_response,
COUNT(Response) - SUM(Response) AS no_response,
COUNT(Response) AS total_responses,
round((sum(Response) *100.0)  / count(Response *1.0),2) AS pct_yes_response
from marketing m 
Group BY Age_group


--Customers who spent the most
SELECT ID, 
(MntWines + MntFruits + MntMeatProducts + MntFishProducts + MntSweetProducts + 
MntGoldProds) AS TotalPurchases
FROM marketing m 
GROUP BY ID
ORDER BY TotalPurchases DESC
LIMIT 10;

--10 Biggest Sales
SELECT ID, 
MntWines, MntFruits, MntMeatProducts, MntFishProducts, 
MntSweetProducts, MntGoldProds,
MAX(MntWines, MntFruits, MntMeatProducts, MntFishProducts, 
MntSweetProducts, MntGoldProds) AS MaxPurchase
FROM marketing m 
ORDER BY MaxPurchase DESC
LIMIT 10;


