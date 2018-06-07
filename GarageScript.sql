
-----------------------------------------------
------------------/* SUBJECT INFO */-----------
-----------------------------------------------


--Subject: CSY2038  Assignment 2: Roddys Garage


-----------------------------------------------
------------------/* DATABASE INFO */----------
-----------------------------------------------


--TYPES: 5
--VARRAYS: 7
--NESTED TABLES: 1
--TABLES: 6

--QUERIES: 16
--FUNCTIONS: 12
--PROCEDURES: 13 + 8 (with Cursors)
--TRIGGERS: 10 + 3 (with Cursors)
--CURSORS: 11


-----------------------------------------------
------------------/* DROP CONSTRAINTS */-------
-----------------------------------------------


ALTER TABLE customers
DROP CONSTRAINT ck_customer_firstname;

ALTER TABLE customers
DROP CONSTRAINT ck_customer_surname;

ALTER TABLE mechanics
DROP CONSTRAINT ck_mechanic_firstname;

ALTER TABLE mechanics
DROP CONSTRAINT ck_mechanic_surname;

ALTER TABLE parts
DROP CONSTRAINT ck_part_name;

ALTER TABLE customers
DROP CONSTRAINT ck_customer_gender;

ALTER TABLE bookings
DROP CONSTRAINT ck_bookings_fixed;

ALTER TABLE parts
DROP CONSTRAINT ck_ordered_status;

ALTER TABLE bookings
DROP CONSTRAINT fk_b_customer_cars;

ALTER TABLE bookings
DROP CONSTRAINT fk_b_mechanics;

ALTER TABLE customer_cars
DROP CONSTRAINT fk_c_customers;

ALTER TABLE replaced_parts
DROP CONSTRAINT fk_r_bookings;

ALTER TABLE replaced_parts
DROP CONSTRAINT fk_r_parts;

ALTER TABLE customers
DROP CONSTRAINT pk_customers;

ALTER TABLE mechanics
DROP CONSTRAINT pk_mechanics;

ALTER TABLE bookings
DROP CONSTRAINT pk_bookings;

ALTER TABLE customer_cars
DROP CONSTRAINT pk_customer_cars;

ALTER TABLE parts
DROP CONSTRAINT pk_parts;

ALTER TABLE replaced_parts
DROP CONSTRAINT pk_replaced_parts;


-----------------------------------------------
------------------/* DROP TABLES */------------
-----------------------------------------------


DROP SEQUENCE customers_seq;
DROP SEQUENCE mechanics_seq;
DROP SEQUENCE bookings_seq;
DROP SEQUENCE customer_cars_seq;
DROP SEQUENCE parts_seq;

DROP TABLE customers;
DROP TABLE mechanics;
DROP TABLE bookings;
DROP TABLE customer_cars;
DROP TABLE parts;
DROP TABLE replaced_parts;
DROP TABLE addresses;

DROP TABLE log_table_users;
DROP TABLE log_table_mechanics;
DROP TABLE log_table_creations;


-----------------------------------------------
------------------/* DROP TYPES */-------------
-----------------------------------------------


DROP TYPE compatibility_table_type;

DROP TYPE address_type;
DROP TYPE diagnosis_type;
DROP TYPE characteristics_type;
DROP TYPE part_characteristics_type;

DROP TYPE manufacturers_varray_type;
DROP TYPE models_varray_type;
DROP TYPE years_made_varray_type;
DROP TYPE displacements_varray_type;
DROP TYPE colors_varray_type;

DROP TYPE part_manufacturers_varray_type;
DROP TYPE suppliers_varray_type;


-----------------------------------------------
------------------/* DROP FUNCTIONS */---------
-----------------------------------------------


DROP FUNCTION func_bookings;
DROP FUNCTION func_username;
DROP FUNCTION func_salary;
DROP FUNCTION func_commission;
DROP FUNCTION func_total_cost;
DROP FUNCTION func_totalcost_byname;
DROP FUNCTION func_rating;
DROP FUNCTION func_car_manufacturer;
DROP FUNCTION func_car_model;
DROP FUNCTION func_car_yearmade;
DROP FUNCTION func_car_displacements;
DROP FUNCTION func_booking_cost;


-----------------------------------------------
------------------/* DROP PROCEDURES */--------
-----------------------------------------------


DROP PROCEDURE proc_bookings_func;
DROP PROCEDURE proc_showinfo_func;
DROP PROCEDURE proc_add_customer;
DROP PROCEDURE proc_evaluation_func;
DROP PROCEDURE proc_evaluationbyname_func;
DROP PROCEDURE proc_notfixed;
DROP PROCEDURE proc_parts_car;
DROP PROCEDURE proc_manufacturers;
DROP PROCEDURE proc_bad_manufacturers;
DROP PROCEDURE proc_parts_notordered;
DROP PROCEDURE proc_booking_cost_func;
DROP PROCEDURE proc_mechanics_car;
DROP PROCEDURE proc_car_characteristics_func;

DROP PROCEDURE proc_mechanics_comm_cur;
DROP PROCEDURE proc_notfixed_cur;
DROP PROCEDURE proc_parts_car_cur;
DROP PROCEDURE proc_manufacturers_cur;
DROP PROCEDURE proc_bad_manufacturers_cur;
DROP PROCEDURE proc_car_characteristics_cur;
DROP PROCEDURE proc_parts_cur;
DROP PROCEDURE proc_foreign_mechanics_cur;


-----------------------------------------------
------------------/* DROP TRIGGERS */----------
-----------------------------------------------


DROP TRIGGER logon_trigg;
DROP TRIGGER logoff_trigg;
DROP TRIGGER create_trigg;
DROP TRIGGER prevent_drop_trigg;
DROP TRIGGER secure_insert_trigg;
DROP TRIGGER customers_trigg;
DROP TRIGGER check_salary_trigg;
DROP TRIGGER mechanics_trigg;
DROP TRIGGER date_constraint_trigg;
DROP TRIGGER bookings_trigg;

DROP TRIGGER check_customers_ins_trigg;
DROP TRIGGER check_mechanics_ins_trigg;
DROP TRIGGER check_replacedparts_ins_trigg;

PURGE RECYCLEBIN;


-----------------------------------------------
------------------/* CREATE VARRAYS */---------
-----------------------------------------------


CREATE TYPE manufacturers_varray_type AS VARRAY(20) OF VARCHAR2(40);
/

CREATE TYPE models_varray_type AS VARRAY(80) OF VARCHAR2(40);
/

CREATE TYPE years_made_varray_type AS VARRAY(40) OF VARCHAR2(4);
/

CREATE TYPE displacements_varray_type AS VARRAY(30) OF VARCHAR2(6);
/

CREATE TYPE colors_varray_type AS VARRAY(20) OF VARCHAR2(40); 
/

CREATE TYPE part_manufacturers_varray_type AS VARRAY(80) OF VARCHAR2(40);
/

CREATE TYPE suppliers_varray_type AS VARRAY(40) OF VARCHAR2(40);
/


-----------------------------------------------
------------------/* CREATE TYPES */-----------
-----------------------------------------------


CREATE OR REPLACE TYPE address_type AS OBJECT (
street                        VARCHAR2(25),
street_no                     VARCHAR2(15),
city                          VARCHAR2(25),
country                       VARCHAR2(25));
/

CREATE OR REPLACE TYPE diagnosis_type AS OBJECT (
description                   VARCHAR2(200),
delivery_date                 DATE);
/

CREATE OR REPLACE TYPE characteristics_type AS OBJECT (
manufacturers                 manufacturers_varray_type,
model                         models_varray_type,
year_made                     years_made_varray_type,
displacements                 displacements_varray_type,
colors                        colors_varray_type);
/

CREATE OR REPLACE TYPE part_characteristics_type AS OBJECT (
part_manufacturer             part_manufacturers_varray_type,
suppliers                     suppliers_varray_type);
/

CREATE TYPE compatibility_table_type AS TABLE OF manufacturers_varray_type;
/


-----------------------------------------------
------------------/* CREATE TABLES */----------
-----------------------------------------------


CREATE TABLE addresses OF address_type;

CREATE TABLE customers (
customer_id                   NUMBER(6),
firstname                     VARCHAR2(25)         NOT NULL,
surname                       VARCHAR2(25)         NOT NULL,
gender                        CHAR,
address                       REF address_type SCOPE IS addresses,
phone_number                  VARCHAR2(15)         NOT NULL,
date_of_birth                 DATE);

CREATE TABLE mechanics (
mechanic_id                   NUMBER(6),
firstname                     VARCHAR2(25)         NOT NULL,
surname                       VARCHAR2(25)         NOT NULL,
gender                        CHAR,
address                       address_type,
phone_number                  VARCHAR2(15)         NOT NULL,
salary                        NUMBER(10,2)         NOT NULL,
commission                    NUMBER(10,2)         NOT NULL,
date_hired                    DATE                 NOT NULL,
profile                       CLOB);

CREATE TABLE bookings (
booking_id                    NUMBER(6),
customer_car_id               NUMBER(6),
mechanic_id                   NUMBER(6),
complaint                     VARCHAR2(300)        NOT NULL,
booking_date                  DATE                 NOT NULL,
fixed                         CHAR,
diagnosis                     diagnosis_type);


CREATE TABLE customer_cars (
customer_car_id               NUMBER(6),
customer_id                   NUMBER(6),
characteristics               characteristics_type);

CREATE TABLE parts (
part_id                       NUMBER(6),
part_number                   NUMBER(6),
name                          VARCHAR2(25)         NOT NULL,
price                         NUMBER(10,2)         NOT NULL,
stock                         NUMBER(6)            NOT NULL,
ordered_status                CHAR                 NOT NULL,
part_characteristics          part_characteristics_type,
compatibility                 compatibility_table_type)
NESTED TABLE compatibility STORE AS compatibility_table;

CREATE TABLE replaced_parts (
booking_id                    NUMBER(6),
part_id                       NUMBER(6),
quantity                      NUMBER(2)            NOT NULL);


-----------------------------------------------
------------------/* PRIMARY KEYS */-----------
-----------------------------------------------


ALTER TABLE customers
ADD CONSTRAINT pk_customers
PRIMARY KEY (customer_id);

ALTER TABLE mechanics
ADD CONSTRAINT pk_mechanics
PRIMARY KEY (mechanic_id);

ALTER TABLE bookings
ADD CONSTRAINT pk_bookings
PRIMARY KEY (booking_id);

ALTER TABLE customer_cars
ADD CONSTRAINT pk_customer_cars
PRIMARY KEY (customer_car_id);

ALTER TABLE parts
ADD CONSTRAINT pk_parts
PRIMARY KEY (part_id);

ALTER TABLE replaced_parts
ADD CONSTRAINT pk_replaced_parts
PRIMARY KEY (booking_id, part_id);


-----------------------------------------------
------------------/* FOREIGN KEYS */-----------
-----------------------------------------------


ALTER TABLE bookings
ADD CONSTRAINT fk_b_customer_cars
FOREIGN KEY (customer_car_id)
REFERENCES customer_cars(customer_car_id);

ALTER TABLE bookings
ADD CONSTRAINT fk_b_mechanics
FOREIGN KEY (mechanic_id)
REFERENCES mechanics(mechanic_id);

ALTER TABLE customer_cars
ADD CONSTRAINT fk_c_customers
FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE replaced_parts
ADD CONSTRAINT fk_r_bookings
FOREIGN KEY (booking_id)
REFERENCES bookings(booking_id);

ALTER TABLE replaced_parts
ADD CONSTRAINT fk_r_parts
FOREIGN KEY (part_id)
REFERENCES parts(part_id);


-----------------------------------------------
------------------/* CHECK CONSTRAINTS */------
-----------------------------------------------


ALTER TABLE customers
ADD CONSTRAINT ck_customer_firstname
CHECK (firstname = upper(firstname));

ALTER TABLE customers
ADD CONSTRAINT ck_customer_surname
CHECK (surname = upper(surname));


ALTER TABLE mechanics
ADD CONSTRAINT ck_mechanic_firstname
CHECK (firstname = upper(firstname));

ALTER TABLE mechanics
ADD CONSTRAINT ck_mechanic_surname
CHECK (surname = upper(surname));

ALTER TABLE parts
ADD CONSTRAINT ck_part_name
CHECK (name = upper(name));

ALTER TABLE customers
ADD CONSTRAINT ck_customer_gender
CHECK (gender IN ('M','F'));

ALTER TABLE bookings
ADD CONSTRAINT ck_bookings_fixed
CHECK (fixed IN ('Y','N'));

ALTER TABLE parts
ADD CONSTRAINT ck_ordered_status
CHECK (ordered_status IN ('Y','N'));


-----------------------------------------------
------------------/* CREATE SEQUENCES */-------
-----------------------------------------------


CREATE SEQUENCE customers_seq
START WITH 1 INCREMENT BY 1
NOMAXVALUE
NOCACHE;

CREATE SEQUENCE mechanics_seq
START WITH 1 INCREMENT BY 1
NOMAXVALUE
NOCACHE;

CREATE SEQUENCE bookings_seq
START WITH 1 INCREMENT BY 1
NOMAXVALUE
NOCACHE;

CREATE SEQUENCE customer_cars_seq
START WITH 1 INCREMENT BY 1
NOMAXVALUE
NOCACHE;

CREATE SEQUENCE parts_seq
START WITH 1 INCREMENT BY 1
NOMAXVALUE
NOCACHE;


-----------------------------------------------
------------------/* INSERT DATA */------------
-----------------------------------------------


ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY'
NLS_DATE_LANGUAGE = 'ENGLISH';


-- Insert into object table addresses

INSERT INTO addresses(street,street_no,city,country)
VALUES('EGNATIA','18', 'THESSALONIKI','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('EGNATIA','108', 'THESSALONIKI','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('EGNATIA','207', 'THESSALONIKI','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('TSIMISKI','32', 'THESSALONIKI','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('TSIMISKI','152', 'THESSALONIKI','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('OLYMPIADOS','59', 'THESSALONIKI','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('ERMOU','167', 'ATHENS','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('FILIPPOU','69', 'ATHENS','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('KASSANDROU','175', 'ATHENS','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('DODEKANHSOU','92', 'THESSALONIKI','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('KASSANDROU','48', 'DRAMA','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('METEORON','12', 'THESSALONIKI','GREECE');

INSERT INTO addresses(street,street_no,city,country)
VALUES('EGNATIA','20', 'THESSALONIKI','GREECE');


-- Insert into table customers, we get address data from object table

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'LINUS', 'TORVALDS','M','46123487','14-07-1990', REF(a)
FROM addresses a
WHERE street = 'EGNATIA' AND street_no = '18';

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'LIN', 'ROBERTS','F','46852277','14-06-1987', REF(a)
FROM addresses a
WHERE street = 'EGNATIA' AND street_no = '108';

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'TOVE', 'TORVALDS','F','46158487','28-12-1985', REF(a)
FROM addresses a
WHERE street = 'EGNATIA' AND street_no = '207';

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'JANE', 'DOE','F','46649787','6-11-1979', REF(a)
FROM addresses a
WHERE street = 'TSIMISKI' AND street_no = '32';

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'JOHN', 'DOE','M','41624487','29-10-1978', REF(a)
FROM addresses a
WHERE street = 'TSIMISKI' AND street_no = '152';

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'JULIA', 'ROBERTS','M','44857487','14-01-1979', REF(a)
FROM addresses a
WHERE street = 'OLYMPIADOS' AND street_no = '59';

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'SHEYLA', 'SMITH','F','46123333','11-02-1982', REF(a)
FROM addresses a
WHERE street = 'ERMOU' AND street_no = '167';

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'RUDYARD', 'NATHANSON','M','46121827','10-05-1988', REF(a)
FROM addresses a
WHERE street = 'FILIPPOU' AND street_no = '69';

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'ASHER', 'ABRAHAMS','M','46126477','7-09-1986', REF(a)
FROM addresses a
WHERE street = 'KASSANDROU' AND street_no = '175';

INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth, address)
SELECT customers_seq.NEXTVAL, 'ARIC', 'MORSE','M','46432187','26-08-1984', REF(a)
FROM addresses a
WHERE street = 'DODEKANHSOU' AND street_no = '92';


-- Insert into table mechanics, without accessing object table

INSERT INTO mechanics (mechanic_id, firstname, surname, gender, phone_number, salary, commission, date_hired, address)
VALUES (mechanics_seq.NEXTVAL, 'FRANKIE', 'FAY','F','46000487', 15000, 8.21, '25-02-1992', 
                              address_type('KASSANDROU', '48', 'DRAMA','GREECE')
);

INSERT INTO mechanics (mechanic_id, firstname, surname, gender, phone_number, salary, commission, date_hired, address)
VALUES (mechanics_seq.NEXTVAL, 'LLOYD', 'KEVINSON','M','46144487', 16000, 9.24, '15-11-1989',
                              address_type('METEORON', '12', 'THESSALONIKI','GREECE')
);

INSERT INTO mechanics (mechanic_id, firstname, surname, gender, phone_number, salary, commission, date_hired, address)
VALUES (mechanics_seq.NEXTVAL, 'GORDON', 'MARSHALL','M','46123337', 18000, 15.95, '9-05-1989',
                              address_type('EGNATIA', '20', 'THESSALONIKI','GREECE')
);


-- Insert into table customer_cars

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 1, characteristics_type (manufacturers_varray_type ('MERCEDES'),
                                                            models_varray_type('BENZ'),
                                                            years_made_varray_type('2016'),
                                                            displacements_varray_type('2800'),
                                                            colors_varray_type('BLACK')
                                            )
);

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 2, characteristics_type (manufacturers_varray_type ('LEXUS'),
                                                            models_varray_type('LS HYBRID'),
                                                            years_made_varray_type('2016'),
                                                            displacements_varray_type('3000'),
                                                            colors_varray_type('SILVER')
                                            )
);

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 3, characteristics_type (manufacturers_varray_type ('LEXUS'),
                                                            models_varray_type('LS HYBRID'),
                                                            years_made_varray_type('2016'),
                                                            displacements_varray_type('3400'),
                                                            colors_varray_type('BLACK')
                                            )
);

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 4, characteristics_type (manufacturers_varray_type ('MAZDA'),
                                                            models_varray_type('RX-7'),
                                                            years_made_varray_type('2007'),
                                                            displacements_varray_type('2600'),
                                                            colors_varray_type('RED')
                                            )
);

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 5, characteristics_type (manufacturers_varray_type ('NISSAN'),
                                                            models_varray_type('SKYLINE'),
                                                            years_made_varray_type('2010'),
                                                            displacements_varray_type('2800'),
                                                            colors_varray_type('SILVER')
                                            )
);

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 6, characteristics_type (manufacturers_varray_type ('MERCEDES'),
                                                            models_varray_type('BENZ'),
                                                            years_made_varray_type('2016'),
                                                            displacements_varray_type('2800'),
                                                            colors_varray_type('BLACK')
                                            )
);

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 7, characteristics_type (manufacturers_varray_type ('BMW'),
                                                            models_varray_type('M3'),
                                                            years_made_varray_type('2008'),
                                                            displacements_varray_type('2200'),
                                                            colors_varray_type('YELLOW')
                                            )
);

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 8, characteristics_type (manufacturers_varray_type ('MAZDA'),
                                                            models_varray_type('RX-8'),
                                                            years_made_varray_type('2008'),
                                                            displacements_varray_type('2800'),
                                                            colors_varray_type('BLACK')
                                            )
);

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 9, characteristics_type (manufacturers_varray_type ('HONDA'),
                                                            models_varray_type('CIVIC TYPE-R'),
                                                            years_made_varray_type('2010'),
                                                            displacements_varray_type('2800'),
                                                            colors_varray_type('BLACK')
                                            )
);

INSERT INTO customer_cars (customer_car_id, customer_id, characteristics)
VALUES (customer_cars_seq.NEXTVAL, 10, characteristics_type (manufacturers_varray_type ('MITSUBISHI'),
                                                            models_varray_type('LANCER EVOLUTION'),
                                                            years_made_varray_type('2007'),
                                                            displacements_varray_type('2400'),
                                                            colors_varray_type('BLACK')
                                            )
);


-- Insert into table parts

INSERT INTO parts(part_id, part_number, name, price, stock, ordered_status, part_characteristics, compatibility)
VALUES (parts_seq.NEXTVAL, 111102, 'FRONT TIRES', 2000, 4, 'Y', part_characteristics_type (
                                                                      part_manufacturers_varray_type('ACTRON TECHNOLOGY'),
                                                                      suppliers_varray_type('THESSALONIKI MERCEDES')
                                                                      ),
                                                                      compatibility_table_type (
                                                                                                manufacturers_varray_type('MERCEDES')
));

INSERT INTO parts(part_id, part_number, name, price, stock, ordered_status, part_characteristics, compatibility)
VALUES (parts_seq.NEXTVAL, 111103, 'BUMPER', 600, 0, 'Y', part_characteristics_type (
                                                                      part_manufacturers_varray_type('NIPRESS'),
                                                                      suppliers_varray_type('THESSALONIKI MERCEDES')
                                                                      ),
                                                                      compatibility_table_type (
                                                                                                manufacturers_varray_type('MERCEDES')
));

INSERT INTO parts(part_id, part_number, name, price, stock, ordered_status, part_characteristics, compatibility)
VALUES (parts_seq.NEXTVAL, 111104, 'DISTRIBUTOR', 2200, 4, 'Y', part_characteristics_type (
                                                                      part_manufacturers_varray_type('MARKET CREATORS'),
                                                                      suppliers_varray_type('MAZDA HELLAS')
                                                                      ),
                                                                      compatibility_table_type (
                                                                                                manufacturers_varray_type('MAZDA')
));

INSERT INTO parts(part_id, part_number, name, price, stock, ordered_status, part_characteristics, compatibility)
VALUES (parts_seq.NEXTVAL, 111105, 'BUMPER', 600, 0, 'Y', part_characteristics_type (
                                                                     part_manufacturers_varray_type('JBM AUTO'),
                                                                     suppliers_varray_type('HONDA PAPADOPOULOS')
                                                                     ),
                                                                      compatibility_table_type (
                                                                                                manufacturers_varray_type('HONDA')
));

INSERT INTO parts(part_id, part_number, name, price, stock, ordered_status, part_characteristics, compatibility)
VALUES (parts_seq.NEXTVAL, 111106, 'SPARK PLUG', 600, 10, 'N', part_characteristics_type (
                                                                     part_manufacturers_varray_type('FIEM INDUSTRIES'),
                                                                     suppliers_varray_type('MAZDA HELLAS')
                                                                     ),
                                                                      compatibility_table_type (
                                                                                                manufacturers_varray_type('MAZDA')
));

INSERT INTO parts(part_id, part_number, name, price, stock, ordered_status, part_characteristics, compatibility)
VALUES (parts_seq.NEXTVAL, 111107, 'FUEL LEVEL SENSOR', 750, 9, 'N', part_characteristics_type (
                                                                     part_manufacturers_varray_type('JBM AUTO'),
                                                                     suppliers_varray_type('THESSALONIKI MERCEDES')
                                                                     ),
                                                                      compatibility_table_type (
                                                                                                manufacturers_varray_type('MERCEDES')
));


-- Insert into table bookings

INSERT INTO bookings(booking_id, customer_car_id, mechanic_id, complaint, fixed, booking_date, diagnosis)
VALUES (bookings_seq.NEXTVAL, 8, 1, 'I have problem steering the wheel', 'Y', '02-11-2016',
                                            diagnosis_type ('Mechanic malfunction', '05-11-2016')
);

INSERT INTO bookings(booking_id, customer_car_id, mechanic_id, complaint, fixed, booking_date, diagnosis)
VALUES (bookings_seq.NEXTVAL, 1, 2, 'The car does not accelerate fast', 'Y', '23-09-2016',
                                            diagnosis_type ('Electronic circuit needs updating', '27-09-2016')
);

INSERT INTO bookings(booking_id, customer_car_id, mechanic_id, complaint, fixed, booking_date, diagnosis)
VALUES (bookings_seq.NEXTVAL, 4, 3, 'Fridge liquid is missing', 'N', '10-01-2017',
                                            diagnosis_type ('Fridge is broken', '16-01-2017')
);

INSERT INTO bookings(booking_id, customer_car_id, mechanic_id, complaint, fixed, booking_date, diagnosis)
VALUES (bookings_seq.NEXTVAL, 9, 1, 'I have trouble starting the engine', 'Y', '05-03-2017',
                                            diagnosis_type ('The battery is almost dead', '07-03-2017')
);

INSERT INTO bookings(booking_id, customer_car_id, mechanic_id, complaint, fixed, booking_date, diagnosis)
VALUES (bookings_seq.NEXTVAL, 1, 3, 'The brakes do not work very well', 'Y', '07-03-2017',
                                            diagnosis_type ('Not enough brakes liquid', '09-03-2017')
);

INSERT INTO bookings(booking_id, customer_car_id, mechanic_id, complaint, fixed, booking_date, diagnosis)
VALUES (bookings_seq.NEXTVAL, 2, 3, 'The car tends to turn left', 'Y', '10-03-2017',
                                            diagnosis_type ('The left wheel is defective', '12-03-2017')
);

INSERT INTO bookings(booking_id, customer_car_id, mechanic_id, complaint, fixed, booking_date, diagnosis)
VALUES (bookings_seq.NEXTVAL, 7, 1, 'The lights go off unexpectedely', 'Y', '11-03-2017',
                                            diagnosis_type ('Electrical malfunction', '16-03-2017')
);

INSERT INTO bookings(booking_id, customer_car_id, mechanic_id, complaint, fixed, booking_date, diagnosis)
VALUES (bookings_seq.NEXTVAL, 10, 3, 'I need a car service', 'Y', '12-MAR-2017',
                                            diagnosis_type ('Normal annual service', '20-03-2017')
);

INSERT INTO bookings(booking_id, customer_car_id, mechanic_id, complaint, fixed, booking_date, diagnosis)
VALUES (bookings_seq.NEXTVAL, 10, 2, 'I need a car service', 'N', '13-03-2017',
                                            diagnosis_type ('Normal annual service', '21-03-2017')
);


-- Insert into table replaced_parts

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(1, 1, 1);

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(1, 4, 1);

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(2, 4, 2);

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(3, 3, 1);

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(3, 2, 1);

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(4, 5, 1);

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(5, 3, 1);

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(5, 2, 2);

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(6, 1, 1);

INSERT INTO replaced_parts(booking_id, part_id, quantity)
VALUES(7, 1, 1);


-----------------------------------------------
------------------/* SIMPLE QUERIES */---------
-----------------------------------------------


-- 1. Show customers who live in Thessaloniki

COLUMN customer_id HEADING 'ID';
COLUMN firstname HEADING 'Firstname' FORMAT A15;
COLUMN surname HEADING 'Surname' FORMAT A15;
COLUMN address.street HEADING 'Street' FORMAT A15;
COLUMN address.street_no HEADING 'No' FORMAT A5;

SELECT customer_id, firstname, surname, s.address.street, s.address.street_no
FROM customers s
WHERE s.address.city = 'THESSALONIKI';


-- 2. Show mechanics name and salary that come from another city

COLUMN firstname HEADING 'Firstname' FORMAT A15;
COLUMN surname HEADING 'Surname' FORMAT A15;
COLUMN salary HEADING 'Salary';
COLUMN address.street HEADING 'Street' FORMAT A15;
COLUMN address.street_no HEADING 'No' FORMAT A5;
COLUMN address.city HEADING 'City' FORMAT A15;

SELECT firstname, surname, salary, s.address.street, s.address.street_no, s.address.city
FROM mechanics s
WHERE s.address.city NOT IN 'THESSALONIKI';


-- 3. Show mechanics name and surname where their commision is from 7.50% - 9.50%

COLUMN firstname HEADING 'Firstname' FORMAT A15;
COLUMN surname HEADING 'Surname' FORMAT A10;
COLUMN commission HEADING 'Commission %';

SELECT surname, firstname, commission, ROUND(commission), FLOOR(commission)
FROM mechanics
WHERE commission BETWEEN 7.50 AND 9.50
ORDER BY commission DESC;


-- 4. Show how many bookings were made from 1st of January until current date by mechanic id 3

SELECT COUNT(booking_id)
FROM bookings
WHERE booking_date BETWEEN TO_DATE('01-JAN-2017') AND SYSDATE
AND mechanic_id = 3;


-- 5. Show booking dates and customer cost where a specific mechanic Gordon Marshall was assigned to the booking

COLUMN booking_date HEADING 'Booking Date' FORMAT A15;
COLUMN (ii.quantity*iii.price) HEADING 'Customer cost';

SELECT i.booking_date, (ii.quantity * iii.price)
FROM bookings i
JOIN replaced_parts ii
ON i.booking_id = ii.booking_id
JOIN parts iii
ON iii.part_id = ii.part_id
WHERE i.mechanic_id IN (
                        SELECT mechanic_id
                        FROM mechanics
                        WHERE firstname = 'GORDON' AND surname = 'MARSHALL');


-- 6. Show booking details where the mechanic could not fix the car

COLUMN booking_id HEADING 'ID';
COLUMN complaint HEADING 'Complaint' FORMAT A25;
COLUMN booking_date HEADING 'Booking Date' FORMAT A15;
COLUMN diagnosis.description HEADING 'Diagnosis' FORMAT A25;

SELECT booking_id, complaint, booking_date, b.diagnosis.description
FROM bookings b
WHERE fixed = 'N';


-- 7. Show booking id, complaint and diagnosis description where the customer cost was more than 1000

COLUMN booking_id HEADING 'ID';
COLUMN complaint HEADING 'Complaint' FORMAT A25;
COLUMN diagnosis.description HEADING 'Diagnosis' FORMAT A25;
COLUMN (ii.quantity*iii.price) HEADING 'Customer cost';

SELECT i.booking_id, i.complaint, i.diagnosis.description, (ii.quantity * iii.price)
FROM bookings i
JOIN replaced_parts ii
ON i.booking_id = ii.booking_id
JOIN parts iii
ON iii.part_id = ii.part_id
WHERE (ii.quantity * iii.price) > 1000;


-- 8. Show mechanics that have worked with customer car id 1

COLUMN firstname HEADING 'Firstname' FORMAT A15;
COLUMN surname HEADING 'Surname' FORMAT A15;

SELECT firstname, surname
FROM mechanics
JOIN bookings
ON bookings.mechanic_id = mechanics.mechanic_id
JOIN customer_cars
ON bookings.customer_car_id = customer_cars.customer_car_id
WHERE customer_cars.customer_car_id = 1
ORDER BY surname;


-- 9. Show the parts that have been replaced for all bookings of customer car id 1

COLUMN iii.name HEADING 'Part name' FORMAT A15;
COLUMN iii.price HEADING 'Price';
COLUMN iii.stock HEADING 'Stock';

SELECT iii.name, iii.price, iii.stock
FROM bookings i
JOIN replaced_parts ii
ON i.booking_id = ii.booking_id
JOIN parts iii
ON iii.part_id = ii.part_id
WHERE i.customer_car_id = 1;


-- 10. Show all parts that have been replaced, by stock ascending order

COLUMN iii.part_id HEADING 'ID';
COLUMN iii.name HEADING 'Part name' FORMAT A15;
COLUMN iii.price HEADING 'Price';
COLUMN iii.stock HEADING 'Stock';

SELECT iii.part_id, iii.name, iii.price, iii.stock
FROM bookings i
JOIN replaced_parts ii
ON i.booking_id = ii.booking_id
JOIN parts iii
ON iii.part_id = ii.part_id
ORDER BY iii.stock ASC;


-- 11. Create welcome message for mechanics with their newly created username

SELECT CONCAT('Good morning', 
             CONCAT
                   (INITCAP(SUBSTR(TRIM(TRAILING ' ' FROM firstname), 2, 3)),
                    LOWER(SUBSTR(surname, 2, 7)))
             )   
FROM mechanics;


-----------------------------------------------
------------------/* COMPLEX QUERIES */--------
-----------------------------------------------


-- 12. Show all manufacturers of all customer cars of customers

COLUMN firstname HEADING 'Firstname' FORMAT A15;
COLUMN surname HEADING 'Surname' FORMAT A15;
COLUMN column_value HEADING 'Manufacturers';

WITH my_data AS (
                 SELECT firstname, surname, c.characteristics.manufacturers AS manufacturers
                 FROM customers
                 JOIN customer_cars c
                 ON customers.customer_id = c.customer_id
)
SELECT my_data.firstname, my_data.surname, child.*
FROM my_data, TABLE(my_data.manufacturers) child;


-- 13. Show all manufacturers of all customer cars that have at least 2 bookings in the garage

COLUMN customer_car_id HEADING 'Customer ID';
COLUMN customer_id HEADING 'Car ID';
COLUMN column_value HEADING 'Manufacturers';

WITH my_data AS (
                 SELECT customer_id, customer_car_id, c.characteristics.manufacturers AS manufacturers
                 FROM customer_cars c
)
SELECT my_data.customer_id, my_data.customer_car_id, child.*
FROM my_data, TABLE(my_data.manufacturers) child
WHERE my_data.customer_car_id IN (
                                  SELECT customer_car_id
                                  FROM bookings
                                  GROUP BY customer_car_id
                                  HAVING COUNT(booking_id) >= 2);


-- 14. Show car characteristics of customer car from customer id 1

COLUMN customer_car_id HEADING 'Customer ID';
COLUMN column_value HEADING 'Characteristics' FORMAT A15;

WITH my_data AS (
                 SELECT customer_id, c.characteristics.manufacturers AS manufacturers, c.characteristics.model AS model,
                                     c.characteristics.year_made AS year_made, c.characteristics.displacements AS displacements
                 FROM customer_cars c
                 WHERE customer_id = 1
)
SELECT my_data.customer_id, child1.*, child2.*, child3.*, child4.*
FROM my_data, TABLE(my_data.manufacturers) child1, 
              TABLE(my_data.model) child2,
              TABLE(my_data.year_made) child3,
              TABLE(my_data.displacements) child4;


-- 15. Show all part numbers and suppliers of all parts

COLUMN part_number HEADING 'Part Number';
COLUMN column_value HEADING 'Suppliers' FORMAT A25;

WITH my_data AS (
                 SELECT part_number, p.part_characteristics.suppliers AS suppliers
                 FROM parts p
)
SELECT my_data.part_number, child.*
FROM my_data, TABLE(my_data.suppliers) child;


-- 16. Show all part numbers and characteristics of the parts that have not been ordered yet

COLUMN part_number HEADING 'Part Number';
COLUMN column_value HEADING 'Characteristics' FORMAT A21;

WITH my_data AS (
                 SELECT part_number, p.part_characteristics.part_manufacturer AS part_manufacturer,
                                     p.part_characteristics.suppliers AS suppliers
                 FROM parts p, TABLE(p.compatibility) child1
                 WHERE ordered_status = 'N'
)
SELECT my_data.part_number, child1.*, child2.*
FROM my_data, TABLE(my_data.part_manufacturer) child1,
              TABLE(my_data.suppliers) child2;


-----------------------------------------------
------------------/* FUNCTIONS */--------------
-----------------------------------------------


SET SERVEROUTPUT ON;

-- 1. Return number of bookings of a customer car id

CREATE OR REPLACE FUNCTION func_bookings
(in_customer_car_id bookings.customer_car_id%TYPE) RETURN NUMBER IS

     vn_booking_ct NUMBER(4);

BEGIN

     SELECT COUNT(*)
     INTO vn_booking_ct 
     FROM bookings
     WHERE customer_car_id = in_customer_car_id;

RETURN vn_booking_ct;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_bookings;
/
SHOW ERRORS;


-- 2. Return username of a mechanic id

CREATE OR REPLACE FUNCTION func_username
(in_mechanic_id mechanics.mechanic_id%TYPE) RETURN VARCHAR2 IS

     vc_username   VARCHAR2(10);

BEGIN

     SELECT CONCAT(
              INITCAP(SUBSTR(TRIM(TRAILING ' ' FROM firstname), 2, 3)),
              LOWER(SUBSTR(surname, 2, 7))
     )   
     INTO vc_username 
     FROM mechanics
     WHERE mechanic_id = in_mechanic_id;

RETURN vc_username;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_username;
/
SHOW ERRORS;


-- 3. Return salary of a mechanic id

CREATE OR REPLACE FUNCTION func_salary
(in_mechanic_id mechanics.mechanic_id%TYPE) RETURN NUMBER IS

     vn_salary   mechanics.salary%TYPE;

BEGIN

     SELECT salary
     INTO vn_salary 
     FROM mechanics
     WHERE mechanic_id = in_mechanic_id;

RETURN vn_salary;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_salary;
/
SHOW ERRORS;


-- 4. Return commission of a mechanic id

CREATE OR REPLACE FUNCTION func_commission
(in_mechanic_id mechanics.mechanic_id%TYPE) RETURN NUMBER IS

     vn_commission   mechanics.commission%TYPE;

BEGIN

     SELECT commission
     INTO vn_commission 
     FROM mechanics
     WHERE mechanic_id = in_mechanic_id;

RETURN vn_commission;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_commission;
/
SHOW ERRORS;


-- 5. Return total customer cost from a booking id

CREATE OR REPLACE FUNCTION func_booking_cost
(in_booking_id bookings.booking_id%TYPE) RETURN NUMBER IS

     vn_booking_cost   NUMBER(10,2);

BEGIN

     SELECT SUM(ii.quantity * iii.price)
     INTO vn_booking_cost
     FROM bookings i
     JOIN replaced_parts ii
     ON i.booking_id = ii.booking_id
     JOIN parts iii
     ON iii.part_id = ii.part_id
     WHERE i.booking_id = in_booking_id;

RETURN vn_booking_cost;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_booking_cost;
/
SHOW ERRORS;


-- 6. Return total customer cost that was generated by a specific mechanic

CREATE OR REPLACE FUNCTION func_total_cost
(in_mechanic_id mechanics.mechanic_id%TYPE) RETURN NUMBER IS

     vn_total_cost   NUMBER(10,2);

BEGIN

     SELECT SUM(ii.quantity * iii.price)
     INTO vn_total_cost
     FROM bookings i
     JOIN replaced_parts ii
     ON i.booking_id = ii.booking_id
     JOIN parts iii
     ON iii.part_id = ii.part_id
     WHERE i.mechanic_id = in_mechanic_id;

RETURN vn_total_cost;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_total_cost;
/
SHOW ERRORS;


-- 7. Return mechanic rating in varchar, according to total cost generated

CREATE OR REPLACE FUNCTION func_rating
(in_total_cost mechanics.salary%TYPE) RETURN VARCHAR2 IS

     vc_rating   VARCHAR2(40);

BEGIN

     IF in_total_cost > 15000 THEN
          vc_rating := 'Excellent performance!!!';

     ELSIF in_total_cost > 8000 THEN
          vc_rating := 'Good performance.';

     ELSIF in_total_cost < 8000 THEN
          vc_rating := 'Bad performance.';
     
     END IF;

RETURN vc_rating;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_rating;
/
SHOW ERRORS;


-- 8. Return total customer cost that was generated by a specific mechanic surname

CREATE OR REPLACE FUNCTION func_totalcost_byname
(in_surname mechanics.surname%TYPE) RETURN NUMBER IS

     vn_total_cost   NUMBER(10,2);

BEGIN

     SELECT SUM(ii.quantity * iii.price)
     INTO vn_total_cost
     FROM bookings i
     JOIN replaced_parts ii
     ON i.booking_id = ii.booking_id
     JOIN parts iii
     ON iii.part_id = ii.part_id
     WHERE i.mechanic_id IN (
                        SELECT mechanic_id
                        FROM mechanics
                        WHERE surname = in_surname);

RETURN vn_total_cost;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_totalcost_byname;
/
SHOW ERRORS;


-- 9. Return the manufacturer of a customer car id

CREATE OR REPLACE FUNCTION func_car_manufacturer
(in_customer_car_id customer_cars.customer_car_id%TYPE) RETURN VARCHAR2 IS

     vc_car_manufacturer   VARCHAR2(40);

BEGIN

     WITH my_data AS (
                 SELECT c.characteristics.manufacturers AS manufacturers
                 FROM customer_cars c
                 WHERE customer_car_id = in_customer_car_id)
     SELECT child1.*
     INTO vc_car_manufacturer
     FROM my_data, TABLE(my_data.manufacturers) child1;

RETURN vc_car_manufacturer;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_car_manufacturer;
/
SHOW ERRORS;


-- 10. Return the model of a customer car id

CREATE OR REPLACE FUNCTION func_car_model
(in_customer_car_id customer_cars.customer_car_id%TYPE) RETURN VARCHAR2 IS

     vc_car_model   VARCHAR2(40);

BEGIN

     WITH my_data AS (
                 SELECT c.characteristics.model AS model
                 FROM customer_cars c
                 WHERE customer_car_id = in_customer_car_id)
     SELECT child1.*
     INTO vc_car_model
     FROM my_data, TABLE(my_data.model) child1;

RETURN vc_car_model;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_car_model;
/
SHOW ERRORS;


-- 11. Return the year made of a customer car id

CREATE OR REPLACE FUNCTION func_car_yearmade
(in_customer_car_id customer_cars.customer_car_id%TYPE) RETURN VARCHAR2 IS

     vc_car_yearmade   VARCHAR2(4);

BEGIN

     WITH my_data AS (
                 SELECT c.characteristics.year_made AS year_made
                 FROM customer_cars c
                 WHERE customer_car_id = in_customer_car_id)
     SELECT child1.*
     INTO vc_car_yearmade
     FROM my_data, TABLE(my_data.year_made) child1;

RETURN vc_car_yearmade;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_car_yearmade;
/
SHOW ERRORS;


-- 12. Return the displacements of a customer car id

CREATE OR REPLACE FUNCTION func_car_displacements
(in_customer_car_id customer_cars.customer_car_id%TYPE) RETURN VARCHAR2 IS

     vc_car_displacements   VARCHAR2(6);

BEGIN

     WITH my_data AS (
                 SELECT c.characteristics.displacements AS displacements
                 FROM customer_cars c
                 WHERE customer_car_id = in_customer_car_id)
     SELECT child1.*
     INTO vc_car_displacements
     FROM my_data, TABLE(my_data.displacements) child1;

RETURN vc_car_displacements;
EXCEPTION WHEN NO_DATA_FOUND THEN RETURN NULL;
END func_car_displacements;
/
SHOW ERRORS;


-----------------------------------------------
------------------/* PROCEDURES */-------------
-----------------------------------------------


SET SERVEROUTPUT ON;

-- 1. Return number of bookings of a customer car id
-- Usage: EXECUTE proc_bookings_func(10);

CREATE OR REPLACE PROCEDURE proc_bookings_func
(in_customer_car_id bookings.customer_car_id%TYPE) IS

     vn_no_of_bookings NUMBER(4);

BEGIN

     vn_no_of_bookings := func_bookings(in_customer_car_id);
     DBMS_OUTPUT.PUT_LINE ('The number of bookings with this car is ' || vn_no_of_bookings);

END proc_bookings_func;
/
SHOW ERRORS;


-- 2. Return username, salary and commission of a mechanic id
-- Usage: EXECUTE proc_showinfo_func(3);

CREATE OR REPLACE PROCEDURE proc_showinfo_func
(in_mechanic_id mechanics.mechanic_id%TYPE) IS

     vc_username VARCHAR2(10);
     vn_salary mechanics.salary%TYPE;
     vn_commission mechanics.commission%TYPE;

BEGIN

     vc_username := func_username(in_mechanic_id);
     vn_salary := func_salary(in_mechanic_id);
     vn_commission := func_commission(in_mechanic_id);
     DBMS_OUTPUT.PUT_LINE ('Username is ' || vc_username);
     DBMS_OUTPUT.PUT_LINE ('Salary is ' || vn_salary || ' GBP');
     DBMS_OUTPUT.PUT_LINE ('Commission is ' || vn_commission || '%');

END proc_showinfo_func;
/
SHOW ERRORS;


-- 3. Procedure to add a customer
-- Usage: EXECUTE proc_add_customer('PAUL', 'PAPADOPOULOS', 'M', '6999999999', '01-01-1980');

CREATE OR REPLACE PROCEDURE proc_add_customer
(in_firstname customers.firstname%TYPE,
 in_surname customers.surname%TYPE,
 in_gender customers.gender%TYPE,
 in_phone_number customers.phone_number%TYPE,
 in_date_of_birth customers.date_of_birth%TYPE) IS

BEGIN

     INSERT INTO customers (customer_id, firstname, surname, gender, phone_number, date_of_birth)
     VALUES (customers_seq.NEXTVAL, in_firstname, in_surname, in_gender, in_phone_number, in_date_of_birth);
     DBMS_OUTPUT.PUT_LINE('Added customer: ' || in_surname || ', ' || in_firstname);

EXCEPTION WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error adding customer: ' || in_surname || ', ' || in_firstname);
END proc_add_customer;
/
SHOW ERRORS;


-- 4. Show total customer cost generated by a specific mechanic
-- Usage: EXECUTE proc_evaluation_func(3);

CREATE OR REPLACE PROCEDURE proc_evaluation_func
(in_mechanic_id mechanics.mechanic_id%TYPE) IS

     vn_total_cost    NUMBER(10,2);

BEGIN

     vn_total_cost := func_total_cost(in_mechanic_id);
     DBMS_OUTPUT.PUT_LINE ('Total earnings generated ' || vn_total_cost || ' GBP');
     
     DBMS_OUTPUT.PUT_LINE (func_rating(vn_total_cost));

END proc_evaluation_func;
/
SHOW ERRORS;


-- 5. Show total customer cost from a booking id
-- Usage: EXECUTE proc_booking_cost_func(1);

CREATE OR REPLACE PROCEDURE proc_booking_cost_func
(in_booking_id bookings.booking_id%TYPE) IS

     vn_booking_cost   NUMBER(10,2);

BEGIN

     vn_booking_cost := func_booking_cost(in_booking_id);

     DBMS_OUTPUT.PUT_LINE ('Booking ID: ' || in_booking_id || ' customer cost: ' || vn_booking_cost);

END proc_booking_cost_func;
/
SHOW ERRORS;


-- 6. Show total customer cost generated by a specific mechanic surname
-- Usage: EXECUTE proc_evaluationbyname_func('MARSHALL');

CREATE OR REPLACE PROCEDURE proc_evaluationbyname_func
(in_surname mechanics.surname%TYPE) IS

     vn_total_cost    NUMBER(10,2);

BEGIN

     vn_total_cost := func_totalcost_byname(in_surname);
     DBMS_OUTPUT.PUT_LINE ('Total earnings generated by ' || in_surname || ': ' || vn_total_cost || ' GBP');

     DBMS_OUTPUT.PUT_LINE (func_rating(vn_total_cost));

END proc_evaluationbyname_func;
/
SHOW ERRORS;


-- 7. Show mechanics firstname, surname and booking id where they could not fix the car
-- Usage: EXECUTE proc_notfixed;

CREATE OR REPLACE PROCEDURE proc_notfixed AS

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     FOR x IN (
               SELECT mechanic_id
               FROM bookings
               WHERE fixed = 'N')
     LOOP
          DBMS_OUTPUT.PUT_LINE ('Mechanic ID: ' || x.mechanic_id);

          FOR xsurname IN (
               SELECT surname
               FROM mechanics
               WHERE mechanic_id = x.mechanic_id)
          LOOP
               DBMS_OUTPUT.PUT_LINE ('Surname: ' || xsurname.surname);
          END LOOP;

          FOR xfirstname IN (
               SELECT firstname
               FROM mechanics
               WHERE mechanic_id = x.mechanic_id)
          LOOP
               DBMS_OUTPUT.PUT_LINE ('Firstname: '  || xfirstname.firstname);
          END LOOP;

          FOR xbooking_id IN (
               SELECT booking_id
               FROM bookings
               WHERE mechanic_id = x.mechanic_id
               AND fixed = 'N')
          LOOP
               DBMS_OUTPUT.PUT_LINE ('Booking ID: '  || xbooking_id.booking_id);
          END LOOP;

          DBMS_OUTPUT.PUT_LINE (chr(13));

     END LOOP;

END proc_notfixed;
/
SHOW ERRORS;


-- 8. Show mechanics that have worked with given customer car id
-- Usage: EXECUTE proc_mechanics_car(1);

CREATE OR REPLACE PROCEDURE proc_mechanics_car
(in_customer_car_id customer_cars.customer_car_id%TYPE) IS

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     FOR x IN (
               SELECT m.mechanic_id, m.firstname, m.surname
               FROM mechanics m
               JOIN bookings
               ON bookings.mechanic_id = m.mechanic_id
               JOIN customer_cars
               ON bookings.customer_car_id = customer_cars.customer_car_id
               WHERE customer_cars.customer_car_id = in_customer_car_id)
     LOOP
          DBMS_OUTPUT.PUT_LINE ('Mechanic ID: ' || x.mechanic_id);
          DBMS_OUTPUT.PUT_LINE ('Surname: ' || x.surname);
          DBMS_OUTPUT.PUT_LINE ('Firstname: '  || x.firstname);

          DBMS_OUTPUT.PUT_LINE (chr(13));

     END LOOP;

END proc_mechanics_car;
/
SHOW ERRORS;


-- 9. Show the parts that have been replaced for all bookings of given customer car id
-- Usage: EXECUTE proc_parts_car(1);

CREATE OR REPLACE PROCEDURE proc_parts_car
(in_customer_car_id customer_cars.customer_car_id%TYPE) IS

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     FOR x IN (
               SELECT iii.part_id, iii.name, iii.price, iii.stock
               FROM bookings i
               JOIN replaced_parts ii
               ON i.booking_id = ii.booking_id
               JOIN parts iii
               ON iii.part_id = ii.part_id
               WHERE i.customer_car_id = in_customer_car_id)
     LOOP
          DBMS_OUTPUT.PUT_LINE ('Part ID: ' || x.part_id);
          DBMS_OUTPUT.PUT_LINE ('Name: ' || x.name);
          DBMS_OUTPUT.PUT_LINE ('Price: ' || x.price);
          DBMS_OUTPUT.PUT_LINE ('Stock: ' || x.stock);

          DBMS_OUTPUT.PUT_LINE (chr(13));

     END LOOP;

END proc_parts_car;
/
SHOW ERRORS;


-- 10. Show all manufacturers of all customer cars of customers
-- Usage: EXECUTE proc_manufacturers;

CREATE OR REPLACE PROCEDURE proc_manufacturers IS

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     FOR x IN (
               WITH my_data AS (
                 SELECT firstname, surname, c.characteristics.manufacturers AS manufacturers
                 FROM customers
                 JOIN customer_cars c
                 ON customers.customer_id = c.customer_id)
               SELECT my_data.firstname, my_data.surname, child.*
               FROM my_data, TABLE(my_data.manufacturers) child)
     LOOP

          DBMS_OUTPUT.PUT_LINE ('Surname: ' || X.surname);
          DBMS_OUTPUT.PUT_LINE ('Firstname: ' || X.firstname);
          DBMS_OUTPUT.PUT_LINE ('Car manufacturer: ' || X.column_value);

          DBMS_OUTPUT.PUT_LINE (chr(13));

     END LOOP;

END proc_manufacturers;
/
SHOW ERRORS;


-- 11. Show all manufacturers of all customer cars that have at least 2 bookings in the garage
-- Usage: EXECUTE proc_bad_manufacturers;

CREATE OR REPLACE PROCEDURE proc_bad_manufacturers IS

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     FOR x IN (
               WITH my_data AS (
                 SELECT customer_id, customer_car_id, c.characteristics.manufacturers AS manufacturers
                 FROM customer_cars c)
               SELECT my_data.customer_id, my_data.customer_car_id, child.*
               FROM my_data, TABLE(my_data.manufacturers) child
               WHERE my_data.customer_car_id IN (
                                                 SELECT customer_car_id
                                                 FROM bookings
                                                 GROUP BY customer_car_id
                                                 HAVING COUNT(booking_id) >= 2))
     LOOP

          DBMS_OUTPUT.PUT_LINE ('Car ID: ' || X.customer_id);
          DBMS_OUTPUT.PUT_LINE ('Customer ID: ' || X.customer_car_id);
          DBMS_OUTPUT.PUT_LINE ('Car manufacturer: ' || X.column_value);

          DBMS_OUTPUT.PUT_LINE (chr(13));

     END LOOP;

END proc_bad_manufacturers;
/
SHOW ERRORS;


-- 12. Show characteristics of a customer car id
-- Usage: EXECUTE proc_car_characteristics_func(1);

CREATE OR REPLACE PROCEDURE proc_car_characteristics_func 
(in_customer_car_id customer_cars.customer_car_id%TYPE) IS

     vc_car_manufacturer   VARCHAR2(40);
     vc_car_model   VARCHAR2(40);
     vc_car_yearmade   VARCHAR2(4);
     vc_car_displacements   VARCHAR2(6);

BEGIN

     vc_car_manufacturer := func_car_manufacturer(in_customer_car_id);
     vc_car_model := func_car_model(in_customer_car_id);
     vc_car_yearmade := func_car_yearmade(in_customer_car_id);
     vc_car_displacements := func_car_displacements(in_customer_car_id);

     DBMS_OUTPUT.PUT_LINE ('Car manufacturer: ' || vc_car_manufacturer);
     DBMS_OUTPUT.PUT_LINE ('Car model: ' || vc_car_model);
     DBMS_OUTPUT.PUT_LINE ('Car yearmade: ' || vc_car_yearmade);
     DBMS_OUTPUT.PUT_LINE ('Car displacements: ' || vc_car_displacements);

END proc_car_characteristics_func;
/
SHOW ERRORS;


-- 13. Show all part numbers and suppliers of the parts that have not been ordered yet
-- Usage: EXECUTE proc_parts_notordered;

CREATE OR REPLACE PROCEDURE proc_parts_notordered IS

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     FOR x IN (
               WITH my_data AS (
                 SELECT part_number, name, p.part_characteristics.suppliers AS suppliers
                 FROM parts p, TABLE(p.compatibility) child
                 WHERE ordered_status = 'N')
               SELECT my_data.part_number, my_data.name, child.*
               FROM my_data, TABLE(my_data.suppliers) child)
     LOOP

          DBMS_OUTPUT.PUT_LINE ('Part number: ' || X.part_number);
          DBMS_OUTPUT.PUT_LINE ('Part name: ' || X.name);
          DBMS_OUTPUT.PUT_LINE ('Supplier: ' || X.column_value);

          DBMS_OUTPUT.PUT_LINE (chr(13));

     END LOOP;

END proc_parts_notordered;
/
SHOW ERRORS;


-----------------------------------------------
------------------/* TRIGGERS */---------------
-----------------------------------------------


SELECT SYS_CONTEXT ('USERENV', 'CURRENT_SCHEMA') FROM DUAL;


-- Tables for triggers

CREATE TABLE log_table_users (
user_id                       VARCHAR2(30),
action                        VARCHAR2(30),
log_date                      DATE);

CREATE TABLE log_table_creations (
user_id                       VARCHAR2(30),
object_type                   VARCHAR2(30),
object_name                   VARCHAR2(30),
object_owner                  VARCHAR2(30),
creation_date                 DATE);

CREATE TABLE log_table_mechanics (
user_id                       VARCHAR2(30),
action                        VARCHAR2(30),
log_date                      DATE,
mechanic_id                   NUMBER(6),
old_salary                    NUMBER(10,2),
new_salary                    NUMBER(10,2),
old_commission                NUMBER(10,2),
new_commission                NUMBER(10,2));


-- 1. After user logon, create log

CREATE OR REPLACE TRIGGER logon_trigg
AFTER LOGON ON CSY2038.SCHEMA

BEGIN 

     INSERT INTO log_table_users (user_id, log_date, action) 
     VALUES (USER, SYSDATE, 'Logged in');

END logon_trigg;
/
SHOW ERRORS;


-- 2. Before user logoff, create log

CREATE OR REPLACE TRIGGER logoff_trigg
BEFORE LOGOFF ON CSY2038.SCHEMA

BEGIN 

     INSERT INTO log_table_users (user_id, log_date, action) 
     VALUES (USER, SYSDATE, 'Logged off');

END logoff_trigg;
/
SHOW ERRORS;


-- 3. After creating table, create log

CREATE OR REPLACE TRIGGER create_trigg 
AFTER CREATE ON CSY2038.SCHEMA 

BEGIN 

     INSERT INTO log_table_creations (user_id, object_type, object_name, object_owner, creation_date)
     VALUES (USER, SYS.DICTIONARY_OBJ_TYPE, SYS.DICTIONARY_OBJ_NAME, SYS.DICTIONARY_OBJ_OWNER, SYSDATE);

END create_trigg;
/
SHOW ERRORS;


-- 4. Before deleting a table, show a message and prevent the action

CREATE OR REPLACE TRIGGER prevent_drop_trigg 
BEFORE DROP ON CSY2038.SCHEMA

BEGIN 

     RAISE_APPLICATION_ERROR (-20101, 'You are not allowed to drop tables'); 

END prevent_drop_trigg;
/
SHOW ERRORS;


-- 5. Before inserting into customers, show message and prevent the action if outside of working days

CREATE OR REPLACE TRIGGER secure_insert_trigg
BEFORE INSERT ON customers

BEGIN

     IF TO_CHAR(SYSDATE,'DY') IN ('SAT','SUN') THEN
           RAISE_APPLICATION_ERROR(-20102, 'You are not allowed to insert into CUSTOMERS table outside of working days');
     END IF;

END secure_insert_trigg;
/
SHOW ERRORS;


-- 6. Before inserting/updating date of birth into customers, show message and prevent the action for wrong date

CREATE OR REPLACE TRIGGER date_constraint_trigg
BEFORE INSERT OR UPDATE OF date_of_birth ON customers FOR EACH ROW

DECLARE

vd_today DATE;

BEGIN

     SELECT SYSDATE 
     INTO vd_today
     FROM DUAL;

     IF :NEW.date_of_birth > vd_today THEN 
           RAISE_APPLICATION_ERROR(-20103, 'Date of birth must be before current date'); 
     ELSE NULL;
     END IF;

END date_constraint_trigg;
/
SHOW ERRORS;


-- 7. After insert/update/delete on customers table, create log for each row

CREATE OR REPLACE TRIGGER customers_trigg 
AFTER INSERT OR UPDATE OR DELETE ON customers FOR EACH ROW

BEGIN 

     IF INSERTING THEN 
           INSERT INTO log_table_users (user_id, log_date, action) 
           VALUES (USER, SYSDATE, 'Inserted into table customers');

     ELSIF UPDATING THEN 
           INSERT INTO log_table_users (user_id, log_date, action) 
           VALUES (USER, SYSDATE, 'Updated on table customers');

     ELSIF DELETING THEN 
           INSERT INTO log_table_users (user_id, log_date, action) 
           VALUES (USER, SYSDATE, 'Deleted from table customers');

     END IF;

END customers_trigg;
/
SHOW ERRORS;


-- 8. After insert/update/delete on bookings table, create log for each row

CREATE OR REPLACE TRIGGER bookings_trigg 
AFTER INSERT OR UPDATE OR DELETE ON bookings FOR EACH ROW

BEGIN 

     IF INSERTING THEN 
           INSERT INTO log_table_users (user_id, log_date, action) 
           VALUES (USER, SYSDATE, 'Inserted into table bookings');

     ELSIF UPDATING THEN 
           INSERT INTO log_table_users (user_id, log_date, action) 
           VALUES (USER, SYSDATE, 'Updated on table bookings');

     ELSIF DELETING THEN 
           INSERT INTO log_table_users (user_id, log_date, action) 
           VALUES (USER, SYSDATE, 'Deleted from table bookings');

     END IF;

END bookings_trigg;
/
SHOW ERRORS;


-- 9. Before updating salary on mechanics table, show message and prevent the action if new salary < 700

CREATE OR REPLACE TRIGGER check_salary_trigg
BEFORE UPDATE of salary ON mechanics FOR EACH ROW 
WHEN(NEW.salary < 700) 

BEGIN 

     RAISE_APPLICATION_ERROR (-20103, 'Do not decrease salary below 700'); 

END check_salary_trigg;
/
SHOW ERRORS;


-- 10. After insert/update/delete on mechanics table, create log for each row with old and new values

CREATE OR REPLACE TRIGGER mechanics_trigg 
AFTER INSERT OR UPDATE OR DELETE ON mechanics FOR EACH ROW

BEGIN 

     IF INSERTING THEN 
           INSERT INTO log_table_mechanics (user_id, log_date, action, mechanic_id,
                                            old_salary, new_salary, old_commission, new_commission)
           VALUES (USER, SYSDATE, 'Inserted into table', :NEW.mechanic_id, :OLD.salary, :NEW.salary, :OLD.commission, :NEW.commission);

     ELSIF UPDATING THEN 
           INSERT INTO log_table_mechanics (user_id, log_date, action, mechanic_id,
                                            old_salary, new_salary, old_commission, new_commission)
           VALUES (USER, SYSDATE, 'Inserted into table', :NEW.mechanic_id, :OLD.salary, :NEW.salary, :OLD.commission, :NEW.commission);

     ELSIF DELETING THEN 
           INSERT INTO log_table_mechanics (user_id, log_date, action, mechanic_id,
                                            old_salary, new_salary, old_commission, new_commission)
           VALUES (USER, SYSDATE, 'Inserted into table', :NEW.mechanic_id, :OLD.salary, :NEW.salary, :OLD.commission, :NEW.commission);

     END IF;

END mechanics_trigg;
/
SHOW ERRORS;


-- 11. Prevent duplicate entries in customers table (trigger with cursor)

CREATE OR REPLACE TRIGGER check_customers_ins_trigg 
BEFORE INSERT OR UPDATE ON customers FOR EACH ROW

DECLARE

PRAGMA AUTONOMOUS_TRANSACTION;

CURSOR cur_customers_ins IS 
     SELECT firstname, surname, date_of_birth
     FROM customers;

     v_surname customers.surname%TYPE; 
     v_firstname customers.firstname%TYPE;
     v_date_of_birth customers.date_of_birth%TYPE;

BEGIN

     OPEN cur_customers_ins;
     LOOP

          FETCH cur_customers_ins INTO v_firstname, v_surname, v_date_of_birth;
          EXIT WHEN cur_customers_ins%NOTFOUND;

          IF :NEW.surname = v_surname THEN
               IF :NEW.firstname = v_firstname THEN
                    IF :NEW.date_of_birth = v_date_of_birth THEN

                         RAISE_APPLICATION_ERROR (-20104, 'A customer with the same firstname/surname/date of birth already exists');
  
                    END IF;
               END IF;
          END IF;

     END LOOP;
     CLOSE cur_customers_ins; 

COMMIT;
END check_customers_ins_trigg;
/
SHOW ERRORS;


-- 12. Prevent duplicate entries in mechanics table (trigger with cursor)

CREATE OR REPLACE TRIGGER check_mechanics_ins_trigg 
BEFORE INSERT OR UPDATE ON mechanics FOR EACH ROW

DECLARE

PRAGMA AUTONOMOUS_TRANSACTION;

CURSOR cur_mechanics_ins IS 
     SELECT firstname, surname, date_hired
     FROM mechanics;

     v_surname customers.surname%TYPE; 
     v_firstname customers.firstname%TYPE;
     v_date_hired mechanics.date_hired%TYPE;

BEGIN

     OPEN cur_mechanics_ins;
     LOOP

          FETCH cur_mechanics_ins INTO v_firstname, v_surname, v_date_hired;
          EXIT WHEN cur_mechanics_ins%NOTFOUND;

          IF :NEW.surname = v_surname THEN
               IF :NEW.firstname = v_firstname THEN
                    IF :NEW.date_hired = v_date_hired THEN

                         RAISE_APPLICATION_ERROR (-20105, 'A mechanic with the same firstname/surname/date hired already exists');
  
                    END IF;
               END IF;
          END IF;

     END LOOP;
     CLOSE cur_mechanics_ins; 

COMMIT;
END check_mechanics_ins_trigg;
/
SHOW ERRORS;


-- 13. Prevent replaced parts entries where the current stock of a part is 0 (trigger with cursor)

CREATE OR REPLACE TRIGGER check_replacedparts_ins_trigg 
BEFORE INSERT OR UPDATE ON replaced_parts FOR EACH ROW

DECLARE

CURSOR cur_replacedparts_ins IS 
     SELECT part_id, stock
     FROM parts;

     v_part_id parts.part_id%TYPE;
     v_stock parts.stock%TYPE;

BEGIN

     OPEN cur_replacedparts_ins;
     LOOP

          FETCH cur_replacedparts_ins INTO v_part_id, v_stock;
          EXIT WHEN cur_replacedparts_ins%NOTFOUND;

          IF :NEW.part_id = v_part_id THEN
               IF v_stock = 0 THEN
                    RAISE_APPLICATION_ERROR (-20106, 'A replacement part has 0 stock, please order part ID ' || v_part_id);
               END IF;
          END IF;

     END LOOP;
     CLOSE cur_replacedparts_ins;

END check_replacedparts_ins_trigg;
/
SHOW ERRORS;


-----------------------------------------------
------------------/* CURSORS */----------------
-----------------------------------------------


-- 1. Show mechanics name, surname and salary that come from another city
-- Usage: EXECUTE proc_foreign_mechanics_cur;

CREATE OR REPLACE PROCEDURE proc_foreign_mechanics_cur IS
CURSOR cur_foreign_mechanics IS 
     SELECT firstname, surname, salary, s.address.city
     FROM mechanics s
     WHERE s.address.city NOT IN 'THESSALONIKI';

     v_surname mechanics.surname%TYPE; 
     v_firstname mechanics.firstname%TYPE;
     v_salary mechanics.salary%TYPE;
     v_city VARCHAR2(25);

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     OPEN cur_foreign_mechanics;
     LOOP

          FETCH cur_foreign_mechanics INTO v_surname, v_firstname, v_salary, v_city;
          EXIT WHEN cur_foreign_mechanics%NOTFOUND;

          DBMS_OUTPUT.PUT_LINE ('Surname: ' || v_surname || ' Firstname: ' || v_firstname || ' Salary: ' || v_salary || ' GBP');
          DBMS_OUTPUT.PUT_LINE ('Lives in: ' || v_city);
          DBMS_OUTPUT.PUT_LINE (chr(13));
  
     END LOOP;
     CLOSE cur_foreign_mechanics;

END proc_foreign_mechanics_cur;
/
SHOW ERRORS;


-- 2. Show mechanics name and surname where their commision is from 7.50% - 9.50% and total customer cost generated
-- Usage: EXECUTE proc_mechanics_comm_cur;

CREATE OR REPLACE PROCEDURE proc_mechanics_comm_cur IS
CURSOR cur_mechanics_comm IS 
     SELECT surname, firstname, commission
     FROM mechanics
     WHERE commission BETWEEN 7.50 AND 9.50
     ORDER BY commission DESC;

     v_surname mechanics.surname%TYPE; 
     v_firstname mechanics.firstname%TYPE;
     v_commission mechanics.commission%TYPE;
     vn_total_cost mechanics.salary%TYPE;

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     OPEN cur_mechanics_comm;
     LOOP

          FETCH cur_mechanics_comm INTO v_surname, v_firstname, v_commission;
          vn_total_cost := func_totalcost_byname(v_surname);
          EXIT WHEN cur_mechanics_comm%NOTFOUND;

          DBMS_OUTPUT.PUT_LINE ('Surname: ' || v_surname || ' Firstname: ' || v_firstname || ' Commission: ' || v_commission || '%');
          DBMS_OUTPUT.PUT_LINE ('Total customer cost generated: ' || vn_total_cost || ' GBP');
          DBMS_OUTPUT.PUT_LINE (chr(13));
  
     END LOOP;
     CLOSE cur_mechanics_comm;

END proc_mechanics_comm_cur;
/
SHOW ERRORS;


-- 3. Show booking details where the mechanic could not fix the car
-- Usage: EXECUTE proc_notfixed_cur;

CREATE OR REPLACE PROCEDURE proc_notfixed_cur IS
CURSOR cur_notfixed IS 
     SELECT booking_id, complaint, booking_date, b.diagnosis.description
     FROM bookings b
     WHERE fixed = 'N';

     v_booking_id bookings.booking_id%TYPE; 
     v_complaint bookings.complaint%TYPE;
     v_booking_date bookings.booking_date%TYPE;
     v_diagnosis_description VARCHAR2(200);

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     OPEN cur_notfixed;
     LOOP

          FETCH cur_notfixed INTO v_booking_id, v_complaint, v_booking_date, v_diagnosis_description;
          EXIT WHEN cur_notfixed%NOTFOUND;

          DBMS_OUTPUT.PUT_LINE ('Booking ID: ' || v_booking_id || ' Booking date: ' || v_booking_date);
          DBMS_OUTPUT.PUT_LINE ('Complaint: ' || v_complaint);
          DBMS_OUTPUT.PUT_LINE ('Diagnosis: ' || v_diagnosis_description);
          DBMS_OUTPUT.PUT_LINE (chr(13));
  
     END LOOP;
     CLOSE cur_notfixed;

END proc_notfixed_cur;
/
SHOW ERRORS;


-- 4. Show the parts that have been replaced for all bookings of given customer car id, by stock ascending order
-- Usage: EXECUTE proc_parts_car_cur(1);

CREATE OR REPLACE PROCEDURE proc_parts_car_cur
(in_customer_car_id customer_cars.customer_car_id%TYPE) IS

CURSOR cur_parts_car IS 
     SELECT iii.part_id, iii.name, iii.price, iii.stock
     FROM bookings i
     JOIN replaced_parts ii
     ON i.booking_id = ii.booking_id
     JOIN parts iii
     ON iii.part_id = ii.part_id
     WHERE i.customer_car_id = in_customer_car_id
     ORDER BY iii.stock ASC;

     v_parts_car_record cur_parts_car%ROWTYPE;

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     OPEN cur_parts_car;
     LOOP

          FETCH cur_parts_car INTO v_parts_car_record;
          EXIT WHEN cur_parts_car%NOTFOUND;

          DBMS_OUTPUT.PUT_LINE ('Part ID: ' || v_parts_car_record.part_id);
          DBMS_OUTPUT.PUT_LINE ('Name: ' || v_parts_car_record.name);
          DBMS_OUTPUT.PUT_LINE ('Price: ' || v_parts_car_record.price);
          DBMS_OUTPUT.PUT_LINE ('Stock: ' || v_parts_car_record.stock);
          DBMS_OUTPUT.PUT_LINE (chr(13));
  
     END LOOP;
     CLOSE cur_parts_car;

END proc_parts_car_cur;
/
SHOW ERRORS;


-- 5. Show all manufacturers of all customer cars of customers
-- Usage: EXECUTE proc_manufacturers_cur;

CREATE OR REPLACE PROCEDURE proc_manufacturers_cur IS
CURSOR cur_manufacturers IS 
     WITH my_data AS (
                 SELECT firstname, surname, c.characteristics.manufacturers AS manufacturers
                 FROM customers
                 JOIN customer_cars c
                 ON customers.customer_id = c.customer_id)
     SELECT my_data.firstname, my_data.surname, child.*
     FROM my_data, TABLE(my_data.manufacturers) child;

     v_manufacturers_record cur_manufacturers%ROWTYPE;

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     OPEN cur_manufacturers;
     LOOP

          FETCH cur_manufacturers INTO v_manufacturers_record;
          EXIT WHEN cur_manufacturers%NOTFOUND;

          DBMS_OUTPUT.PUT_LINE ('Surname: ' || v_manufacturers_record.surname);
          DBMS_OUTPUT.PUT_LINE ('Firstname: ' || v_manufacturers_record.firstname);
          DBMS_OUTPUT.PUT_LINE ('Car manufacturer: ' || v_manufacturers_record.column_value);
          DBMS_OUTPUT.PUT_LINE (chr(13));
  
     END LOOP;
     CLOSE cur_manufacturers;

END proc_manufacturers_cur;
/
SHOW ERRORS;


-- 6. Show all manufacturers of all customer cars that have at least 2 bookings in the garage
-- Usage: EXECUTE proc_bad_manufacturers_cur;

CREATE OR REPLACE PROCEDURE proc_bad_manufacturers_cur IS
CURSOR cur_manufacturers IS 
     WITH my_data AS (
                 SELECT customer_id, customer_car_id, c.characteristics.manufacturers AS manufacturers
                 FROM customer_cars c)
     SELECT my_data.customer_id, my_data.customer_car_id, child.*
     FROM my_data, TABLE(my_data.manufacturers) child
     WHERE my_data.customer_car_id IN (
                                  SELECT customer_car_id
                                  FROM bookings
                                  GROUP BY customer_car_id
                                  HAVING COUNT(booking_id) >= 2);

     v_manufacturers_record cur_manufacturers%ROWTYPE;

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     OPEN cur_manufacturers;
     LOOP

          FETCH cur_manufacturers INTO v_manufacturers_record;
          EXIT WHEN cur_manufacturers%NOTFOUND;

          DBMS_OUTPUT.PUT_LINE ('Car ID: ' || v_manufacturers_record.customer_car_id);
          DBMS_OUTPUT.PUT_LINE ('Customer ID: ' || v_manufacturers_record.customer_id);
          DBMS_OUTPUT.PUT_LINE ('Car manufacturer: ' || v_manufacturers_record.column_value);
          DBMS_OUTPUT.PUT_LINE (chr(13));
  
     END LOOP;
     CLOSE cur_manufacturers;

END proc_bad_manufacturers_cur;
/
SHOW ERRORS;


-- 7. Show car characteristics of all customer cars of a specific customer
-- Usage: EXECUTE proc_car_characteristics_cur(1);

CREATE OR REPLACE PROCEDURE proc_car_characteristics_cur 
(in_customer_id customers.customer_id%TYPE) IS

CURSOR cur_car_characteristics IS 
     SELECT customer_car_id
     FROM customer_cars
     WHERE customer_id = in_customer_id;

     v_car_characteristics_record cur_car_characteristics%ROWTYPE;

     vc_car_manufacturer   VARCHAR2(40);
     vc_car_model   VARCHAR2(40);
     vc_car_yearmade   VARCHAR2(4);
     vc_car_displacements   VARCHAR2(6);

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));
     OPEN cur_car_characteristics;
     LOOP

          FETCH cur_car_characteristics INTO v_car_characteristics_record;
          EXIT WHEN cur_car_characteristics%NOTFOUND;

          vc_car_manufacturer := func_car_manufacturer(v_car_characteristics_record.customer_car_id);
          vc_car_model := func_car_model(v_car_characteristics_record.customer_car_id);
          vc_car_yearmade := func_car_yearmade(v_car_characteristics_record.customer_car_id);
          vc_car_displacements := func_car_displacements(v_car_characteristics_record.customer_car_id);

          DBMS_OUTPUT.PUT_LINE ('Car manufacturer: ' || vc_car_manufacturer);
          DBMS_OUTPUT.PUT_LINE ('Car model: ' || vc_car_model);
          DBMS_OUTPUT.PUT_LINE ('Car yearmade: ' || vc_car_yearmade);
          DBMS_OUTPUT.PUT_LINE ('Car displacements: ' || vc_car_displacements);
          DBMS_OUTPUT.PUT_LINE (chr(13));
  
     END LOOP;
     CLOSE cur_car_characteristics;

END proc_car_characteristics_cur;
/
SHOW ERRORS;


-- 8. Show all part numbers and suppliers of all parts that have been ordered or have not been ordered yet
-- Usage: EXECUTE proc_parts_cur('ordered'); -- Usage: EXECUTE proc_parts_cur('notordered');

CREATE OR REPLACE PROCEDURE proc_parts_cur
(in_param parts.name%TYPE) IS

CURSOR cur_parts_o IS 
     WITH my_data AS (
                      SELECT part_number, name, p.part_characteristics.suppliers AS suppliers, ordered_status
                      FROM parts p)
     SELECT my_data.part_number, my_data.name, child.*, my_data.ordered_status
     FROM my_data, TABLE(my_data.suppliers) child
     WHERE ordered_status = 'Y';

     v_parts_o_record cur_parts_o%ROWTYPE;

CURSOR cur_parts_n IS 
     WITH my_data AS (
                      SELECT part_number, name, p.part_characteristics.suppliers AS suppliers, ordered_status
                      FROM parts p)
     SELECT my_data.part_number, my_data.name, child.*, my_data.ordered_status
     FROM my_data, TABLE(my_data.suppliers) child
     WHERE ordered_status = 'N';

     v_parts_n_record cur_parts_n%ROWTYPE;

BEGIN

     DBMS_OUTPUT.PUT_LINE (chr(13));

     IF in_param = 'ordered' THEN
     
          OPEN cur_parts_o;
          LOOP

               FETCH cur_parts_o INTO v_parts_o_record;
               EXIT WHEN cur_parts_o%NOTFOUND;

               DBMS_OUTPUT.PUT_LINE ('Part number: ' || v_parts_o_record.part_number);
               DBMS_OUTPUT.PUT_LINE ('Part name: ' || v_parts_o_record.name);
               DBMS_OUTPUT.PUT_LINE ('Supplier: ' || v_parts_o_record.column_value);
               DBMS_OUTPUT.PUT_LINE ('Ordered status: ' || v_parts_o_record.ordered_status);
               DBMS_OUTPUT.PUT_LINE (chr(13));
  
          END LOOP;
          CLOSE cur_parts_o;

     ELSIF in_param = 'notordered' THEN

          OPEN cur_parts_n;
          LOOP

               FETCH cur_parts_n INTO v_parts_n_record;
               EXIT WHEN cur_parts_n%NOTFOUND;

               DBMS_OUTPUT.PUT_LINE ('Part number: ' || v_parts_n_record.part_number);
               DBMS_OUTPUT.PUT_LINE ('Part name: ' || v_parts_n_record.name);
               DBMS_OUTPUT.PUT_LINE ('Supplier: ' || v_parts_n_record.column_value);
               DBMS_OUTPUT.PUT_LINE ('Ordered status: ' || v_parts_n_record.ordered_status);
               DBMS_OUTPUT.PUT_LINE (chr(13));
  
          END LOOP;
          CLOSE cur_parts_n;

     END IF;

END proc_parts_cur;
/
SHOW ERRORS;


SELECT * FROM TAB;
