/*                          
   -----------------------------------------------------------------------------------------------                       
   Service Request        : Test-Item
   Description 	          : Please add the PICs in the attachment to NJ october 2024 posting table. Thank you! 
   Date                   : 09/18/2024(MM/DD/YYYY)
   Author                 : Vimal Sahu               
  ------------------------------------------------------------------------------------------------                         
*/ 

-----------------------------------------------  
--Step 1 : Get the state key for NJ
-----------------------------------------------
SELECT * 
FROM   state 
WHERE   abbreviation = 'NJ' 
and state_key = 2
​

-----------------------------------------------  
--Step 2 : Verify excel imported data  
-----------------------------------------------
​SELECT * FROM  [pse].[VS_NJ_tech_179607_09182024]
-- 8 records 


-----------------------------------------------  
--Step 3: Get the count
-----------------------------------------------
SELECT count(*)
FROM   posted_item 
WHERE  year = 2024
       AND month = 10
       AND state_key = 2  
​--5534 records


------------------------------------------------------------
--Step 4 : Check if there any existing data in temp table
------------------------------------------------------------
select * from posted_item poi inner join [pse].[VS_NJ_tech_179607_09182024] temp ON 
poi.partner_item_code = temp.[Importer Item Code]
where poi.month = 10 and 
poi.state_key = 2 and 
poi.year = 2024
-- 0 records 
-- if there is existing data then contact to user.


-----------------------------------------------
--Step 5 : Add items 
-----------------------------------------------
INSERT INTO posted_item 
            (item_key, 
             state_key, 
             month, 
             year, 
             case_cost_wholesaler, 
             case_cost_retailer, 
             posted_datetime, 
             posted_user_key,
			 partner_item_code) 
SELECT dbo.item.item_key, 
       2   AS state, 
       10  AS month, 
       2024  AS year, 
       rs.[cost/case wholesaler], 
       rs.[cost/case retailer], 
       Getdate()   AS posted_time, 
       789   AS posted_user_key,
	    rs.[Importer Item Code] AS  'partner_item_code' 
FROM   dbo.item 
       INNER JOIN [pse].[VS_NJ_tech_179607_09182024] rs 
            ON dbo.item.item_code = rs.[twm item code] 
		LEFT JOIN posted_item ON posted_item.item_key=item.item_key 
		and posted_item.state_key= 2
		and posted_item.month = 10
		and posted_item.year= 2024   
		and posted_item.partner_item_code= rs.[Importer Item Code] 
		  
​-- 8 rows will be affect.	
​
-----------------------------------------------  
--Step 6 : Verify record added 
-----------------------------------------------
SELECT item.item_code, 
       posted_item.* 
FROM   posted_item 
       INNER JOIN item 
               ON posted_item.item_key = item.item_key 
WHERE  year = 2024
       AND month = 10
       AND state_key = 2
       AND posted_datetime >= '2024-09-18' 
ORDER  BY posted_datetime DESC 
​​​-- 0 records ​​


-----------------------------------------------  
--Step 7 : Verify the posted items 
-----------------------------------------------
SELECT count(*) 
FROM   posted_item 
WHERE  year = 2024
       AND month = 10
       AND state_key = 2
-- 5542 records ​


----------------------------------------------------
--Step 8 : Drop temp table
----------------------------------------------------
drop table  [pse].[VS_NJ_tech_179607_09182024]

-- This is the comment 