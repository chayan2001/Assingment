use mavenmovies ;
--use commands
/*In the context of a database used for a Maven Movies application (or similar movie databases), we typically deal with entities such as Movies, Actors, Directors, Studios, and possibly Users and Reviews. Here’s how primary keys and foreign keys might be applied in this kind of database, and the differences between them:

### Primary Keys (PKs)
Primary keys uniquely identify each record within a table. They must contain unique values, and no field in a primary key can be null. Examples of tables and primary keys might include:

1. **Movies Table**
   - **Primary Key:** `movie_id`
     - This uniquely identifies each movie in the database.

2. **Actors Table**
   - **Primary Key:** `actor_id`
     - This uniquely identifies each actor in the database.

3. **Directors Table**
   - **Primary Key:** `director_id`
     - This uniquely identifies each director in the database.

4. **Users Table**
   - **Primary Key:** `user_id`
     - This uniquely identifies each user in the database.

### Foreign Keys (FKs)
Foreign keys are used to establish and enforce relationships between tables. They point to the primary key of another table. Foreign keys help maintain referential integrity, ensuring that the data in the related tables remains consistent.

Examples of foreign keys in a Maven Movies database might include:

1. **Movies Table**
   - **Foreign Key:** `director_id` (refers to `directors.director_id`)
     - This establishes a relationship where each movie is directed by one director.

2. **Movies Table**
   - **Foreign Key:** `studio_id` (refers to `studios.studio_id`)
     - This establishes a relationship where each movie is produced by one studio.

3. **Movie_Actors Table (Junction Table for many-to-many relationship)**
   - **Foreign Key 1:** `movie_id` (refers to `movies.movie_id`)
   - **Foreign Key 2:** `actor_id` (refers to `actors.actor_id`)
     - This creates a many-to-many relationship between movies and actors. A movie can have multiple actors, and an actor can participate in multiple movies.

4. **Reviews Table**
   - **Foreign Key:** `movie_id` (refers to `movies.movie_id`)
     - This establishes a relationship where each review is associated with a specific movie.

### Key Differences Between Primary Keys and Foreign Keys:

1. **Purpose**:
   - **Primary Key:** Uniquely identifies each record within its own table.
   - **Foreign Key:** Links records in one table to the records in another table to maintain referential integrity.

2. **Uniqueness**:
   - **Primary Key:** Must contain unique values. No two records can have the same primary key.
   - **Foreign Key:** Can have duplicate values. Multiple rows in a table can reference the same value in another table (for example, multiple actors can be assigned to the same movie).

3. **Nullability**:
   - **Primary Key:** Cannot contain null values, as it must uniquely identify a record.
   - **Foreign Key:** Can contain null values, which can represent the absence of a relationship (e.g., a movie without a director or a review without a movie).

4. **Location**:
   - **Primary Key:** Resides in the table that contains the entity being identified.
   - **Foreign Key:** Resides in a table that references another table's primary key.

### Example Scenario:
In a **Movies** table, the `movie_id` would be the primary key, ensuring that each movie is uniquely identified. If a movie is produced by a specific studio, the `studio_id` would be a foreign key linking to the **Studios** table. Similarly, if an actor is involved in a movie, the `actor_id` in a **Movie_Actors** junction table would reference both the `movie_id` in the **Movies** table and the `actor_id` in the **Actors** table.

This structure allows for organizing data efficiently, enabling relationships between entities (such as which actors acted in which movies) while maintaining data integrity.*/
--question 2
select * from actor
--question 3
select * from customer 
--question 4
select * from country
--queston 5
select * 
from customer
where active = 1 
--question 6
select * from rental
where staff_id = 1
--questin 7
select * from film 
where rental_duration > 5
--question 8 
select * from film
where replacement_cost > 15 and replacement_cost < 20
--question 9
select count(distinct first_name) from actor
--question 10
select * from customer
limit 10
--question 11
select * from customer
where first_name like 'B%'
limit 3
--question 12
select * from film
where rating like 'G%'
limit 5
--question 13
select * from customer
where first_name like 'A%'
--question 14
select * from customer
where first_name like '%a'
--question 15
select * from city
where city like '%a'
limit 4
--question 16
select * from customer
where first_name like '%ni%'
--question 17
select * from customer
where first_name like '_r%'
--question 18
select * from customer
where first_name like 'a%' and length(first_name) = 5
--question 19
select * from customer
where first_name like'a%' and first_name like '%o'
--question 20
select * from film
where rating like 'pg%'
--question 21
select * from film 
where length >= 50 and length <=100
--question 22
select * from actor
limit 50
--question 23
SELECT DISTINCT film_id
FROM inventory;



