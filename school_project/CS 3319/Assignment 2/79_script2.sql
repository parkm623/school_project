-- ---------------------------------
-- Part 1 SQL Updates

USE assign2db; 
SELECT * FROM hospital;
UPDATE hospital SET headdoc ='GD56' , headdocstartdate ='2010-12-19' WHERE hoscode ='BBC';
UPDATE hospital SET headdoc ='SE66' , headdocstartdate ='2004-05-30' WHERE hoscode ='ABC';
UPDATE hospital SET headdoc ='YT67' , headdocstartdate ='2001-06-01' WHERE hoscode ='DDE';
SELECT * FROM hospital;

-- ---------------------------------
-- Part 2 SQL Inserts

INSERT INTO doctor VALUES ('AX29','Ray','Park','2022-02-15','1997-04-30','ABC','Surgeon');
INSERT INTO patient VALUES ('123456789','Thomas','Cruise ','1962-07-03');
INSERT INTO looksafter VALUES ('AX29','123456789');
INSERT INTO hospital VALUES ('TRS','Sunnybrook','Toronto','ON','800','AX29','2022-10-12');
SELECT * FROM doctor;
SELECT * FROM patient;
SELECT * FROM looksafter;
SELECT * FROM hospital;

-- ---------------------------------
-- Part 3 SQL Queries

-- Query 1
SELECT lastname FROM patient;
-- Query 2
SELECT DISTINCT lastname FROM patient;
-- Query 3
SELECT * FROM doctor ORDER BY lastname;
-- Query 4
SELECT hosname, hoscode FROM hospital WHERE numofbed > 1500;
-- Query 5
SELECT firstname, lastname FROM doctor WHERE hosworksat IN (SELECT hoscode FROM hospital WHERE hosname ='St. Joseph');
-- Query 6
SELECT firstname, lastname FROM patient WHERE lastname LIKE 'G%';
-- Query 7
SELECT firstname, lastname FROM patient WHERE ohipnum IN (SELECT ohipnum FROM looksafter WHERE licensenum IN (SELECT licensenum FROM doctor WHERE lastname ='Webster'));
-- Query 8
SELECT h.hosname, h.city, d.lastname FROM hospital h JOIN doctor d ON d.licensenum = h.headdoc;
-- Query 9
SELECT SUM(numofbed) AS  'numOfBeds' FROM hospital;
-- Query 10
SELECT p.firstname AS 'p.FirstName', p.lastname AS 'p.LastName', d.firstname AS 'd.FirstName', d.lastname AS 'd.LastName' FROM (SELECT l.licensenum, l.ohipnum FROM looksafter l JOIN hospital h ON l.licensenum = h.headdoc) head JOIN patient p ON p.ohipnum = head.ohipnum JOIN doctor d ON d.licensenum = head.licensenum;
-- Query 11
SELECT d.lastname, d.firstname, h.prov FROM (SELECT lastname, firstname, hosworksat FROM doctor WHERE speciality = 'Surgeon') d JOIN (SELECT hoscode, prov FROM hospital WHERE hosname = 'Victoria') h ON d.hosworksat = h.hoscode;
-- Query 12
SELECT firstname FROM doctor WHERE licensenum NOT IN (SELECT licensenum FROM looksafter);
-- Query 13
SELECT d.lastname, d.firstname, c.numOfPatients, h.hosname FROM (SELECT licensenum, COUNT(licensenum) AS 'numOfPatients' FROM looksafter GROUP BY licensenum HAVING COUNT(licensenum) > 1) c JOIN doctor d ON c.licensenum = d.licensenum JOIN hospital h ON d.hosworksat = h.hoscode;
-- Query 14
SELECT head.firstname AS 'Doctor First Name', head.lastname AS 'Doctor Last Name', h.hosname AS 'Head of  Hospital Name' , work.hosname AS 'Works at Hospital Name' FROM hospital h JOIN (SELECT firstname, lastname, licensenum, hosworksat FROM doctor JOIN hospital ON headdoc = licensenum) head ON head.licensenum = h.headdoc AND head.hosworksat != h.hoscode 
JOIN (SELECT firstname, hosname FROM doctor JOIN hospital ON hosworksat = hoscode) work ON work.firstname = head.firstname;
-- Query 15
-- Display the firstname and lastname of all doctors and hospital name and province who work in Ontario province and end with letter 'K' on lastname.
SELECT firstname, lastname, hosname, prov FROM doctor JOIN hospital ON hosworksat = hoscode AND prov = 'ON' AND lastname LIKE '%k'; 

-- ---------------------------------
--  Part 4 SQL Views/Deletes
CREATE VIEW dptemp AS SELECT d.firstname AS 'dfirst', d.lastname AS 'dlast', d.birthdate AS 'dbirth', p.firstname AS 'pfirst', p.lastname AS 'plast', p.birthdate AS 'pbirth'  FROM  doctor d JOIN looksafter l ON d.licensenum = l.licensenum JOIN patient p ON p.ohipnum = l.ohipnum;
SHOW TABLES;
SELECT * FROM dptemp;
SELECT dlast, dbirth, plast, pbirth FROM dptemp WHERE dbirth > pbirth;
SELECT * FROM patient;
SELECT * FROM looksafter;
DELETE FROM patient WHERE lastname = 'Cruise';
SELECT * FROM patient;
SELECT * FROM looksafter;
SELECT * FROM doctor;
DELETE FROM doctor WHERE firstname = 'Bernie';
SELECT * FROM doctor;
DELETE FROM doctor WHERE firstname = 'Ray' AND lastname = 'Park'; 
-- The doctor who I created is a head doctor of hospital, which means hospital table has foreign key of doctor's unique code so it can't be deleted until remove head postion from hospital table.