# Database Scenario 
UPS prides itself on having up-to-date information on the processing and current location of 
each shipped item. To do this, UPS relies on a company-wide information system. Shipped 
items are the heart of the UPS product tracking information system. Shipped items can be 
characterized by item number (unique), weight, dimensions, insurance amount, destination, 
and final delivery date.  
Shipped items are received into the UPS system at a single retail center. Retail centers are 
characterized by their type, uniqueID, phone number and address.  
Shipped items make their way to their destination via one or more standard UPS 
transportation events (i.e., flights, truck deliveries). These transportation events are 
characterized by a unique scheduleNumber, a type (e.g, flight, truck), and a delivery Route.  
Children toy lots are included in the Shipped items. A children toy lot is uniquely identified by 
the Lot number. A children toy lot is characterized by Create date, Lot Number, Cost of 
Materials.  
The Lot includes the Production units. A production unit is uniquely identified by its serial 
number. A production unit is characterized by the serial number, Exact weight, Product type, 
Product Description and the quality test details.  
A toy lot is created from Raw Materials. A raw material is uniquely identified by the material 
Id.  Raw Materials are characterized by material Id, Raw material type and by the unit cost. 
There are 2 types of raw materials such as Direct and indirect. Direct materials can be 
categorized by final product_id. In direct materials categorized by process_id. 
After finalizing the shipped items and confirming the transportation event by the custom, 
they will assign a delivery agent to distribute the shipped items. And the delivery agent can 
be categorized by agent_id, name,vehicle number etc.  

# Part 1 
• Analyze the given scenario and carry out the below tasks 
• Document any assumptions made.
• Develop the ERD and logical model.
• Normalize the logical model to 3NF.
• Implement the logical model in MS SQL server and enter suitable sample data.
• Identify all necessary constraints and enforce them on the tables.
• Develop the required views, functions, stored procedures, triggers, and indexes as 
specified below.
• Identify 2 suitable triggers that can be applied on the database and explain and 
implement them. 
• Identify the possible users of this database and create 2 views for them.
• Based on the below questions identify 2 indexes that will optimize the given 
queries and implement them. 
• Write stored procedures to carry out the below DML functions. 
• List all the shipped items that weights more than 500g. 
• List all the shipped items where the city of the retail center is Kandy. 
3. List down the lot numbers which has the highest unit cost values of the raw 
materials. 
4. List all the retail centers taken by the type “toys suitable for age between 
5-10” 

# Part 2
• Select and study two database vulnerabilities focusing on techniques and impact. (20 
Marks) 
• Understand how to mitigate the selected vulnerabilities and suggest countermeasures to 
overcome from the selected vulnerabilities. (15 Marks) 
