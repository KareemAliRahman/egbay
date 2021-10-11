DROP DATABASE IF EXISTS egbay;

CREATE DATABASE egbay with OWNER=egbay;

-- ALTER ROLE egbay

\c egbay

CREATE TABLE "person" (
	id SERIAL PRIMARY KEY,
	username TEXT UNIQUE NOT NULL,
	-- Password VARCHAR(40) NOT NULL,
	name TEXT NOT NULL,
	dob DATE
	-- Role VARCHAR(40) NOT NULL,
);

CREATE TABLE "category" (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	description TEXT NOT NULL,
	created_By INT NOT NULL,
	CONSTRAINT fk_category_person
		FOREIGN KEY(created_by)
			REFERENCES person(id)
);

CREATE TABLE "product" (
	id SERIAL PRIMARY KEY,
	name TEXT NOT NULL,
	description TEXT NOT NULL,
	price MONEY Not NULL,
	category_id INT NOT NULL, 
	created_by INT NOT NULL, 
	created_at DATE NOT NULL,
	is_archived BOOLEAN NOT NULL, 
	CONSTRAINT fk_product_person
		FOREIGN KEY(created_by)
			REFERENCES person(id),
	CONSTRAINT fk_product_category
		FOREIGN KEY(category_id)
			REFERENCES category(id)
);

INSERT INTO person (username, name, dob)
VALUES 
('admin','admin','1988-08-01'),
('manager', 'manager', '1988-08-02'),
('customer', 'customer', '1988-08-03');

INSERT INTO category (name, description, created_by)
VALUES
('reading', 'all things related to reading', 1),
('household devices', 'all things related to household devices', 1),
('category 1', 'description of category 1', 1),
('category 2', 'description of category 2', 1),
('category 3', 'description of category 3', 1),
('category 4', 'description of category 4', 1);

INSERT INTO product (name, description, price, category_id, created_by, created_at, is_archived)
VALUES 
('Air Conditioner', 'A high quality Air conditioner', 1499.9, 1, 1, '2021-01-02'::timestamp, FALSE),
('Fan', 'high quality fan', 149.99, 1,1, '2021-02-02'::timestamp, FALSE),
('Fan1', 'high quality fan', 149.99, 3,1, '2021-03-02'::timestamp, FALSE),
('Fan2', 'high quality fan', 149.99, 3,1, '2021-04-02'::timestamp, FALSE),
('Fan3', 'high quality fan', 149.99, 3,1, '2021-05-02'::timestamp, FALSE),
('Fan4', 'high quality fan', 149.99, 3,1, '2021-06-02'::timestamp, FALSE),
('Book', 'high quality book', 19.99, 1,1, '2021-07-02'::timestamp, TRUE);

-- create table person
-- (
--   id serial primary key
--   , name text not null
--   , email text not null
--   dob date -- date of birth
-- )

-- insert into users(name, email) values ('John', 'john@mail.com');
-- insert into users(name, email) values ('Kareem', 'kareem@mail.com');
-- insert into users(name, email) values ('Hazem', 'hazem@mail.com');
-- insert into users(name, email) values ('Mahmoud', 'mahmoud@mail.com');
-- insert into users(name, email) values ('Ahmed', 'ahmed@mail.com');
-- insert into users(name, email) values ('Tamer', 'tamer@mail.com');

-- create table product
-- (
--   id serial primary key
--   , name text not null
--   , category
-- )