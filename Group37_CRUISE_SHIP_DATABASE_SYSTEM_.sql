CREATE DATABASE CRUISE_SHIP_DATABASE_SYSTEM;

USE CRUISE_SHIP_DATABASE_SYSTEM;
-- DROP SCHEMA CRUISE_SHIP_DATABASE_SYSTEM;
-- SCHEMA MODIFICATION

CREATE TABLE SHIP(
	SHIP_ID VARCHAR(12) NOT NULL,
    CREW_CAPACITY INT NOT NULL,
    NO_OF_DEPARTMENT INT NOT NULL,
    PRIMARY KEY(SHIP_ID)
);

CREATE TABLE SHIP_NAME(
	SHIP_ID VARCHAR(12) NOT NULL,
    SHIP_NAME VARCHAR(20) NOT NULL,
    PRIMARY KEY(SHIP_ID),
    CONSTRAINT SHIP_NAME FOREIGN KEY(SHIP_ID) REFERENCES SHIP(SHIP_ID) ON UPDATE CASCADE
);

ALTER TABLE SHIP_NAME
DROP CONSTRAINT SHIP_NAME;

ALTER TABLE SHIP
ADD CONSTRAINT SHIP_ID_RELATION FOREIGN KEY(SHIP_ID) REFERENCES SHIP_NAME(SHIP_ID);

CREATE TABLE EMPLOYEE(
	EMPLOYEE_ID VARCHAR(12) NOT NULL,
    FIRST_NAME VARCHAR(20) NOT NULL,
    LAST_NAME VARCHAR(20) NOT NULL,
    COUNTRY VARCHAR(20) NOT NULL,
    PROVINCE VARCHAR(20) NOT NULL,
    CITY VARCHAR(20) NOT NULL,
    STREET VARCHAR(20) NOT NULL,
    POSITION VARCHAR(30) NOT NULL,
    WORKING_DEPARTMENT VARCHAR(30),
    WORKING_SHIP VARCHAR(20),
    PRIMARY KEY(EMPLOYEE_ID),
    CONSTRAINT WORKING_IN FOREIGN KEY(WORKING_SHIP) REFERENCES SHIP(SHIP_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

ALTER TABLE EMPLOYEE ADD SUPERVISOR_ID VARCHAR(20);
ALTER TABLE EMPLOYEE ADD CONSTRAINT FOREIGN KEY(SUPERVISOR_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID) ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE EMPLOYEE_NIC(
	EMPLOYEE_ID VARCHAR(20) NOT NULL,
    NIC VARCHAR(20) NOT NULL,
    PRIMARY KEY(EMPLOYEE_ID),
    CONSTRAINT EMPLOYEE_NIC FOREIGN KEY(EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID) ON UPDATE CASCADE
);

ALTER TABLE EMPLOYEE_NIC DROP CONSTRAINT EMPLOYEE_NIC;
ALTER TABLE EMPLOYEE ADD CONSTRAINT FK_EMPL_ID FOREIGN KEY(EMPLOYEE_ID) REFERENCES EMPLOYEE_NIC(EMPLOYEE_ID);

CREATE TABLE EMPLOYEE_WORKED_SHIP(
	EMPLOYEE_ID VARCHAR(20) NOT NULL,
    PREVIOUS_WORKED_SHIP VARCHAR(30) NOT NULL,
    PRIMARY KEY(EMPLOYEE_ID, PREVIOUS_WORKED_SHIP),
    CONSTRAINT WORKED_SHIP FOREIGN KEY(EMPLOYEE_ID) REFERENCES EMPLOYEE(EMPLOYEE_ID) ON UPDATE CASCADE
);

CREATE TABLE DEPARTMENT(
	DEPARTMENT_ID VARCHAR(20) NOT NULL,
    DEPARTMENT_NAME VARCHAR(50) NOT NULL,
    DEPARTMENT_HEAD VARCHAR(20),
    SHIP_ID VARCHAR(20) NOT NULL,
    NO_OF_WORKERS INT NOT NULL,
    PRIMARY KEY(DEPARTMENT_ID),
    CONSTRAINT FK_DEPARTMENT_HEAD FOREIGN KEY(DEPARTMENT_HEAD) REFERENCES EMPLOYEE(EMPLOYEE_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_SHIP_ID FOREIGN KEY(SHIP_ID) REFERENCES SHIP(SHIP_ID) ON UPDATE CASCADE
);
ALTER TABLE DEPARTMENT
DROP CONSTRAINT FK_SHIP_ID;
ALTER TABLE DEPARTMENT
ADD CONSTRAINT FK_SHIP_ID FOREIGN KEY(SHIP_ID) REFERENCES SHIP_NAME(SHIP_ID);


ALTER TABLE EMPLOYEE
ADD CONSTRAINT FK_WORKING_DEPARTMENT FOREIGN KEY(WORKING_DEPARTMENT) REFERENCES DEPARTMENT(DEPARTMENT_ID)
ON DELETE SET NULL ON UPDATE CASCADE;

CREATE TABLE PASSENGER(
	PASSENGER_ID VARCHAR(20) NOT NULL,
    FIRST_NAME VARCHAR(20) NOT NULL,
    LAST_NAME VARCHAR(20) NOT NULL,
    COUNTRY VARCHAR(20) NOT NULL,
    PROVINCE VARCHAR(20) NOT NULL,
    CITY VARCHAR(20) NOT NULL,
    STREET VARCHAR(20) NOT NULL,
    TRAVELLING_SHIP VARCHAR(20) NOT NULL,
    PRIMARY KEY(PASSENGER_ID),
    CONSTRAINT FK_TRAVELLING_SHIP FOREIGN KEY(TRAVELLING_SHIP)  REFERENCES SHIP(SHIP_ID) ON UPDATE CASCADE
);

ALTER TABLE PASSENGER
DROP CONSTRAINT FK_TRAVELLING_SHIP;
ALTER TABLE PASSENGER
ADD CONSTRAINT FK_TRAVELLING_SHIP FOREIGN KEY(TRAVELLING_SHIP) REFERENCES SHIP_NAME(SHIP_ID) ON UPDATE CASCADE;

CREATE TABLE PASSENGER_PASSPORT(
	PASSENGER_ID VARCHAR(20) NOT NULL,
    PASSPORT VARCHAR(20) NOT NULL,
    PRIMARY KEY(PASSENGER_ID),
    CONSTRAINT FK_PASSENGER_PASSPORT FOREIGN KEY(PASSENGER_ID) REFERENCES PASSENGER(PASSENGER_ID) ON UPDATE CASCADE
);

ALTER TABLE PASSENGER_PASSPORT DROP CONSTRAINT FK_PASSENGER_PASSPORT; 
ALTER TABLE PASSENGER ADD CONSTRAINT FK_PSG_ID FOREIGN KEY(PASSENGER_ID) REFERENCES PASSENGER_PASSPORT(PASSENGER_ID);

CREATE TABLE PASSENGER_CONTACT(
	PASSENGER_ID VARCHAR(20) NOT NULL,
    CONTACT_NUMBER VARCHAR(15) NOT NULL,
    PRIMARY KEY(PASSENGER_ID, CONTACT_NUMBER),
    CONSTRAINT FK_PASSENGER_CONTACT FOREIGN KEY(PASSENGER_ID) REFERENCES PASSENGER(PASSENGER_ID) ON UPDATE CASCADE
);

ALTER TABLE PASSENGER_CONTACT
DROP CONSTRAINT FK_PASSENGER_CONTACT;
ALTER TABLE PASSENGER_CONTACT
ADD CONSTRAINT FK_PASSENGER_CONTACT FOREIGN KEY(PASSENGER_ID) REFERENCES PASSENGER_PASSPORT(PASSENGER_ID);

CREATE TABLE PASSENGER_MEDICAL_HISTORY(
	PASSENGER VARCHAR(20) NOT NULL,
    MEDICATED_DATE DATE NOT NULL,
    MEDICAL_CONDITION VARCHAR(200) NOT NULL,
    MEDICATION VARCHAR(200) NOT NULL,
    PRIMARY KEY(PASSENGER, MEDICATED_DATE),
    CONSTRAINT DEPENDS_ON FOREIGN KEY(PASSENGER) REFERENCES PASSENGER(PASSENGER_ID) ON UPDATE CASCADE
    
);
ALTER TABLE PASSENGER_MEDICAL_HISTORY DROP FOREIGN KEY DEPENDS_ON;
ALTER TABLE PASSENGER_MEDICAL_HISTORY DROP PRIMARY KEY; 
ALTER TABLE PASSENGER_MEDICAL_HISTORY ADD CONSTRAINT DEPENDS_ON FOREIGN KEY(PASSENGER) REFERENCES PASSENGER(PASSENGER_ID) ON UPDATE CASCADE;


CREATE TABLE CABIN(
	DECK INT NOT NULL,
    CABIN_NUMBER INT NOT NULL,
    CABIN_TYPE VARCHAR(30) NOT NULL,
    PRIMARY KEY(DECK, CABIN_NUMBER)
);

ALTER TABLE CABIN DROP PRIMARY KEY;
ALTER TABLE CABIN ADD COLUMN SHIP VARCHAR(20) NOT NULL;
ALTER TABLE CABIN ADD PRIMARY KEY(DECK,CABIN_NUMBER, SHIP); 
ALTER TABLE CABIN ADD CONSTRAINT FK_CABIN_BELONG_SHIP FOREIGN KEY(SHIP) REFERENCES SHIP_NAME(SHIP_ID);

CREATE TABLE CABIN_INCHARGE(
	DECK INT NOT NULL,
    CABIN_NUMBER INT NOT NULL,
    INCHARGE VARCHAR(20) NOT NULL,
    PRIMARY KEY(DECK, CABIN_NUMBER, INCHARGE),
	CONSTRAINT FK_INCHARGE FOREIGN KEY(INCHARGE) REFERENCES EMPLOYEE(EMPLOYEE_ID) ON UPDATE CASCADE,
    CONSTRAINT FK_CABIN_INCHARGE FOREIGN KEY(DECK, CABIN_NUMBER) REFERENCES CABIN(DECK, CABIN_NUMBER)
);

ALTER TABLE CABIN_INCHARGE DROP FOREIGN KEY FK_CABIN_INCHARGE;
ALTER TABLE CABIN_INCHARGE DROP PRIMARY KEY;
ALTER TABLE CABIN_INCHARGE ADD COLUMN SHIP VARCHAR(20) NOT NULL;
ALTER TABLE CABIN_INCHARGE ADD PRIMARY KEY(DECK,CABIN_NUMBER, INCHARGE, SHIP);
ALTER TABLE CABIN_INCHARGE ADD CONSTRAINT FK_CABIN_INCHARGE FOREIGN KEY(DECK, CABIN_NUMBER, SHIP) REFERENCES CABIN(DECK, CABIN_NUMBER, SHIP);

CREATE TABLE CABIN_SERVICE_REQUEST(
	DECK INT NOT NULL,
    CABIN_NUMBER INT NOT NULL,
    REQUEST_DATE DATE NOT NULL,
    SERVICE_REQUEST_TYPE VARCHAR(100) NOT NULL,
    PRIMARY KEY(DECK, CABIN_NUMBER, REQUEST_DATE),
    CONSTRAINT FK_CABIN_SERVICE_REQUEST FOREIGN KEY(DECK, CABIN_NUMBER) REFERENCES CABIN(DECK, CABIN_NUMBER) ON UPDATE CASCADE    
);
ALTER TABLE CABIN_SERVICE_REQUEST DROP FOREIGN KEY FK_CABIN_SERVICE_REQUEST;
ALTER TABLE CABIN_SERVICE_REQUEST DROP PRIMARY KEY;
ALTER TABLE CABIN_SERVICE_REQUEST ADD COLUMN SHIP VARCHAR(20) NOT NULL;
ALTER TABLE CABIN_SERVICE_REQUEST ADD PRIMARY KEY(DECK, CABIN_NUMBER, REQUEST_DATE, SHIP);
ALTER TABLE CABIN_SERVICE_REQUEST ADD CONSTRAINT FK_CABIN_SERVICE_REQUEST FOREIGN KEY(DECK, CABIN_NUMBER, SHIP) 
REFERENCES CABIN(DECK, CABIN_NUMBER, SHIP) ON UPDATE CASCADE;

CREATE TABLE CRUISE_DINNING_RESERVATION(
	DECK INT NOT NULL,
    CABIN_NUMBER INT NOT NULL, 
    RESERVATION_DATE DATE NOT NULL,
    RESERVATION_TIME TIME NOT NULL,
    NUMBER_OF_GUESTS INT NOT NULL,
    PRIMARY KEY(DECK, CABIN_NUMBER, RESERVATION_DATE, RESERVATION_TIME),
    CONSTRAINT FK_CRUISE_DINNING_RESERVATION FOREIGN KEY(DECK, CABIN_NUMBER) REFERENCES CABIN(DECK, CABIN_NUMBER) ON UPDATE CASCADE
    
);
ALTER TABLE CRUISE_DINNING_RESERVATION DROP FOREIGN KEY FK_CRUISE_DINNING_RESERVATION;
ALTER TABLE CRUISE_DINNING_RESERVATION DROP PRIMARY KEY;
ALTER TABLE CRUISE_DINNING_RESERVATION ADD COLUMN SHIP VARCHAR(20) NOT NULL;
ALTER TABLE CRUISE_DINNING_RESERVATION ADD PRIMARY KEY(DECK, CABIN_NUMBER, RESERVATION_DATE, RESERVATION_TIME, SHIP);
ALTER TABLE CRUISE_DINNING_RESERVATION ADD CONSTRAINT FK_CRUISE_DINNING_RESERVATION FOREIGN KEY(DECK, CABIN_NUMBER, SHIP)
REFERENCES CABIN(DECK, CABIN_NUMBER, SHIP) ON UPDATE CASCADE;


CREATE TABLE PORT(
	PORT_ID VARCHAR(20) NOT NULL,
    PORT_NAME VARCHAR(30) NOT NULL,
    LOCATION VARCHAR(100) NOT NULL,
    PRIMARY KEY(PORT_ID)
);

CREATE TABLE CRUISE(
	CRUISE_ID VARCHAR(20) NOT NULL,
    CRUISE_SHIP VARCHAR(20) NOT NULL,
    DEPARTURE_PORT VARCHAR(30),
    DEPARTURE_DATE DATE NOT NULL,
    DESTINATION_PORT VARCHAR(30),
    PRIMARY KEY(CRUISE_ID),
    CONSTRAINT FK_CRUISE_SHIP FOREIGN KEY(CRUISE_SHIP) REFERENCES SHIP(SHIP_ID) ON UPDATE CASCADE,
    CONSTRAINT FK_DEPARTURE_PORT FOREIGN KEY(DEPARTURE_PORT) REFERENCES PORT(PORT_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_DESTINATION_PORT FOREIGN KEY(DESTINATION_PORT) REFERENCES PORT(PORT_ID) ON DELETE SET NULL ON UPDATE CASCADE
);


-- DATA MODIFICATION

-- SHIP_NAME TABLE

INSERT INTO SHIP_NAME VALUES ('SH1', 'Adonia');
INSERT INTO SHIP_NAME VALUES ('SH2', 'Cristal');
INSERT INTO SHIP_NAME VALUES ('SH3', 'Eagle');
INSERT INTO SHIP_NAME VALUES ('SH4', 'Helena');
INSERT INTO SHIP_NAME VALUES ('SH5', 'Lady Nelson');
INSERT INTO SHIP_NAME VALUES ('SH6', 'Iskra');

UPDATE SHIP_NAME SET SHIP_NAME = 'Elissa' WHERE SHIP_ID = 'SH3';
UPDATE SHIP_NAME SET SHIP_NAME = 'Gloria' WHERE SHIP_ID = 'SH1';

DELETE FROM SHIP_NAME WHERE SHIP_ID = 'SH6';

-- SHIP TABLE

INSERT INTO SHIP VALUES ('SH1', 2000, 7);
INSERT INTO SHIP VALUES ('SH2', 3000, 10);
INSERT INTO SHIP VALUES ('SH3', 4000, 12);
INSERT INTO SHIP VALUES ('SH4', 2000, 5);
INSERT INTO SHIP VALUES ('SH5', 1500, 6);

UPDATE SHIP SET CREW_CAPACITY = 3500, NO_OF_DEPARTMENT = 8 WHERE SHIP_ID = 'SH2';
UPDATE SHIP SET CREW_CAPACITY = 4500, NO_OF_DEPARTMENT = 15 WHERE SHIP_ID = 'SH3';

DELETE FROM SHIP WHERE SHIP_ID = 'SH5';

-- EMPLOYEE_NIC TABLE

INSERT INTO EMPLOYEE_NIC VALUES ('SH1EMP1', '200145246325');
INSERT INTO EMPLOYEE_NIC VALUES ('SH1EMP2', '200045786325');
INSERT INTO EMPLOYEE_NIC VALUES ('SH2EMP1', '199945212525');
INSERT INTO EMPLOYEE_NIC VALUES ('SH1EMP3', '199845636575');
INSERT INTO EMPLOYEE_NIC VALUES ('SH3EMP1', '199745249225');
INSERT INTO EMPLOYEE_NIC VALUES ('SH2EMP2', '200145462325');
INSERT INTO EMPLOYEE_NIC VALUES ('SH3EMP2', '200045462325');

UPDATE EMPLOYEE_NIC SET NIC = '200145891325' WHERE EMPLOYEE_ID = 'SH2EMP2';
UPDATE EMPLOYEE_NIC SET NIC = '199845636123' WHERE EMPLOYEE_ID = 'SH3EMP1';

DELETE FROM EMPLOYEE_NIC WHERE EMPLOYEE_ID = 'SH2EMP2';

-- EMPLOYEE TABLE

INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, COUNTRY, PROVINCE, CITY, STREET, POSITION, WORKING_SHIP) 
VALUES ('SH1EMP1', 'Senura', 'Koshala', 'Sri Lanka', 'Eatern', 'Uhana', 'DS.Senanayake Street', 'Cjief Engineer', 'SH1');
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, COUNTRY, PROVINCE, CITY, STREET, POSITION, WORKING_SHIP) 
VALUES ('SH1EMP2', 'Wasanjith', 'Kodikara', 'Austrailiya', 'Queensland', 'Leydens Hill', '20 Bayview Close', 'Captain', 'SH1');
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, COUNTRY, PROVINCE, CITY, STREET, POSITION, WORKING_SHIP) 
VALUES ('SH2EMP1', 'Hirusha', 'Kularathne', 'Bangaladesh', 'Dhaka', 'Dhaka', '7/2, north dhanmondi', 'Chief Engineer', 'SH2');
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, COUNTRY, PROVINCE, CITY, STREET, POSITION, WORKING_SHIP) 
VALUES ('SH1EMP3', 'David', 'Smith', 'Germany', 'Sachsen-Anhalt', 'Förderstedt', 'Feldstrasse 26', 'Coock', 'SH1');
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, COUNTRY, PROVINCE, CITY, STREET, POSITION, WORKING_SHIP) 
VALUES ('SH3EMP1', 'Kris', 'Gail', 'Jamaica', 'Ocho Rios', 'Ocho Rios', '103 Main St', 'Seaman', 'SH3');
INSERT INTO EMPLOYEE (EMPLOYEE_ID, FIRST_NAME, LAST_NAME, COUNTRY, PROVINCE, CITY, STREET, POSITION, WORKING_SHIP) 
VALUES ('SH3EMP2', 'Virat', 'Kholi', 'India', 'Maharashtra', 'Mumbai', 'Temkar Street', 'Cleaner', 'SH3');

UPDATE EMPLOYEE SET POSITION = 'Chief Engineer', SUPERVISOR_ID = 'SH1EMP2' WHERE EMPLOYEE_ID = 'SH1EMP1';
UPDATE EMPLOYEE SET SUPERVISOR_ID = 'SH1EMP2'  WHERE EMPLOYEE_ID = 'SH2EMP3';
UPDATE EMPLOYEE SET POSITION = 'Seaman', STREET = 'North Dhanmondi' WHERE EMPLOYEE_ID = 'SH2EMP1';
UPDATE EMPLOYEE SET POSITION = 'Chief Cook' WHERE EMPLOYEE_ID = 'SH3EMP2';
UPDATE EMPLOYEE SET POSITION = 'Cook', SUPERVISOR_ID = 'SH3EMP2' WHERE EMPLOYEE_ID = 'SH3EMP1';
-- UPDATE EMPLOYEE SET WORKING_DEPARTMENT = 'SH1DP1' WHERE EMPLOYEE_ID = 'SH1EMP1';
-- UPDATE EMPLOYEE SET WORKING_DEPARTMENT = 'SH1DP2' WHERE EMPLOYEE_ID = 'SH1EMP2';
-- UPDATE EMPLOYEE SET WORKING_DEPARTMENT = 'SH3DP3' WHERE EMPLOYEE_ID = 'SH3EMP1';
-- UPDATE EMPLOYEE SET WORKING_DEPARTMENT = 'SH3DP3' WHERE EMPLOYEE_ID = 'SH3EMP2';

DELETE FROM EMPLOYEE WHERE EMPLOYEE_ID = 'SH1EMP3';

-- EMPLOYEE_WORKED_SHIP TABLE

INSERT INTO EMPLOYEE_WORKED_SHIP VALUES ('SH1EMP1', 'Moby Baby');
INSERT INTO EMPLOYEE_WORKED_SHIP VALUES ('SH1EMP1', 'Oceanic');
INSERT INTO EMPLOYEE_WORKED_SHIP VALUES ('SH1EMP2', 'Pacific Dream');
INSERT INTO EMPLOYEE_WORKED_SHIP VALUES ('SH1EMP2', 'Queen Mary 2');
INSERT INTO EMPLOYEE_WORKED_SHIP VALUES ('SH2EMP1', 'RawFaith');
INSERT INTO EMPLOYEE_WORKED_SHIP VALUES ('SH3EMP1', 'Rosella');

UPDATE EMPLOYEE_WORKED_SHIP SET PREVIOUS_WORKED_SHIP = 'Sea Lion' WHERE EMPLOYEE_ID = 'SH1EMP1'AND PREVIOUS_WORKED_SHIP = 'Moby Baby';
UPDATE EMPLOYEE_WORKED_SHIP SET PREVIOUS_WORKED_SHIP = 'Unicorn' WHERE EMPLOYEE_ID = 'SH2EMP1'AND PREVIOUS_WORKED_SHIP = 'RawFaith';

DELETE FROM EMPLOYEE_WORKED_SHIP WHERE EMPLOYEE_ID = 'SH1EMP2' AND PREVIOUS_WORKED_SHIP = 'Queen Mary 2';

-- DEPARTMENT TABLE

INSERT INTO DEPARTMENT VALUES ('SH1DP1', 'Engineering Department', 'SH1EMP2', 'SH1', 50);
INSERT INTO DEPARTMENT VALUES ('SH3DP3', 'Food and Beverage Department', 'SH3EMP2', 'SH3', 75);
INSERT INTO DEPARTMENT VALUES ('SH1DP2', 'Deck Department', 'SH1EMP2', 'SH1', 100);
INSERT INTO DEPARTMENT VALUES ('SH2DP1', 'Entertainment Department', NULL, 'SH2', 50);
INSERT INTO DEPARTMENT VALUES ('SH3DP2', 'Engineering Department', NULL, 'SH3', 60);
INSERT INTO DEPARTMENT VALUES ('SH1DP4', 'Security Department', NULL, 'SH1', 50);

UPDATE DEPARTMENT SET DEPARTMENT_HEAD = 'SH1EMP1' WHERE DEPARTMENT_ID = 'SH1DP1'; 
UPDATE DEPARTMENT SET DEPARTMENT_NAME = 'Housekeeping Department', NO_OF_WORKERS = 150 WHERE DEPARTMENT_ID = 'SH2DP1';

DELETE FROM DEPARTMENT WHERE DEPARTMENT_ID = 'SH1DP4';


-- PASSENGER_PASSPORT TABLE

INSERT INTO PASSENGER_PASSPORT VALUES ('SH1PS1', '199720013005');
INSERT INTO PASSENGER_PASSPORT VALUES ('SH1PS2', '199562343005');
INSERT INTO PASSENGER_PASSPORT VALUES ('SH2PS3', '894560013005');
INSERT INTO PASSENGER_PASSPORT VALUES ('SH3PS2', '152100013005');
INSERT INTO PASSENGER_PASSPORT VALUES ('SH3PS5', '178320013005');
INSERT INTO PASSENGER_PASSPORT VALUES ('SH3PS8', '200020013005');
INSERT INTO PASSENGER_PASSPORT VALUES ('SH1PS7', '100230013005');

UPDATE PASSENGER_PASSPORT SET PASSPORT = '188952634561' WHERE PASSENGER_ID = 'SH1PS2';
UPDATE PASSENGER_PASSPORT SET PASSPORT = '188822634561' WHERE PASSENGER_ID = 'SH1PS7';

DELETE FROM PASSENGER_PASSPORT WHERE PASSENGER_ID = 'SH1PS7';

-- PASSENGER TABLE

INSERT INTO PASSENGER VALUES ('SH1PS1', 'Vidara', 'Supun', 'Sri Lanka', 'Central', 'Digana', 'Light Lane', 'sh1');
INSERT INTO PASSENGER VALUES ('SH1PS2', 'Uditha', 'Chavishan', 'India', 'Karnataka', 'Bangalore', '23, Hosur Main Road', 'sh1');
INSERT INTO PASSENGER VALUES ('SH2PS3', 'Mathew', 'David', 'Germany', 'Freistaat Bayern', 'Bad Steben', 'Billwerder Neuer', 'sh2');
INSERT INTO PASSENGER VALUES ('SH3PS2', 'Mitchel', 'Starc', 'Finland', 'Southern Savonia', 'Savonlinna', 'Liisankatu 39', 'sh3');
INSERT INTO PASSENGER VALUES ('SH3PS8', 'Tim', 'Southee', 'South Africa', 'Queensland', 'Uhana', '19 Creek Street', 'sh3');
INSERT INTO PASSENGER VALUES ('SH3PS5', 'David', 'Warner', 'Austrailia', 'Queensland', 'Jondaryan', '19 Creek Street', 'sh3');

UPDATE PASSENGER SET FIRST_NAME = 'Hardik', LAST_NAME = 'Pandya' WHERE PASSENGER_ID = 'SH1PS2';
UPDATE PASSENGER SET COUNTRY = 'Austrailia' WHERE PASSENGER_ID = 'SH3PS2';

DELETE FROM PASSENGER WHERE PASSENGER_ID = 'SH2PS3';

-- PASSENGER_CONTACT TABLE

INSERT INTO PASSENGER_CONTACT VALUES ('SH1PS1', '0766258105');
INSERT INTO PASSENGER_CONTACT VALUES ('SH1PS1', '0716258105');
INSERT INTO PASSENGER_CONTACT VALUES ('SH1PS2', '0756285105');
INSERT INTO PASSENGER_CONTACT VALUES ('SH3PS2', '0704558105');
INSERT INTO PASSENGER_CONTACT VALUES ('SH3PS2', '0766782105');
INSERT INTO PASSENGER_CONTACT VALUES ('SH3PS5', '0766250005');

UPDATE PASSENGER_CONTACT SET CONTACT_NUMBER = '0751246987' WHERE PASSENGER_ID = 'SH1PS1' AND CONTACT_NUMBER = '0766258105';
UPDATE PASSENGER_CONTACT SET CONTACT_NUMBER = '0751245687' WHERE PASSENGER_ID = 'SH3PS2' AND CONTACT_NUMBER = '0704558105';

DELETE FROM PASSENGER_CONTACT WHERE PASSENGER_ID = 'SH3PS2' AND CONTACT_NUMBER = '0766782105';

-- PASSENGER_MEDICAL_HISTORY


INSERT INTO PASSENGER_MEDICAL_HISTORY VALUES ('SH1PS1', '2023-12-05', 'Depression', 'Anxiolytics or sedatives ');
INSERT INTO PASSENGER_MEDICAL_HISTORY VALUES ('SH1PS1', '2023-12-08', 'Motion Sickness', 'Dimenhydrinate (Dramamine),Meclizine (Bonine, Antivert)');
INSERT INTO PASSENGER_MEDICAL_HISTORY VALUES ('SH1PS2', '2023-12-25', 'Dehydration', 'Oral rehydration solutions (e.g., Pedialyte)');
INSERT INTO PASSENGER_MEDICAL_HISTORY VALUES ('SH3PS2', '2023-12-18', 'Gastrointestinal Issues', 'Antidiarrheal medications (e.g., loperamide/Imodium)');
INSERT INTO PASSENGER_MEDICAL_HISTORY VALUES ('SH3PS2', '2023-12-20', 'Respiratory Infections', 'Decongestants ');
INSERT INTO PASSENGER_MEDICAL_HISTORY VALUES ('SH3PS5', '2023-12-30', 'Injuries', 'Analgesics for pain relief');

UPDATE PASSENGER_MEDICAL_HISTORY SET MEDICAL_CONDITION = 'Skin Conditions' WHERE PASSENGER = 'SH1PS1' AND MEDICATED_DATE = '2023-12-08'; 
UPDATE PASSENGER_MEDICAL_HISTORY SET MEDICATION = 'Antiseptic solutions or creams for wound cleaning' WHERE PASSENGER = 'SH3PS5' AND MEDICATED_DATE = '2023-12-30'; 

DELETE FROM PASSENGER_MEDICAL_HISTORY WHERE PASSENGER = 'SH3PS2' AND MEDICATED_DATE = '2023-12-20';

-- CABIN TABLE

INSERT INTO CABIN VALUES (2, 24, 'Dinning Room 1', 'SH1');
INSERT INTO CABIN VALUES (2, 35, 'Dinning Room 2', 'SH1');
INSERT INTO CABIN VALUES (3, 31, 'Ocean view cabin', 'SH3');
INSERT INTO CABIN VALUES (3, 15, 'Family Cabin 1', 'SH3');
INSERT INTO CABIN VALUES (4, 23, 'Suite', 'SH1');
INSERT INTO CABIN VALUES (5, 30, 'Balcony Cabin', 'SH2');

UPDATE CABIN SET CABIN_TYPE = 'Dinning Room 1' WHERE DECK = 3 AND CABIN_NUMBER = 31 AND SHIP = 'SH3';
UPDATE CABIN SET DECK = 10, CABIN_NUMBER = 1, CABIN_TYPE = "Captain's Quarters" WHERE DECK = 2 AND CABIN_NUMBER = 24 AND SHIP = 'SH1';

DELETE FROM CABIN WHERE DECK = 4 AND CABIN_NUMBER = 23 AND SHIP = 'SH1';

-- CABIN_INCHARGE TABLE 

INSERT INTO CABIN_INCHARGE VALUES ('2', '35', 'SH1EMP1', 'SH1');
INSERT INTO CABIN_INCHARGE VALUES ('10', '1', 'SH1EMP2', 'SH1');
INSERT INTO CABIN_INCHARGE VALUES ('3', '31', 'SH2EMP1', 'SH3');
INSERT INTO CABIN_INCHARGE VALUES ('3', '31', 'SH3EMP2', 'SH3');
INSERT INTO CABIN_INCHARGE VALUES ('2', '35', 'SH1EMP2', 'SH1');
INSERT INTO CABIN_INCHARGE VALUES ('5', '30', 'SH3EMP1', 'SH2');

UPDATE CABIN_INCHARGE SET INCHARGE = 'SH3EMP1' WHERE DECK = 3 AND CABIN_NUMBER = 31 AND INCHARGE = 'SH2EMP1';
UPDATE CABIN_INCHARGE SET INCHARGE = 'SH2EMP1' WHERE DECK = 5 AND CABIN_NUMBER = 30 AND INCHARGE = 'SH3EMP1';

DELETE FROM CABIN_INCHARGE WHERE DECK = 5 AND CABIN_NUMBER = 30 AND INCHARGE = 'SH2EMP1';

-- CABIN_SERVICE_REQUAEST TABLE

INSERT INTO CABIN_SERVICE_REQUEST VALUES (2, 35, '2023-12-10', 'Table Broken', 'SH1');
INSERT INTO CABIN_SERVICE_REQUEST VALUES (2, 35, '2023-12-25', 'Chair Broken', 'SH1');
INSERT INTO CABIN_SERVICE_REQUEST VALUES (10, 1, '2023-12-22', 'Bed Broken', 'SH1');
INSERT INTO CABIN_SERVICE_REQUEST VALUES (3, 31, '2023-12-30', 'Need a Chair', 'SH3');
INSERT INTO CABIN_SERVICE_REQUEST VALUES (3, 15, '2023-12-05', 'Need to fix the cupboard', 'SH3'); 
INSERT INTO CABIN_SERVICE_REQUEST VALUES (5, 30, '2023-12-10', 'Tile broken', 'SH2');

UPDATE CABIN_SERVICE_REQUEST SET SERVICE_REQUEST_TYPE = 'Need a Chair' WHERE DECK = 10 AND CABIN_NUMBER = 1 AND SHIP = 'SH1';
UPDATE CABIN_SERVICE_REQUEST SET SERVICE_REQUEST_TYPE = 'Wall broken' WHERE DECK = 5 AND CABIN_NUMBER = 30 AND SHIP = 'SH2';

DELETE FROM CABIN_SERVICE_REQUEST WHERE DECK = 5 AND CABIN_NUMBER = 30 AND SHIP = 'SH2';

-- CRUISE_DINNING_RESERVATION TABLE

INSERT INTO CRUISE_DINNING_RESERVATION VALUES (2, 35, '2023-12-11', '13:30:00', 5, 'SH1' );
INSERT INTO CRUISE_DINNING_RESERVATION VALUES (2, 35, '2023-12-12', '17:00:00', 5, 'SH1' );
INSERT INTO CRUISE_DINNING_RESERVATION VALUES (2, 35, '2023-12-13', '20:30:00', 5, 'SH1' );
INSERT INTO CRUISE_DINNING_RESERVATION VALUES (3, 31, '2023-12-11', '15:30:00', 10, 'SH3' );
INSERT INTO CRUISE_DINNING_RESERVATION VALUES (3, 31, '2023-12-25', '19:00:00', 12, 'SH3' );
INSERT INTO CRUISE_DINNING_RESERVATION VALUES (3, 31, '2023-12-02', '11:30:00', 7, 'SH3' );

UPDATE CRUISE_DINNING_RESERVATION SET NUMBER_OF_GUESTS = 8 WHERE DECK = 2 AND CABIN_NUMBER = 35 AND SHIP = 'SH1' AND RESERVATION_DATE = '2023-12-12' AND RESERVATION_TIME = '17:00:00';
UPDATE CRUISE_DINNING_RESERVATION SET NUMBER_OF_GUESTS = 15 WHERE DECK = 3 AND CABIN_NUMBER = 31 AND SHIP = 'SH3' AND RESERVATION_DATE = '2023-12-02' AND RESERVATION_TIME = '11:30:00';

DELETE FROM CRUISE_DINNING_RESERVATION WHERE DECK = 2 AND CABIN_NUMBER = 35 AND SHIP = 'SH1' AND RESERVATION_DATE = '2023-12-11' AND RESERVATION_TIME = '13:30:00';

-- PORT TABLE

INSERT INTO PORT VALUES ('PT1', 'Miami', 'Florida, USA');
INSERT INTO PORT VALUES ('PT2', 'Port Everglades', 'Florida, USA');
INSERT INTO PORT VALUES ('PT3', 'Nassau', 'Bahamas');
INSERT INTO PORT VALUES ('PT4', 'Cozumel', 'Mexico');
INSERT INTO PORT VALUES ('PT5', 'St. Thomas', 'US Virgin Islands');
INSERT INTO PORT VALUES ('PT6', 'Barcelona', 'Spain');

UPDATE PORT SET PORT_NAME = 'Venice', LOCATION = 'Italy' WHERE PORT_ID = 'PT2';
UPDATE PORT SET PORT_NAME = 'Sydney', LOCATION = 'Australia' WHERE PORT_ID = 'PT4';

DELETE FROM PORT WHERE PORT_ID = 'PT5';

-- CRUISE TEBLE

INSERT INTO CRUISE VALUES ('CR1', 'SH1', 'PT1', '2023-11-30', 'PT2');
INSERT INTO CRUISE VALUES ('CR2', 'SH1', 'PT6', '2023-10-28', 'PT2');
INSERT INTO CRUISE VALUES ('CR3', 'SH3', 'PT2', '2023-12-01', 'PT3');
INSERT INTO CRUISE VALUES ('CR4', 'SH3', 'PT3', '2023-12-30', 'PT4');
INSERT INTO CRUISE VALUES ('CR5', 'SH2', 'PT1', '2023-11-25', 'PT6');
INSERT INTO CRUISE VALUES ('CR6', 'SH2', 'PT3', '2023-12-10', 'PT2');

UPDATE CRUISE SET DEPARTURE_PORT = 'PT4' WHERE CRUISE_ID = 'CR2';
UPDATE CRUISE SET DESTINATION_PORT = 'PT4' WHERE CRUISE_ID = 'CR5';

DELETE FROM CRUISE WHERE CRUISE_ID = 'CR6';

-- CHAPTER 4 - TRANSACTION
-- 1

SELECT * FROM SHIP_NAME;

-- 2

SELECT EMPLOYEE_ID, COUNTRY, WORKING_DEPARTMENT, WORKING_SHIP FROM EMPLOYEE;


-- 3

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, DEPARTMENT_ID, DEPARTMENT_NAME FROM EMPLOYEE CROSS JOIN DEPARTMENT;

-- 4

CREATE VIEW CABIN_SERVICE AS SELECT * FROM CABIN NATURAL JOIN CABIN_SERVICE_REQUEST; 
SELECT * FROM CABIN_SERVICE;

-- 5

SELECT PORT_ID, PORT_NAME, CRUISE_ID, DEPARTURE_PORT, DESTINATION_PORT FROM PORT AS P NATURAL JOIN CRUISE AS C;

-- 6

SELECT EMPLOYEE_ID AS EMPL_ID, COUNT(EMPLOYEE_ID) AS EXPERIENCE FROM EMPLOYEE_WORKED_SHIP GROUP BY EMPLOYEE_ID ORDER BY EXPERIENCE DESC;

-- 7

SELECT EMPLOYEE_ID, COUNTRY, POSITION, WORKING_DEPARTMENT FROM EMPLOYEE WHERE ((POSITION LIKE "%Engineer") OR (POSITION LIKE "%Cook%"));


-- COMPLEX QUERIES

-- 1

(SELECT E.EMPLOYEE_ID, E.WORKING_SHIP, E.COUNTRY FROM EMPLOYEE AS E INNER JOIN DEPARTMENT AS D ON E.WORKING_DEPARTMENT = D.DEPARTMENT_ID WHERE D.SHIP_ID = 'SH3')
UNION
(SELECT E.EMPLOYEE_ID, E.WORKING_SHIP,E.COUNTRY FROM EMPLOYEE AS E INNER JOIN SHIP AS S ON E.WORKING_SHIP = S.SHIP_ID WHERE S.SHIP_ID = 'SH1');


-- 2

(SELECT E.EMPLOYEE_ID, E.WORKING_SHIP FROM EMPLOYEE AS E INNER JOIN SHIP AS S ON E.WORKING_SHIP = S.SHIP_ID)
INTERSECT
(SELECT E.EMPLOYEE_ID, E.WORKING_SHIP FROM EMPLOYEE AS E INNER JOIN CABIN_INCHARGE AS CI ON E.EMPLOYEE_ID = CI.INCHARGE WHERE E.WORKING_SHIP = 'SH1');

-- 3

(SELECT PP.PASSENGER_ID FROM PASSENGER_PASSPORT AS PP NATURAL JOIN PASSENGER_CONTACT AS PC)
EXCEPT
(SELECT PP.PASSENGER_ID FROM PASSENGER_PASSPORT AS PP INNER JOIN PASSENGER_MEDICAL_HISTORY AS PMS ON PP.PASSENGER_ID = PMS.PASSENGER WHERE PP.PASSENGER_ID = 'SH1PS1');

-- 4

(SELECT E.FIRST_NAME, E.LAST_NAME, E.CITY FROM EMPLOYEE AS E LEFT JOIN DEPARTMENT AS D ON E.EMPLOYEE_ID = D.DEPARTMENT_HEAD)
INTERSECT
(SELECT E.FIRST_NAME, E.LAST_NAME, E.CITY FROM EMPLOYEE AS E LEFT JOIN CABIN_INCHARGE AS CI ON E.EMPLOYEE_ID = CI.INCHARGE WHERE CI.SHIP = 'SH1');

-- 5 NATURAL JOIN

CREATE VIEW UV1 AS SELECT S.SHIP_ID, SN.SHIP_NAME FROM SHIP_NAME AS SN NATURAL JOIN SHIP AS S;
SELECT * FROM UV1;

-- 6 INNER JOIN

CREATE VIEW UV2 AS SELECT EN.EMPLOYEE_ID, EN.NIC, D.DEPARTMENT_NAME FROM EMPLOYEE_NIC AS EN INNER JOIN 
DEPARTMENT AS D ON EN.EMPLOYEE_ID = D.DEPARTMENT_HEAD;
SELECT * FROM UV2;

-- 7 LEFT OUTER JOIN

CREATE VIEW UV3 AS SELECT * FROM SHIP_NAME AS SN LEFT JOIN CABIN AS C ON SN.SHIP_ID = C.SHIP WHERE SN.SHIP_ID != 'SH1';
SELECT * FROM UV3;

-- 8 RIGHT POTER JOIN

CREATE VIEW UV4 AS SELECT PC.PASSENGER_ID, PC.CONTACT_NUMBER, PP.PASSPORT FROM PASSENGER_CONTACT AS PC RIGHT JOIN 
PASSENGER_PASSPORT AS PP ON PC.PASSENGER_ID = PP.PASSENGER_ID;
SELECT * FROM UV4;

-- 9 FULL OUTER JOIN

CREATE VIEW UV5 AS SELECT EN.EMPLOYEE_ID, EN.NIC, CI.INCHARGE FROM EMPLOYEE_NIC AS EN LEFT OUTER JOIN CABIN_INCHARGE AS CI ON EN.EMPLOYEE_ID = CI.INCHARGE;
CREATE VIEW UV6 AS SELECT CI.INCHARGE, EN.EMPLOYEE_ID, EN.NIC FROM CABIN_INCHARGE AS CI RIGHT OUTER JOIN EMPLOYEE_NIC AS EN ON EN.EMPLOYEE_ID = CI.INCHARGE;
(SELECT * FROM UV5) UNION (SELECT * FROM UV6);

-- 10 

CREATE VIEW UV7 AS SELECT EN.EMPLOYEE_ID, EN.NIC FROM EMPLOYEE_NIC AS EN NATURAL JOIN EMPLOYEE_WORKED_SHIP AS EWS;
CREATE VIEW UV8 AS SELECT EN.EMPLOYEE_ID, EN.NIC FROM EMPLOYEE_NIC AS EN INNER JOIN EMPLOYEE_WORKED_SHIP AS EWS ON EN.EMPLOYEE_ID = EWS.EMPLOYEE_ID;

(SELECT * FROM UV7) INTERSECT (SELECT * FROM UV8);

-- 11 NESTED QUERY

SELECT EMPLOYEE_ID FROM EMPLOYEE WHERE EMPLOYEE_ID IN (SELECT INCHARGE FROM CABIN_INCHARGE);

-- 12 NESTED QUERY

SELECT SHIP_ID, SHIP_NAME FROM SHIP_NAME WHERE SHIP_ID IN (SELECT SHIP_ID FROM SHIP WHERE CREW_CAPACITY >2000);

-- 13 NESTED QUERY

SELECT EMPLOYEE_ID, WORKING_SHIP, WORKING_DEPARTMENT FROM EMPLOYEE WHERE EMPLOYEE_ID IN (SELECT INCHARGE FROM CABIN_INCHARGE WHERE INCHARGE NOT IN ('SH1EMP1','SH1EMP2'));

-- TUNNING

-- 1 RM METHODE

EXPLAIN SELECT E.EMPLOYEE_ID, E.WORKING_SHIP, E.COUNTRY 
FROM EMPLOYEE AS E 
WHERE E.WORKING_DEPARTMENT IN (
    SELECT D.DEPARTMENT_ID 
    FROM DEPARTMENT AS D 
    WHERE D.SHIP_ID = 'SH3'
)
UNION
SELECT E.EMPLOYEE_ID, E.WORKING_SHIP, E.COUNTRY 
FROM EMPLOYEE AS E 
WHERE E.WORKING_SHIP = 'SH1';

-- 2 RM METHODE

EXPLAIN (SELECT E.EMPLOYEE_ID, E.WORKING_SHIP FROM EMPLOYEE AS E INNER JOIN SHIP AS S ON E.WORKING_SHIP = S.SHIP_ID WHERE S.SHIP_ID = 'SH1')
INTERSECT
(SELECT E.EMPLOYEE_ID, E.WORKING_SHIP FROM EMPLOYEE AS E INNER JOIN CABIN_INCHARGE AS CI ON E.EMPLOYEE_ID = CI.INCHARGE WHERE E.WORKING_SHIP = 'SH1');

-- 3 RM METHODE

EXPLAIN SELECT PC.PASSENGER_ID 
FROM PASSENGER_PASSPORT AS PP 
INNER JOIN PASSENGER_CONTACT AS PC ON PP.PASSENGER_ID = PC.PASSENGER_ID
LEFT JOIN PASSENGER_MEDICAL_HISTORY AS PMS ON PP.PASSENGER_ID = PMS.PASSENGER 
WHERE PP.PASSENGER_ID <> 'SH1PS1' OR PMS.PASSENGER IS NULL;

-- 4 RM METHODE

EXPLAIN (SELECT E.FIRST_NAME, E.LAST_NAME, E.CITY FROM EMPLOYEE AS E LEFT JOIN DEPARTMENT AS D ON E.EMPLOYEE_ID = D.DEPARTMENT_HEAD WHERE E.WORKING_SHIP = 'SH1')
INTERSECT
(SELECT E.FIRST_NAME, E.LAST_NAME, E.CITY FROM EMPLOYEE AS E LEFT JOIN CABIN_INCHARGE AS CI ON E.EMPLOYEE_ID = CI.INCHARGE);

-- 5 ALREADY TUNED

-- CREATE VIEW UV1 AS SELECT S.SHIP_ID, SN.SHIP_NAME FROM SHIP_NAME AS SN NATURAL JOIN SHIP AS S;
EXPLAIN SELECT * FROM UV1;

-- 6 TUNNED

-- CREATE VIEW UV2 AS SELECT EN.EMPLOYEE_ID, EN.NIC, D.DEPARTMENT_NAME FROM EMPLOYEE_NIC AS EN INNER JOIN 
-- DEPARTMENT AS D ON EN.EMPLOYEE_ID = D.DEPARTMENT_HEAD;
EXPLAIN SELECT * FROM UV2;

-- 7 INDEX TUNNED

-- CREATE VIEW UV3 AS SELECT * FROM SHIP_NAME AS SN LEFT JOIN CABIN AS C ON SN.SHIP_ID = C.SHIP WHERE SN.SHIP_ID != 'SH1';
EXPLAIN SELECT * FROM UV3;
CREATE INDEX CABIN_TYPE_INDEX ON CABIN(CABIN_TYPE);
DROP INDEX CABIN_TYPE_INDEX ON CABIN;

-- 8 TUNNED

-- CREATE VIEW UV4 AS SELECT PC.PASSENGER_ID, PC.CONTACT_NUMBER, PP.PASSPORT FROM PASSENGER_CONTACT AS PC RIGHT JOIN 
-- PASSENGER_PASSPORT AS PP ON PC.PASSENGER_ID = PP.PASSENGER_ID;
EXPLAIN SELECT * FROM UV4;

-- 9 TUNNED

-- CREATE VIEW UV5 AS SELECT EN.EMPLOYEE_ID, EN.NIC, CI.INCHARGE FROM EMPLOYEE_NIC AS EN LEFT OUTER JOIN CABIN_INCHARGE AS CI ON EN.EMPLOYEE_ID = CI.INCHARGE;
-- CREATE VIEW UV6 AS SELECT CI.INCHARGE, EN.EMPLOYEE_ID, EN.NIC FROM CABIN_INCHARGE AS CI RIGHT OUTER JOIN EMPLOYEE_NIC AS EN ON EN.EMPLOYEE_ID = CI.INCHARGE;
EXPLAIN (SELECT * FROM UV5) UNION (SELECT * FROM UV6);

-- 10 

-- CREATE VIEW UV7 AS SELECT EN.EMPLOYEE_ID, EN.NIC FROM EMPLOYEE_NIC AS EN NATURAL JOIN EMPLOYEE_WORKED_SHIP AS EWS;
-- CREATE VIEW UV8 AS SELECT EN.EMPLOYEE_ID, EN.NIC FROM EMPLOYEE_NIC AS EN INNER JOIN EMPLOYEE_WORKED_SHIP AS EWS ON EN.EMPLOYEE_ID = EWS.EMPLOYEE_ID;
EXPLAIN (SELECT * FROM UV7) INTERSECT (SELECT * FROM UV8);


