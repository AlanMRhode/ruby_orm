-- Alan Rhode

-- Ruby ORM

CREATE TABLE users (
   id serial PRIMARY KEY,   
   fname varchar(50),
   lname varchar(50),
   email varchar(75), 
   dateCreated timestamp DEFAULT current_timestamp);