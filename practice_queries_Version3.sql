Select * from Garments;
Select * from ProductionBatches;
Select * from Workers;

--Section 1: Garment Info Queries

--1. List all garments sorted by design date from newest to oldest.

Select * from Garments
Order by design_date DESC;

--2. Count how many garments fall into each category.

Select category, COUNT(*) AS 'Designs per categories' from Garments
Group By category;

--3. Find the average number of sizes per size_range.

--Aggregate function AVG() can not be applied on 'varchar' data-type.

--4. Show the 5 most recently designed garments.

Select TOP 5 * from Garments
Order by design_date DESC;

--5.What is the distribution of fabric types used?

--Answer: Query not very clear however trying to what I have understood.

Select fabric_type, COUNT(*) as 'Distribution of fabric types' from Garments
Group By fabric_type;

--6. Identify garments designed before January 2023.

Select * from Garments
Where design_date > '2023-01-18'

--7. Group garments by fabric type and count how many in each group.

Select fabric_type, COUNT(*) as 'Fabric Type/Group' from Garments
Group By fabric_type;

--8.Which category has the highest number of designed garments?

Select TOP 1 category, COUNT(category) 'Highest Number of Desgins/Category' from Garments
Group By category
Order By COUNT(category) DESC;

--9. Show number of garments designed per month.

--Not very clear to me :(

Select design_date, COUNT(style_name) as 'Designs/Date' from Garments
Group by design_date;

--10. List all garments that use Denim fabric.

Select * from Garments
Where fabric_type = 'Denim';

--Section 2: Production Batch Insights

--1. List all production batches in descending order of production_date.

Select * from ProductionBatches
Order by production_date DESC;

--2. Count how many batches each supervisor has managed.

Select supervisor_name, COUNT(*) AS 'Total Batches/Supervisor' from ProductionBatches
Group By supervisor_name;

--3. Identify the factory location with the most batches.

Select TOP 1 factory_location, COUNT(factory_location) as 'Factory with most batches' from ProductionBatches
Group by factory_location
Order by COUNT(factory_location);

--4. Total number of garments produced across all batches.

Select SUM(quantity_produced) as 'Total Quantity Produced' from ProductionBatches;

--5. Average quantity produced per batch.

Select AVG(quantity_produced) as 'Avg. Quantity Produced' from ProductionBatches;

--6.Which garments have been produced in the most batches?

Select MAX(quantity_produced) as 'Max. Quantity Produced' from ProductionBatches;

--7. Find the earliest recorded production batch.

Select TOP 1 production_date AS 'Earliest Batch' from ProductionBatches
Order by production_date DESC;

--8. List supervisors who managed more than 3 batches.

--Since all the supervisors managing to batches each also, not very sure whether "Where" clause would be applicable here or not so did as per my understanding

Select supervisor_name, COUNT(*) AS 'Superviors with 3+ Batches' from ProductionBatches
Group By supervisor_name;

--9. Get a list of all unique factory locations.

Select DISTINCT factory_location from ProductionBatches;

---10. Show how many batches were produced in each month.

--Not sure how to club month details so that we can get the total quantity produced in a single month.

Select production_date,Sum(quantity_produced) as 'Quantity by date' From ProductionBatches
Group by production_date;

--Section 3 Worker-Level Metrics

--1. Show all workers sorted by hours worked in descending order.
--1.1: Showing all information for workers

Select * from Workers 
Order By hours_worked DESC;
--1.2 : Showing worker names & hours_worked with desending order by hours_worked.

Select name, hours_worked from Workers
Order by hours_worked DESC;

--2. Calculate the average wage per hour.

Select AVG(wage_per_hour) AS 'Avg. wage/hour' from Workers;

--3. How many different workers are there in total?

Select DISTINCT name from Workers;

--4. Count how many workers performed each task.

Select task, COUNT(name) AS 'Total Task' from Workers
Group By task;

--5.Which workers worked more than 40 hours in a batch?

Select * from Workers;

Select name from Workers
Where hours_worked > 40;

/*Select batch_id, SUM(hours_worked) as 'Sum of worked hours' from Workers
Group by batch_id
Order by [Sum of worked hours] DESC; */

--Noone has worked for total 40 hrs

--6. Group and count workers by task type.

Select task, COUNT(name) AS 'Total workers/Task' from Workers
Group by task;

--7. Identify the highest paid worker (hourly rate).

Select TOP 1 * from Workers
Order by wage_per_hour DESC;

--Because 2 workers are paid equally high wage/hour

Select TOP 2 * from Workers
Order by wage_per_hour DESC;

--8. Show workers whose task is "Stitching".

Select * from Workers
Where task = 'Stitching';

--9. List workers who earned above the average total wage.

Select * from Workers Where wage_per_hour >
(Select AVG(wage_per_hour) from Workers);

--10.Which tasks are commonly associated with batches of more than 500 garments?

Select W.task, P.quantity_produced from ProductionBatches P
INNER JOIN Workers W
ON
P.batch_id = W.batch_id
Where P.quantity_produced > 500;

---Section 4: Multi-table Joins (Advanced Insights)

--1. List each garment's style name along with its production quantities.

Select G.style_name,P.quantity_produced from Garments G
INNER JOIN ProductionBatches P
ON
G.garment_id=P.garment_id;

--2. Count how many batches have been produced per factory location.

Select P.factory_location, SUM(W.batch_id) AS 'Products/Factory' from ProductionBatches P
INNER JOIN Workers W
ON
P.batch_id = W.batch_id
GROUP By factory_location

--3. Identify the top 3 garments with the most total quantity produced.

--Based on style_name

Select TOP 3 G.style_name, SUM(P.quantity_produced) as 'Total Quantity' from Garments G
INNER JOIN ProductionBatches P
ON
G.garment_id = P.garment_id
Group By G.style_name
Order By [Total Quantity] DESC;

--Based on category

Select TOP 3 G.category, SUM(P.quantity_produced) as 'Total Quantity' from Garments G
INNER JOIN ProductionBatches P
ON
G.garment_id = P.garment_id
Group By G.category
Order By [Total Quantity] DESC;

---4. Get the average hours worked for workers who worked on "Jeans".

Select AVG(hours_worked) AS 'Avg worked hours for jeans' from ProductionBatches P
INNER JOIN Workers W
ON P.batch_id = W.batch_id
INNER JOIN Garments G
ON G.garment_id = P.garment_id
Where category = 'Jeans';

--5.Which fabric types are used most in garments with more than 1000 units produced?

Select G.category, SUM(quantity_produced) '1000 units produced/fabric type' from Garments G
INNER JOIN ProductionBatches P
ON G.garment_id = P.garment_id
Group By G.category
HAVING SUM(quantity_produced) > 1000;

--6. List all workers with their tasks and the garment they worked on.

Select w.name, W.task, G.fabric_type from Workers W
INNER JOIN ProductionBatches P
On W.batch_id = P.batch_id
INNER JOIN Garments G
On P.garment_id = G.garment_id

--7.What is the average wage per hour for workers who did "Quality Check"?

Select AVG(wage_per_hour) 'Avg. wage/hr for QC' from Workers
Where task = 'Quality Check';

--8. List all supervisors who worked on garments made of "Cotton".

Select DISTINCT(P.supervisor_name) from Garments G
INNER JOIN ProductionBatches P
ON G.garment_id=P.garment_id
Where fabric_type = 'Cotton'

--9. Which categories of garments involve the most stitching work?

--A little trick not a good one with HAVING clause :)

Select W.task, G.category, SUM(hours_worked) AS 'Total hours' from Garments G
INNER JOIN ProductionBatches P
ON G.garment_id = P.garment_id
INNER JOIN Workers W
ON P.batch_id = W.batch_id
Where task = 'Stitching'
GROUP by G.category,W.task, W.hours_worked
HAVING SUM(hours_worked) = 16
Order By [Total hours] DESC;

--10. Count how many total hours were worked per factory location.

Select DISTINCT(P.factory_location),SUM(W.hours_worked) AS 'Total worked hours/Factory Location' from ProductionBatches P
INNER JOIN Workers W
ON P.batch_id = W.batch_id
Group By factory_location;

----Done------