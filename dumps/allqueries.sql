
-- 4 Display the total number of customers based on gender who have placed individual orders of worth at least Rs.3000.
SELECT orders.ORD_ID, product.PRO_NAME
FROM orders
JOIN supplier_pricing ON orders.PRICING_ID = supplier_pricing.PRICING_ID
JOIN product ON supplier_pricing.PRO_ID = product.PRO_ID
WHERE orders.ORD_DATE > '2021-10-05';

-- 5 Display all the orders along with product name ordered by a customer having Customer_Id=2.-- 
SELECT orders.ORD_ID, orders.ORD_AMOUNT, orders.ORD_DATE, customer.CUS_NAME, product.PRO_NAME
FROM orders
JOIN customer ON orders.CUS_ID = customer.CUS_ID
JOIN supplier_pricing ON orders.PRICING_ID = supplier_pricing.PRICING_ID
JOIN product ON supplier_pricing.PRO_ID = product.PRO_ID
WHERE customer.CUS_ID = 2;

-- 6 Display the Supplier details who can supply more than one product.
SELECT supplier.*
FROM supplier
JOIN supplier_pricing ON supplier.SUPP_ID = supplier_pricing.SUPP_ID
GROUP BY supplier.SUPP_ID
HAVING COUNT(DISTINCT supplier_pricing.PRO_ID) > 1;

-- 7 Find the least expensive product from each category and print the table with category id, name, product name, and price of the product.
SELECT category.CAT_ID, category.CAT_NAME, product.PRO_NAME, MIN(supplier_pricing.SUPP_PRICE) AS Min_Price
FROM category
JOIN product ON category.CAT_ID = product.CAT_ID
JOIN supplier_pricing ON product.PRO_ID = supplier_pricing.PRO_ID
GROUP BY category.CAT_ID, product.PRO_NAME;

-- 8 Display the Id and Name of the Product ordered after “2021-10-05”.
SELECT orders.ORD_ID, product.PRO_NAME
FROM orders
JOIN supplier_pricing ON orders.PRICING_ID = supplier_pricing.PRICING_ID
JOIN product ON supplier_pricing.PRO_ID = product.PRO_ID
WHERE orders.ORD_DATE > '2021-10-05';

-- 9 Display customer name and gender whose names start or end with character 'A'.
SELECT CUS_NAME, CUS_GENDER
FROM customer
WHERE CUS_NAME LIKE 'A%' OR CUS_NAME LIKE '%A';

-- 10 Create a stored procedure to display supplier id, name, Rating (Average rating of all the products sold by every customer), and Type_of_Service.
DELIMITER //

CREATE PROCEDURE GetSupplierRating()
BEGIN
    SELECT
        supplier.SUPP_ID,
        supplier.SUPP_NAME,
        AVG(rating.RAT_RATSTARS) AS Avg_Rating,
        CASE
            WHEN AVG(rating.RAT_RATSTARS) = 5 THEN 'Excellent Service'
            WHEN AVG(rating.RAT_RATSTARS) > 4 THEN 'Good Service'
            WHEN AVG(rating.RAT_RATSTARS) > 2 THEN 'Average Service'
            ELSE 'Poor Service'
        END AS Type_of_Service
    FROM supplier
    LEFT JOIN supplier_pricing ON supplier.SUPP_ID = supplier_pricing.SUPP_ID
    LEFT JOIN orders ON supplier_pricing.PRICING_ID = orders.PRICING_ID
    LEFT JOIN rating ON orders.ORD_ID = rating.ORD_ID
    GROUP BY supplier.SUPP_ID;
END //

DELIMITER ;

CALL GetSupplierRating();