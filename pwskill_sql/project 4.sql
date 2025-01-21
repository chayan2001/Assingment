use mavenmovies
--question 1 
select customer_id ,
sum(amount) as total_spent , 
rank() over (order by sum(amount) desc) as spending_rank
from payment
group by customer_id
order by spending_rank
--question 2
SELECT
    f.film_id,
    f.title,
    r.rental_date,
    SUM(r.rental_amount) OVER (PARTITION BY f.film_id ORDER BY r.rental_date) AS cumulative_revenue
FROM
    rentals r
JOIN
    films f ON r.film_id = f.film_id
ORDER BY
    r.rental_date;

--question 3
SELECT
    f.film_id,
    f.title,
    AVG(r.rental_duration) AS avg_rental_duration
FROM
    films f
JOIN
    rentals r ON f.film_id = r.film_id
GROUP BY
    f.film_id, f.title
HAVING
    ABS(f.length - AVG(r.rental_duration)) <= 5 -- Films with similar lengths (e.g., within 5 days of average rental duration)
ORDER BY
    avg_rental_duration;
```

### 4. **Identify the top 3 films in each category based on their rental counts.**

```sql
WITH film_rentals AS (
    SELECT
        f.film_id,
        f.title,
        c.category_name,
        COUNT(r.rental_id) AS rental_count
    FROM
        films f
    JOIN
        rentals r ON f.film_id = r.film_id
    JOIN
        film_categories fc ON f.film_id = fc.film_id
    JOIN
        categories c ON fc.category_id = c.category_id
    GROUP BY
        f.film_id, f.title, c.category_name
)
SELECT
    film_id,
    title,
    category_name,
    rental_count,
    RANK() OVER (PARTITION BY category_name ORDER BY rental_count DESC) AS rank
FROM
    film_rentals
WHERE
    rank <= 3
ORDER BY
    category_name, rank;
```

### 5. **Find the monthly revenue trend for the entire rental store over time.**

```sql
SELECT
    TO_CHAR(r.rental_date, 'YYYY-MM') AS month,
    SUM(r.rental_amount) AS total_revenue
FROM
    rentals r
GROUP BY
    TO_CHAR(r.rental_date, 'YYYY-MM')
ORDER BY
    month;
```

### 6. **Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.**

```sql
WITH customer_rentals AS (
    SELECT
        r.customer_id,
        COUNT(r.rental_id) AS rental_count
    FROM
        rentals r
    GROUP BY
        r.customer_id
),
average_rentals AS (
    SELECT
        AVG(rental_count) AS avg_rentals
    FROM
        customer_rentals
)
SELECT
    cr.customer_id,
    cr.rental_count,
    cr.rental_count - ar.avg_rentals AS rental_count_difference
FROM
    customer_rentals cr, average_rentals ar
ORDER BY
    rental_count_difference DESC;
```

### 7. **Identify the customers whose total spending on rentals falls within the top 20% of all customers.**

```sql
WITH total_spending AS (
    SELECT
        r.customer_id,
        SUM(r.rental_amount) AS total_spent
    FROM
        rentals r
    GROUP BY
        r.customer_id
),
spending_percentile AS (
    SELECT
        total_spent,
        PERCENT_RANK() OVER (ORDER BY total_spent DESC) AS percentile
    FROM
        total_spending
)
SELECT
    ts.customer_id,
    ts.total_spent
FROM
    total_spending ts
JOIN
    spending_percentile sp ON ts.total_spent = sp.total_spent
WHERE
    sp.percentile >= 0.8
ORDER BY
    ts.total_spent DESC;
```

### 8. **Calculate the running total of rentals per category, ordered by rental count.**

```sql
SELECT
    c.category_name,
    f.film_id,
    f.title,
    COUNT(r.rental_id) AS rental_count,
    SUM(COUNT(r.rental_id)) OVER (PARTITION BY c.category_name ORDER BY COUNT(r.rental_id) DESC) AS running_total
FROM
    rentals r
JOIN
    films f ON r.film_id = f.film_id
JOIN
    film_categories fc ON f.film_id = fc.film_id
JOIN
    categories c ON fc.category_id = c.category_id
GROUP BY
    c.category_name, f.film_id, f.title
ORDER BY
    c.category_name, rental_count DESC;
```

### 9. **Find the films that have been rented less than the average rental count for their respective categories.**

```sql
WITH category_rentals AS (
    SELECT
        c.category_name,
        f.film_id,
        COUNT(r.rental_id) AS rental_count
    FROM
        rentals r
    JOIN
        films f ON r.film_id = f.film_id
    JOIN
        film_categories fc ON f.film_id = fc.film_id
    JOIN
        categories c ON fc.category_id = c.category_id
    GROUP BY
        c.category_name, f.film_id
),
category_avg_rentals AS (
    SELECT
        category_name,
        AVG(rental_count) AS avg_rental_count
    FROM
        category_rentals
    GROUP BY
        category_name
)
SELECT
    cr.film_id,
    f.title,
    cr.rental_count,
    cr.category_name
FROM
    category_rentals cr
JOIN
    category_avg_rentals ca ON cr.category_name = ca.category_name
JOIN
    films f ON cr.film_id = f.film_id
WHERE
    cr.rental_count < ca.avg_rental_count
ORDER BY
    cr.category_name, cr.rental_count;
```

### 10. **Identify the top 5 months with the highest revenue and display the revenue generated in each month.**

```sql
SELECT
    TO_CHAR(r.rental_date, 'YYYY-MM') AS month,
    SUM(r.rental_amount) AS total_revenue
FROM
    rentals r
GROUP BY
    TO_CHAR(r.rental_date, 'YYYY-MM')
ORDER BY
    total_revenue DESC
FETCH FIRST 5 ROWS ONLY;
```
--normalization and cte
Let's go through each of your questions one by one, based on the Sakila database.

---

### 1. **First Normal Form (1NF):**

**a. Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF.**

In the Sakila database, a typical table that may violate 1NF is the **`customer`** table. If, for example, the **`customer`** table contains a column like `phone_numbers` where multiple phone numbers for a customer are stored in a single cell (e.g., comma-separated or space-separated values), this violates 1NF. 

To normalize the table to 1NF:
- **1NF requires atomic values**: Each column must contain only one value per row.
- If the `phone_numbers` column is storing multiple values, we would separate this into multiple rows or create a new **`customer_phone`** table to store the individual phone numbers.

The new design would look like this:
- **Customer** table (without `phone_numbers`):
  - `customer_id`
  - `first_name`
  - `last_name`
  - `email`
  - `address_id`
  - etc.

- **Customer_Phone** table:
  - `customer_phone_id` (Primary Key)
  - `customer_id` (Foreign Key referencing Customer)
  - `phone_number`

Now, each phone number is stored in a separate row, and the data is atomic, meeting the 1NF requirement.

---

### 2. **Second Normal Form (2NF):**

**a. Choose a table in Sakila and describe how you would determine whether it is in 2NF. If it violates 2NF, explain the steps to normalize it.**

Take the **`film_actor`** table as an example. 

The **`film_actor`** table typically has the following columns:
- `actor_id` (Primary Key)
- `film_id` (Primary Key)
- `last_update`

This table is likely in 1NF but may violate **2NF** because it contains a **partial dependency**.

**Steps to check if it violates 2NF:**
- A table is in **2NF** if it is in **1NF** and **there are no partial dependencies** (i.e., no non-key attributes depend on only part of the composite primary key).
- In this case, the composite primary key is `(actor_id, film_id)`. However, the column `last_update` does not depend on both `actor_id` and `film_id` — it is independent of them and likely just a timestamp.

**Steps to normalize to 2NF:**
- To normalize to 2NF, we remove the partial dependency by creating a new table for `last_update` and associating it with the composite key `(actor_id, film_id)`.

New design:
1. **Film_Actor** table:
   - `actor_id`
   - `film_id`
   - **Primary Key**: `(actor_id, film_id)`

2. **Film_Actor_Last_Update** table:
   - `actor_id`
   - `film_id`
   - `last_update`
   - **Primary Key**: `(actor_id, film_id)`

Now, the **`Film_Actor`** table only stores the relationship, and the **`Film_Actor_Last_Update`** table stores the timestamp separately, removing the partial dependency.

---

### 3. **Third Normal Form (3NF):**

**a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies present and outline the steps to normalize the table to 3NF.**

Consider the **`rental`** table:
- `rental_id`
- `rental_date`
- `inventory_id`
- `customer_id`
- `staff_id`
- `return_date`
- `last_update`

**Transitive Dependency:**
- `staff_id` -> `staff_name` (i.e., the staff name can be derived from `staff_id`).
- This creates a transitive dependency because `staff_name` depends on `staff_id`, and `staff_id` depends on the **primary key** (`rental_id`).

To normalize to 3NF:
1. **Remove the transitive dependency** by placing `staff_name` in a separate table (the **`staff`** table).
2. Create a reference between the **`rental`** table and the **`staff`** table using `staff_id`.

New design:
1. **Rental** table:
   - `rental_id` (Primary Key)
   - `rental_date`
   - `inventory_id`
   - `customer_id`
   - `staff_id`
   - `return_date`
   - `last_update`

2. **Staff** table:
   - `staff_id` (Primary Key)
   - `staff_name`
   - etc.

Now, the `rental` table no longer stores `staff_name`, eliminating the transitive dependency.

---

### 4. **Normalization Process:**

**a. Take a specific table in Sakila and guide through the process of normalizing it from the initial unnormalized form up to at least 2NF.**

Let’s take the **`payment`** table as an example, which might initially look like this (unnormalized):

| payment_id | customer_id | amount | payment_date | film_title | film_category |
|------------|-------------|--------|--------------|------------|---------------|
| 1          | 10          | 5.00   | 2025-01-01   | Movie A    | Action        |
| 2          | 10          | 7.00   | 2025-01-02   | Movie B    | Drama         |

**Step 1: 1NF** (Atomic values):
- The above table already has atomic values. So it is in **1NF**.

**Step 2: 2NF** (No partial dependency):
- The composite primary key could be `(payment_id, customer_id)`, but `film_title` and `film_category` depend on `film_id` (not the whole composite key).
- We need to split `film_title` and `film_category` into a separate table and reference it using a `film_id`.

**Step 3: 3NF** (Remove transitive dependencies):
- In 3NF, `film_category` might depend on `film_id`. If so, we should normalize the data further and remove transitive dependencies.

Final design:
1. **Payment** table:
   - `payment_id` (Primary Key)
   - `customer_id`
   - `amount`
   - `payment_date`
   - `film_id`

2. **Film** table:
   - `film_id` (Primary Key)
   - `film_title`
   - `film_category`

This structure is now in 2NF and 3NF, with no partial or transitive dependencies.

---

### 5. **CTE Basics:**

**a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in from the actor and film_actor tables.**

```sql
WITH actor_film_count AS (
    SELECT
        a.actor_id,
        a.first_name || ' ' || a.last_name AS actor_name,
        COUNT(fa.film_id) AS film_count
    FROM
        actor a
    JOIN
        film_actor fa ON a.actor_id = fa.actor_id
    GROUP BY
        a.actor_id
)
SELECT * FROM actor_film_count;
```

---

### 6. **CTE with Joins:**

**a. Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate.**

```sql
WITH film_language_info AS (
    SELECT
        f.title AS film_title,
        l.name AS language_name,
        f.rental_rate
    FROM
        film f
    JOIN
        language l ON f.language_id = l.language_id
)
SELECT * FROM film_language_info;
```

---

### 7. **CTE for Aggregation:**

**a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables.**

```sql
WITH customer_revenue AS (
    SELECT
        c.customer_id,
        SUM(p.amount) AS total_revenue
    FROM
        customer c
    JOIN
        payment p ON c.customer_id = p.customer_id
    GROUP BY
        c.customer_id
)
SELECT * FROM customer_revenue;
```

---

### 8. **CTE with Window Functions:**

**a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.**

```sql
WITH film_ranking AS (
    SELECT
        f.title,
        f.rental_duration,
        RANK() OVER (ORDER BY f.rental_duration DESC) AS rental_rank
    FROM
        film f
)
SELECT * FROM film_ranking;
```

---

### 9. **CTE and Filtering:**

**a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer table to retrieve additional customer details.**

```sql
WITH frequent_customers AS (
    SELECT
        customer_id
    FROM
        rental
    GROUP BY
        customer_id
    HAVING
        COUNT(rental_id) > 2
)
SELECT
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email
FROM
    frequent_customers fc
JOIN
    customer c ON fc.customer_id = c.customer_id;
```

---

These queries should cover all of the tasks, from normalization to CTE usage, based on the Sakila database. Be sure to adjust any column names or table structures if your setup varies.

Let's go through the requested queries one by one, addressing each use case as per your requirements.

---

### 1. **CTE for Date Calculations:**

**a. Write a query using a CTE to find the total number of rentals made each month, considering the `rental_date` from the rental table.**

We can calculate the total number of rentals made each month using a CTE that groups by the `rental_date`, formatted to just include the year and month.

```sql
WITH rentals_per_month AS (
    SELECT
        TO_CHAR(r.rental_date, 'YYYY-MM') AS month,
        COUNT(r.rental_id) AS total_rentals
    FROM
        rental r
    GROUP BY
        TO_CHAR(r.rental_date, 'YYYY-MM')
)
SELECT * FROM rentals_per_month
ORDER BY month;
```

**Explanation:**
- The CTE `rentals_per_month` groups the data by the `rental_date` column, formatted as `YYYY-MM`, and counts the total rentals (`rental_id`).
- The final `SELECT` pulls all the results, ordered by the month.

---

### 2. **CTE and Self-Join:**

**a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the `film_actor` table.**

We can use a self-join on the `film_actor` table to find all pairs of actors who have appeared in the same film together. The self-join will match actors within the same film.

```sql
WITH actor_pairs AS (
    SELECT
        fa1.actor_id AS actor1_id,
        fa2.actor_id AS actor2_id,
        fa1.film_id
    FROM
        film_actor fa1
    JOIN
        film_actor fa2 ON fa1.film_id = fa2.film_id
    WHERE
        fa1.actor_id < fa2.actor_id  -- Ensuring that we only show each pair once
)
SELECT
    ap.actor1_id,
    ap.actor2_id,
    f.title AS film_title
FROM
    actor_pairs ap
JOIN
    film f ON ap.film_id = f.film_id
ORDER BY
    f.title, ap.actor1_id, ap.actor2_id;
```

**Explanation:**
- The `actor_pairs` CTE joins the `film_actor` table with itself to find pairs of actors (`fa1.actor_id` and `fa2.actor_id`) that appear in the same film (`fa1.film_id = fa2.film_id`).
- The `WHERE` clause ensures that each pair of actors is only listed once (`fa1.actor_id < fa2.actor_id`).
- Finally, the main `SELECT` joins the `actor_pairs` with the `film` table to get the `film_title` for each pair.

---

### 3. **CTE for Recursive Search:**

**a. Implement a recursive CTE to find all employees under a specific manager (assuming an employee table structure with a `manager_id` field).**

A recursive CTE can be used to search through a hierarchical structure, such as employees who report to a manager and recursively find their subordinates.

Here’s an example assuming you have an `employee` table with the columns `employee_id`, `name`, and `manager_id`.

```sql
WITH RECURSIVE employee_hierarchy AS (
    -- Base case: Start with the manager (e.g., manager_id = 1)
    SELECT
        employee_id,
        name,
        manager_id
    FROM
        employee
    WHERE
        manager_id = 1  -- Change this to the desired manager_id to start from
    
    UNION ALL
    
    -- Recursive case: Find employees who report to the employees already in the hierarchy
    SELECT
        e.employee_id,
        e.name,
        e.manager_id
    FROM
        employee e
    JOIN
        employee_hierarchy eh ON e.manager_id = eh.employee_id
)
SELECT * FROM employee_hierarchy;
```

**Explanation:**
- The recursive CTE `employee_hierarchy` starts with employees who report directly to a given manager (e.g., `manager_id = 1`).
- The `UNION ALL` part recursively adds employees who report to those already included in the hierarchy.
- This process continues until no more employees can be found under the hierarchy.

---

### Summary of Queries:

1. **CTE for Date Calculations**: The first query calculates total rentals by month, utilizing a CTE and date formatting.
2. **CTE and Self-Join**: The second query generates actor pairs who have appeared together in the same film using a self-join on the `film_actor` table.
3. **CTE for Recursive Search**: The third query finds all employees under a specific manager, using a recursive CTE to traverse the hierarchy.

These are common techniques in SQL for working with hierarchical data, joining tables, and performing date-based aggregations. Let me know if you need more specific modifications or explanations!



