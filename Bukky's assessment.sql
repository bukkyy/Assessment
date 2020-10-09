-- '1. IDENTIFY AGENTS ASSIGNED TO EACH CUSTOMER AND THEIR WORKING AREA';
SELECT a.agent_code, agent_name, cust_name, cust_code, a.working_area 
FROM customer c JOIN agents a 
	ON c.agent_code=a.agent_code
ORDER BY a.agent_code;

-- '2. WHAT IS THE OUTSTANDING AMOUNT FROM EACH CUSTOMERS?';
SELECT cust_code, cust_name,outstanding_amt, a.agent_code, agent_name
 FROM customer c, agents a
WHERE c.agent_code=a.agent_code
ORDER BY outstanding_amt;

-- '3.  WHAT IS THE AVERAGE OUTSTANDING AMOUNT, FIND THE CUSTOMERS WHOSE OUTSTANDING AMOUNT IS GREATER THAN AVERAGE
-- ( first find the average, then find the customers who have more than the average)';
SELECT AVG(outstanding_amt) FROM CUSTOMER;
SELECT cust_name, cust_code, outstanding_amt, agent_code
 FROM CUSTOMER 
WHERE outstanding_amt > (SELECT AVG(outstanding_amt) from CUSTOMER)
ORDER BY outstanding_amt;

-- '4. WHO ARE THE AGENTS WHOSE CUSTOMERS ARE UNDERPERFORMING BASED ON THE AVERAGE OUTSTANDING AMOUNT WHERE THE AGENT IS GREATER THAN OR EQUAL to 1';
SELECT a.agent_code, agent_name, cust_code, count(1) from customer c
JOIN agents a on a.agent_code =c.agent_code
WHERE outstanding_amt > (SELECT AVG(outstanding_amt) FROM customer)
GROUP BY a.agent_code, agent_name, cust_code
HAVING count(a.agent_code) >= 1
ORDER BY count(1) desc;


-- '5. WHAT IS THE CURRENT COMMISSIONN OF AGENTS WHO ARE UNDERPERFORMING?;'
SELECT a.agent_code, agent_name, a.commission, cust_code, count(1) from customer c
JOIN agents a on a.agent_code =c.agent_code
WHERE outstanding_amt > (SELECT AVG(outstanding_amt) FROM customer)
GROUP BY a.agent_code, agent_name, cust_code
HAVING count(a.agent_code) >= 1
order by a.agent_code;


-- '6. REDUCE THE COMMISSION OF AGENTS WHOSE CUSTOMERS ARE UNDERPERFORMING';
UPDATE AGENTS 
Set commission = 0.09 
WHERE agent_code in (	SELECT agent_code 
                        FROM CUSTOMER 
                        WHERE outstanding_amt > (SELECT AVG(outstanding_amt) FROM CUSTOMER)
					);



-- '7. WHAT IS THE PERCENTAGE PAID IN ADVANCE PER CUSTOMER FOR ORDERS?';
SELECT cust_name, c.cust_code, ord_amount, advance_amount, ROUND(((advance_amount / ord_amount) *100),2) AS PAYMENT_PERCENTAGE 
FROM orders o, customer c
WHERE o.cust_code = c.cust_code
ORDER BY payment_percentage desc;


-- '8. IDENTIFY THE COMPANY NAME AND CITY THAT PRODUCES JAFFA CAKES';
SELECT co.company_id, co.company_name, co.company_city, f.item_name 
FROM company co
LEFT JOIN foods f on f.company_id = co.company_id
WHERE item_name = 'Jaffa Cakes';


-- '9. IDENTIFY STUDENTS IN EACH SECTION WHOSE TOTAL ATTENDANCE IS GREATER THAN OR EQUAL TO 75';
SELECT s.rollid, s.name, s.title, s.section, class_attended 
FROM student s
JOIN studentreport sr on sr.rollid=s.rollid
WHERE class_attended >= 75
order by s.name;

-- '10. IDENTIFY THE BEST STUDENT OF THE SESSION';
SELECT s.rollid, s.name, s.title, sr.semister as semester, sr.grade from studentreport sr
JOIN student s on s.rollid=sr.rollid
WHERE sr.grade = 'AA'
ORDER BY s.name;