DROP DATABASE IF EXISTS Airport_Database;

CREATE DATABASE Airport_Database;

USE Airport_Database;

DROP TABLE IF EXISTS `Airline`;

CREATE TABLE `Airline` (
  `IATA_Airline_Code` char(2) PRIMARY KEY,
  `Company_Name` varchar(50) NOT NULL,
  `Number_of_aircrafts_owned` int DEFAULT 0,
  `Active` Boolean DEFAULT TRUE,
  `Country_of_Ownership` varchar(255),
  `Managing_Director`  varchar(255)
);

-- -- ----------------------------------------------------------

DROP TABLE IF EXISTS `Capacity_of_Aircraft`;

CREATE TABLE `Capacity_of_Aircraft` (
  `Manufacturer` varchar(255) NOT NULL,
  `Capacity` int NOT NULL,
  `Plane_Model` varchar(255) NOT NULL,
  constraint capacityKey PRIMARY KEY (`Plane_Model`,`Manufacturer` )
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Aircraft`;

CREATE TABLE `Aircraft` (
  `Registration_No.` int PRIMARY KEY,
  `Manufacturer` varchar(255) NOT NULL,
  `Plane_Model` varchar(255) NOT NULL,
  `Distance_Travelled` int DEFAULT 0,
  `Flight_ID` varchar(10),
  `Last_Maintanence_Check_Date` date,
  `Owners_IATA_Airline_Code` varchar(2),

  FOREIGN KEY (`Plane_Model`,`Manufacturer`) REFERENCES `Capacity_of_Aircraft` (`Plane_Model`,`Manufacturer`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`Owners_IATA_Airline_Code`) REFERENCES `Airline` (`IATA_Airline_Code`) ON DELETE SET NULL ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Airport`;

CREATE TABLE `Airport` (
  `IATA_CODE` varchar(3) PRIMARY KEY,
  `Manager` varchar(255),
  `Time_Zone` char(6),
  `Name` varchar(255),
  `City` varchar(255),
  `Country` varchar(255),
  `Latitude` float,
  `Longitude` float
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Runway`;

CREATE TABLE `Runway` (
  `IATA_CODE` char(3),
  `Runway_ID` int,
  `Length` float,
  `Width` float,
  `Status` enum('Assigned', 'Available', 'Disfunctional') DEFAULT 'Available',
  PRIMARY KEY (`IATA_CODE`, `Runway_ID`),

  FOREIGN KEY (`IATA_CODE`) REFERENCES `Airport` (`IATA_CODE`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Terminal`;

CREATE TABLE `Terminal` (
  `IATA_CODE` char(3),
  `Terminal_ID` int,
  `Flight_Handling_capacity` int,
  `Floor_Area` float,
  PRIMARY KEY (`IATA_CODE`, `Terminal_ID`),

  FOREIGN KEY (`IATA_CODE`) REFERENCES `Airport` (`IATA_CODE`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `PNR_Info_Deduction`;

CREATE TABLE `PNR_Info_Deduction` (
  `PNR_Number` char(6) PRIMARY KEY,
  `Scheduled_Boarding_Time` time,
  `Terminal_number` int,
  `class_of_travel` enum('Economy', 'Business') DEFAULT 'Economy',
  `Source_IATA_CODE` char(3),

  FOREIGN KEY (`Source_IATA_CODE`,`Terminal_number`) REFERENCES `Terminal` (`IATA_CODE`, `Terminal_ID`)  ON DELETE SET NULL ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Airline_Employees/CREW`;

CREATE TABLE `Airline_Employees/CREW` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `First_Name` varchar(255) NOT NULL,
  `Minit` varchar(255),
  `Last_Name` varchar(255),
  `Joining_Date` date,
  `Salary` int,
  `Nationality` varchar(255),
  `DOB` date,
  `Gender` enum('Male', 'Female', 'Others'),
  `Employer_IATA_Airline_Code` char(2),

  FOREIGN KEY (`Employer_IATA_Airline_Code`) REFERENCES `Airline` (`IATA_Airline_Code`) ON DELETE SET NULL ON UPDATE CASCADE
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Route`;

CREATE TABLE `Route` (
  `Route_ID` int PRIMARY KEY,
  `Source_IATA_CODE` char(3) NOT NULL,
  `Destination_IATA_CODE` char(3) NOT NULL,
  `Take_off_runway_id` int,
  `Scheduled_Arrival` time,  
  `Scheduled_Departure` time,
  `Date` DATE NOT NULL, 
  `Status` enum('Departed', 'Boarding','On_route','Delayed','Arrived','Check-in','Not_applicable') NOT NULL DEFAULT 'Not_applicable',
  `Actual_Arrival_Time` time,
  `Actual_Departure_Time` time,
  `Time_duration` time,
  `Distance_Travelled` int,
  `Landing_Runway_ID` int,
  `Registration_No.` int,
  `Pilot_Captain_Aadhar_card_number` char(12) NOT NULL,
  `Chief_Flight_Attendant_Aadhar_card_number` char(12) NOT NULL,

  CONSTRAINT Route_1 FOREIGN KEY (`Destination_IATA_CODE`) REFERENCES `Airport` (`IATA_CODE`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_2 FOREIGN KEY (`Source_IATA_CODE`) REFERENCES `Airport` (`IATA_CODE`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_3 FOREIGN KEY (`Registration_No.`) REFERENCES `Aircraft` (`Registration_No.`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT Route_4 FOREIGN KEY (`Destination_IATA_CODE`,`Landing_Runway_ID`) REFERENCES `Runway` (`IATA_CODE`, `Runway_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_5 FOREIGN KEY (`Source_IATA_CODE`,`Take_off_runway_id`) REFERENCES `Runway` (`IATA_CODE`, `Runway_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_6 FOREIGN KEY (`Pilot_Captain_Aadhar_card_number`) REFERENCES `Airline_Employees/CREW` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT Route_7 FOREIGN KEY (`Chief_Flight_Attendant_Aadhar_card_number`) REFERENCES `Airline_Employees/CREW` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Passenger`;

CREATE TABLE `Passenger` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `First_Name` varchar(255) NOT NULL,
  `Minit` varchar(255),
  `Last_Name` varchar(255),
  `DOB` date,
  `Gender` enum('Male', 'Female', 'Others'),
  `House_Number` varchar(10),
  `Building` varchar(255),
  `City` varchar(255),
  `Email-ID` varchar(255) UNIQUE,
  `Senior_Citizen` Boolean,
  `Nationality` varchar(255)
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Boarding_Pass`;

CREATE TABLE `Boarding_Pass` (
  `Barcode_No.` char(12) PRIMARY KEY,
  `PNR_Number` char(6) NOT NULL,
  `Seat` varchar(5) NOT NULL,
  `Aadhar_card_number` char(12) NOT NULL,
  `Route_ID` int NOT NULL,

  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`PNR_Number`) REFERENCES `PNR_Info_Deduction` (`PNR_Number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`Route_ID`) REFERENCES `Route` (`Route_ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Emergency_Contact`;

CREATE TABLE `Emergency_Contact` (
  `Name` varchar(255),
  `Phone_No` bigint(10) UNIQUE NOT NULL,
  `Aadhar_card_number` char(12),
  PRIMARY KEY (`Name`, `Aadhar_card_number`),

  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Passenger` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Luggage`;

CREATE TABLE `Luggage` (
  `Baggage_ID` bigint(10) PRIMARY KEY,
  `Barcode_No.` char(12),

  FOREIGN KEY (`Barcode_No.`) REFERENCES `Boarding_Pass` (`Barcode_No.`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Flight_Crew`;

CREATE TABLE `Flight_Crew` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airline_Employees/CREW` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Pilot`;

CREATE TABLE `Pilot` (
  `Aadhar_card_number` char(12) PRIMARY KEY NOT NULL,
  `Pilot_license_number` char(12) UNIQUE NOT NULL,
  `Number_of_flying_hours` int,

  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Flight_Crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Flight_Attendant`;

CREATE TABLE `Flight_Attendant` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `Training/Education` varchar(255),

  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Flight_Crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Flight_Engineer`;

CREATE TABLE `Flight_Engineer` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `Education` varchar(255),
  `Manufacturer` varchar(255),
  `Plane_Model_No.` varchar(255),

  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Flight_Crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE
);



DROP TABLE IF EXISTS `Flight_Crew_SERVES_ON_THE_Route`;

CREATE TABLE `Flight_Crew_SERVES_ON_THE_Route` (
  `Aadhar_card_number` char(12),
  `Route_ID` int,
  PRIMARY KEY (`Aadhar_card_number`, `Route_ID`),

  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Flight_Crew` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`Route_ID`) REFERENCES `Route` (`Route_ID`) ON DELETE CASCADE ON UPDATE CASCADE
);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `On_Ground`;

CREATE TABLE `On_Ground` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `Job_title` varchar(255),
  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airline_Employees/CREW` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Airport_Employees/CREWS`;

CREATE TABLE `Airport_Employees/CREWS` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `Working_Airport_IATA_CODE` char(3),
  `First_Name` varchar(255) NOT NULL,
  `Minit` varchar(255),
  `Last_Name` varchar(255),
  `Experience` int DEFAULT 0,
  `Salary` int,
  `Nationality` varchar(255),
  `DOB` date,
  `Gender` enum('Male', 'Female', 'Others'),
  `Supervisor_Aadhar_card_number` char(12),


FOREIGN KEY (`Working_Airport_IATA_CODE`) REFERENCES `Airport` (`IATA_CODE`) ON DELETE CASCADE ON UPDATE CASCADE,
FOREIGN KEY (`Supervisor_Aadhar_card_number`) REFERENCES `Airport_Employees/CREWS` (`Aadhar_card_number`) ON DELETE SET NULL ON UPDATE CASCADE

);


-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Management_and_operations_executives`;

CREATE TABLE `Management_and_operations_executives` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `Job_title` varchar(255),

  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airport_Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Security`;

CREATE TABLE `Security` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `Designation` varchar(255),
  `Security_ID_Number` int UNIQUE,

  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airport_Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Air_Traffic_Controller`;

CREATE TABLE `Air_Traffic_Controller` (
  `Aadhar_card_number` char(12) PRIMARY KEY,
  `Current_communication_Frequency` float,
  `Training/Education` varchar(255),

  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airport_Employees/CREWS` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);


-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Crew_has_worked_together`;

CREATE TABLE `Crew_has_worked_together` (
  `Pilot_Captain_Aadhar_card_number` char(12),
  `Pilot_First_Officer_Aadhar_card_number` char(12),
  `Flight_Attendant_Aadhar_card_number` char(12),
  `Flight_Engineer_Aadhar_card_number` char(12),
  `Avg_Competence_Rating` float,
  CHECK (`Avg_Competence_Rating` >= 0 AND `Avg_Competence_Rating` <=10),
  `Number_of_Languages_spoken_overall` int,
  PRIMARY KEY (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`),

  FOREIGN KEY(`Pilot_Captain_Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Pilot_First_Officer_Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Flight_Attendant_Aadhar_card_number`) REFERENCES `Flight_Attendant` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Flight_Engineer_Aadhar_card_number`) REFERENCES `Flight_Engineer` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Flight_Crew_feedback`;

CREATE TABLE `Flight_Crew_feedback` (
  `Pilot_Captain_Aadhar_card_number` char(12),
  `Pilot_First_Officer_Aadhar_card_number` char(12),
  `Flight_Attendant_Aadhar_card_number` char(12),
  `Flight_Engineer_Aadhar_card_number` char(12),
  `Feedback_given_by_the_passengers_for_the_crew` varchar(255),
  PRIMARY KEY (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Feedback_given_by_the_passengers_for_the_crew`),

  FOREIGN KEY(`Pilot_Captain_Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Pilot_First_Officer_Aadhar_card_number`) REFERENCES `Pilot` (`Aadhar_card_number`)  ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Flight_Attendant_Aadhar_card_number`) REFERENCES `Flight_Attendant` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(`Flight_Engineer_Aadhar_card_number`) REFERENCES `Flight_Engineer` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Boarding_Pass_Special_Services`;

CREATE TABLE `Boarding_Pass_Special_Services` (
  `Barcode_No.` varchar(12),
  `Special_Services` enum('Wheelchair', 'Disability Assistance', 'XL seats', 'Priority Boarding'),
  PRIMARY KEY (`Barcode_No.`, `Special_Services`),
  FOREIGN KEY (`Barcode_No.`) REFERENCES `Boarding_Pass` (`Barcode_No.`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Languages_spoken_by_airline_employee`;

CREATE TABLE `Languages_spoken_by_airline_employee` (
  `Aadhar_card_number` char(12),
  `Language` varchar(255),
  PRIMARY KEY (`Aadhar_card_number`, `Language`),
  FOREIGN KEY (`Aadhar_card_number`) REFERENCES `Airline_Employees/CREW` (`Aadhar_card_number`) ON DELETE CASCADE ON UPDATE CASCADE

);

-- -- ------------------------------------------------------------

DROP TABLE IF EXISTS `Stopover_Airports_of_Route`;

CREATE TABLE `Stopover_Airports_of_Route` (
  `Route_ID` int,
  `Stopover_Airport_IATA_CODE` varchar(3),
  PRIMARY KEY (`Route_ID`, `Stopover_Airport_IATA_CODE`),

  FOREIGN KEY (`Route_ID`) REFERENCES `Route` (`Route_ID`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`Stopover_Airport_IATA_CODE`) REFERENCES `Airport` (`IATA_CODE`) ON DELETE CASCADE ON UPDATE CASCADE

);

INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('207090631573', 'NICOLAS', 'LA', 'LOGAN', '2010-4-17', 'Male', '227', 'LO', 'Hyderabad', 'NICOLASLLOGAN@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('150667941422', 'AMANDA', 'SA', 'ROBLEDO', '1975-3-8', 'Male', '401', 'RO', 'Mumbai', 'AMANDASROBLEDO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('311872947944', 'RICHARD', 'MA', 'DAVIS', '1961-9-11', 'Male', '72', 'DA', 'Pune', 'RICHARDMDAVIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('906673823836', 'STEPHANIE', 'AA', 'ANDALUZ', '1953-10-18', 'Male', '837', 'AN', 'Hyderabad', 'STEPHANIEAANDALUZ@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('195743834667', 'NATALIE', 'AA', 'BRAY-KEEFER', '1986-3-18', 'Female', '909', 'BR', 'Bengaluru', 'NATALIEABRAY-KEEFER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('302739141189', 'JACQUELINE', 'EA', 'BREWER', '1990-1-17', 'Female', '463', 'BR', 'Mumbai', 'JACQUELINEEBREWER@hotmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('152246692823', 'CHARLES', 'IA', 'KIDD', '1957-8-2', 'Female', '360', 'KI', 'Toronto', 'CHARLESIKIDD@gmail.com', '1', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('449200994374', 'KAMILAH', 'AA', 'MASON', '1984-10-20', 'Male', '871', 'MA', 'Delhi', 'KAMILAHAMASON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('598578863608', 'BRITTANY', 'CA', 'MCCLINTON', '2008-5-27', 'Male', '804', 'MC', 'Pune', 'BRITTANYCMCCLINTON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('112222795509', 'SHERITA', 'SA', 'OWENS', '1950-1-3', 'Male', '461', 'OW', 'Mumbai', 'SHERITASOWENS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('607932019779', 'DRAKE', 'EA', 'ROBINSON', '2004-1-8', 'Male', '902', 'RO', 'Delhi', 'DRAKEEROBINSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('191968477066', 'JAWAN', 'AA', 'STOCKDALE', '1961-2-12', 'Female', '744', 'ST', 'Pune', 'JAWANASTOCKDALE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('588499828637', 'INDIGO', 'CA', 'WILLIAMS', '1994-9-6', 'Female', '109', 'WI', 'Mumbai', 'INDIGOCWILLIAMS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('878788802330', 'FREDERICK', 'RA', 'WINN', '1958-11-5', 'Female', '424', 'WI', 'Bengaluru', 'FREDERICKRWINN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('660672253823', 'LISA', 'MA', 'BARNETT', '1973-5-10', 'Male', '268', 'BA', 'Hyderabad', 'LISAMBARNETT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('962798560240', 'ROBERT', 'A', 'CINTRON', '1961-7-19', 'Male', '868', 'CI', 'Mumbai', 'ROBERTCINTRON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('902907191536', 'DIANA', 'A', 'MADRIGAL', '2019-10-12', 'Male', '420', 'MA', 'Chicago', 'DIANAMADRIGAL@gmail.com', '0', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('545295423127', 'JIANHUAI', 'A', 'XIE', '1988-2-25', 'Male', '449', 'XI', 'Mumbai', 'JIANHUAIXIE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('379405065549', 'ANTHONY', 'MA', 'TAMEZ', '1984-1-16', 'Female', '970', 'TA', 'Delhi', 'ANTHONYMTAMEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('668127242353', 'THERESA', 'A', 'GOMEZ', '2003-4-1', 'Female', '954', 'GO', 'Mumbai', 'THERESAGOMEZ@hotmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('936808290378', 'EDWARD', 'A', 'KODATT', '1971-2-6', 'Female', '36', 'KO', 'Pune', 'EDWARDKODATT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('991718823545', 'DANIEL', 'PA', 'MARTIN', '1988-1-22', 'Male', '644', 'MA', 'Delhi', 'DANIELPMARTIN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('440611948707', 'CHRISTINA', 'JA', 'MORGANELLI', '1950-9-22', 'Male', '683', 'MO', 'Pune', 'CHRISTINAJMORGANELLI@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('289020936379', 'LATIFA', 'A', 'ADEYEMO', '1958-12-14', 'Male', '312', 'AD', 'Mumbai', 'LATIFAADEYEMO@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('487744883827', 'ERIKA', 'RA', 'ALVARADO', '2001-7-11', 'Male', '580', 'AL', 'Bengaluru', 'ERIKARALVARADO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('129418607536', 'SHATARIA', 'A', 'CHESTNUT', '1997-1-14', 'Female', '609', 'CH', 'Hyderabad', 'SHATARIACHESTNUT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('394856058451', 'DIAMOND', 'A', 'CLAY', '2005-12-26', 'Female', '169', 'CL', 'Pune', 'DIAMONDCLAY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('653475904431', 'ROSALVA', 'A', 'CORREA', '2001-10-1', 'Female', '209', 'CO', 'London', 'ROSALVACORREA@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('729778449116', 'LILLIAN', 'A', 'CORTES', '2015-9-11', 'Male', '720', 'CO', 'Pune', 'LILLIANCORTES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('479755336220', 'REBECCA', 'SA', 'CUDECKI', '2008-10-3', 'Male', '450', 'CU', 'Mumbai', 'REBECCASCUDECKI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('215945706305', 'MELVINA', 'MA', 'DOUGLAS', '1957-2-6', 'Male', '477', 'DO', 'Delhi', 'MELVINAMDOUGLAS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('434806690436', 'THERESA', 'AA', 'EDMONDSON', '2020-7-24', 'Male', '161', 'ED', 'Pune', 'THERESAAEDMONDSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('998859180013', 'JOSHLYN', 'A', 'FIKES', '1985-3-8', 'Female', '669', 'FI', 'Bengaluru', 'JOSHLYNFIKES@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('516327813872', 'BRIANNA', 'A', 'FINNEY', '1978-4-3', 'Female', '196', 'FI', 'Pune', 'BRIANNAFINNEY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('162620865752', 'PACHINA', 'RA', 'FRAZIER', '1971-6-19', 'Female', '856', 'FR', 'Pune', 'PACHINARFRAZIER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('980396674004', 'TAWNJA', 'LA', 'FRAZIER', '1992-9-20', 'Male', '197', 'FR', 'Bengaluru', 'TAWNJALFRAZIER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('530337723408', 'MARQUISE', 'A', 'FREEMAN', '1960-12-4', 'Male', '788', 'FR', 'Hyderabad', 'MARQUISEFREEMAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('810365104449', 'COURTNEY', 'A', 'GAGE', '1962-11-4', 'Male', '601', 'GA', 'Mumbai', 'COURTNEYGAGE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('408924071666', 'RAQUEL', 'KA', 'GILLINGS', '1970-8-4', 'Male', '972', 'GI', 'Pune', 'RAQUELKGILLINGS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('777509633526', 'LISA', 'DA', 'GONZALEZ', '1986-8-21', 'Female', '472', 'GO', 'Pune', 'LISADGONZALEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('382938575139', 'JAZMIN', 'A', 'GUTIERREZ', '1992-8-6', 'Female', '402', 'GU', 'Bengaluru', 'JAZMINGUTIERREZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('888243500387', 'MARQUITA', 'VA', 'HARRIS', '2013-2-28', 'Female', '424', 'HA', 'NewYork', 'MARQUITAVHARRIS@gmail.com', '0', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('562160131218', 'PHYLLIS', 'AA', 'HARRIS', '2013-11-6', 'Male', '695', 'HA', 'Pune', 'PHYLLISAHARRIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('808155753159', 'CHANEL', 'RA', 'HESTER', '1968-3-22', 'Male', '799', 'HE', 'Bengaluru', 'CHANELRHESTER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('319875724256', 'NIKITA', 'A', 'HUTCHIESON', '1965-10-26', 'Male', '636', 'HU', 'Pune', 'NIKITAHUTCHIESON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('888111164019', 'JENNIFER', 'VA', 'IDOWU', '2020-11-1', 'Male', '766', 'ID', 'Mumbai', 'JENNIFERVIDOWU@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('902484285179', 'KATRINA', 'KA', 'JACKSON', '1982-11-23', 'Female', '399', 'JA', 'Pune', 'KATRINAKJACKSON@hotmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('674120066554', 'EBONY', 'NA', 'JOHNSON', '1986-3-6', 'Female', '826', 'JO', 'Bengaluru', 'EBONYNJOHNSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('206394752118', 'ASHA', 'SA', 'LEWIS', '1973-8-13', 'Female', '511', 'LE', 'Delhi', 'ASHASLEWIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('520697910564', 'WILLIAM', 'AA', 'MACKLIN', '1957-5-15', 'Male', '829', 'MA', 'Mumbai', 'WILLIAMAMACKLIN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('587464229547', 'THOMAS', 'JA', 'MAHER', '2009-4-25', 'Male', '918', 'MA', 'Pune', 'THOMASJMAHER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('468577721871', 'TANIA', 'CA', 'MATOS', '1991-5-2', 'Male', '733', 'MA', 'Pune', 'TANIACMATOS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('746089352731', 'LITITIA', 'A', 'MCCOLLUM', '2008-8-18', 'Male', '384', 'MC', 'Agra', 'LITITIAMCCOLLUM@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('769223717930', 'CONRAD', 'A', 'MOORE', '2009-9-14', 'Female', '512', 'MO', 'Hyderabad', 'CONRADMOORE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('318832402857', 'MONICA', 'LA', 'MORGAN', '2013-7-6', 'Female', '241', 'MO', 'Vancouver', 'MONICALMORGAN@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('203484369343', 'JESSICA', 'MA', 'NUNEZ', '2018-8-23', 'Female', '910', 'NU', 'Mumbai', 'JESSICAMNUNEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('220189353923', 'ERNESTO', 'A', 'OCHOA', '2005-10-1', 'Male', '146', 'OC', 'Bengaluru', 'ERNESTOOCHOA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('430661164482', 'BRIDGET', 'MA', 'DONOHUE', '1987-8-10', 'Male', '147', 'OL', 'Agra', 'BRIDGETMODONOHUE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('260665573547', 'BARBARA', 'LA', 'OLIVER', '1990-5-6', 'Male', '196', 'OL', 'Agra', 'BARBARALOLIVER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('757815584875', 'MATTHEW', 'A', 'PARKS', '1987-7-13', 'Male', '723', 'PA', 'Delhi', 'MATTHEWPARKS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('284332550815', 'TAMMY', 'AA', 'PETTIS', '2018-8-25', 'Female', '550', 'PE', 'Mumbai', 'TAMMYAPETTIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('125748434671', 'KIFINEY', 'RA', 'PITTS', '1972-1-21', 'Female', '898', 'PI', 'Agra', 'KIFINEYRPITTS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('843955864404', 'NEKIA', 'SA', 'PRICE', '1983-8-11', 'Female', '764', 'PR', 'Bengaluru', 'NEKIASPRICE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('844100237778', 'STEPHANEY', 'LA', 'REEVES', '1958-10-22', 'Male', '301', 'RE', 'Agra', 'STEPHANEYLREEVES@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('957032439716', 'MORGAN', 'RA', 'RICHARDSON', '1973-4-4', 'Male', '515', 'RI', 'Hyderabad', 'MORGANRRICHARDSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('162419083545', 'ALESHA', 'SA', 'ROBINSON', '2010-5-4', 'Male', '229', 'RO', 'Agra', 'ALESHASROBINSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('741430151992', 'ISABEL', 'GA', 'SALCEDO', '2006-9-26', 'Male', '178', 'SA', 'Mumbai', 'ISABELGSALCEDO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('227540062206', 'BENITA', 'A', 'SHAVERS', '1961-11-17', 'Female', '980', 'SH', 'Agra', 'BENITASHAVERS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('907985826328', 'YVONNE', 'A', 'SHEARRILL', '1968-8-15', 'Female', '749', 'SH', 'Bengaluru', 'YVONNESHEARRILL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('979333366244', 'HOLLY', 'CA', 'SHEW', '1995-8-10', 'Female', '957', 'SH', 'Agra', 'HOLLYCSHEW@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('445003929423', 'KELLY', 'AA', 'SHUGRUE', '2013-9-25', 'Male', '537', 'SH', 'San Francisco', 'KELLYASHUGRUE@gmail.com', '0', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('301322176115', 'PATRICIA', 'AA', 'STEIBING', '1951-8-10', 'Male', '581', 'ST', 'Delhi', 'PATRICIAASTEIBING@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('259920896017', 'MELINDA', 'EA', 'STEPHENS', '1967-9-10', 'Male', '565', 'ST', 'Agra', 'MELINDAESTEPHENS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('295134364736', 'FREDDIE', 'MA', 'STREET', '1988-4-4', 'Male', '1000', 'ST', 'Mumbai', 'FREDDIEMSTREET@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('154217461963', 'VIVIAN', 'EA', 'TAMRAS', '1999-3-15', 'Female', '807', 'TA', 'Bengaluru', 'VIVIANETAMRAS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('203561139409', 'PIERRE', 'A', 'URQUHART', '1968-9-8', 'Female', '691', 'UR', 'Agra', 'PIERREURQUHART@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('185985522397', 'NOEMI', 'A', 'VELAZQUEZ', '1962-10-9', 'Female', '612', 'VE', 'Agra', 'NOEMIVELAZQUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('926549471832', 'KEARRA', 'SA', 'WALLACE', '2013-12-28', 'Male', '996', 'WA', 'Hyderabad', 'KEARRASWALLACE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('971332165381', 'DALONDA', 'A', 'WALTON-PAGE', '1997-1-16', 'Male', '626', 'WA', 'Bengaluru', 'DALONDAWALTON-PAGE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('601857496728', 'CONSUELO', 'A', 'ZAMBRANO', '1956-4-23', 'Male', '950', 'ZA', 'Mumbai', 'CONSUELOZAMBRANO@yahoo.co.in', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('841682687454', 'DIANE', 'EA', 'ANGELETTI', '1993-5-21', 'Male', '14', 'AN', 'Montreal', 'DIANEEANGELETTI@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('392015460330', 'RHONDA', 'CA', 'COLLINS', '1961-1-23', 'Female', '479', 'CO', 'Agra', 'RHONDACCOLLINS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('878294842928', 'MARYANN', 'A', 'GRANGER', '2005-2-8', 'Female', '59', 'GR', 'Bengaluru', 'MARYANNGRANGER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('827667444188', 'GUYDRUDGE', 'A', 'ALTIDOR', '2011-6-13', 'Female', '703', 'AL', 'London', 'GUYDRUDGEALTIDOR@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('150509228378', 'ANGELA', 'DA', 'BOYD', '1970-2-26', 'Male', '141', 'BO', 'Mumbai', 'ANGELADBOYD@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('172374668645', 'LATONYA', 'DA', 'BROWN', '2014-9-22', 'Male', '486', 'BR', 'Agra', 'LATONYADBROWN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('933234057203', 'JATON', 'A', 'BURNAM', '2009-3-21', 'Male', '995', 'BU', 'Agra', 'JATONBURNAM@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('966621709488', 'BLANCA', 'EA', 'DATRO', '1969-3-14', 'Male', '471', 'DA', 'Bengaluru', 'BLANCAEDATRO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('371260491044', 'JENNIFER', 'A', 'DATRO', '1989-4-23', 'Female', '298', 'DA', 'Delhi', 'JENNIFERDATRO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('973408873868', 'LYNNETTE', 'A', 'DIGBY-POWELL', '2009-7-2', 'Female', '705', 'DI', 'Agra', 'LYNNETTEDIGBY-POWELL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('750432555990', 'JOYRI', 'DA', 'DUBOIS', '1952-3-28', 'Female', '243', 'DU', 'Mumbai', 'JOYRIDDUBOIS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('147000504847', 'MARYANN', 'EA', 'FERGUSON', '1969-8-24', 'Male', '900', 'FE', 'Kolkata', 'MARYANNEFERGUSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('261084200588', 'DIAUNDRA', 'A', 'FORBISH', '2004-10-1', 'Male', '504', 'FO', 'Hyderabad', 'DIAUNDRAFORBISH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('806130121923', 'SHAVANNAH', 'SA', 'FRANKLIN', '1983-6-8', 'Male', '348', 'FR', 'Bengaluru', 'SHAVANNAHSFRANKLIN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('907801232948', 'CARLA', 'TA', 'GREEN', '1961-2-22', 'Male', '997', 'GR', 'Hyderabad', 'CARLATGREEN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('679162257152', 'ISSA', 'AA', 'HADDAD', '1974-9-15', 'Female', '622', 'HA', 'London', 'ISSAAHADDAD@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('328262674792', 'BRIAN', 'KA', 'HAYNES', '1994-8-3', 'Female', '776', 'HA', 'Mumbai', 'BRIANKHAYNES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('998569191127', 'DAWN', 'PA', 'HINTON', '1995-4-6', 'Female', '762', 'HI', 'Kolkata', 'DAWNPHINTON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('107641374236', 'ASHLEY', 'NA', 'HUBBARD', '1958-6-22', 'Male', '525', 'HU', 'Kolkata', 'ASHLEYNHUBBARD@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('774989630671', 'INDIA', 'CA', 'JENKINS', '2000-7-21', 'Male', '821', 'JE', 'Hyderabad', 'INDIACJENKINS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('504451253936', 'STEFANIE', 'LA', 'KOLEK', '1961-2-18', 'Male', '434', 'KO', 'Bengaluru', 'STEFANIELKOLEK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('648534138100', 'DIVINITY', 'NA', 'LANE', '1975-7-24', 'Male', '540', 'LA', 'Mumbai', 'DIVINITYNLANE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('879334963851', 'DONNELL', 'LA', 'LATTIMORE', '1987-8-13', 'Female', '786', 'LA', 'Delhi', 'DONNELLLLATTIMORE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('772536939567', 'JARET', 'MA', 'LEONARD', '2017-2-3', 'Female', '11', 'LE', 'Pune', 'JARETMLEONARD@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('256760162370', 'NICARICO', 'A', 'LIDDELL', '1984-1-16', 'Female', '420', 'LI', 'Pune', 'NICARICOLIDDELL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('317669172527', 'RITA', 'FA', 'LOCKHART', '1975-4-11', 'Male', '70', 'LO', 'Bengaluru', 'RITAFLOCKHART@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('789535029093', 'ALICIA', 'MA', 'MARTIN', '2015-6-24', 'Male', '891', 'MA', 'Mumbai', 'ALICIAMMARTIN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('664317092189', 'IRIS', 'MA', 'MILLER', '1960-12-9', 'Male', '638', 'MI', 'Pune', 'IRISMMILLER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('693897522681', 'RAQUEL', 'EA', 'MORA-ZARAGOZA', '2008-12-19', 'Male', '992', 'MO', 'Delhi', 'RAQUELEMORA-ZARAGOZA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('632454512607', 'KIMBERLY', 'JA', 'MULLEN', '1991-6-21', 'Female', '45', 'MU', 'Pune', 'KIMBERLYJMULLEN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('199653002424', 'LINDA', 'DA', 'PIERCE', '1961-4-16', 'Female', '913', 'PI', 'Bengaluru', 'LINDADPIERCE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('437785294956', 'SHAWNA', 'SA', 'SAMPLE', '1953-7-18', 'Female', '466', 'SA', 'Montreal', 'SHAWNASSAMPLE@gmail.com', '1', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('354061382498', 'KARA', 'AA', 'SHEEHY', '2009-6-3', 'Male', '487', 'SH', 'Delhi', 'KARAASHEEHY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('302202827631', 'YANIRA', 'A', 'SIERRA', '2000-6-8', 'Male', '48', 'SI', 'Pune', 'YANIRASIERRA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('805768715675', 'RENEE', 'A', 'SLAUGHTER', '1997-11-1', 'Male', '72', 'SL', 'Mumbai', 'RENEESLAUGHTER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('984773638854', 'PATRICIA', 'A', 'VEGA', '1999-11-14', 'Male', '688', 'VE', 'Hyderabad', 'PATRICIAVEGA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('283846350978', 'MATTHEW', 'CA', 'WALKER', '2007-12-13', 'Female', '569', 'WA', 'Pune', 'MATTHEWCWALKER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('457213117949', 'TALENA', 'NA', 'COX', '2000-5-11', 'Female', '532', 'CO', 'Bengaluru', 'TALENANCOX@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('298272432716', 'LASHELLE', 'LA', 'FISHER', '2005-7-2', 'Female', '964', 'FI', 'NewYork', 'LASHELLELFISHER@gmail.com', '0', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('684229221952', 'KIMBERLY', 'MA', 'FITZPATRICK', '2009-5-28', 'Male', '294', 'FI', 'Pune', 'KIMBERLYMFITZPATRICK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('701960570247', 'SANDRA', 'DA', 'FOSTON', '1994-5-14', 'Male', '10', 'FO', 'Pune', 'SANDRADFOSTON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('544819430528', 'JUAN', 'LA', 'RANGEL', '1982-9-17', 'Male', '483', 'RA', 'Delhi', 'JUANLRANGEL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('642795041087', 'MARY', 'CA', 'ROMERO', '1961-4-2', 'Male', '395', 'RO', 'Mumbai', 'MARYCROMERO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('965446139948', 'SHAUN', 'A', 'SIMPSON', '1991-5-5', 'Female', '476', 'SI', 'Bengaluru', 'SHAUNSIMPSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('207577322706', 'TOMEKA', 'YA', 'PRICE', '2007-10-13', 'Female', '123', 'PR', 'Delhi', 'TOMEKAYPRICE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('132625673917', 'MURIEL', 'A', 'WEAVER', '2013-6-6', 'Female', '830', 'WE', 'Pune', 'MURIELWEAVER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('305031346364', 'KERRI', 'JA', 'STOJACK', '2001-4-5', 'Male', '636', 'ST', 'Pune', 'KERRIJSTOJACK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('107060275569', 'CHRISTINA', 'A', 'COCHAND', '1977-8-25', 'Male', '222', 'CO', 'Mumbai', 'CHRISTINACOCHAND@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('384537713635', 'JAMES', 'CA', 'BATTIESTE', '1980-1-28', 'Male', '459', 'BA', 'Hyderabad', 'JAMESCBATTIESTE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('260533660905', 'MARK', 'GA', 'GAMENG', '1979-3-13', 'Male', '961', 'GA', 'Pune', 'MARKGGAMENG@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('128556721392', 'NELIA', 'A', 'GONZALEZ', '1954-7-13', 'Female', '417', 'GO', 'Bengaluru', 'NELIAGONZALEZ@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('733654590871', 'KIMBERLEY', 'AA', 'HANSEN', '2000-6-5', 'Female', '143', 'HA', 'Delhi', 'KIMBERLEYAHANSEN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('945874925582', 'ANN', 'A', 'HINTERMAN', '1994-11-5', 'Female', '206', 'HI', 'Pune', 'ANNHINTERMAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('460081588423', 'KIMBERLY', 'DA', 'HOOPER', '1981-8-7', 'Male', '571', 'HO', 'Pune', 'KIMBERLYDHOOPER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('726117916587', 'MERCY', 'A', 'AKOMAA', '2014-10-14', 'Male', '489', 'AK', 'Bengaluru', 'MERCYAKOMAA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('714997361643', 'BRITISH', 'MA', 'LASSITER', '2008-10-25', 'Male', '185', 'LA', 'Mumbai', 'BRITISHMLASSITER@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('333932767424', 'DONNA', 'LA', 'MINNIEFIELD', '1960-8-24', 'Male', '137', 'MI', 'Vancouver', 'DONNALMINNIEFIELD@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('645125928635', 'SONYA', 'LA', 'TAYLOR', '2013-4-18', 'Female', '76', 'TA', 'Pune', 'SONYALTAYLOR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('785342807166', 'NEREIDA', 'A', 'AVILES', '1958-12-22', 'Female', '663', 'AV', 'Delhi', 'NEREIDAAVILES@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('326310748226', 'JOSEPH', 'FA', 'BAZAL', '2005-12-8', 'Female', '932', 'BA', 'Pune', 'JOSEPHFBAZAL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('612086734183', 'ARISHA', 'DA', 'DELANEY', '2012-3-6', 'Male', '924', 'DE', 'Bengaluru', 'ARISHADDELANEY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('276511446130', 'MARIA', 'EA', 'GAMEZ', '1979-10-11', 'Male', '217', 'GA', 'London', 'MARIAEGAMEZ@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('942727915435', 'DELORIS', 'A', 'HEATH', '2000-10-13', 'Male', '855', 'HE', 'Mumbai', 'DELORISHEATH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('390021761050', 'AARON', 'DA', 'JEFFRIES', '1976-5-19', 'Male', '928', 'JE', 'Pune', 'AARONDJEFFRIES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('370962119472', 'ROBERT', 'JA', 'LIGUE III', '1959-12-8', 'Female', '621', 'LI', 'Hyderabad', 'ROBERTJLIGUE III@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('933688831340', 'JENNIFER', 'A', 'MARTINIS', '1995-9-1', 'Female', '553', 'MA', 'Kolkata', 'JENNIFERMARTINIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('142814815975', 'JON', 'A', 'MICKLES', '2005-4-25', 'Female', '370', 'MI', 'Kolkata', 'JONMICKLES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('185092629829', 'ANTHONY', 'A', 'MINOR', '2012-9-14', 'Female', '812', 'MI', 'Delhi', 'ANTHONYMINOR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('799245744506', 'TOWANDA', 'A', 'MOSES', '1980-6-7', 'Male', '159', 'MO', 'Bengaluru', 'TOWANDAMOSES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('473407148189', 'TIMOTHY', 'PA', 'PARVIN', '1974-5-12', 'Male', '413', 'PA', 'Mumbai', 'TIMOTHYPPARVIN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('263911246445', 'EMONI', 'DA', 'RICHARDSON', '1984-7-17', 'Male', '428', 'RI', 'Kolkata', 'EMONIDRICHARDSON@hotmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('430177754974', 'DONNA', 'RA', 'SCOTT', '1963-11-12', 'Male', '239', 'SC', 'Delhi', 'DONNARSCOTT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('829850237368', 'JOHNNIE', 'MA', 'SHAFFER', '1994-1-5', 'Female', '504', 'SH', 'Kolkata', 'JOHNNIEMSHAFFER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('743475476997', 'YVONNE', 'A', 'SILVA', '2004-2-16', 'Female', '473', 'SI', 'Kolkata', 'YVONNESILVA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('581559418034', 'MARY', 'LA', 'TOWNS', '2001-10-14', 'Female', '575', 'TO', 'Delhi', 'MARYLTOWNS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('231986540258', 'PATRICE', 'CA', 'WILLIS', '2005-8-19', 'Male', '82', 'WI', 'Mumbai', 'PATRICECWILLIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('869751629757', 'SHARMAN', 'VA', 'WORTHY', '2010-6-15', 'Male', '562', 'WO', 'Bengaluru', 'SHARMANVWORTHY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('228374455783', 'PAULA', 'A', 'CLINE', '1977-4-9', 'Male', '623', 'CL', 'Delhi', 'PAULACLINE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('483752157384', 'PETER', 'JA', 'GONZALEZ', '2018-9-18', 'Male', '249', 'GO', 'Kolkata', 'PETERJGONZALEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('903075418867', 'JENNIFER', 'CA', 'TAYLOR', '1992-6-21', 'Female', '4', 'TA', 'Mumbai', 'JENNIFERCTAYLOR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('312614875041', 'ANA', 'LUISAA', 'ARENAS', '1988-6-7', 'Female', '833', 'AR', 'Hyderabad', 'ANALUISAARENAS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('671463840096', 'BEVERLY', 'A', 'BALLARD', '1960-11-17', 'Female', '885', 'BA', 'Kolkata', 'BEVERLYBALLARD@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('389930829279', 'LASHAWNDA', 'A', 'BARR', '2001-6-8', 'Male', '562', 'BA', 'Kolkata', 'LASHAWNDABARR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('770829328166', 'VALERIE', 'A', 'BIAS', '1963-12-27', 'Male', '799', 'BI', 'Toronto', 'VALERIEBIAS@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('816265849917', 'MARTA', 'A', 'BRANCH', '1974-6-28', 'Male', '481', 'BR', 'Mumbai', 'MARTABRANCH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('676258172551', 'JOSE', 'A', 'CARDENAS', '2004-5-24', 'Male', '942', 'CA', 'Bengaluru', 'JOSECARDENAS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('570770391644', 'RAQUEL', 'YA', 'CASTELLANOS', '1969-9-20', 'Female', '55', 'CA', 'London', 'RAQUELYCASTELLANOS@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('499033473365', 'NICOLE', 'RA', 'COSTANZO', '1959-11-11', 'Female', '625', 'CO', 'Kolkata', 'NICOLERCOSTANZO@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('217994403774', 'CHIMERE', 'SA', 'COX', '1993-11-9', 'Female', '99', 'CO', 'Delhi', 'CHIMERESCOX@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('437026515078', 'MARIA', 'RA', 'DANIELS', '1996-5-7', 'Male', '657', 'DA', 'Kolkata', 'MARIARDANIELS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('704452391342', 'GENEEN', 'A', 'DEAN', '2019-2-4', 'Male', '704', 'DE', 'Kolkata', 'GENEENDEAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('159502015807', 'KERMITTE', 'LA', 'DEASON', '1951-4-7', 'Male', '678', 'DE', 'Mumbai', 'KERMITTELDEASON@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('939132184139', 'SANDRA', 'DA', 'DUBUCLET', '1952-3-2', 'Male', '203', 'DU', 'Bengaluru', 'SANDRADDUBUCLET@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('355306902007', 'ANTOINETTE', 'MA', 'ESPARZA', '1992-9-6', 'Female', '486', 'ES', 'Chennai', 'ANTOINETTEMESPARZA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('244307140758', 'CANDACE', 'A', 'EXSON', '1983-2-4', 'Female', '982', 'EX', 'Delhi', 'CANDACEEXSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('922124073348', 'CARRIE', 'AA', 'FEENY', '2001-6-15', 'Female', '696', 'FE', 'Chennai', 'CARRIEAFEENY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('555131547468', 'KIMBERLY', 'TA', 'FRENCH', '1977-3-11', 'Male', '899', 'FR', 'Chennai', 'KIMBERLYTFRENCH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('199433440561', 'GARY', 'WA', 'GALLAS', '1991-11-17', 'Male', '747', 'GA', 'Bengaluru', 'GARYWGALLAS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('522919517233', 'EVELYN', 'A', 'GONZALEZ', '1970-12-21', 'Male', '209', 'GO', 'Pune', 'EVELYNGONZALEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('850131811619', 'SHARJUNAE', 'LA', 'GRAYER', '1971-7-19', 'Male', '625', 'GR', 'Hyderabad', 'SHARJUNAELGRAYER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('664942158462', 'CARLA', 'A', 'GREEN', '1954-11-18', 'Female', '768', 'GR', 'Mumbai', 'CARLAGREEN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('230134262748', 'AMY', 'CA', 'HALM', '1993-8-2', 'Female', '351', 'HA', 'Pune', 'AMYCHALM@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('352438233911', 'SHAVON', 'MA', 'HAMILTON', '1969-11-27', 'Female', '114', 'HA', 'Delhi', 'SHAVONMHAMILTON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('935776398461', 'RHONDA', 'A', 'HARBIN', '1978-8-18', 'Male', '657', 'HA', 'Pune', 'RHONDAHARBIN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('799014571773', 'LADONNA', 'RA', 'HARRIS', '1956-4-20', 'Male', '898', 'HA', 'Pune', 'LADONNARHARRIS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('190606839341', 'KELLIE', 'A', 'HUNT', '1970-5-25', 'Male', '696', 'HU', 'Mumbai', 'KELLIEHUNT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('799369811759', 'WANDA', 'A', 'JEFFERSON', '1985-4-6', 'Male', '150', 'JE', 'Bengaluru', 'WANDAJEFFERSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('276657105161', 'LAWANA', 'A', 'JONES WILLIAMS', '1968-9-14', 'Female', '561', 'JO', 'Pune', 'LAWANAJONES WILLIAMS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('700378128427', 'RENEE', 'PA', 'LAYE', '1955-12-20', 'Female', '891', 'LA', 'Montreal', 'RENEEPLAYE@gmail.com', '1', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('764692793635', 'SHERELYNNE', 'LA', 'LAYNE', '1989-6-16', 'Female', '945', 'LA', 'Pune', 'SHERELYNNELLAYNE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('265125061865', 'BONNIE', 'MA', 'LEMPERIS', '2015-12-22', 'Male', '949', 'LE', 'Pune', 'BONNIEMLEMPERIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('304231210018', 'JAVON', 'DA', 'LEWIS-BROWN', '1982-10-12', 'Male', '368', 'LE', 'Delhi', 'JAVONDLEWIS-BROWN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('325439086346', 'KATHLEEN', 'A', 'LOPEZ', '1991-9-21', 'Male', '874', 'LO', 'Pune', 'KATHLEENLOPEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('479596918134', 'ZETA', 'A', 'LYON', '1988-10-6', 'Male', '888', 'LY', 'Bengaluru', 'ZETALYON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('899017946187', 'RONNIE', 'A', 'MCFIELD', '2010-6-2', 'Female', '711', 'MC', 'Mumbai', 'RONNIEMCFIELD@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('206458280011', 'JOHNNA', 'A', 'MCINNIS', '2006-8-18', 'Female', '99', 'MC', 'Bengaluru', 'JOHNNAMCINNIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('420840242945', 'LIZABEL', 'A', 'MERCADO', '1983-4-20', 'Female', '131', 'ME', 'Hyderabad', 'LIZABELMERCADO@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('683186566699', 'THELMA', 'EA', 'MINOR', '1964-2-24', 'Male', '401', 'MI', 'Pune', 'THELMAEMINOR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('209740220526', 'MONIQUE', 'LA', 'MONTGOMERY', '1959-1-20', 'Male', '76', 'MO', 'Pune', 'MONIQUELMONTGOMERY@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('683907499097', 'TRACY', 'A', 'NUNO', '1993-1-28', 'Male', '50', 'NU', 'Mumbai', 'TRACYNUNO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('379410362813', 'ANTOINE', 'A', 'PATRICK', '2018-11-10', 'Male', '30', 'PA', 'Bengaluru', 'ANTOINEPATRICK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('516025128396', 'TORIA', 'IA', 'PHILLIP', '2001-6-3', 'Female', '372', 'PH', 'Delhi', 'TORIAIPHILLIP@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('572227204768', 'GUADALUPE', 'A', 'PROBO', '1973-11-28', 'Female', '779', 'PR', 'Pune', 'GUADALUPEPROBO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('522729864898', 'ALEXANDRIA', 'OA', 'RAMBUS', '1977-6-15', 'Female', '486', 'RA', 'Bengaluru', 'ALEXANDRIAORAMBUS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('512730411673', 'LATONIA', 'DA', 'RANDOLPH', '1954-1-12', 'Male', '101', 'RA', 'Mumbai', 'LATONIADRANDOLPH@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('581478947596', 'FRANZETTA', 'AA', 'REDD', '1998-8-20', 'Male', '388', 'RE', 'Bengaluru', 'FRANZETTAAREDD@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('149843027110', 'JERRY', 'A', 'ROMERO', '1951-3-16', 'Male', '573', 'RO', 'Delhi', 'JERRYROMERO@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('184608958723', 'BRIAN', 'MA', 'ROWE', '1956-9-2', 'Male', '238', 'RO', 'Bengaluru', 'BRIANMROWE@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('349699324970', 'LYNNTOSHA', 'NA', 'SCOTT', '2018-4-23', 'Female', '862', 'SC', 'Mumbai', 'LYNNTOSHANSCOTT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('508444378955', 'CHERYL', 'JA', 'SHORT-GIPSON', '1975-1-20', 'Female', '742', 'SH', 'Bengaluru', 'CHERYLJSHORT-GIPSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('705833330229', 'NANCY', 'AA', 'SIMON', '1957-8-7', 'Female', '900', 'SI', 'Bengaluru', 'NANCYASIMON@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('985069232535', 'KIMBERLY', 'AA', 'SIMPSON', '1959-3-12', 'Male', '438', 'SI', 'Mumbai', 'KIMBERLYASIMPSON@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('476592469291', 'STACIE', 'A', 'SMIGIELSKI', '1969-1-18', 'Male', '316', 'SM', 'Hyderabad', 'STACIESMIGIELSKI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('403069128350', 'SHIRLEY', 'MA', 'SMITH', '1987-1-24', 'Male', '217', 'SM', 'Delhi', 'SHIRLEYMSMITH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('276334408607', 'LATISA', 'YA', 'STEWART', '1952-9-15', 'Male', '814', 'ST', 'Bengaluru', 'LATISAYSTEWART@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('173088700264', 'BEATA', 'A', 'SZOT', '1995-8-16', 'Female', '716', 'SZ', 'Bengaluru', 'BEATASZOT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('418967534050', 'VERONICA', 'RA', 'THOMPSON', '2015-5-26', 'Female', '462', 'TH', 'Montreal', 'VERONICARTHOMPSON@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('360754673882', 'ALEXANDRA', 'CA', 'TOLEDO', '1950-3-4', 'Female', '536', 'TO', 'Bengaluru', 'ALEXANDRACTOLEDO@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('592232310023', 'LEKISHA', 'A', 'TRIGGLETH', '2017-8-24', 'Male', '158', 'TR', 'Bengaluru', 'LEKISHATRIGGLETH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('539944676870', 'JASHAYA', 'LA', 'TURNAGE', '1981-8-19', 'Male', '124', 'TU', 'Bengaluru', 'JASHAYALTURNAGE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('257477530607', 'YVIS', 'A', 'VARGAS', '1988-1-3', 'Male', '597', 'VA', 'Delhi', 'YVISVARGAS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('999096482163', 'CARMEN', 'A', 'VILLALPANDO', '2018-1-13', 'Male', '745', 'VI', 'Mumbai', 'CARMENVILLALPANDO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('426004588315', 'CHARLES', 'A', 'VISTO-ARAUJO', '1963-12-14', 'Female', '368', 'VI', 'Bengaluru', 'CHARLESVISTO-ARAUJO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('801100703126', 'CASSANDRA', 'LA', 'WHITE', '1982-10-12', 'Female', '97', 'WH', 'Bengaluru', 'CASSANDRALWHITE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('254526260713', 'JEFFERY', 'A', 'WHITE', '2006-7-28', 'Female', '205', 'WH', 'Bengaluru', 'JEFFERYWHITE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('685306158418', 'ALEXIS', 'A', 'WILLIAMS', '1994-7-11', 'Male', '747', 'WI', 'Bengaluru', 'ALEXISWILLIAMS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('328987277297', 'JASMINE', 'RA', 'WILLIAMS', '1955-11-2', 'Male', '677', 'WI', 'Mumbai', 'JASMINERWILLIAMS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('102756400581', 'TAKEYLA', 'GA', 'WILLIAMS', '1963-3-11', 'Male', '404', 'WI', 'Delhi', 'TAKEYLAGWILLIAMS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('375183930342', 'OCTAVIA', 'A', 'WILLIS', '1988-4-24', 'Male', '407', 'WI', 'Bengaluru', 'OCTAVIAWILLIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('635610926316', 'ANGELA', 'LA', 'WILSON- DAVIS', '1989-8-28', 'Female', '300', 'WI', 'Los Angeles', 'ANGELALWILSON- DAVIS@gmail.com', '0', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('923700012332', 'VALLARY', 'AA', 'WILSON', '1961-7-20', 'Female', '530', 'WI', 'Hyderabad', 'VALLARYAWILSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('275544326703', 'BENITA', 'A', 'WRIGHT', '1991-1-14', 'Female', '170', 'WR', 'Bengaluru', 'BENITAWRIGHT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('516386055911', 'HELENA', 'AA', 'BREWSTER', '1978-2-17', 'Male', '695', 'BR', 'Pune', 'HELENAABREWSTER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('280279660706', 'BOBBIE', 'JA', 'BYRD', '2018-4-21', 'Male', '568', 'BY', 'Delhi', 'BOBBIEJBYRD@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('523450623482', 'MAURICE', 'A', 'GRIFFIN', '1956-5-14', 'Male', '452', 'GR', 'Pune', 'MAURICEGRIFFIN@yahoo.co.in', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('821336829357', 'SHAQUNIA', 'RA', 'SMITH', '1971-9-6', 'Male', '10', 'SM', 'Mumbai', 'SHAQUNIARSMITH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('274026111101', 'LASHAWN', 'MA', 'THOMAS', '1959-2-25', 'Female', '607', 'TH', 'London', 'LASHAWNMTHOMAS@gmail.com', '1', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('405482480278', 'ROMELLA', 'A', 'WOODS', '2001-1-9', 'Female', '837', 'WO', 'Pune', 'ROMELLAWOODS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('643441678252', 'MICHAEL', 'MA', 'MCMURRAY', '2003-3-5', 'Female', '468', 'MC', 'Pune', 'MICHAELMMCMURRAY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('849930510072', 'MICHAEL', 'JA', 'BSHARAH', '1950-8-22', 'Male', '154', 'BS', 'Delhi', 'MICHAELJBSHARAH@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('465849559932', 'JOCELYN', 'JA', 'BUCHANAN', '2020-1-8', 'Male', '79', 'BU', 'Pune', 'JOCELYNJBUCHANAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('374047037851', 'FRANCESCA', 'NA', 'LYNN', '2005-11-25', 'Male', '654', 'LY', 'Chennai', 'FRANCESCANLYNN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('325689985568', 'TARA', 'RA', 'NEMETH', '2008-11-11', 'Male', '311', 'NE', 'Mumbai', 'TARARNEMETH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('514602378618', 'YASMINE', 'A', 'TOLEDO', '1961-1-16', 'Female', '493', 'TO', 'Bengaluru', 'YASMINETOLEDO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('887127804408', 'JERMAINE', 'CA', 'GILMER', '1984-12-26', 'Female', '39', 'GI', 'Vancouver', 'JERMAINECGILMER@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('910932834215', 'CAROL', 'A', 'TRIPLETT', '1965-10-22', 'Female', '839', 'TR', 'Bengaluru', 'CAROLTRIPLETT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('765672822342', 'CYNTHIA', 'LA', 'MC GHEE', '1970-6-18', 'Female', '812', 'MC', 'Bengaluru', 'CYNTHIALMC GHEE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('207939001028', 'VALERIE', 'A', 'PRENDERGAST', '1960-10-11', 'Male', '397', 'PR', 'Bengaluru', 'VALERIEPRENDERGAST@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('488077310542', 'CHRISTOPHER', 'A', 'ROWE', '1962-6-22', 'Male', '291', 'RO', 'Hyderabad', 'CHRISTOPHERROWE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('129012135594', 'JERRY', 'A', 'ABRAHAM', '2000-9-26', 'Male', '978', 'AB', 'Delhi', 'JERRYABRAHAM@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('266506253523', 'MARIA', 'GA', 'AGUAYO', '1991-5-8', 'Male', '529', 'AG', 'Mumbai', 'MARIAGAGUAYO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('577016411776', 'JEAN', 'PA', 'ALEXIS', '1977-8-18', 'Female', '809', 'AL', 'Bengaluru', 'JEANPALEXIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('923142389193', 'ASHAUNTA', 'SA', 'BAKER', '1961-7-1', 'Female', '307', 'BA', 'Bengaluru', 'ASHAUNTASBAKER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('254174657664', 'VANESSA', 'A', 'BARRERA', '1994-3-21', 'Female', '372', 'BA', 'Bengaluru', 'VANESSABARRERA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('269853191621', 'JASMINE', 'A', 'JACKSON', '1967-8-23', 'Male', '114', 'JA', 'Mumbai', 'JASMINEJACKSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('402451294104', 'CANDACE', 'RA', 'LOCKWOOD', '1951-5-1', 'Male', '72', 'LO', 'Delhi', 'CANDACERLOCKWOOD@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('594976747942', 'ADALEE', 'A', 'PARRA', '2011-2-23', 'Male', '615', 'PA', 'Bengaluru', 'ADALEEPARRA@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('716866658134', 'CANDIS', 'JA', 'REED', '2006-11-14', 'Male', '190', 'RE', 'Bengaluru', 'CANDISJREED@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('103705643890', 'JULIA', 'A', 'RUIZ', '1966-2-12', 'Female', '267', 'RU', 'Bengaluru', 'JULIARUIZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('130320057105', 'MELISSA', 'RA', 'SMITH', '1982-4-20', 'Female', '509', 'SM', 'Mumbai', 'MELISSARSMITH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('136024895785', 'JACQUELYN', 'CA', 'SOTO', '1976-12-9', 'Female', '331', 'SO', 'Bengaluru', 'JACQUELYNCSOTO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('451446195146', 'NICOLE', 'MA', 'TALEND', '1962-11-14', 'Male', '303', 'TA', 'Hyderabad', 'NICOLEMTALEND@hotmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('425053423515', 'DEBORAH', 'LA', 'THOMPSON', '1952-4-11', 'Male', '46', 'TH', 'Delhi', 'DEBORAHLTHOMPSON@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('493259767701', 'DANIEL', 'AA', 'VALDIVIA', '2004-3-2', 'Male', '127', 'VA', 'Bengaluru', 'DANIELAVALDIVIA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('675338023609', 'YUXIAN', 'A', 'WEN', '1955-10-6', 'Male', '17', 'WE', 'San Francisco', 'YUXIANWEN@gmail.com', '1', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('133125586336', 'LESSIE', 'A', 'WILLIAMS', '1954-6-9', 'Female', '536', 'WI', 'Bengaluru', 'LESSIEWILLIAMS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('212249754488', 'WANDA', 'MA', 'WILLIAMS', '1967-10-17', 'Female', '852', 'WI', 'Mumbai', 'WANDAMWILLIAMS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('916031128846', 'JESSICA', 'A', 'PAPP', '1975-4-4', 'Female', '998', 'PA', 'Bengaluru', 'JESSICAPAPP@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('923192631750', 'ANDRIA', 'A', 'AGUILAR', '1953-11-18', 'Male', '754', 'AG', 'Toronto', 'ANDRIAAGUILAR@gmail.com', '1', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('663476556400', 'RICHARD', 'A', 'LINDBERG', '1980-1-8', 'Male', '921', 'LI', 'Bengaluru', 'RICHARDLINDBERG@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('645099769325', 'GEORGE', 'A', 'ARROYO', '1982-8-19', 'Male', '264', 'AR', 'Delhi', 'GEORGEARROYO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('406931771979', 'SHAWN', 'NA', 'SMITH', '1986-5-9', 'Male', '46', 'SM', 'Mumbai', 'SHAWNNSMITH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('135611548844', 'KWELI', 'TA', 'KWAZA', '1966-4-3', 'Female', '405', 'KW', 'Bengaluru', 'KWELITKWAZA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('505291410580', 'DARLENE', 'DA', 'DUKE', '1991-4-1', 'Female', '712', 'DU', 'Chennai', 'DARLENEDDUKE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('957792348576', 'SHARTONE', 'LA', 'MOORE', '1996-3-1', 'Female', '549', 'MO', 'Chennai', 'SHARTONELMOORE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('599196148588', 'GENEVA', 'A', 'MORRIS', '1982-8-3', 'Male', '834', 'MO', 'Mumbai', 'GENEVAMORRIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('982706930849', 'TYWANA', 'SA', 'BROOME', '1954-5-13', 'Male', '364', 'BR', 'Kolkata', 'TYWANASBROOME@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('718034221496', 'GEORGIA', 'NA', 'BUTLER', '1981-9-3', 'Male', '939', 'BU', 'Hyderabad', 'GEORGIANBUTLER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('191379608154', 'MERCEDES', 'MA', 'COFFEE', '1976-4-7', 'Male', '776', 'CO', 'Kolkata', 'MERCEDESMCOFFEE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('279067350735', 'PATRICK', 'JA', 'DOWLING', '2013-12-21', 'Female', '422', 'DO', 'Kolkata', 'PATRICKJDOWLING@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('486334593278', 'JOSE', 'A', 'FRAIRE', '1952-1-25', 'Female', '926', 'FR', 'Delhi', 'JOSEFRAIRE@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('699342170370', 'KELLY', 'AA', 'GARR PFEIFER', '1954-9-13', 'Female', '831', 'GA', 'Mumbai', 'KELLYAGARR PFEIFER@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('336423921567', 'JAMES', 'A', 'HILL', '1984-11-28', 'Male', '563', 'HI', 'Bengaluru', 'JAMESHILL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('799509921430', 'RAVEN', 'RA', 'JACKSON', '1977-7-28', 'Male', '379', 'JA', 'Bengaluru', 'RAVENRJACKSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('395618766916', 'LARONDA', 'SA', 'JAMISON', '1967-8-20', 'Male', '503', 'JA', 'Delhi', 'LARONDASJAMISON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('495699468168', 'CHANTE', 'LA', 'LEWIS', '1970-6-13', 'Male', '478', 'LE', 'Bengaluru', 'CHANTELLEWIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('418129643827', 'VERONICA', 'IA', 'MALDONADO', '1970-2-17', 'Female', '528', 'MA', 'London', 'VERONICAIMALDONADO@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('355061452380', 'CHERIE', 'LA', 'MINNIFIELD', '1972-8-18', 'Female', '511', 'MI', 'Bengaluru', 'CHERIELMINNIFIELD@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('243401059014', 'NICOLE', 'MA', 'NASIR', '1979-5-12', 'Female', '690', 'NA', 'Mumbai', 'NICOLEMNASIR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('299024915943', 'ROMEL', 'A', 'RAY', '1994-4-6', 'Male', '946', 'RA', 'Bengaluru', 'ROMELRAY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('393303541607', 'GEORGE', 'A', 'STEWART JR.', '1976-7-5', 'Male', '364', 'ST', 'Hyderabad', 'GEORGESTEWART JR.@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('733063971604', 'BRANDON', 'DA', 'TERRELL', '1980-7-16', 'Male', '935', 'TE', 'Delhi', 'BRANDONDTERRELL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('754909536596', 'TERRY', 'EA', 'WATKINS', '1951-1-22', 'Male', '290', 'WA', 'Bengaluru', 'TERRYEWATKINS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('361383046390', 'DELORES', 'GA', 'WILLIAMS', '1991-2-28', 'Female', '533', 'WI', 'Montreal', 'DELORESGWILLIAMS@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('813024926888', 'ALEJANDRO', 'A', 'ABONCE', '2001-4-5', 'Female', '68', 'AB', 'Bengaluru', 'ALEJANDROABONCE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('723269172686', 'ALA', 'A', 'ABU-HUMOS', '1965-8-12', 'Female', '819', 'AB', 'Bengaluru', 'ALAABU-HUMOS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('401843241657', 'LUIS', 'AA', 'ACEVES', '1982-11-26', 'Male', '177', 'AC', 'Mumbai', 'LUISAACEVES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('391826987704', 'ELIAS', 'A', 'AGREDANO', '1952-1-26', 'Male', '193', 'AG', 'Bengaluru', 'ELIASAGREDANO@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('409565375077', 'CARLA', 'A', 'ALECRIM COLACO RAMOS', '1970-1-4', 'Male', '978', 'AL', 'Bengaluru', 'CARLAALECRIM COLACO RAMOS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('833286637007', 'TYLER', 'JA', 'ALEXANDER', '2000-11-17', 'Male', '226', 'AL', 'Delhi', 'TYLERJALEXANDER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('371258961953', 'BAKER', 'HA', 'ALFARAJAT', '2001-11-13', 'Female', '174', 'AL', 'Bengaluru', 'BAKERHALFARAJAT@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('963976634374', 'MICHAEL', 'JA', 'ALFARO', '2006-12-26', 'Female', '918', 'AL', 'Bengaluru', 'MICHAELJALFARO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('162599582043', 'MICHAEL', 'WA', 'AMBROSE', '2010-4-3', 'Female', '857', 'AM', 'Bengaluru', 'MICHAELWAMBROSE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('939988876625', 'RYAN', 'DA', 'ANDERSON', '1954-8-16', 'Male', '238', 'AN', 'Bengaluru', 'RYANDANDERSON@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('190249883035', 'JENNY', 'DA', 'ANDREWS', '2019-9-26', 'Male', '31', 'AN', 'Mumbai', 'JENNYDANDREWS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('146027300121', 'VICKY', 'A', 'APOSTOLOU', '1961-2-6', 'Male', '623', 'AP', 'Bengaluru', 'VICKYAPOSTOLOU@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('314274436742', 'OLEKSANDR', 'A', 'ARTYMOVYCH', '1993-12-12', 'Male', '473', 'AR', 'Bengaluru', 'OLEKSANDRARTYMOVYCH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('875699933257', 'GABRIEL', 'A', 'AUGUSTYNIAK', '1975-9-24', 'Female', '588', 'AU', 'Hyderabad', 'GABRIELAUGUSTYNIAK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('474264207408', 'IVAN', 'A', 'AVILA', '1960-1-18', 'Female', '8', 'AV', 'Bengaluru', 'IVANAVILA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('322045746657', 'NIKKOLAI', 'AA', 'AZEVEDO', '2004-11-1', 'Female', '400', 'AZ', 'Bengaluru', 'NIKKOLAIAAZEVEDO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('524072474465', 'LUIS', 'EA', 'BAEZ', '2005-6-25', 'Male', '348', 'BA', 'London', 'LUISEBAEZ@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('805899460746', 'MAURY', 'UA', 'BAHENA', '2008-7-11', 'Male', '761', 'BA', 'Delhi', 'MAURYUBAHENA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('691591994642', 'FERNANDA', 'A', 'BALLESTEROS', '1996-8-2', 'Male', '984', 'BA', 'Kolkata', 'FERNANDABALLESTEROS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('443779954453', 'ANDRE', 'A', 'BALSECA', '2004-1-27', 'Male', '164', 'BA', 'Mumbai', 'ANDREBALSECA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('751529501416', 'JESSICA', 'RA', 'BANKS', '2017-3-22', 'Female', '343', 'BA', 'Agra', 'JESSICARBANKS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('452784325925', 'JOYCE', 'PA', 'BANSLEY', '1952-4-16', 'Female', '437', 'BA', 'Delhi', 'JOYCEPBANSLEY@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('641027662554', 'DENISSE', 'A', 'BARON', '1992-3-19', 'Female', '814', 'BA', 'Agra', 'DENISSEBARON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('340420114634', 'WILLIAM', 'EA', 'BARRETT-DWYER', '2017-5-16', 'Male', '969', 'BA', 'Vancouver', 'WILLIAMEBARRETT-DWYER@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('246466735580', 'JELENA', 'A', 'BECIREVIC', '1950-6-11', 'Male', '474', 'BE', 'NewYork', 'JELENABECIREVIC@gmail.com', '1', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('421086145338', 'PATRYK', 'A', 'BEDNARZ', '2016-9-17', 'Male', '810', 'BE', 'Agra', 'PATRYKBEDNARZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('881346406347', 'CARMON', 'TA', 'BENAMON', '2014-5-15', 'Male', '845', 'BE', 'Agra', 'CARMONTBENAMON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('744986677244', 'JACOB', 'LA', 'BENCIE', '2013-8-23', 'Female', '676', 'BE', 'Hyderabad', 'JACOBLBENCIE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('324730020111', 'MIGUEL', 'AA', 'BERMUDEZ VALLES', '1975-7-20', 'Female', '501', 'BE', 'Mumbai', 'MIGUELABERMUDEZ VALLES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('880083693169', 'ALONSO', 'A', 'BERNAL', '2014-3-6', 'Female', '942', 'BE', 'Agra', 'ALONSOBERNAL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('811729698168', 'CHANDA', 'BA', 'BLACKAMORE', '1996-11-28', 'Male', '805', 'BL', 'Bengaluru', 'CHANDABBLACKAMORE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('783990215496', 'NATHANIEL', 'A', 'BLACKMAN IV', '1952-9-24', 'Male', '574', 'BL', 'Delhi', 'NATHANIELBLACKMAN IV@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('130015502919', 'JAMES', 'AA', 'BODDEN', '1986-4-22', 'Male', '126', 'BO', 'Bengaluru', 'JAMESABODDEN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('983836236902', 'JOSIAH', 'GA', 'BOLANOS', '1962-1-24', 'Male', '613', 'BO', 'Bengaluru', 'JOSIAHGBOLANOS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('501580228641', 'NYASIA', 'PA', 'BOLDEN', '1984-3-7', 'Female', '903', 'BO', 'Mumbai', 'NYASIAPBOLDEN@hotmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('959133141129', 'COURTNEY', 'EA', 'BOLLIN', '2002-11-10', 'Female', '713', 'BO', 'Delhi', 'COURTNEYEBOLLIN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('846633651714', 'SANTIAGO', 'A', 'BOYAS', '1954-4-27', 'Female', '972', 'BO', 'Bengaluru', 'SANTIAGOBOYAS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('875843798258', 'PHILLIP', 'AA', 'BREDENBERG', '1962-6-27', 'Male', '43', 'BR', 'Bengaluru', 'PHILLIPABREDENBERG@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('977635795160', 'NICHOLAS', 'A', 'BUMBARIS', '1977-3-21', 'Male', '613', 'BU', 'Bengaluru', 'NICHOLASBUMBARIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('764939034016', 'BRIAN', 'A', 'BURAK', '1967-4-28', 'Male', '909', 'BU', 'Bengaluru', 'BRIANBURAK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('529863560635', 'PATRICK', 'JA', 'BURKE', '1999-11-8', 'Male', '953', 'BU', 'London', 'PATRICKJBURKE@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('589385828532', 'LESLEY', 'EA', 'BUTLER', '1967-8-22', 'Female', '168', 'BU', 'Mumbai', 'LESLEYEBUTLER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('605073995473', 'ANGELINA', 'PA', 'CAHUE', '1981-7-22', 'Female', '934', 'CA', 'Hyderabad', 'ANGELINAPCAHUE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('485435021847', 'VICTOR', 'A', 'CAHUE', '1986-1-3', 'Female', '92', 'CA', 'Bengaluru', 'VICTORCAHUE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('565159997963', 'JANET', 'LA', 'CALDERON', '2001-7-9', 'Male', '544', 'CA', 'Bengaluru', 'JANETLCALDERON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('599953047020', 'MARIA', 'LA', 'CAPI', '1954-9-9', 'Male', '341', 'CA', 'Bengaluru', 'MARIALCAPI@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('131888913314', 'PRISCILLA', 'A', 'CARBAJAL', '2013-12-3', 'Male', '229', 'CA', 'Delhi', 'PRISCILLACARBAJAL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('450862785239', 'PABLO', 'JA', 'CARTAGENA', '1954-12-3', 'Male', '783', 'CA', 'Bengaluru', 'PABLOJCARTAGENA@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('714047739324', 'ALESHIA', 'AA', 'CARTER', '1977-12-22', 'Female', '964', 'CA', 'Montreal', 'ALESHIAACARTER@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('216417595823', 'DANIEL', 'TA', 'CASEY', '1961-3-16', 'Female', '859', 'CA', 'Mumbai', 'DANIELTCASEY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('854567648069', 'ANTHONY', 'JA', 'CESENA', '2017-3-20', 'Female', '57', 'CE', 'Bengaluru', 'ANTHONYJCESENA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('990601574360', 'IVAN', 'VA', 'CISNEROS ZAVALA', '1952-2-28', 'Male', '167', 'CI', 'Bengaluru', 'IVANVCISNEROS ZAVALA@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('222550017428', 'ANDREW', 'JA', 'CISZEK', '2012-5-5', 'Male', '808', 'CI', 'Bengaluru', 'ANDREWJCISZEK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('798872691742', 'DWANE', 'RA', 'CLARK', '2013-3-8', 'Male', '195', 'CL', 'Bengaluru', 'DWANERCLARK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('464619640140', 'ARIEON', 'LA', 'CLAYTON', '1981-8-6', 'Male', '633', 'CL', 'Delhi', 'ARIEONLCLAYTON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('863491540958', 'LILIAN', 'A', 'COCIORVA', '2015-6-20', 'Female', '259', 'CO', 'Mumbai', 'LILIANCOCIORVA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('985916710256', 'MARSEILLA', 'AA', 'COLLINS', '1973-8-23', 'Female', '964', 'CO', 'Agra', 'MARSEILLAACOLLINS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('532645477174', 'RACHEL', 'SA', 'COLLINS', '1981-10-1', 'Female', '985', 'CO', 'Pune', 'RACHELSCOLLINS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('764374600564', 'ERICK', 'A', 'CORTEZ', '2009-12-3', 'Male', '739', 'CO', 'Pune', 'ERICKCORTEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('676592595463', 'KEVIN', 'MA', 'COYNE', '1960-6-6', 'Male', '346', 'CO', 'Hyderabad', 'KEVINMCOYNE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('228719603161', 'MATTHEW', 'TA', 'DAHILL', '1997-6-28', 'Male', '250', 'DA', 'Pune', 'MATTHEWTDAHILL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('589422183921', 'SAMUEL', 'A', 'DANIELS', '1975-1-18', 'Male', '499', 'DA', 'Mumbai', 'SAMUELDANIELS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('886560121125', 'ASHA', 'KA', 'DAS', '1973-10-2', 'Female', '232', 'DA', 'Pune', 'ASHAKDAS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('704061898917', 'ALEXANDER', 'A', 'DAVID', '2003-12-11', 'Female', '846', 'DA', 'Glasgow', 'ALEXANDERDAVID@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('104179493962', 'HOUSTON', 'AA', 'DAY', '2016-7-23', 'Female', '290', 'DA', 'Delhi', 'HOUSTONADAY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('170862696244', 'VERONICA', 'MA', 'DE JESUS', '1956-12-24', 'Male', '485', 'DE', 'Pune', 'VERONICAMDE JESUS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('189987710798', 'VANESSA', 'AA', 'DELEON', '2002-6-5', 'Male', '546', 'DE', 'Pune', 'VANESSAADELEON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('261605960961', 'CRISTIAN', 'A', 'DE LUNA', '1996-11-9', 'Male', '488', 'DE', 'Mumbai', 'CRISTIANDE LUNA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('441172874397', 'MARGARITA', 'A', 'DIAZ', '2009-1-7', 'Male', '309', 'DI', 'Pune', 'MARGARITADIAZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('423602507442', 'MERCEDES', 'A', 'DIAZ', '1954-11-18', 'Female', '647', 'DI', 'Delhi', 'MERCEDESDIAZ@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('170450296187', 'DEJA\'', 'JA', 'DICKENS', '2017-7-19', 'Female', '987', 'DI', 'Pune', 'DEJA\'JDICKENS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('793636550631', 'SARAH', 'LA', 'DONNELLAN', '2015-12-14', 'Female', '81', 'DO', 'Pune', 'SARAHLDONNELLAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('914066692974', 'TIMOTHY', 'JA', 'DOOHAN', '1972-2-19', 'Male', '871', 'DO', 'Mumbai', 'TIMOTHYJDOOHAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('979450501005', 'DAVID', 'JA', 'DORIA', '1969-10-28', 'Male', '579', 'DO', 'Toronto', 'DAVIDJDORIA@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('167299490125', 'MICHELLE', 'A', 'DRAPALA', '1966-6-24', 'Male', '773', 'DR', 'Pune', 'MICHELLEDRAPALA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('707796540702', 'GONZALO', 'A', 'DURAN JR', '1950-4-17', 'Male', '413', 'DU', 'Hyderabad', 'GONZALODURAN JR@yahoo.co.in', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('482262964829', 'ZEKO', 'A', 'DUROVIC', '2018-1-14', 'Female', '130', 'DU', 'Pune', 'ZEKODUROVIC@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('958159755571', 'HARIS', 'A', 'DZEBIC', '2019-5-19', 'Female', '405', 'DZ', 'Mumbai', 'HARISDZEBIC@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('541641624287', 'MARC', 'GA', 'EDINGBURG', '2019-3-4', 'Female', '463', 'ED', 'Delhi', 'MARCGEDINGBURG@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('243168117955', 'ANGELA', 'VA', 'EDWARDS', '2009-7-21', 'Male', '242', 'ED', 'Pune', 'ANGELAVEDWARDS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('149106824972', 'LUKE', 'DA', 'ENGEL', '2004-2-4', 'Male', '806', 'EN', 'Pune', 'LUKEDENGEL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('403463020682', 'MARIO', 'JA', 'ENOCH', '1957-1-15', 'Male', '532', 'EN', 'Pune', 'MARIOJENOCH@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('177651855359', 'MARIA', 'GA', 'ESPINOZA', '2015-9-11', 'Male', '1000', 'ES', 'Pune', 'MARIAGESPINOZA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('290091299917', 'DERVA', 'A', 'FEJZIC', '1994-6-26', 'Female', '920', 'FE', 'Hyderabad', 'DERVAFEJZIC@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('186698056563', 'MABEL', 'A', 'FERNANDEZ', '1980-8-1', 'Female', '828', 'FE', 'Mumbai', 'MABELFERNANDEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('436326180534', 'EVA', 'A', 'FLECHA', '2019-4-28', 'Female', '816', 'FL', 'Delhi', 'EVAFLECHA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('752940292349', 'PALOMA', 'A', 'FLORES', '2013-5-10', 'Male', '119', 'FL', 'Pune', 'PALOMAFLORES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('367589096955', 'JIMMY', 'A', 'FRANCOIS', '1959-10-8', 'Male', '746', 'FR', 'Agra', 'JIMMYFRANCOIS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('323774827423', 'ALEC', 'DA', 'FREEMAN', '2011-5-5', 'Male', '624', 'FR', 'Agra', 'ALECDFREEMAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('308219994833', 'GEORGE', 'AA', 'FREEMAN', '1989-1-4', 'Male', '725', 'FR', 'Mumbai', 'GEORGEAFREEMAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('400025703459', 'MARISSA', 'A', 'FREYRE', '1981-9-12', 'Female', '702', 'FR', 'Agra', 'MARISSAFREYRE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('440001131615', 'LUKASZ', 'A', 'FRONCKIEL', '1959-12-16', 'Female', '80', 'FR', 'Glasgow', 'LUKASZFRONCKIEL@gmail.com', '1', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('878136462680', 'PATRICK', 'A', 'GAJEWNIAK', '1961-2-4', 'Female', '830', 'GA', 'Los Angeles', 'PATRICKGAJEWNIAK@gmail.com', '0', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('113077153487', 'YING', 'A', 'GAO', '1973-11-16', 'Male', '62', 'GA', 'Delhi', 'YINGGAO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('202021790034', 'ROBERTO', 'A', 'GARCIA', '2013-6-10', 'Male', '28', 'GA', 'Bengaluru', 'ROBERTOGARCIA@hotmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('808212101025', 'STEPHANIE', 'NA', 'GARRIGA', '1991-2-7', 'Male', '700', 'GA', 'Mumbai', 'STEPHANIENGARRIGA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('928945511419', 'NICHOLAS', 'SA', 'GERENA', '1982-9-22', 'Male', '25', 'GE', 'Vancouver', 'NICHOLASSGERENA@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('206884774803', 'ALEXANDRA', 'EA', 'GIAMPAPA', '2001-4-24', 'Female', '268', 'GI', 'Bengaluru', 'ALEXANDRAEGIAMPAPA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('372329060520', 'HOONG', 'TA', 'GIANG', '1953-8-14', 'Female', '859', 'GI', 'Hyderabad', 'HOONGTGIANG@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('804586711131', 'BENEDIKT', 'A', 'GIRARDI', '1979-8-3', 'Female', '354', 'GI', 'Bengaluru', 'BENEDIKTGIRARDI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('428998919149', 'JOEFEL', 'LA', 'GO', '1981-7-13', 'Male', '103', 'GO', 'Bengaluru', 'JOEFELLGO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('188505450326', 'HANNAH', 'RA', 'GOLDSTEIN', '1978-2-14', 'Male', '411', 'GO', 'Mumbai', 'HANNAHRGOLDSTEIN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('389735373652', 'JESSE', 'EA', 'GOMEZ', '1966-5-15', 'Male', '795', 'GO', 'Bengaluru', 'JESSEEGOMEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('848585699781', 'MARCOS', 'A', 'GOMEZ', '2007-6-5', 'Male', '966', 'GO', 'Bengaluru', 'MARCOSGOMEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('216659908856', 'GISELA', 'A', 'GONZALEZ', '1964-5-20', 'Female', '718', 'GO', 'Delhi', 'GISELAGONZALEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('936639373849', 'YOUNESS', 'A', 'GOUMRHAR', '2012-3-1', 'Female', '444', 'GO', 'Bengaluru', 'YOUNESSGOUMRHAR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('304408994409', 'EDWIN', 'JA', 'GRAMAJO', '1958-2-2', 'Female', '67', 'GR', 'Bengaluru', 'EDWINJGRAMAJO@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('553800691470', 'ROBERT', 'CA', 'GRANT', '2012-5-5', 'Male', '765', 'GR', 'Delhi', 'ROBERTCGRANT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('134221603957', 'BRYANT', 'A', 'GREGORY', '1953-9-6', 'Male', '662', 'GR', 'Mumbai', 'BRYANTGREGORY@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('911666046868', 'JUSTIN', 'KA', 'GRISSETT', '2014-5-13', 'Male', '2', 'GR', 'Bengaluru', 'JUSTINKGRISSETT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('919795966723', 'CRYSTAL', 'A', 'GUERRERO', '1993-1-26', 'Male', '25', 'GU', 'Bengaluru', 'CRYSTALGUERRERO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('935657050194', 'ROSALINDA', 'A', 'GUILLEN', '1962-6-12', 'Female', '502', 'GU', 'Bengaluru', 'ROSALINDAGUILLEN@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('428360413153', 'JUAN', 'CA', 'HARO', '1968-12-20', 'Female', '146', 'HA', 'Hyderabad', 'JUANCHARO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('871680105097', 'KEVIN', 'DA', 'HARTWIG', '2013-9-11', 'Female', '983', 'HA', 'Mumbai', 'KEVINDHARTWIG@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('418995690390', 'HASSAN', 'SA', 'HASAN', '1957-9-16', 'Male', '925', 'HA', 'Bengaluru', 'HASSANSHASAN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('914425773016', 'DANIELLE', 'MA', 'HERBERG', '1995-2-10', 'Male', '381', 'HE', 'Bengaluru', 'DANIELLEMHERBERG@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('350978962723', 'BERNARDO', 'DA', 'HERNANDEZ', '2010-2-7', 'Male', '571', 'HE', 'Delhi', 'BERNARDODHERNANDEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('312987312327', 'PARIS', 'LA', 'HILLIARD', '1964-4-22', 'Male', '563', 'HI', 'Bengaluru', 'PARISLHILLIARD@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('210559956668', 'DENNIS', 'CA', 'HINTON II', '1968-8-23', 'Female', '44', 'HI', 'Mumbai', 'DENNISCHINTON II@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('310347651765', 'THOMAS', 'EA', 'HOFFMAN III', '2019-10-24', 'Female', '162', 'HO', 'Bengaluru', 'THOMASEHOFFMAN III@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('554474406890', 'ABEL', 'A', 'HUERTA JR', '1988-2-11', 'Female', '696', 'HU', 'Bengaluru', 'ABELHUERTA JR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('533854538464', 'RICARDO', 'DA', 'HUERTA', '1984-5-26', 'Male', '902', 'HU', 'Mumbai', 'RICARDODHUERTA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('259618039621', 'MAYKIAE', 'KA', 'INGRAM', '1962-10-28', 'Male', '334', 'IN', 'Delhi', 'MAYKIAEKINGRAM@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('670326241101', 'HUNTER', 'AA', 'INVIE', '2001-1-24', 'Male', '86', 'IN', 'Bengaluru', 'HUNTERAINVIE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('913958800262', 'CIPRIAN', 'MA', 'IUGA', '1963-12-16', 'Male', '336', 'IU', 'Glasgow', 'CIPRIANMIUGA@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('669269175847', 'JOE', 'EA', 'JACKSON', '1969-6-4', 'Female', '872', 'JA', 'Hyderabad', 'JOEEJACKSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('926733050246', 'JUAN', 'A', 'JACKSON', '1953-9-23', 'Female', '804', 'JA', 'Delhi', 'JUANJACKSON@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('339845622042', 'KAMERON', 'RA', 'JACKSON', '1975-8-1', 'Female', '609', 'JA', 'Bengaluru', 'KAMERONRJACKSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('110389763033', 'MARIO', 'LA', 'JACKSON', '2014-6-10', 'Male', '434', 'JA', 'Mumbai', 'MARIOLJACKSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('950192347902', 'ANGELA', 'RA', 'JACOBS', '1970-8-6', 'Male', '461', 'JA', 'Delhi', 'ANGELARJACOBS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('241118400901', 'MICHAEL', 'PA', 'JELESNIANSKI', '1974-6-18', 'Male', '297', 'JE', 'Bengaluru', 'MICHAELPJELESNIANSKI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('729993127502', 'ANDREW', 'AA', 'JENSIK', '1959-4-12', 'Male', '8', 'JE', 'Agra', 'ANDREWAJENSIK@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('258481924250', 'JOSEMARIA', 'A', 'JIMENEZ', '1973-3-16', 'Female', '783', 'JI', 'Mumbai', 'JOSEMARIAJIMENEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('136634002984', 'STEVEN', 'RA', 'JOHNSON', '1954-3-11', 'Female', '423', 'JO', 'Agra', 'STEVENRJOHNSON@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('516136490559', 'ISSA', 'DA', 'JONES', '1992-12-7', 'Female', '212', 'JO', 'Agra', 'ISSADJONES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('205236975261', 'TIASHAVON', 'CA', 'JONES', '1965-9-17', 'Male', '273', 'JO', 'Delhi', 'TIASHAVONCJONES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('298499645654', 'GUMERSINDO', 'AA', 'JUAREZ', '1968-3-18', 'Male', '31', 'JU', 'Agra', 'GUMERSINDOAJUAREZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('710855939430', 'KRISTEN', 'JA', 'KENDALL', '1989-5-3', 'Male', '654', 'KE', 'Hyderabad', 'KRISTENJKENDALL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('136081975666', 'TIFFANY', 'CA', 'KENNEDY-HUNTER', '1965-6-24', 'Male', '947', 'KE', 'Delhi', 'TIFFANYCKENNEDY-HUNTER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('752379148933', 'SAMANTHA', 'AA', 'KHALIFEH', '1963-2-6', 'Female', '814', 'KH', 'Montreal', 'SAMANTHAAKHALIFEH@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('680210835403', 'ABDUL', 'SA', 'KHAN', '2011-6-4', 'Female', '295', 'KH', 'Mumbai', 'ABDULSKHAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('101298531821', 'MOHAMMED', 'SA', 'KHAN', '2005-1-13', 'Female', '243', 'KH', 'Agra', 'MOHAMMEDSKHAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('222120666506', 'LAWRENCE', 'CA', 'KILGORE-WOODEN', '1980-10-16', 'Male', '810', 'KI', 'Chennai', 'LAWRENCECKILGORE-WOODEN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('403303397556', 'NICHOLAS', 'SA', 'KILLHAM', '2011-3-4', 'Male', '569', 'KI', 'Chennai', 'NICHOLASSKILLHAM@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('519349054401', 'KATHARINE', 'LA', 'KIRCHNER', '2003-2-22', 'Male', '983', 'KI', 'Mumbai', 'KATHARINELKIRCHNER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('545261384649', 'JACOB', 'DA', 'KOEHRING', '2018-8-22', 'Male', '990', 'KO', 'Kolkata', 'JACOBDKOEHRING@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('713046704489', 'ANDREW', 'AA', 'KRAMER', '1988-4-14', 'Female', '51', 'KR', 'Hyderabad', 'ANDREWAKRAMER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('566450318372', 'ANGIE', 'A', 'LANDA', '1988-6-11', 'Female', '120', 'LA', 'Kolkata', 'ANGIELANDA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('712683921112', 'ASHLEY', 'MA', 'LEPKOWSKI', '2007-5-19', 'Female', '705', 'LE', 'Mumbai', 'ASHLEYMLEPKOWSKI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('613052191058', 'JESSICA', 'MA', 'LEWANDOWSKI', '1974-2-27', 'Male', '109', 'LE', 'Delhi', 'JESSICAMLEWANDOWSKI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('717253160263', 'ERIC', 'A', 'LIANG', '2017-9-24', 'Male', '341', 'LI', 'Kolkata', 'ERICLIANG@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('365542532592', 'MICHAEL', 'AA', 'LICHAY', '2012-1-23', 'Male', '78', 'LI', 'Kolkata', 'MICHAELALICHAY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('839412129071', 'COLLEEN', 'AA', 'LINDGREN', '2015-11-16', 'Male', '827', 'LI', 'Kolkata', 'COLLEENALINDGREN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('412438280015', 'ISAAC', 'JA', 'LOPEZ', '1989-6-17', 'Female', '418', 'LO', 'Mumbai', 'ISAACJLOPEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('767866964951', 'ITZEL', 'SA', 'LOPEZ', '1954-11-13', 'Female', '983', 'LO', 'Hyderabad', 'ITZELSLOPEZ@hotmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('575600102152', 'JOSHUA', 'RA', 'LOPEZ', '1997-10-22', 'Female', '480', 'LO', 'Kolkata', 'JOSHUARLOPEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('849457978278', 'MARINO', 'OA', 'LOPEZ', '2020-7-7', 'Male', '536', 'LO', 'Pune', 'MARINOOLOPEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('339556067418', 'VINCENT', 'LA', 'LUJANO', '2005-8-1', 'Male', '383', 'LU', 'Mumbai', 'VINCENTLLUJANO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('576742045215', 'JOSHUA', 'RA', 'MAAS', '1981-11-14', 'Male', '833', 'MA', 'San Francisco', 'JOSHUARMAAS@gmail.com', '0', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('947204999528', 'JORGE', 'AA', 'MAGANA', '2019-7-3', 'Male', '585', 'MA', 'Pune', 'JORGEAMAGANA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('867174718737', 'JUSTIN', 'CA', 'MAGNAN', '1999-3-25', 'Female', '323', 'MA', 'Pune', 'JUSTINCMAGNAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('453716766261', 'ABDULFATTAH', 'SA', 'MAHDI', '1985-7-18', 'Female', '493', 'MA', 'Mumbai', 'ABDULFATTAHSMAHDI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('645143135546', 'ANDREW', 'A', 'MAI', '1984-10-16', 'Female', '621', 'MA', 'Glasgow', 'ANDREWMAI@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('828590806190', 'BRIAN', 'A', 'MAI', '1964-2-22', 'Male', '327', 'MA', 'Delhi', 'BRIANMAI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('337352454362', 'CLAIRE', 'KA', 'MANLEY', '1961-2-4', 'Male', '370', 'MA', 'Bengaluru', 'CLAIREKMANLEY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('551296431931', 'IARAHIM', 'A', 'MANSOUR', '1964-9-8', 'Male', '537', 'MA', 'Bengaluru', 'IARAHIMMANSOUR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('148132962680', 'MITCHELL', 'JA', 'MAROZAS', '2009-12-3', 'Male', '833', 'MA', 'Bengaluru', 'MITCHELLJMAROZAS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('176738206383', 'AMAURI', 'A', 'MARTINEZ', '2016-1-26', 'Female', '710', 'MA', 'Bengaluru', 'AMAURIMARTINEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('931145853882', 'CARLOS', 'MA', 'MARTINEZ', '1965-10-14', 'Female', '881', 'MA', 'Hyderabad', 'CARLOSMMARTINEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('641153913197', 'DAVID', 'NA', 'MARTINEZ', '2006-5-28', 'Female', '102', 'MA', 'Mumbai', 'DAVIDNMARTINEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('950457091189', 'DELILAH', 'AA', 'MARTINEZ', '1984-3-13', 'Male', '758', 'MA', 'Bengaluru', 'DELILAHAMARTINEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('439772832509', 'JOSHUA', 'RA', 'MARTIN', '1976-7-10', 'Male', '956', 'MA', 'Bengaluru', 'JOSHUARMARTIN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('678651389258', 'TYWON', 'JA', 'MCCALL', '1977-12-21', 'Male', '623', 'MC', 'Bengaluru', 'TYWONJMCCALL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('726663590730', 'JAMARY', 'DA', 'MCKINNEY', '1994-6-14', 'Male', '259', 'MC', 'Mumbai', 'JAMARYDMCKINNEY@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('791914692790', 'KYLEE', 'AA', 'MCMAHON', '1984-8-19', 'Female', '403', 'MC', 'Bengaluru', 'KYLEEAMCMAHON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('692894146746', 'MALACHI', 'XA', 'MCNUTT', '1964-5-12', 'Female', '823', 'MC', 'Bengaluru', 'MALACHIXMCNUTT@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('869752894518', 'SEBASTIAN', 'A', 'MEDALA', '1980-10-5', 'Female', '178', 'ME', 'Delhi', 'SEBASTIANMEDALA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('648978121666', 'XAVIER', 'AA', 'MENDIA', '2003-8-8', 'Male', '575', 'ME', 'Bengaluru', 'XAVIERAMENDIA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('714617728875', 'FRANCISCO', 'JA', 'MERAZ', '1979-11-18', 'Male', '356', 'ME', 'Montreal', 'FRANCISCOJMERAZ@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('121047216054', 'MICHAEL', 'DA', 'MILBURN JR', '1975-1-22', 'Male', '135', 'MI', 'Mumbai', 'MICHAELDMILBURN JR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('690739132776', 'FOREST', 'DA', 'MINX', '2000-11-6', 'Male', '841', 'MI', 'Bengaluru', 'FORESTDMINX@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('589370563933', 'ERIC', 'A', 'MIRANDA', '1964-12-10', 'Female', '940', 'MI', 'Delhi', 'ERICMIRANDA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('909580032561', 'KAIBER', 'AA', 'MONARREZ', '1959-11-12', 'Female', '19', 'MO', 'Bengaluru', 'KAIBERAMONARREZ@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('713195939696', 'CAMERON', 'DA', 'MOORE', '1978-5-14', 'Female', '497', 'MO', 'Bengaluru', 'CAMERONDMOORE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('464936417796', 'DAVID', 'RA', 'MORALES', '2017-10-12', 'Male', '952', 'MO', 'Mumbai', 'DAVIDRMORALES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('386511685329', 'NATHAN', 'LA', 'MORA', '1966-2-20', 'Male', '482', 'MO', 'Bengaluru', 'NATHANLMORA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('601398044491', 'CRYSTAL', 'A', 'MORENO', '2015-3-2', 'Male', '360', 'MO', 'Hyderabad', 'CRYSTALMORENO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('642907618650', 'FABIAN', 'GA', 'MORENO', '2020-10-26', 'Male', '355', 'MO', 'Bengaluru', 'FABIANGMORENO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('321512669223', 'JEMELL', 'TA', 'MORGAN', '1955-11-8', 'Female', '425', 'MO', 'Bengaluru', 'JEMELLTMORGAN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('136819979587', 'MONER', 'WA', 'MOUSA', '1983-1-15', 'Female', '518', 'MO', 'Delhi', 'MONERWMOUSA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('716114867039', 'ALEXIA', 'NA', 'MUELLER', '1966-12-21', 'Female', '747', 'MU', 'Mumbai', 'ALEXIANMUELLER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('913606150491', 'MAEVE', 'AA', 'MULLAN', '1995-3-22', 'Male', '677', 'MU', 'Bengaluru', 'MAEVEAMULLAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('294130071845', 'TONY', 'A', 'MUNOZ JR', '2011-2-16', 'Male', '397', 'MU', 'Bengaluru', 'TONYMUNOZ JR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('509778440794', 'NATHANIEL', 'RA', 'MUNOZ', '2001-9-25', 'Male', '810', 'MU', 'Bengaluru', 'NATHANIELRMUNOZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('786959024473', 'JASON', 'RA', 'MURRY', '1985-5-24', 'Male', '93', 'MU', 'Bengaluru', 'JASONRMURRY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('645699716206', 'ANDRES', 'A', 'NARANJO', '1987-12-1', 'Female', '996', 'NA', 'Mumbai', 'ANDRESNARANJO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('175210402456', 'JOSE', 'AA', 'NAVARRETE', '1961-8-7', 'Female', '898', 'NA', 'Delhi', 'JOSEANAVARRETE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('257902008401', 'CRISTIAN', 'JA', 'NAVARRO', '1957-2-16', 'Female', '515', 'NA', 'Pune', 'CRISTIANJNAVARRO@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('875183697044', 'MARIO', 'A', 'NAVARRO', '1994-8-26', 'Male', '276', 'NA', 'Pune', 'MARIONAVARRO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('561772551695', 'VICTOR', 'A', 'NEGRON', '1964-11-25', 'Male', '489', 'NE', 'Glasgow', 'VICTORNEGRON@yahoo.co.in', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('741468313641', 'ANTONIO', 'JA', 'NELSON', '1971-12-26', 'Male', '350', 'NE', 'Pune', 'ANTONIOJNELSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('107019611963', 'IOAN', 'FA', 'NEMES', '1989-9-9', 'Male', '572', 'NE', 'Mumbai', 'IOANFNEMES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('860551775276', 'CHRISTIAN', 'DA', 'NUNEZ', '1977-7-4', 'Female', '590', 'NU', 'Hyderabad', 'CHRISTIANDNUNEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('428291995556', 'JAMES', 'MA', 'ODONNELL', '1959-11-28', 'Female', '3', 'OL', 'Pune', 'JAMESMODONNELL@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('862889811144', 'ALEJANDRO', 'A', 'OLAGUEZ', '2003-12-22', 'Female', '927', 'OL', 'Pune', 'ALEJANDROOLAGUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('715693795643', 'GRACE', 'CA', 'OMACHI', '1974-3-7', 'Male', '589', 'OM', 'Pune', 'GRACECOMACHI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('783003418664', 'NICHOLAS', 'AA', 'OOMENS', '1966-5-14', 'Male', '626', 'OO', 'Mumbai', 'NICHOLASAOOMENS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('558409114630', 'JUAN', 'MA', 'ORTIZ JR', '1974-3-6', 'Male', '214', 'OR', 'Delhi', 'JUANMORTIZ JR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('242699143557', 'DJ', 'GA', 'PACHECO', '1982-12-3', 'Male', '687', 'PA', 'Pune', 'DJGPACHECO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('111960475707', 'VANESSA', 'A', 'PALMA', '1995-9-21', 'Female', '303', 'PA', 'Pune', 'VANESSAPALMA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('495135970134', 'RYAN', 'WA', 'PARRISH', '2004-12-2', 'Female', '337', 'PA', 'Toronto', 'RYANWPARRISH@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('860176084127', 'AKIB', 'IA', 'PATEL', '1977-7-8', 'Female', '29', 'PA', 'Pune', 'AKIBIPATEL@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('601482339783', 'ANALYSE', 'A', 'PEREZ', '2020-9-19', 'Male', '870', 'PE', 'Mumbai', 'ANALYSEPEREZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('491287140247', 'FRANCISCO', 'A', 'PEREZ II', '1952-11-2', 'Male', '404', 'PE', 'Pune', 'FRANCISCOPEREZ II@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('341812099313', 'OSWALDO', 'A', 'PEREZ', '1952-9-6', 'Male', '164', 'PE', 'Pune', 'OSWALDOPEREZ@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('521365848376', 'RAFAEL', 'A', 'PEREZ', '1981-11-6', 'Male', '860', 'PE', 'Bengaluru', 'RAFAELPEREZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('699886327005', 'REBECCA', 'RA', 'PEREZ', '1958-3-16', 'Female', '149', 'PE', 'Mumbai', 'REBECCARPEREZ@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('934989295164', 'MAE', 'FA', 'PFLAUMER', '2000-5-2', 'Female', '722', 'PF', 'Bengaluru', 'MAEFPFLAUMER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('893747144553', 'SEAN', 'MA', 'PHELAN', '1962-10-17', 'Female', '680', 'PH', 'Delhi', 'SEANMPHELAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('690215592887', 'ANAMARIA', 'AA', 'PIRNUTA', '2003-9-3', 'Male', '662', 'PI', 'Bengaluru', 'ANAMARIAAPIRNUTA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('971283201003', 'FRANCESCO', 'A', 'POMPEO', '2006-5-22', 'Male', '97', 'PO', 'Los Angeles', 'FRANCESCOPOMPEO@gmail.com', '0', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('657867899457', 'CHRISTIAN', 'JA', 'PONCE', '1992-11-26', 'Male', '347', 'PO', 'Hyderabad', 'CHRISTIANJPONCE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('418379241731', 'TOMASZ', 'ZA', 'POTRAWSKI', '1999-9-6', 'Male', '813', 'PO', 'Mumbai', 'TOMASZZPOTRAWSKI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('800836524731', 'THOMAS', 'RA', 'POTTER', '1964-12-23', 'Female', '254', 'PO', 'Bengaluru', 'THOMASRPOTTER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('207140910637', 'HENRY', 'A', 'PRADO', '1969-1-26', 'Female', '758', 'PR', 'Bengaluru', 'HENRYPRADO@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('523664328625', 'PATRYK', 'TA', 'PRASAK', '2020-12-27', 'Female', '116', 'PR', 'Bengaluru', 'PATRYKTPRASAK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('245517595231', 'MILTON', 'A', 'QUITO', '1967-3-8', 'Male', '403', 'QU', 'Mumbai', 'MILTONQUITO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('662959198584', 'HUMBERTO', 'CA', 'RABADAN', '1954-4-26', 'Male', '239', 'RA', 'Bengaluru', 'HUMBERTOCRABADAN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('879927312101', 'JUANA', 'A', 'RAMIREZ', '1989-4-4', 'Male', '181', 'RA', 'Bengaluru', 'JUANARAMIREZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('796689682487', 'JOSEPH', 'JA', 'RAMONES', '1967-7-6', 'Male', '744', 'RA', 'Bengaluru', 'JOSEPHJRAMONES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('607356468995', 'BRANDON', 'SA', 'RANDHAWA', '1963-4-7', 'Female', '19', 'RA', 'Bengaluru', 'BRANDONSRANDHAWA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('350440359135', 'JAMES', 'A', 'RAPACZ', '1960-3-25', 'Female', '182', 'RA', 'Delhi', 'JAMESRAPACZ@hotmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('179284754966', 'TOMASZ', 'A', 'RATAJCZYK', '2004-1-12', 'Female', '216', 'RA', 'Hyderabad', 'TOMASZRATAJCZYK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('931023970585', 'CHRISTIAN', 'JA', 'REYES', '1967-1-28', 'Male', '384', 'RE', 'Delhi', 'CHRISTIANJREYES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('442564806084', 'DANIEL', 'A', 'RICO', '1966-3-1', 'Male', '287', 'RI', 'Mumbai', 'DANIELRICO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('268718594885', 'MARCUS', 'IA', 'RIVERA', '1965-11-20', 'Male', '222', 'RI', 'Delhi', 'MARCUSIRIVERA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('945413813294', 'YASMIN', 'A', 'RIVERA', '2013-12-9', 'Male', '29', 'RI', 'Bengaluru', 'YASMINRIVERA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('816019368462', 'DANIEL', 'RA', 'ROCHA', '1997-1-26', 'Female', '160', 'RO', 'Bengaluru', 'DANIELRROCHA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('518803742083', 'ALYSSA', 'AA', 'RODRIGUEZ', '1991-2-27', 'Female', '174', 'RO', 'Bengaluru', 'ALYSSAARODRIGUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('744666140937', 'ARTHUR', 'AA', 'RODRIGUEZ', '1954-1-20', 'Female', '460', 'RO', 'Edinburgh', 'ARTHURARODRIGUEZ@gmail.com', '1', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('191765361721', 'JASON', 'AA', 'RODRIGUEZ', '2008-4-17', 'Male', '12', 'RO', 'Mumbai', 'JASONARODRIGUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('130495950159', 'JOVANNI', 'MA', 'RODRIGUEZ', '1958-7-20', 'Male', '313', 'RO', 'Bengaluru', 'JOVANNIMRODRIGUEZ@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('282986902686', 'KEVIN', 'A', 'RODRIGUEZ', '2010-3-11', 'Male', '635', 'RO', 'Vancouver', 'KEVINRODRIGUEZ@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('135243236106', 'MICHAEL', 'LA', 'RODRIGUEZ', '2016-2-6', 'Female', '81', 'RO', 'Bengaluru', 'MICHAELLRODRIGUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('686492787709', 'RODOLFO', 'EA', 'ROLDAN', '2016-5-10', 'Male', '704', 'RO', 'Bengaluru', 'RODOLFOEROLDAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('785119924429', 'BRANDON', 'JA', 'ROSALES', '1998-8-9', 'Male', '638', 'RO', 'Delhi', 'BRANDONJROSALES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('189695170901', 'MAURICIO', 'A', 'ROSALES JR', '2020-1-14', 'Male', '762', 'RO', 'Mumbai', 'MAURICIOROSALES JR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('437236982365', 'JOSE', 'A', 'SALDANA', '1970-9-2', 'Male', '527', 'SA', 'Hyderabad', 'JOSESALDANA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('128997587812', 'ABDULLAH', 'HA', 'SALEH', '1994-12-10', 'Female', '353', 'SA', 'Pune', 'ABDULLAHHSALEH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('935876364181', 'IRVING', 'A', 'SANCHEZ', '2005-12-1', 'Female', '119', 'SA', 'Pune', 'IRVINGSANCHEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('893084786475', 'NICHOLAS', 'AA', 'SANCHEZ', '1981-4-20', 'Female', '627', 'SA', 'Mumbai', 'NICHOLASASANCHEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('381906094020', 'NOEL', 'A', 'SANTIAGO', '2005-12-25', 'Male', '493', 'SA', 'Delhi', 'NOELSANTIAGO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('470638228259', 'OLIVIA', 'AA', 'SARDELLA', '1959-10-5', 'Male', '377', 'SA', 'Kolkata', 'OLIVIAASARDELLA@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('517637145305', 'TOMASZ', 'A', 'SAS', '2014-4-25', 'Male', '910', 'SA', 'Kolkata', 'TOMASZSAS@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('123921371493', 'LAVELLE', 'MA', 'SCHAFFER', '1970-12-1', 'Male', '526', 'SC', 'Kolkata', 'LAVELLEMSCHAFFER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('167653050874', 'JAKE', 'A', 'SCHMEISSER', '1994-2-7', 'Female', '253', 'SC', 'Kolkata', 'JAKESCHMEISSER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('703174042938', 'LAUREN', 'AA', 'SCHNOTALA', '2008-5-21', 'Female', '606', 'SC', 'Mumbai', 'LAURENASCHNOTALA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('636096799226', 'DANIEL', 'AA', 'SCHWARTZ', '1962-8-14', 'Female', '633', 'SC', 'Hyderabad', 'DANIELASCHWARTZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('303479606899', 'GUSTAVO', 'A', 'SEGURA', '2012-11-14', 'Male', '851', 'SE', 'Kolkata', 'GUSTAVOSEGURA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('734022970910', 'DANIEL', 'MA', 'SELKE', '2004-12-27', 'Male', '366', 'SE', 'Kolkata', 'DANIELMSELKE@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('241040032437', 'TOYA', 'VA', 'SEVIER JR', '2006-7-23', 'Male', '562', 'SE', 'Kolkata', 'TOYAVSEVIER JR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('559801413072', 'CLAIRE', 'MA', 'SHEAHAN', '2006-10-26', 'Male', '285', 'SH', 'Bengaluru', 'CLAIREMSHEAHAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('836961527765', 'LUKE', 'DA', 'SHEAHAN', '2008-8-1', 'Female', '109', 'SH', 'Mumbai', 'LUKEDSHEAHAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('265977119189', 'PIOTR', 'PA', 'SIATKA', '1953-7-22', 'Female', '224', 'SI', 'Bengaluru', 'PIOTRPSIATKA@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('541388326361', 'CARL', 'JA', 'SMITH', '1995-2-3', 'Female', '663', 'SM', 'Delhi', 'CARLJSMITH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('663553437995', 'COURTNEY', 'A', 'SMITH', '1977-3-17', 'Male', '544', 'SM', 'Bengaluru', 'COURTNEYSMITH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('919579941038', 'GRACE', 'EA', 'SMITH', '1992-1-8', 'Male', '209', 'SM', 'Bengaluru', 'GRACEESMITH@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('686500867005', 'JAWUAN', 'OA', 'SMITH', '1954-11-13', 'Male', '883', 'SM', 'Mumbai', 'JAWUANOSMITH@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('986711043099', 'MICHAEL', 'JA', 'SPILOTRO III', '2018-3-21', 'Male', '898', 'SP', 'Bengaluru', 'MICHAELJSPILOTRO III@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('673370860273', 'MOLLY', 'MA', 'SPRAY', '1973-3-8', 'Female', '855', 'SP', 'Bengaluru', 'MOLLYMSPRAY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('209485922351', 'MICHAEL', 'JA', 'STACK JR', '2008-7-16', 'Female', '239', 'ST', 'Bengaluru', 'MICHAELJSTACK JR@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('404181987661', 'WAYNE', 'AA', 'STEVENSON', '2008-10-18', 'Female', '129', 'ST', 'Bengaluru', 'WAYNEASTEVENSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('736452185434', 'JAKE', 'WA', 'STORCK', '1978-11-6', 'Male', '273', 'ST', 'Mumbai', 'JAKEWSTORCK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('763762432467', 'ALEXANDER', 'LA', 'STROCKIS', '2009-3-22', 'Male', '839', 'ST', 'Hyderabad', 'ALEXANDERLSTROCKIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('316282413427', 'TAMICO', 'A', 'STRONG', '1992-12-9', 'Male', '516', 'ST', 'Edinburgh', 'TAMICOSTRONG@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('812429922123', 'HRISTOS', 'HA', 'TIROVOLAS', '1980-7-26', 'Male', '723', 'TI', 'Delhi', 'HRISTOSHTIROVOLAS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('572635773372', 'JUAN', 'A', 'TOLEDO', '1983-9-16', 'Female', '62', 'TO', 'Bengaluru', 'JUANTOLEDO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('985436151357', 'MAXWELL', 'AA', 'TORRES', '2017-8-22', 'Female', '767', 'TO', 'Bengaluru', 'MAXWELLATORRES@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('317861556165', 'MEGAN', 'MA', 'TOTOSZ', '1994-11-11', 'Female', '755', 'TO', 'Bengaluru', 'MEGANMTOTOSZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('886328868653', 'CAMILLEA', 'GA', 'TOWNS', '2013-4-9', 'Male', '948', 'TO', 'Mumbai', 'CAMILLEAGTOWNS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('545633838020', 'JERMAINE', 'AA', 'TOWNSEND', '1953-7-14', 'Male', '967', 'TO', 'Bengaluru', 'JERMAINEATOWNSEND@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('638100866396', 'KRYSTAL', 'RA', 'TROTTER', '1966-6-10', 'Male', '91', 'TR', 'Bengaluru', 'KRYSTALRTROTTER@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('464552628800', 'AURORA', 'FA', 'TSAI', '1958-2-25', 'Male', '779', 'TS', 'Montreal', 'AURORAFTSAI@gmail.com', '1', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('439283971237', 'BRANDON', 'CA', 'TWYMAN', '1951-3-3', 'Female', '264', 'TW', 'Bengaluru', 'BRANDONCTWYMAN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('150252408178', 'KESHARA', 'DA', 'TYSON', '1985-2-23', 'Female', '894', 'TY', 'Delhi', 'KESHARADTYSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('324909478494', 'ANTONIO', 'A', 'VACA', '1968-3-19', 'Female', '707', 'VA', 'Mumbai', 'ANTONIOVACA@hotmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('118189229995', 'JASMINE', 'NA', 'VALENTIN', '1959-5-6', 'Male', '214', 'VA', 'Bengaluru', 'JASMINENVALENTIN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('940777191539', 'ELIZABETH', 'MA', 'VARGAS', '1959-3-15', 'Male', '183', 'VA', 'Bengaluru', 'ELIZABETHMVARGAS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('732365268990', 'MIGUEL', 'AA', 'VASQUEZ', '1987-12-5', 'Male', '28', 'VA', 'Bengaluru', 'MIGUELAVASQUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('212455102579', 'DAVID', 'A', 'VAZQUEZ', '1975-11-9', 'Male', '504', 'VA', 'Hyderabad', 'DAVIDVAZQUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('787278267783', 'DEYVY', 'A', 'VAZQUEZ', '2004-3-10', 'Female', '937', 'VA', 'Mumbai', 'DEYVYVAZQUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('769769667221', 'JESSE', 'A', 'VAZQUEZ', '2016-8-13', 'Female', '738', 'VA', 'Bengaluru', 'JESSEVAZQUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('744894538417', 'JOSEPH', 'DA', 'VECCHIO', '1966-3-7', 'Female', '614', 'VE', 'Kolkata', 'JOSEPHDVECCHIO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('184821429551', 'ALEXANDER', 'JA', 'VERTA', '1991-6-15', 'Male', '236', 'VE', 'Pune', 'ALEXANDERJVERTA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('635240527933', 'TYLER', 'JA', 'VIDEKA', '1993-4-15', 'Male', '404', 'VI', 'Delhi', 'TYLERJVIDEKA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('673136379400', 'CODY', 'JA', 'VILLASENOR', '1987-2-25', 'Male', '224', 'VI', 'Edinburgh', 'CODYJVILLASENOR@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('763588488778', 'LEE', 'YA', 'WALBY', '1999-11-17', 'Male', '348', 'WA', 'Mumbai', 'LEEYWALBY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('899260739031', 'SHALEAH', 'JA', 'WALTON', '2007-1-7', 'Female', '543', 'WA', 'San Francisco', 'SHALEAHJWALTON@gmail.com', '0', 'USA');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('791740392205', 'WILLIAM', 'MA', 'WASHINGTON JR', '1959-3-8', 'Female', '622', 'WA', 'Pune', 'WILLIAMMWASHINGTON JR@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('327199667689', 'AUSTIN', 'DA', 'WATTS', '1962-11-7', 'Female', '58', 'WA', 'Pune', 'AUSTINDWATTS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('874830705219', 'ANTONIO', 'TA', 'WHITFIELD', '2006-2-15', 'Male', '131', 'WH', 'Pune', 'ANTONIOTWHITFIELD@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('903736875313', 'AARON', 'DA', 'WILLIAMS', '2002-2-4', 'Male', '28', 'WI', 'Delhi', 'AARONDWILLIAMS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('652246103390', 'AERIAL', 'CA', 'WILLIAMS', '1951-4-17', 'Male', '610', 'WI', 'Mumbai', 'AERIALCWILLIAMS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('908697942407', 'BRANDON', 'A', 'WILLIAMS', '1957-4-20', 'Male', '801', 'WI', 'Pune', 'BRANDONWILLIAMS@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('874087351711', 'CORA', 'AA', 'WILLIAMS', '2010-7-16', 'Female', '934', 'WI', 'Hyderabad', 'CORAAWILLIAMS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('956719693153', 'DOUGLAS', 'AA', 'WILLIAMS', '1961-1-7', 'Female', '521', 'WI', 'Pune', 'DOUGLASAWILLIAMS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('136629210536', 'DARELL', 'LA', 'WILLIS', '1995-10-8', 'Female', '652', 'WI', 'Pune', 'DARELLLWILLIS@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('234986661373', 'RACHEL', 'DA', 'WILLIS', '1975-7-5', 'Male', '896', 'WI', 'Mumbai', 'RACHELDWILLIS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('834570806842', 'BRANDON', 'MA', 'WILSON', '1989-12-5', 'Male', '919', 'WI', 'Delhi', 'BRANDONMWILSON@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('181851193133', 'NICOLE', 'KA', 'WITCZAK', '1998-3-9', 'Male', '942', 'WI', 'Pune', 'NICOLEKWITCZAK@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('293108456055', 'SAM', 'A', 'WU', '1995-5-5', 'Male', '744', 'WU', 'Pune', 'SAMWU@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('858608715880', 'JIGEN', 'A', 'YAN', '1954-3-4', 'Female', '787', 'YA', 'Mumbai', 'JIGENYAN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('588800101787', 'LUCIANO', 'GA', 'YI', '2002-12-16', 'Female', '65', 'YI', 'Bengaluru', 'LUCIANOGYI@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('132713121669', 'EUGENE', 'A', 'YOUNG', '1984-11-1', 'Female', '91', 'YO', 'Bengaluru', 'EUGENEYOUNG@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('835782902679', 'SERGIO', 'A', 'ZAGALA', '2013-9-4', 'Male', '728', 'ZA', 'Toronto', 'SERGIOZAGALA@gmail.com', '0', 'Canada');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('375664043754', 'MOHAMMAD', 'HA', 'ZAHRAN', '1973-5-19', 'Male', '442', 'ZA', 'Bengaluru', 'MOHAMMADHZAHRAN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('916051207970', 'CHRISTYANA', 'RA', 'ZAPATA', '1999-6-9', 'Male', '136', 'ZA', 'Mumbai', 'CHRISTYANARZAPATA@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('575911254920', 'EDGAR', 'A', 'ZARAGOZA-RODRIGUEZ', '1970-11-22', 'Male', '107', 'ZA', 'Hyderabad', 'EDGARZARAGOZA-RODRIGUEZ@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('660432735173', 'WENHUI', 'A', 'ZHAO', '1962-2-15', 'Female', '992', 'ZH', 'Delhi', 'WENHUIZHAO@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('694638083777', 'SIMON', 'A', 'ZHONG', '1982-12-6', 'Female', '542', 'ZH', 'Bengaluru', 'SIMONZHONG@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('592974853834', 'ERICA', 'LA', 'ALLEN', '1954-2-19', 'Female', '200', 'AL', 'Bengaluru', 'ERICALALLEN@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('606578752964', 'ACHEN', 'JA', 'ALLEN MORENO', '1967-8-15', 'Male', '473', 'AL', 'Bengaluru', 'ACHENJALLEN MORENO@yahoo.co.in', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('668219397711', 'CHERYL', 'MA', 'ANTHONY', '1974-9-15', 'Male', '179', 'AN', 'Mumbai', 'CHERYLMANTHONY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('989226156177', 'LIWANIKA', 'A', 'BANKS', '2006-10-25', 'Male', '61', 'BA', 'Bengaluru', 'LIWANIKABANKS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('773384598584', 'KENDEL', 'LA', 'BARRY', '2009-2-21', 'Male', '317', 'BA', 'Bengaluru', 'KENDELLBARRY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('824034095625', 'CHARLES', 'A', 'BROWNLEE', '1953-4-23', 'Female', '371', 'BR', 'Bengaluru', 'CHARLESBROWNLEE@gmail.com', '1', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('155193386904', 'SONJA', 'LA', 'BROWN', '1983-3-14', 'Female', '778', 'BR', 'Mumbai', 'SONJALBROWN@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('196667604075', 'ANTOINE', 'A', 'BUSCH', '1981-7-19', 'Female', '334', 'BU', 'Edinburgh', 'ANTOINEBUSCH@gmail.com', '0', 'UK');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('595481438888', 'LISA', 'GA', 'CLARK-MCKAY', '1984-8-3', 'Male', '206', 'CL', 'Bengaluru', 'LISAGCLARK-MCKAY@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('217822079332', 'RENEE', 'MA', 'COBBS', '2009-3-22', 'Male', '973', 'CO', 'Delhi', 'RENEEMCOBBS@gmail.com', '0', 'Indian');
INSERT INTO `Airport_Database`.`Passenger` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `DOB`, `Gender`, `House_Number`, `Building`, `City`, `Email-ID`, `Senior_Citizen`, `Nationality`) VALUES ('933509521853', 'TENNELL', 'RA', 'COLEMAN', '1970-9-14', 'Male', '554', 'CO', 'Hyderabad', 'TENNELLRCOLEMAN@hotmail.com', '0', 'Indian');


INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('STEFANIE', '9958347441', '207090631573');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('EFRAIN', '7225214588', '150667941422');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHERRON', '3906534338', '311872947944');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRANDON', '7181853025', '906673823836');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SYRIA', '7103945226', '195743834667');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANGEL', '7613908651', '302739141189');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('AIMIE', '6410025165', '152246692823');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('HECTOR', '5002508468', '449200994374');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TRINH', '4514463017', '598578863608');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CARLA', '9574228973', '112222795509');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANDRZEI', '6637826115', '607932019779');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LATOYA', '9320543444', '191968477066');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMES', '3686682057', '588499828637');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CRISTY', '6992587480', '878788802330');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JENEICE', '8267441192', '660672253823');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BARBARA', '6068141656', '962798560240');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TIMOTHY', '9267553957', '902907191536');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GEANNA', '9165837100', '545295423127');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('IVRA', '9660238919', '379405065549');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('REGINA', '8689224163', '668127242353');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KIMBERLY', '9768622675', '936808290378');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BEN', '9246675233', '991718823545');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SUSAN', '7642313136', '440611948707');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VALERIE', '3513935151', '289020936379');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOCELYN', '7247303630', '487744883827');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIA', '2154780888', '129418607536');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CARL', '3688413544', '394856058451');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GEORGE', '2146891284', '653475904431');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHANEL', '3560355729', '729778449116');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RODNEY', '9112956828', '479755336220');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LIANG', '2331337936', '215945706305');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALEJANDRO', '6541645889', '434806690436');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICIA', '4946364897', '998859180013');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANTOINETTE', '3024862060', '516327813872');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('THEODORE', '9398740010', '162620865752');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('M', '5960756362', '980396674004');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('OMAR', '5880442871', '530337723408');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRUCE', '9131709124', '810365104449');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DE', '3169811006', '408924071666');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICIA', '7498957839', '777509633526');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JEREMIAH', '7206655213', '382938575139');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANDREW', '8829250100', '888243500387');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CANDACE', '5559938771', '562160131218');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LENORE', '2607790098', '808155753159');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JULIO', '9062079592', '319875724256');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANTHONY', '6850648549', '888111164019');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANGELA', '9431250848', '902484285179');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RACHEL', '9221326490', '674120066554');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LORIELLE', '3163482096', '206394752118');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NELSON', '4201242414', '520697910564');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VICENTE', '8416090750', '587464229547');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERIC', '4739573811', '468577721871');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SONIA', '9914467627', '746089352731');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMES', '4345338168', '769223717930');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TAMEKA', '3772012350', '318832402857');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRANDY', '9824218004', '203484369343');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALYSSA', '2702250274', '220189353923');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('STATIA', '6773435321', '430661164482');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ATHANASIA', '5474666791', '260665573547');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('FERNANDO', '9531397730', '757815584875');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DENISE', '2143203001', '284332550815');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GAYATRI', '6886670513', '125748434671');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SANDRA', '4017791277', '843955864404');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TIJA', '6350024622', '844100237778');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RYAN', '4252612524', '957032439716');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VIDAL', '6246188605', '162419083545');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KASANDRA', '7194078369', '741430151992');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DIANE', '4740200345', '227540062206');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ISAAC', '8383209133', '907985826328');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('QUINCY', '9325700074', '979333366244');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('WILLIE', '2945110527', '445003929423');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICE', '4558075113', '301322176115');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SUSAN', '9318367168', '259920896017');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHERYL', '6629062521', '295134364736');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '7872616902', '154217461963');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAVIER', '7531614284', '203561139409');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LINH', '8477716678', '185985522397');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('OLGA', '8594609614', '926549471832');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHANNON', '4335155901', '971332165381');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHANNA', '7960338078', '601857496728');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIA', '8501055297', '841682687454');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RAMONA', '5121376627', '392015460330');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIBEL', '5681881578', '878294842928');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TYRA', '7848940461', '827667444188');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JACKIE', '8767482913', '150509228378');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LATONYA', '9958603840', '172374668645');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('REDONIA', '8060899695', '933234057203');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KAREN', '5570115677', '966621709488');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICIA', '3818774396', '371260491044');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '7771871848', '973408873868');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHOLA', '8248413125', '750432555990');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTINE', '4777453621', '147000504847');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAL', '4803666811', '261084200588');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LILIANA', '6943385897', '806130121923');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSHUA', '4391820985', '907801232948');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JENNIFER', '4844147170', '679162257152');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JENNA', '5401018067', '328262674792');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SARAH', '3027890121', '998569191127');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRIAN', '5339457034', '107641374236');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ORONDA', '4784187955', '774989630671');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SAMANTHA', '8654790655', '504451253936');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ADRIAN', '2660327507', '648534138100');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIUSZ', '3317513487', '879334963851');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DIANE', '4600093588', '772536939567');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRITTANY', '9234093501', '256760162370');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JEANNE', '6008146952', '317669172527');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAHKEEM', '2365534368', '789535029093');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RACHEL', '3642751234', '664317092189');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DAISY', '9528839036', '693897522681');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHARMAINE', '7911869743', '632454512607');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTOPHER', '6258523597', '199653002424');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LATESHA', '4330823971', '437785294956');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LINDA', '2659188173', '354061382498');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LILIA', '5470876714', '302202827631');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('WILLIAM', '9359526153', '805768715675');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TONYA', '7068013161', '984773638854');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIO', '4613067725', '283846350978');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TORRENCE', '8646278429', '457213117949');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TIFFANY', '7531548410', '298272432716');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ADAM', '5788151672', '684229221952');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CYNTHIA', '3278711611', '701960570247');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DEBRA', '6077265642', '544819430528');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DIANA', '8893426215', '642795041087');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('EDGARD', '2267839591', '965446139948');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHIQUITA', '9690703327', '207577322706');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHOAIB', '3462680074', '132625673917');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CRYSTAL', '5690481872', '305031346364');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JEANNETTE', '9627757287', '107060275569');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('WHITNEY', '8668152369', '384537713635');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DELL', '3573653371', '260533660905');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LATASHA', '8655717417', '128556721392');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RAE', '5239876318', '733654590871');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHARDAE', '9271906775', '945874925582');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTOPHER', '7309274435', '460081588423');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KEIANA', '4565310507', '726117916587');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KAREN', '8581337426', '714997361643');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GINA', '6445431590', '333932767424');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LASHONDA', '5739008143', '645125928635');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VAN', '5376048212', '785342807166');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DOLORES', '3179244977', '326310748226');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MAGDALENA', '4646298209', '612086734183');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DAVID', '4711465060', '276511446130');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANGELA', '8221275152', '942727915435');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ARTURO', '5127085770', '390021761050');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JEANEEN', '8659246913', '370962119472');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KYISHIA', '9212860226', '933688831340');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHELITHIA', '2767923798', '142814815975');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TAMIKA', '2234893967', '185092629829');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ASHLEY', '6970806118', '799245744506');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LATOSHA', '5794031960', '473407148189');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('AMBER', '2460032248', '263911246445');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIANA', '2776838170', '430177754974');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANDREW', '5799901907', '829850237368');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('WILLIAM', '3303800620', '743475476997');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KENNETH', '9276948481', '581559418034');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LAUREN', '8877515989', '231986540258');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('FEDERICA', '5662294927', '869751629757');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTINE', '4938722674', '228374455783');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JANICE', '7205689670', '483752157384');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARY', '6610368021', '903075418867');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHAWN', '8023584997', '312614875041');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RANDY', '3763799068', '671463840096');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KRISTIE', '8035779776', '389930829279');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANASTASIA', '5119665912', '770829328166');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOEL', '2027667393', '816265849917');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KAULA', '9694754472', '676258172551');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('AL', '5681907209', '570770391644');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANGELA', '6628960116', '499033473365');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BEATRIZ', '9041560069', '217994403774');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MILOS', '8847912468', '437026515078');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JESSE', '8087947556', '704452391342');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICK', '2157516642', '159502015807');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JUANITA', '5893312079', '939132184139');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANTOINETTE', '9101312347', '355306902007');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JESSICA', '6914127071', '244307140758');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JENNIFER', '7865407464', '922124073348');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NIHAL', '4175556495', '555131547468');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LAQUICE', '5691959802', '199433440561');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TYISHA', '7685184123', '522919517233');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GRICELDA', '2844292980', '850131811619');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '8212721531', '664942158462');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARCUS', '3876136878', '230134262748');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TAMEKA', '2338086915', '352438233911');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ELVIRA', '2894978561', '935776398461');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DEVONNA', '5306449555', '799014571773');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIO', '2211818219', '190606839341');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PARIS', '7625241412', '799369811759');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('HELEN', '3724199329', '276657105161');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NATALIA', '4239409761', '700378128427');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAKUB', '8131286987', '764692793635');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARGARET', '3121170127', '265125061865');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PEDRO', '9567783733', '304231210018');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RAISA', '4529260125', '325439086346');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RAYNARD', '4125145589', '479596918134');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANGEL', '5474472204', '899017946187');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KIARA', '4785406199', '206458280011');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TALIA', '4775155650', '420840242945');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KAREN', '9353872128', '683186566699');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NIKOL', '7848367336', '209740220526');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('EILEEN', '3213470807', '683907499097');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTOPHER', '5555559831', '379410362813');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ARELINA', '7993588072', '516025128396');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TIFFINIE', '9235462208', '572227204768');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('EVAN', '5610408284', '522729864898');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ARIANNA', '4291314425', '512730411673');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LAURA', '6008523542', '581478947596');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ROLANDO', '6980512022', '149843027110');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHANETTA', '2537392789', '184608958723');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RICHARD', '8419627245', '349699324970');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERIC', '8627759379', '508444378955');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KATHRYN', '2513049423', '705833330229');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KELSEY', '8627635886', '985069232535');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VICTORIA', '4309801532', '476592469291');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VALERYE', '8316517038', '403069128350');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('EVELINA', '4866816190', '276334408607');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KATHERINE', '4227152704', '173088700264');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANDREA', '6471995189', '418967534050');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NATHANIEL', '5781309088', '360754673882');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JESSICA', '5651699214', '592232310023');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALEXIS', '4303997085', '539944676870');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KELLYE', '8640153564', '257477530607');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALYNE', '7519751784', '999096482163');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('APRIL', '2950966918', '426004588315');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('FELICIA', '7266458677', '801100703126');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KIMBERLY', '9620844733', '254526260713');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALENKA', '9894434039', '685306158418');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSE', '9499118517', '328987277297');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JULIA', '5988659230', '102756400581');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KAYE', '2902330156', '375183930342');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSE', '4902743388', '635610926316');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JILL', '4054883708', '923700012332');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DOMINIQUE', '3007514822', '275544326703');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '8922023954', '516386055911');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KRISTIN', '9166211657', '280279660706');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MEGAN', '9136031813', '523450623482');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERIN', '5338676536', '821336829357');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('AIDA', '7921980884', '274026111101');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('YANJUN', '7511723122', '405482480278');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NATHAN', '2894652728', '643441678252');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LAZERRICK', '8504347210', '849930510072');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSE', '6100130728', '465849559932');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('HOPE', '3084408475', '374047037851');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('QIWEN', '4837715825', '325689985568');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MAURA', '8698403836', '514602378618');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JUSTIN', '2054516973', '887127804408');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RAFAEL', '7607484109', '910932834215');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALLISON', '9134038245', '765672822342');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KEVIN', '2771631766', '207939001028');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DEAN', '4127338793', '488077310542');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTIAN', '5019015578', '129012135594');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JENNIFER', '5980178517', '266506253523');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERIKA', '3508695559', '577016411776');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALLYSON', '3016746049', '923142389193');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KATRIN', '9011002312', '254174657664');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANDREA', '4891457034', '269853191621');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRUCE', '5154886901', '402451294104');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BERNARD', '3381013447', '594976747942');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHLOE', '3978649676', '716866658134');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MATTHEW', '4482796790', '103705643890');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALONSO', '2726298134', '130320057105');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHUN', '3313487113', '136024895785');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RHONDA', '4864131007', '451446195146');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TIFFANY', '2284822772', '425053423515');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KIMBERLY', '3231701752', '493259767701');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('YISRAEL', '6452153870', '675338023609');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NELSON', '3301960756', '133125586336');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MORGAN', '2172149414', '212249754488');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '9891771446', '916031128846');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHARON', '4874981859', '923192631750');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JEFFREY', '9642439726', '663476556400');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NOEL', '4060895609', '645099769325');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RAFAEL', '5420654679', '406931771979');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JADON', '6575931000', '135611548844');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOVANY', '2726673280', '505291410580');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANDREW', '3639388917', '957792348576');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIA', '5479985664', '599196148588');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KASSOUM', '8192232882', '982706930849');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SANDRA', '8580081652', '718034221496');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHARLOTTE', '3389523861', '191379608154');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TABITHA', '4596242773', '279067350735');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TONEY', '2163377882', '486334593278');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JANIE', '5352273046', '699342170370');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ARTURO', '9508062601', '336423921567');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VERONICA', '2505108242', '799509921430');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('IVON', '6629445917', '395618766916');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMILLE', '4938214733', '495699468168');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('QUANITA', '7917682461', '418129643827');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MATTHEW', '2298340786', '355061452380');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SANTOS', '7797816700', '243401059014');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GIANFRANCO', '4310162934', '299024915943');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('YVETTE', '4624295215', '393303541607');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANA', '5326749558', '733063971604');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERICKA', '5078141348', '754909536596');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JUANITA', '7481656854', '361383046390');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TYRESHEA', '3833816721', '813024926888');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KARYN', '6746465636', '723269172686');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('WILLIAM', '7244317813', '401843241657');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHELLE', '9461710821', '391826987704');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTINE', '3196964096', '409565375077');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIELLE', '2560546705', '833286637007');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSEPH', '7393752761', '371258961953');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LORANE', '7973627962', '963976634374');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TERRANCE', '8442719647', '162599582043');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSE', '7672631302', '939988876625');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERIK', '5404934826', '190249883035');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHEKELIA', '2085147732', '146027300121');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SYED', '6356930505', '314274436742');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NANIDA', '8508583803', '875699933257');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LAUREN', '5180068597', '474264207408');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BYRON', '2189605448', '322045746657');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANTHONY', '5123463298', '524072474465');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DIARA', '8023511211', '805899460746');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LAURA', '2369748481', '691591994642');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ROSA', '8446083131', '443779954453');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CATHY', '9253295168', '751529501416');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DESTINY', '2597146010', '452784325925');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GERALD', '9600501385', '641027662554');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JEONEVA', '4185714310', '340420114634');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ELIZABETH', '6305199168', '246466735580');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DORIAN', '6375952858', '421086145338');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VELIA', '8554988013', '881346406347');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIA', '3259024251', '744986677244');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARICELA', '8469376887', '324730020111');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICK', '2033187279', '880083693169');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RICHARD', '8953432638', '811729698168');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANDREA', '8067900745', '783990215496');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANIL', '6223954593', '130015502919');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALONZO', '4988601075', '983836236902');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SABBIR', '4923701604', '501580228641');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JASON', '6569433124', '959133141129');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TARA', '7083415405', '846633651714');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MIGUEL', '7451955270', '875843798258');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICK', '9107368265', '977635795160');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NICOLE', '6777713670', '764939034016');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('WILLIAM', '4363762579', '529863560635');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KEVIN', '5256925573', '589385828532');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSEPH', '3961290488', '605073995473');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DARIUSZ', '4098084708', '485435021847');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAKE', '4396997241', '565159997963');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTOPHER', '3045867352', '599953047020');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PAUL', '6392184070', '131888913314');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRUCE', '4555087840', '450862785239');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JUSTIN', '4947526321', '714047739324');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMES', '6478574440', '216417595823');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALEXANDER', '3522999723', '854567648069');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SCOTT', '8888665911', '990601574360');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('OMAR', '8503526903', '222550017428');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SEAN', '7746537098', '798872691742');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RYAN', '9987905681', '464619640140');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GEORGE', '6630273140', '863491540958');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSEPH', '2201905220', '985916710256');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSHUA', '5207224474', '532645477174');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RANDALL', '3715590200', '764374600564');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MATTHEW', '7789644854', '676592595463');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TIFFANY', '5318131151', '228719603161');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JENNA', '3177631357', '589422183921');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '7000396400', '886560121125');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NICHOLAS', '5040507113', '704061898917');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('HARRY', '4635467948', '104179493962');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LUKE', '8532635942', '170862696244');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JEFFREY', '2206086640', '189987710798');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSEPH', '7456023318', '261605960961');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '8781480310', '441172874397');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '3532798986', '423602507442');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DECLAN', '3436590485', '170450296187');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SAVOY', '3977384530', '793636550631');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TONIKA', '8733032486', '914066692974');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '4833684799', '979450501005');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DAMEIN', '7413665708', '167299490125');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DAVID', '6381715089', '707796540702');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SYLVESTER', '8641956725', '482262964829');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('EARL', '5608779925', '958159755571');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MAGDALENA', '3684866660', '541641624287');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICK', '3715184675', '243168117955');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KANTON', '2708944731', '149106824972');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '6315414945', '403463020682');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RYAN', '7033660022', '177651855359');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRIAN', '5177626939', '290091299917');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '5880946160', '186698056563');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '7246286797', '436326180534');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DONNELL', '3859074976', '752940292349');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIELLE', '6979604339', '367589096955');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '9064791122', '323774827423');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRIAN', '5420021034', '308219994833');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSEPH', '8371155198', '400025703459');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GEOVANNI', '5522979377', '440001131615');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RYAN', '3639477809', '878136462680');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '3555181697', '113077153487');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SAUL', '4906393581', '202021790034');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CONOR', '2882613922', '808212101025');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JESUS', '3055921397', '928945511419');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('HOLLY', '9833071631', '206884774803');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JONATHAN', '8957531656', '372329060520');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('STEPHEN', '9423480517', '804586711131');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '5118192932', '428998919149');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DAVID', '7993889035', '188505450326');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RYAN', '4195494201', '389735373652');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ADALBERTO', '4200189768', '848585699781');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARK', '8834431453', '216659908856');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRIAN', '8752527780', '936639373849');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PETER', '2357288437', '304408994409');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JASON', '8379918409', '553800691470');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PAUL', '4220539752', '134221603957');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SEAN', '6269485415', '911666046868');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAVIER', '6862617720', '919795966723');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '6728262878', '935657050194');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PETER', '6912396027', '428360413153');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRADLEY', '8756098939', '871680105097');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JORGE', '7999083912', '418995690390');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '8220693282', '914425773016');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LOGAN', '7325571432', '350978962723');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSEPH', '8481840068', '312987312327');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MANUEL', '3623362501', '210559956668');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALEXANDER', '2594897850', '310347651765');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ROGER', '7296094922', '554474406890');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('AGNIESZKA', '4196752466', '533854538464');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHAWN', '9594401173', '259618039621');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GERALD', '5960318723', '670326241101');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JASON', '9404608599', '913958800262');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JUAN', '6510214695', '669269175847');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '6991746113', '926733050246');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TIMOTHY', '7034949062', '339845622042');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '8652826056', '110389763033');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JORDAN', '7204118318', '950192347902');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RAMON', '9487438436', '241118400901');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DEVONTE', '3868428812', '729993127502');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('IBRAHIM', '9324723909', '258481924250');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRITTANY', '9057212667', '136634002984');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '2728199260', '516136490559');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CONNOR', '9146419569', '205236975261');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DAKOTA', '6276155387', '298499645654');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JONATHAN', '9260772673', '710855939430');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('FERNANDO', '9355243701', '136081975666');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('WILLIAM', '8092757816', '752379148933');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTINA', '3258080203', '680210835403');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('STEPHON', '3657468352', '101298531821');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('HUBERT', '9901762644', '222120666506');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ZACHARY', '2024593270', '403303397556');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TRAVIS', '4446157989', '519349054401');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANDREA', '4493668755', '545261384649');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMES', '8135447964', '713046704489');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TERRENCE', '8059482217', '566450318372');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('OSCAR', '7663538319', '712683921112');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANDRZEJ', '5007078110', '613052191058');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KYLE', '2253883861', '717253160263');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('OMOTAYO', '7880314140', '365542532592');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHARLZ', '9001580460', '839412129071');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '4648290465', '412438280015');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JEREMY', '9323952111', '767866964951');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RYAN', '9952110177', '575600102152');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRIAN', '4996297366', '849457978278');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('HANLE', '8205504019', '339556067418');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SEAN', '4452664054', '576742045215');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NIKOLA', '3397776490', '947204999528');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JACOB', '6933669358', '867174718737');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRIAN', '3084321954', '453716766261');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('STEFAN', '3707714201', '645143135546');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '9286767221', '828590806190');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '3095333951', '337352454362');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '4201005685', '551296431931');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RYAN', '7364255274', '148132962680');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANGEL', '3000058382', '176738206383');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PAIGE', '6371432898', '931145853882');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALVARO', '7059649365', '641153913197');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VICTOR', '9707960565', '950457091189');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JACK', '6496234146', '439772832509');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NICHOLAS', '2301396991', '678651389258');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMES', '6109410867', '726663590730');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JENNIFER', '9869281257', '791914692790');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ADAN', '3499061623', '692894146746');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSE', '3461628135', '869752894518');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('OMAR', '3833641852', '648978121666');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SAMANTHA', '4410808190', '714617728875');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JEREMY', '4812292278', '121047216054');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JENNIFER', '8016578488', '690739132776');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '6568292700', '589370563933');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ROSE', '3310554036', '909580032561');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KYLE', '4761625418', '713195939696');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KYLE', '9002440248', '464936417796');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('GARRETT', '7012466789', '386511685329');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '4650133791', '601398044491');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '4016738496', '642907618650');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JESUS', '6773464078', '321512669223');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERWIN', '7739474129', '136819979587');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTINA', '6992164568', '716114867039');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JONATHAN', '7215917538', '913606150491');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RAYMOND', '5481422119', '294130071845');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NOEL', '4771564520', '509778440794');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LEONEL', '6422066027', '786959024473');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JASON', '7895557645', '645699716206');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JERMAINE', '3655399747', '175210402456');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JUAN', '3079265209', '257902008401');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KEVIN', '5081499153', '875183697044');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RYAN', '7369942617', '561772551695');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHAWN', '5115257190', '741468313641');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ZACHARY', '5531375259', '107019611963');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ENRIQUE', '7966007511', '860551775276');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARY', '8079522747', '428291995556');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KAREN', '5253666282', '862889811144');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANNY', '3676755035', '715693795643');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTOPHER', '3284433524', '783003418664');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KEVIN', '3238387031', '558409114630');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RICARDO', '8092052294', '242699143557');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANNE', '2936886068', '111960475707');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '3497961289', '495135970134');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LUKE', '6430686772', '860176084127');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KALEY', '7450895443', '601482339783');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMES', '9319546405', '491287140247');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALEXANDER', '4378027702', '341812099313');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALBERTO', '2145155135', '521365848376');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '8805074779', '699886327005');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('COLIN', '7971947216', '934989295164');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '3049707004', '893747144553');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANTHONY', '4483751393', '690215592887');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHRISTIAN', '7405909254', '971283201003');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DREW', '2627897796', '657867899457');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MATTHEW', '6587820445', '418379241731');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICK', '3622187151', '800836524731');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LAQUINN', '4019899237', '207140910637');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('STEVEN', '5659926881', '523664328625');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSHUA', '6067897673', '245517595231');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CARLOS', '6051548063', '662959198584');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LARRY', '2749944304', '879927312101');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TRAVIS', '8013512518', '796689682487');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KEVIN', '2944185868', '607356468995');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JUAN', '6623673954', '350440359135');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '2279392134', '179284754966');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('AL', '8372177850', '931023970585');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '7837056743', '442564806084');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRIAN', '4877291215', '268718594885');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('WILLIAM', '9529520044', '945413813294');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KATIE', '4485784959', '816019368462');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ARTHUR', '8937654568', '518803742083');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '8739868006', '744666140937');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TERRENCE', '4660145943', '191765361721');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '2359329086', '130495950159');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ADAM', '2086100800', '282986902686');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RUDY', '3702080550', '135243236106');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('EDGAR', '6625195131', '686492787709');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ROBERT', '6275844338', '785119924429');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JULIAN', '7058387229', '189695170901');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICK', '8203217538', '437236982365');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('TIMOTHY', '8693413170', '128997587812');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('EMILY', '6231356051', '935876364181');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PAUL', '9185362391', '893084786475');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MITCHELL', '5422333880', '381906094020');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('REBECCA', '7280514401', '470638228259');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOSE', '4690374633', '517637145305');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANSHAWN', '7819552264', '123921371493');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DANIEL', '8398571621', '167653050874');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('CHIKITA', '4652969403', '703174042938');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERIK', '2774759526', '636096799226');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ORLANDO', '9213761491', '303479606899');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARTIN', '4003203956', '734022970910');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('OSCAR', '4028245720', '241040032437');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MEGAN', '4860176790', '559801413072');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '9582976226', '836961527765');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMES', '5377417369', '265977119189');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('WALTER', '2892875665', '541388326361');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MATTHEW', '5766676882', '663553437995');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANTHONY', '5938878757', '919579941038');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SAMUEL', '6832836460', '686500867005');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERIC', '6959913291', '986711043099');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHANE', '8625988535', '673370860273');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MATTHEW', '8784980772', '209485922351');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARK', '5234653494', '404181987661');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHN', '8030440130', '736452185434');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RYAN', '4997911917', '763762432467');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SEAN', '3555483196', '316282413427');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '5914827648', '812429922123');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MANUEL', '8141850331', '572635773372');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('IVAN', '6321995762', '985436151357');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DAVID', '4550305065', '317861556165');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DIMITRIUS', '3243822373', '886328868653');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RICHARD', '8768340950', '545633838020');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BRADLEY', '6143351205', '638100866396');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('AMIELIO', '8379763534', '464552628800');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LAUREN', '7865627742', '439283971237');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KEVIN', '7851352737', '150252408178');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DONALD', '4270302234', '324909478494');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ROBERT', '9191728877', '118189229995');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERIK', '3494441280', '940777191539');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('VERONICA', '3021876864', '732365268990');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RAYMOND', '5637400740', '212455102579');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KACY', '7429944263', '787278267783');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NELIDA', '9169078359', '769769667221');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANNIE', '8571166734', '744894538417');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SANDRA', '3517809687', '184821429551');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('STACEY', '4760489874', '635240527933');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('AUDREY', '7168215808', '673136379400');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('IRMA', '3514787126', '763588488778');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KEITH', '4558768476', '899260739031');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('RITA', '9579298528', '791740392205');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DEBORAH', '4187423186', '327199667689');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIE', '6856174451', '874830705219');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LATASHA', '9362029982', '903736875313');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DEMETRIS', '9444700937', '652246103390');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('FREDERICK', '6840750702', '908697942407');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMES', '9450890787', '874087351711');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ALENE', '2763483377', '956719693153');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('SHERRON', '4319571194', '136629210536');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JAMIE', '4323743930', '234986661373');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DINAH', '5572910179', '834570806842');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BESSIE', '7099177078', '181851193133');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('EDIE', '9075482811', '293108456055');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LETICIA', '2690995326', '858608715880');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NANCY', '3944246810', '588800101787');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JOHANA', '5941718230', '132713121669');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('KATRIANA', '4435580771', '835782902679');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('YVETTE', '8848307384', '375664043754');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LINDA', '4020992189', '916051207970');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DAVITA', '7860266449', '575911254920');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('THELMA', '8672533964', '660432735173');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ANGELA', '3019831529', '694638083777');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MICHAEL', '8839062189', '592974853834');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('JACQUELINE', '8382112333', '606578752964');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ERIC', '9551726839', '668219397711');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('BARBARA', '2283008827', '989226156177');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('NATALIE', '9449716396', '773384598584');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('DELLA', '3176686883', '824034095625');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MAE', '3036092602', '155193386904');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('LAWANDA', '5534734238', '196667604075');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('ADRIAN', '2477580562', '595481438888');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('PATRICIA', '6191490946', '217822079332');
INSERT INTO `Airport_Database`.`Emergency_Contact` (`Name`, `Phone_No`, `Aadhar_card_number`) VALUES ('MARIA', '2293846827', '933509521853');


INSERT INTO `Airport_Database`.`Airline` (`IATA_Airline_Code`, `Company_Name`, `Number_of_aircrafts_owned`, `Active`, `Country_of_Ownership`, `Managing_Director`) VALUES ('6E', 'Indigo Airlines Limited', '9', '1', 'India', 'RAhul Bhatia');
INSERT INTO `Airport_Database`.`Airline` (`IATA_Airline_Code`, `Company_Name`, `Number_of_aircrafts_owned`, `Active`, `Country_of_Ownership`, `Managing_Director`) VALUES ('SG', 'Spicejet Limited', '4', '1', 'India', 'Ajay Singh');
INSERT INTO `Airport_Database`.`Airline` (`IATA_Airline_Code`, `Company_Name`, `Number_of_aircrafts_owned`, `Active`, `Country_of_Ownership`, `Managing_Director`) VALUES ('AI', 'Air India Limited', '7', '1', 'India', 'Campbell Wilson');
INSERT INTO `Airport_Database`.`Airline` (`IATA_Airline_Code`, `Company_Name`, `Number_of_aircrafts_owned`, `Active`, `Country_of_Ownership`, `Managing_Director`) VALUES ('UK', 'Air Vistara', '5', '1', 'India', 'Samriti Dalvi');
INSERT INTO `Airport_Database`.`Airline` (`IATA_Airline_Code`, `Company_Name`, `Number_of_aircrafts_owned`, `Active`, `Country_of_Ownership`, `Managing_Director`) VALUES ('G8', 'Go Airways', '2', '1', 'India', 'Jeh Wadia');


INSERT INTO `Airport_Database`.`Capacity_of_Aircraft` (`Manufacturer`, `Capacity`, `Plane_Model`) VALUES ('Boeing', '320', '747');
INSERT INTO `Airport_Database`.`Capacity_of_Aircraft` (`Manufacturer`, `Capacity`, `Plane_Model`) VALUES ('Boeing', '340', '737');
INSERT INTO `Airport_Database`.`Capacity_of_Aircraft` (`Manufacturer`, `Capacity`, `Plane_Model`) VALUES ('Airbus', '280', '320');
INSERT INTO `Airport_Database`.`Capacity_of_Aircraft` (`Manufacturer`, `Capacity`, `Plane_Model`) VALUES ('Airbus', '300', '330');
INSERT INTO `Airport_Database`.`Capacity_of_Aircraft` (`Manufacturer`, `Capacity`, `Plane_Model`) VALUES ('Airbus', '260', '340');
INSERT INTO `Airport_Database`.`Capacity_of_Aircraft` (`Manufacturer`, `Capacity`, `Plane_Model`) VALUES ('Boeing', '320', '777');


INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('212', 'Airbus', '320', '4576786', '10', '2020-09-28', '6E');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('234', 'Airbus', '320', '986655', '9', '2020-09-21', '6E');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('236', 'Airbus', '330', '4557678', '20', '2020-09-28', '6E');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('238', 'Airbus', '330', '7978445', '19', '2020-09-21', '6E');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('274', 'Airbus', '340', '32456', '26', '2020-09-21', '6E');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('546', 'Airbus', '320', '349876', '11', '2020-09-24', '6E');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('589', 'Airbus', '330', '5678', '25', '2020-09-28', '6E');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('878', 'Airbus', '320', '3468322', '12', '2020-09-21', '6E');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('893', 'Airbus', '320', '2199934', '8', '2020-09-24', '6E');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('242', 'Boeing', '747', '2325437', '4', '2020-09-28', 'AI');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('343', 'Airbus', '320', '76335', '13', '2020-09-21', 'AI');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('555', 'Airbus', '330', '65686', '23', '2020-09-28', 'AI');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('574', 'Airbus', '340', '3453', '24', '2020-09-21', 'AI');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('796', 'Boeing', '737', '34343434', '15', '2020-09-28', 'AI');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('974', 'Airbus', '330', '77777777', '18', '2020-09-28', 'AI');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('975', 'Boeing', '747', '234276', '5', '2020-09-24', 'AI');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('673', 'Boeing', '777', '345340', '27', '2020-09-29', 'G8');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('692', 'Boeing', '777', '857323', '28', '2020-09-29', 'G8');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('124', 'Boeing', '737', '5465879', '14', '2020-09-24', 'SG');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('345', 'Boeing', '747', '542321', '1', '2020-09-21', 'SG');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('435', 'Boeing', '747', '23421', '2', '2020-09-21', 'SG');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('645', 'Boeing', '747', '65767', '3', '2020-09-24', 'SG');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('232', 'Boeing', '747', '876453', '6', '2020-09-21', 'UK');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('235', 'Boeing', '777', '76876', '22', '2020-09-21', 'UK');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('642', 'Boeing', '747', '23878', '7', '2020-09-21', 'UK');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('734', 'Boeing', '737', '654332', '16', '2020-09-21', 'UK');
INSERT INTO `Airport_Database`.`Aircraft` (`Registration_No.`, `Manufacturer`, `Plane_Model`, `Distance_Travelled`, `Flight_ID`, `Last_Maintanence_Check_Date`, `Owners_IATA_Airline_Code`) VALUES ('875', 'Boeing', '777', '8888888', '21', '2020-09-21', 'UK');


INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('423842256711', 'JERNARD', 'SA', 'JOHNSON', '2022-04-15', '8367', 'Indian', '2010-4-17', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('487301900720', 'LEAH', 'MA', 'JOSLYN', '2022-04-15', '1976', 'Indian', '1975-3-8', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('839379776636', 'MICHELL', 'AA', 'KEMPER', '2022-04-15', '3702', 'Indian', '1961-9-11', 'Female', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('763239030001', 'KATHERINE', 'AA', 'KLEMCHUK', '2022-04-15', '7131', 'Indian', '1953-10-18', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('267270646226', 'LASHENA', 'EA', 'LAWTON', '2022-04-15', '7122', 'Indian', '1986-3-18', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('705118388146', 'ISAAC', 'IA', 'PALMA-RUWE', '2022-04-15', '7633', 'Indian', '1990-1-17', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('895445335106', 'BRIA', 'AA', 'PHILLIPS', '2022-04-19', '4150', 'Indian', '1957-8-2', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('573139661735', 'JUSTUS', 'CA', 'RICHARDSON', '2022-04-19', '5799', 'Indian', '1984-10-20', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('178901887912', 'NADIRI', 'SA', 'SAUNDERS', '2022-04-19', '2132', 'Indian', '2008-5-27', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('968293757996', 'CRISTINA', 'EA', 'ALEGRIA', '2022-04-19', '2032', 'Indian', '1950-1-3', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('987073359667', 'ANTHONY', 'AA', 'BATTLE', '2022-04-19', '4176', 'Indian', '2004-1-8', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('464486919784', 'RENA', 'CA', 'TURPIN', '2022-04-19', '1130', 'Indian', '1961-2-12', 'Female', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('272041370301', 'DIEGO', 'RA', 'MORALES', '2022-04-19', '9752', 'Indian', '1994-9-6', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('774444132904', 'LATASHA', 'MA', 'ADDISON', '2022-04-19', '4670', 'Indian', '1958-11-5', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('419649385822', 'RISHAUNDA', 'A', 'ANDREWS', '2022-04-19', '7795', 'Indian', '1973-5-10', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('952078195347', 'RONALD', 'A', 'BRANCH', '2022-05-23', '6864', 'Indian', '1961-7-19', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('365788043732', 'ANDREW', 'A', 'CHEBUHAR', '2022-05-23', '9512', 'Indian', '2009-10-12', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('523364866992', 'MICHELLE', 'MA', 'CIPRES', '2022-05-23', '5899', 'Indian', '1988-2-25', 'Female', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('682892019010', 'DENISE', 'A', 'DAVENPORT', '2022-05-23', '3545', 'Indian', '1984-1-16', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('436363863265', 'SARA', 'A', 'DOE', '2022-05-23', '5417', 'Indian', '2003-4-1', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('659471917725', 'ASHANTA', 'PA', 'HARRISON', '2022-05-23', '1687', 'Indian', '1971-2-6', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('773578728750', 'LIONEL', 'JA', 'HOLMES', '2022-05-23', '7581', 'Indian', '1988-1-22', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('788035500462', 'RENEE', 'A', 'JACKSON', '2022-05-23', '6232', 'Indian', '1950-9-22', 'Female', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('482861471480', 'SONYA', 'RA', 'JACKSON', '2020-06-14', '8021', 'Indian', '1958-12-14', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('887225220049', 'ALEX', 'A', 'KERNER', '2020-06-14', '3639', 'Indian', '2001-7-11', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('539894579755', 'XENA', 'A', 'LOPEZ', '2020-06-14', '8848', 'Indian', '1997-1-14', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('685850699467', 'GUILLERMO', 'A', 'LUGO', '2020-06-14', '6359', 'Indian', '2005-12-26', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('295985438642', 'ALVINA', 'A', 'LYNN', '2020-06-14', '7818', 'Indian', '2001-10-1', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('387424604116', 'REYMUNDO', 'SA', 'MARTINEZ', '2020-06-14', '5015', 'Indian', '2005-9-11', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('757544661652', 'ASHLEY', 'MA', 'MILLER', '2020-06-14', '5083', 'Indian', '2008-10-3', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('996366605513', 'MARGARET', 'AA', 'NORRIS', '2020-06-14', '9137', 'Indian', '1957-2-6', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('559764090284', 'JOHN', 'A', 'PACIRA', '2019-04-19', '5883', 'Indian', '2020-7-24', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('507987293417', 'DEONA', 'A', 'PHILLIPS', '2019-04-19', '6193', 'Indian', '1985-3-8', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('576538804352', 'MARIA', 'RA', 'POTTS', '2019-04-19', '4107', 'Indian', '1978-4-3', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('517628926875', 'ALLEN', 'LA', 'PULLIAM', '2019-04-19', '7584', 'Indian', '1971-6-19', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('373431374191', 'SANDRA', 'A', 'SEREDA', '2019-04-19', '1285', 'Indian', '1992-9-20', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('436899770238', 'TIFFANY', 'A', 'SHELL', '2019-04-19', '5742', 'Indian', '1960-12-4', 'Female', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('172124790919', 'SILVIO', 'KA', 'SMERIGLIO', '2019-04-19', '8767', 'Indian', '1962-11-4', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('311899954816', 'JEFFREY', 'DA', 'THIVEL', '2019-04-19', '3200', 'Indian', '1970-8-4', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('189012025021', 'CYNTHIA', 'A', 'THOMAS', '2020-01-30', '6367', 'Indian', '1986-8-21', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('593984902158', 'BRIANNA', 'VA', 'VANCANT', '2020-01-30', '6652', 'Indian', '1992-8-6', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('823455853160', 'ASHANTHI', 'AA', 'VAUGHN', '2020-01-30', '2982', 'Indian', '2013-2-28', 'Female', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('279413154352', 'TAMIKA', 'RA', 'WESTMORELAND', '2020-01-30', '7184', 'Indian', '2013-11-6', 'Female', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('113128320405', 'DOROTA', 'A', 'WILCZEWSKA', '2020-01-30', '6133', 'Indian', '1968-3-22', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('392948176090', 'GLORIA', 'VA', 'WILLIAMS', '2020-01-30', '8420', 'Indian', '1965-10-26', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('508612826180', 'GWENDOLYN', 'KA', 'WILLIAMS', '2020-01-30', '5170', 'Indian', '2020-11-1', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('233363221108', 'NATHAN', 'NA', 'GASS', '2020-01-30', '7230', 'Indian', '1982-11-23', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('749515388866', 'RAVEN', 'SA', 'JOHNSON', '2020-01-30', '8356', 'Indian', '1986-3-6', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('164713043824', 'EMANUEL', 'AA', 'MORENO', '2020-01-30', '6589', 'Indian', '1973-8-13', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('637470568896', 'ARMANDO', 'JA', 'VELAZQUEZ', '2010-10-10', '7711', 'Indian', '1957-5-15', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('874814427763', 'NICHOLAS', 'CA', 'CASPER', '2010-10-10', '3709', 'Indian', '2009-4-25', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('777211077788', 'MIA', 'A', 'WILLIAMS', '2010-10-10', '5733', 'Indian', '1991-5-2', 'Female', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('767644651742', 'VANESSA', 'A', 'ARANDA-ORTIZ', '2010-10-10', '5905', 'Indian', '2008-8-18', 'Female', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('120295354135', 'KYLIE', 'LA', 'RUSCHEINSKI', '2010-10-10', '9180', 'Indian', '2009-9-14', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('447585081788', 'JASMINE', 'MA', 'BAKER', '2010-10-10', '4196', 'Indian', '2013-7-6', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('309085507854', 'ALICIA', 'A', 'IVY', '2010-10-10', '4575', 'Indian', '1998-8-23', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('341648440548', 'NICOLLE', 'MA', 'BROWN', '2010-10-10', '3458', 'Indian', '1995-10-1', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('463262786649', 'LIONEL', 'LA', 'GARZA III', '2010-10-10', '4182', 'Indian', '1987-8-10', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('427691459617', 'DOLORES', 'A', 'GODINEZ', '2012-12-12', '3295', 'Indian', '1990-5-6', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('139446154652', 'PETER', 'AA', 'HAMILTON', '2012-12-12', '7545', 'Indian', '1987-7-13', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('816989698738', 'ROBERT', 'RA', 'KUSCHELL', '2012-12-12', '9719', 'Indian', '1988-8-25', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('492889047751', 'DARRIN', 'SA', 'PATTON', '2002-03-10', '9096', 'Indian', '1972-1-21', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('740585609636', 'MARIBEL', 'LA', 'SALDANA', '2002-03-10', '6329', 'Indian', '1983-8-11', 'Female', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('590695444281', 'FRANKIE', 'RA', 'CARODINE', '2002-03-10', '4032', 'Indian', '1958-10-22', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('998727690821', 'EDWARD', 'SA', 'DETRAYON', '2002-03-10', '6096', 'Indian', '1973-4-4', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('533489174577', 'TYANA', 'GA', 'PARKER', '2002-03-10', '1100', 'Indian', '1990-5-4', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('895942302481', 'NICOLE', 'A', 'ALSTON', '2002-03-10', '8372', 'Indian', '1990-9-26', 'Female', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('263894653433', 'ANDRE', 'A', 'ANDREWS JR', '2009-09-09', '8663', 'Indian', '1961-11-17', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('989795868900', 'GERALD', 'CA', 'BRITTS', '2009-09-09', '2370', 'Indian', '1968-8-15', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('929409113318', 'EMANUEL', 'AA', 'BUFORD', '2009-09-09', '4704', 'Indian', '1995-8-10', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('898590197215', 'COURTNEY', 'AA', 'CEASAR', '2009-09-09', '7328', 'Indian', '1990-9-25', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('885349935083', 'CHARLES', 'EA', 'COPELAND III', '2009-09-09', '2581', 'Indian', '1951-8-10', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('915403132186', 'JOCELYN', 'MA', 'HODGE', '2009-09-09', '6175', 'Indian', '1967-9-10', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('947056199545', 'LASHANDRIA', 'EA', 'JONES', '2009-09-09', '6849', 'Indian', '1988-4-4', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('882529509704', 'CARLISA', 'A', 'LEE', '2009-09-09', '7223', 'Indian', '1999-3-15', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('701316776234', 'ANGELIQUE', 'A', 'SCOTT', '2009-09-09', '5625', 'Indian', '1968-9-8', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('576404241274', 'DEON', 'SA', 'SUGGS', '2009-09-09', '6415', 'Indian', '1962-10-9', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('351662528098', 'BARRY', 'A', 'TIDWELL', '2004-04-03', '6371', 'Indian', '1990-12-28', 'Female', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('723531887630', 'DONNA', 'A', 'SHIELDS', '2004-04-03', '4984', 'Indian', '1997-1-16', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('271274517218', 'TIESHA', 'EA', 'THOMAS', '2004-04-03', '2959', 'Indian', '1956-4-23', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('293071995777', 'PATRICIA', 'CA', 'HICKS', '2004-04-03', '8246', 'Indian', '1993-5-21', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('960473363810', 'ANISSA', 'A', 'DELGADO', '2004-04-03', '1508', 'Indian', '1961-1-23', 'Female', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('186480088941', 'TEVIN', 'A', 'MORRIS', '2004-04-03', '4594', 'Indian', '2005-2-8', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('699936401511', 'BRITTANY', 'DA', 'PARNELL', '2004-04-03', '4971', 'Indian', '1981-6-13', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('229570111446', 'JASMIN', 'DA', 'PLASCENCIA', '2004-04-03', '6647', 'Indian', '1970-2-26', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('940190667854', 'FANNY', 'A', 'TERRY', '2005-12-12', '2229', 'Indian', '2014-9-22', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('994162770130', 'SELENA', 'EA', 'RODRIGUEZ', '2005-12-12', '4719', 'Indian', '2009-3-21', 'Female', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('562920204688', 'TAMARA', 'A', 'TARVER', '2005-12-12', '5706', 'Indian', '1969-3-14', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('357284469139', 'MALCOLM', 'A', 'HONORABLE', '2005-12-12', '5822', 'Indian', '1989-4-23', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('866295518182', 'CATHERINE', 'DA', 'HUTCHINS', '2005-12-12', '1374', 'Indian', '2009-7-2', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('728003163445', 'ANDREA', 'EA', 'JONES', '2011-11-09', '1394', 'Indian', '1952-3-28', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('743180682606', 'SHALETA', 'A', 'MURDOCK', '2011-11-09', '7951', 'Indian', '1969-8-24', 'Female', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('725253952481', 'CARLY', 'SA', 'PODBIELSKI', '2011-11-09', '8636', 'Indian', '1984-10-1', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('307444476492', 'MAYA', 'TA', 'HOOD', '2011-11-09', '1760', 'Indian', '1983-6-8', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('201895719396', 'EVANN', 'AA', 'JOHNSON', '2011-11-09', '2675', 'Indian', '1961-2-22', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('442222040823', 'LAI', 'KA', 'NG', '2011-11-09', '4868', 'Indian', '1974-9-15', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('350063861992', 'WILLIAM', 'PA', 'ZOPP', '2015-10-15', '6374', 'Indian', '1994-8-3', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('710069101922', 'LISA', 'NA', 'STIGLER', '2015-10-15', '2183', 'Indian', '1995-4-6', 'Female', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('801202304690', 'EDWARD', 'CA', 'THOMAS', '2015-10-15', '1105', 'Indian', '1958-6-22', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('910746441422', 'DEDRICK', 'LA', 'BANKS', '2015-10-15', '5065', 'Indian', '2000-7-21', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('727603019279', 'DAVID', 'NA', 'BROWN', '2004-03-13', '9945', 'Indian', '1961-2-18', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('984116856572', 'JOSE', 'LA', 'CORDOVA', '2006-05-15', '7497', 'Indian', '1975-7-24', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('852751115441', 'ANTOANETA', 'MA', 'IVANOVA', '2006-06-06', '2619', 'Indian', '1987-8-13', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('324523567094', 'ROLANDO', 'A', 'IVORY', '2018-09-18', '9847', 'Indian', '1977-2-3', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('331235638977', 'LORRAINE', 'FA', 'MINOR', '2002-02-20', '1997', 'Indian', '1984-1-16', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('901079987005', 'SHERECE', 'MA', 'YOUNG', '2011-11-20', '7884', 'Indian', '1975-4-11', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('859876076991', 'LATONYAA', 'MA', 'FEDRICK', '2012-12-15', '1624', 'Indian', '1985-6-24', 'Female', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('742345609823', 'MANUEL', 'RA', 'MONDRAGON', '2003-06-04', '20566', 'Indian', '1968-3-22', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('508807841865', 'GERALD', 'A', 'NAVARRO', '2011-08-09', '71457', 'Indian', '1965-10-26', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('743065235687', 'MICHELLE', 'VA', 'NIX', '2011-04-06', '33870', 'Indian', '1970-11-1', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('117708762407', 'RADE', 'KA', 'OBRENIC', '2011-06-07', '20566', 'Indian', '1982-11-23', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('844295166474', 'KAROL', 'NA', 'PADALA', '2004-04-04', '71457', 'Indian', '1986-3-6', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('659520341336', 'JAMES', 'SA', 'PAWLAK', '2019-09-09', '33870', 'Indian', '1973-8-13', 'Male', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('268709851713', 'MATTHEW', 'AA', 'PERNIC', '2022-03-12', '92327', 'Indian', '1957-5-15', 'Female', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('612272332784', 'CELINA', 'JA', 'QUINN', '2004-11-14', '18430', 'Indian', '1979-4-25', 'Male', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('382252530528', 'RICARDO', 'CA', 'RAMOS', '2010-02-10', '65174', 'Indian', '1991-5-2', 'Male', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('204847494048', 'CHRISTIANA', 'A', 'RENO', '1998-01-20', '93237', 'Indian', '1950-8-18', 'Male', 'UK');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('926393263101', 'DEVAN', 'A', 'RICHARDSON', '2003-06-14', '69207', 'Indian', '1990-9-14', 'Female', '6E');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('442125731778', 'EVETTE', 'LA', 'RIVERA', '2003-07-15', '61042', 'Indian', '1983-7-6', 'Male', 'SG');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('138043292367', 'MARY', 'MA', 'RUGLIC', '2020-12-23', '43389', 'Indian', '1988-8-23', 'Female', 'AI');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('452985909959', 'MARCOS', 'A', 'SANCHEZ', '2013-03-12', '74604', 'Indian', '1990-10-1', 'Female', 'G8');
INSERT INTO `Airport_Database`.`Airline_Employees/CREW` (`Aadhar_card_number`, `First_Name`, `Minit`, `Last_Name`, `Joining_Date`, `Salary`, `Nationality`, `DOB`, `Gender`, `Employer_IATA_Airline_Code`) VALUES ('972738450911', 'KIMBERLY', 'MA', 'SANDERS', '2003-04-15', '17674', 'Indian', '1987-8-10', 'Male', 'UK');


INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('423842256711');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('487301900720');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('839379776636');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('763239030001');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('267270646226');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('705118388146');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('895445335106');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('573139661735');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('178901887912');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('968293757996');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('987073359667');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('464486919784');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('272041370301');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('774444132904');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('419649385822');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('952078195347');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('365788043732');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('523364866992');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('682892019010');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('436363863265');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('659471917725');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('773578728750');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('788035500462');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('482861471480');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('887225220049');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('539894579755');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('685850699467');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('295985438642');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('387424604116');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('757544661652');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('996366605513');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('559764090284');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('507987293417');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('576538804352');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('517628926875');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('373431374191');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('436899770238');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('172124790919');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('311899954816');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('189012025021');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('593984902158');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('823455853160');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('279413154352');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('113128320405');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('392948176090');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('508612826180');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('233363221108');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('749515388866');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('164713043824');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('637470568896');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('874814427763');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('777211077788');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('767644651742');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('120295354135');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('447585081788');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('309085507854');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('341648440548');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('463262786649');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('427691459617');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('139446154652');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('816989698738');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('492889047751');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('740585609636');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('590695444281');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('998727690821');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('533489174577');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('895942302481');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('915403132186');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('947056199545');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('882529509704');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('701316776234');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('576404241274');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('351662528098');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('723531887630');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('271274517218');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('940190667854');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('994162770130');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('562920204688');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('357284469139');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('866295518182');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('728003163445');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('743180682606');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('725253952481');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('801202304690');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('910746441422');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('727603019279');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('984116856572');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('852751115441');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('324523567094');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('331235638977');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('263894653433');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('989795868900');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('929409113318');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('898590197215');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('885349935083');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('293071995777');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('960473363810');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('186480088941');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('699936401511');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('229570111446');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('307444476492');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('201895719396');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('442222040823');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('350063861992');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('710069101922');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('901079987005');
INSERT INTO `Airport_Database`.`Flight_Crew` (`Aadhar_card_number`) VALUES ('859876076991');


INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('427691459617', '143237675511', '20566');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('139446154652', '524774458664', '71457');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('816989698738', '661150524446', '33870');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('492889047751', '846255266160', '1139');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('740585609636', '103718540791', '2612');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('590695444281', '690717978037', '9905');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('998727690821', '573158997432', '71020');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('533489174577', '448679812176', '71');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('895942302481', '540228469986', '12717');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('576404241274', '251625264823', '92327');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('351662528098', '350522158966', '18430');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('723531887630', '305435512607', '65174');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('271274517218', '982572511921', '93237');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('866295518182', '991862478697', '69207');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('728003163445', '227181280736', '61042');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('743180682606', '624884196880', '43389');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('725253952481', '814731645998', '74604');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('852751115441', '189961712723', '17674');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('324523567094', '823622804182', '14986');
INSERT INTO `Airport_Database`.`Pilot` (`Aadhar_card_number`, `Pilot_license_number`, `Number_of_flying_hours`) VALUES ('331235638977', '448760540703', '50667');


INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('423842256711', 'Flight_Crew 1');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('705118388146', 'Flight_Crew 2');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('987073359667', 'Flight_Crew 3');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('952078195347', 'Flight_Crew 4');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('659471917725', 'Flight_Crew 5');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('539894579755', 'Flight_Crew 6');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('996366605513', 'Flight_Crew 7');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('373431374191', 'Flight_Crew 8');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('593984902158', 'Flight_Crew 9');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('508612826180', 'Flight_Crew 10');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('874814427763', 'Flight_Crew 11');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('309085507854', 'Flight_Crew 12');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('701316776234', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('940190667854', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('727603019279', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('839379776636', 'Flight_Crew 1');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('573139661735', 'Flight_Crew 2');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('272041370301', 'Flight_Crew 3');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('523364866992', 'Flight_Crew 4');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('788035500462', 'Flight_Crew 5');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('295985438642', 'Flight_Crew 6');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('507987293417', 'Flight_Crew 7');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('172124790919', 'Flight_Crew 8');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('279413154352', 'Flight_Crew 9');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('749515388866', 'Flight_Crew 10');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('767644651742', 'Flight_Crew 11');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('463262786649', 'Flight_Crew 12');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('915403132186', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('562920204688', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('763239030001', 'Flight_Crew 1');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('178901887912', 'Flight_Crew 2');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('774444132904', 'Flight_Crew 3');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('682892019010', 'Flight_Crew 4');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('482861471480', 'Flight_Crew 5');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('387424604116', 'Flight_Crew 6');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('576538804352', 'Flight_Crew 7');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('311899954816', 'Flight_Crew 8');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('113128320405', 'Flight_Crew 9');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('164713043824', 'Flight_Crew 10');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('120295354135', 'Flight_Crew 11');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('947056199545', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('357284469139', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('801202304690', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('487301900720', 'Flight_Crew 1');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('895445335106', 'Flight_Crew 2');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('464486919784', 'Flight_Crew 3');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('365788043732', 'Flight_Crew 4');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('773578728750', 'Flight_Crew 5');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('685850699467', 'Flight_Crew 6');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('559764090284', 'Flight_Crew 7');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('436899770238', 'Flight_Crew 8');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('823455853160', 'Flight_Crew 9');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('233363221108', 'Flight_Crew 10');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('777211077788', 'Flight_Crew 11');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('341648440548', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('994162770130', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('984116856572', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('267270646226', 'Flight_Crew 1');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('968293757996', 'Flight_Crew 2');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('419649385822', 'Flight_Crew 3');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('436363863265', 'Flight_Crew 4');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('887225220049', 'Flight_Crew 5');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('757544661652', 'Flight_Crew 6');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('517628926875', 'Flight_Crew 7');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('189012025021', 'Flight_Crew 8');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('392948176090', 'Flight_Crew 9');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('637470568896', 'Flight_Crew 10');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('447585081788', 'Flight_Crew 11');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('882529509704', 'Sr. Flight_Crew Training');
INSERT INTO `Airport_Database`.`Flight_Attendant` (`Aadhar_card_number`, `Training/Education`) VALUES ('910746441422', 'Sr. Flight_Crew Training');


INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('263894653433', 'Aerospace Engineering', 'Boeing', '737');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('989795868900', 'Aerospace Engineering', 'Boeing', '777');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('929409113318', 'Aerospace Engineering', 'Boeing', '737');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('898590197215', 'Aerospace Engineering', 'Airbus', '320');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('885349935083', 'Aerospace Engineering', 'Boeing', '747');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('293071995777', 'Aerospace Engineering', 'Airbus', '330');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('960473363810', 'Aerospace Engineering', 'Boeing', '737');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('186480088941', 'Aerospace Engineering', 'Airbus', '320');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('699936401511', 'Aerospace Engineering', 'Boeing', '777');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('229570111446', 'Aerospace Engineering', 'Boeing', '747');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('307444476492', 'Aerospace Engineering', 'Boeing', '777');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('201895719396', 'Aerospace Engineering', 'Boeing', '747');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('442222040823', 'Aerospace Engineering', 'Airbus', '340');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('350063861992', 'Aerospace Engineering', 'Boeing', '747');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('710069101922', 'Aerospace Engineering', 'Boeing', '747');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('901079987005', 'Aerospace Engineering', 'Boeing', '777');
INSERT INTO `Airport_Database`.`Flight_Engineer` (`Aadhar_card_number`, `Education`, `Manufacturer`, `Plane_Model_No.`) VALUES ('859876076991', 'Aerospace Engineering', 'Boeing', '777');


INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('742345609823', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('508807841865', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('743065235687', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('117708762407', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('844295166474', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('659520341336', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('268709851713', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('612272332784', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('382252530528', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('204847494048', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('926393263101', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('442125731778', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('138043292367', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('452985909959', 'Ground Staff');
INSERT INTO `Airport_Database`.`On_Ground` (`Aadhar_card_number`, `Job_title`) VALUES ('972738450911', 'Ground Staff');


INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('423842256711', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('705118388146', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('987073359667', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('952078195347', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('659471917725', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('539894579755', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('996366605513', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('373431374191', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('593984902158', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('508612826180', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('874814427763', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('309085507854', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('701316776234', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('940190667854', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('727603019279', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('839379776636', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('573139661735', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('272041370301', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('523364866992', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('788035500462', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('295985438642', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('507987293417', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('172124790919', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('279413154352', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('749515388866', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('767644651742', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('463262786649', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('915403132186', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('562920204688', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('763239030001', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('178901887912', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('774444132904', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('682892019010', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('482861471480', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('387424604116', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('576538804352', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('311899954816', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('113128320405', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('164713043824', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('120295354135', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('947056199545', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('357284469139', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('801202304690', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('487301900720', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('895445335106', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('464486919784', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('365788043732', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('773578728750', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('685850699467', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('559764090284', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('436899770238', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('823455853160', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('233363221108', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('777211077788', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('341648440548', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('994162770130', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('984116856572', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('267270646226', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('968293757996', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('419649385822', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('436363863265', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('887225220049', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('757544661652', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('517628926875', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('189012025021', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('392948176090', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('637470568896', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('447585081788', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('882529509704', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('910746441422', 'English');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('423842256711', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('705118388146', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('987073359667', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('952078195347', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('659471917725', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('539894579755', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('996366605513', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('373431374191', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('593984902158', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('508612826180', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('874814427763', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('309085507854', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('701316776234', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('940190667854', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('727603019279', 'Hindi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('487301900720', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('895445335106', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('464486919784', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('365788043732', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('773578728750', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('685850699467', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('559764090284', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('436899770238', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('823455853160', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('233363221108', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('777211077788', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('341648440548', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('994162770130', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('984116856572', 'Tamil');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('267270646226', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('968293757996', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('419649385822', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('436363863265', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('887225220049', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('757544661652', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('517628926875', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('189012025021', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('392948176090', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('637470568896', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('447585081788', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('882529509704', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('910746441422', 'Marathi');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('267270646226', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('968293757996', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('419649385822', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('436363863265', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('887225220049', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('757544661652', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('517628926875', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('189012025021', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('392948176090', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('637470568896', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('447585081788', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('882529509704', 'Telugu');
INSERT INTO `Airport_Database`.`Languages_spoken_by_airline_employee` (`Aadhar_card_number`, `Language`) VALUES ('910746441422', 'Telugu');


INSERT INTO `Airport_Database`.`Airport` (`IATA_CODE`, `Manager`, `Time_Zone`, `Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('DEL', 'Narayana Rao Kada', '+05:30', 'Indira Gandhi International Airport', 'Delhi', 'India', '28.7041', '77.1025');
INSERT INTO `Airport_Database`.`Airport` (`IATA_CODE`, `Manager`, `Time_Zone`, `Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('HYD', 'Ajaj Mohammed', '+05:30', 'Rajiv Gandhi International Airport', 'Hyderabad', 'India', '17.385', '78.4867');
INSERT INTO `Airport_Database`.`Airport` (`IATA_CODE`, `Manager`, `Time_Zone`, `Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('MUM', 'Smita Brid', '+05:30', 'Chattrapati Shivaji International Airport', 'Mumbai', 'India', '19.076', '72.8777');
INSERT INTO `Airport_Database`.`Airport` (`IATA_CODE`, `Manager`, `Time_Zone`, `Name`, `City`, `Country`, `Latitude`, `Longitude`) VALUES ('BLR', 'Hari Marar', '+05:30', 'KempeGowda International Airport', 'Bengaluru', 'India', '12.9716', '77.5946');


INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('BLR', '0', '13123', '148', 'Available');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('BLR', '1', '13120', '200', 'Available');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('DEL', '0', '9229', '150.9', 'Available');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('DEL', '1', '12500', '150.92', 'Available');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('DEL', '2', '14534.121', '196.85', 'Available');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('HYD', '0', '12162', '148', 'Available');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('HYD', '1', '13980', '200', 'Available');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('HYD', '2', '3622', '98', 'Disfunctional');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('MUM', '0', '12008', '200', 'Available');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('MUM', '1', '9810', '148', 'Available');
INSERT INTO `Airport_Database`.`Runway` (`IATA_CODE`, `Runway_ID`, `Length`, `Width`, `Status`) VALUES ('MUM', '2', '334', '567', 'Disfunctional');


INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('DEL', '1', '450', '34753');
INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('DEL', '2', '280', '54320');
INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('DEL', '3', '800', '76459');
INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('MUM', '1', '325', '21457');
INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('MUM', '2', '341', '23574');
INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('MUM', '3', '560', '87934');
INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('HYD', '1', '560', '23572');
INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('HYD', '2', '960', '46973');
INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('BLR', '1', '650', '23258');
INSERT INTO `Airport_Database`.`Terminal` (`IATA_CODE`, `Terminal_ID`, `Flight_Handling_capacity`, `Floor_Area`) VALUES ('BLR', '2', '860', '143766');


INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('956655099681', 'DEL', 'MAUREEN', 'DA', 'CHIAVOLA', '18', '50667', 'Indian', '1986-8-21', 'Female', '956655099681');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('998808524131', 'MUM', 'MCKAY', 'VA', 'MURPHY', '22', '71457', 'Indian', '2013-2-28', 'Male', '998808524131');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('999820913949', 'BLR', 'HERMAN', 'AA', 'JOHNSON', '25', '33870', 'Indian', '2013-11-6', 'Male', '999820913949');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('815733892734', 'HYD', 'MARGARET', 'A', 'GAECKE', '21', '20566', 'Indian', '1992-8-6', 'Female', '815733892734');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('776852249050', 'DEL', 'CHRISTOPHER', 'AA', 'HAMMONDS', '9', '65174', 'Indian', '2020-7-24', 'Male', '956655099681');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('815389550189', 'MUM', 'BRYANT', 'A', 'HOGAN', '11', '93237', 'Indian', '1985-3-8', 'Male', '998808524131');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('815733892733', 'HYD', 'XUAN', 'A', 'LE', '12', '69207', 'Indian', '1978-4-3', 'Female', '815733892734');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('817550895816', 'BLR', 'ANTHONY', 'RA', 'LIN', '12', '61042', 'Indian', '1971-6-19', 'Male', '999820913949');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('419931616553', 'DEL', 'SANDRA', 'A', 'GARNER', '4', '43389', 'Indian', '1961-7-19', 'Female', '776852249050');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('436837066216', 'MUM', 'BIANCA', 'A', 'GLASS', '4', '74604', 'Indian', '2019-10-12', 'Male', '815389550189');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('443459752216', 'BLR', 'TYNEASHA', 'A', 'MURCHISON', '4', '17674', 'Indian', '1988-2-25', 'Female', '817550895816');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('450805939067', 'HYD', 'JULIO', 'MA', 'PANTOJA', '4', '14986', 'Indian', '1984-1-16', 'Male', '815733892733');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('137979359058', 'DEL', 'VERNICA', 'LA', 'MORRIS', '0', '20566', 'Indian', '2010-4-17', 'Female', '419931616553');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('144269786726', 'DEL', 'BRUCE', 'SA', 'ADELMAN', '0', '71457', 'Indian', '1975-3-8', 'Male', '419931616553');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('149655844898', 'DEL', 'MAYRA', 'MA', 'MUNOZ', '0', '33870', 'Indian', '1961-9-11', 'Female', '419931616553');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('159961373889', 'DEL', 'BRITTANY', 'AA', 'BURKS', '1', '20566', 'Indian', '1953-10-18', 'Female', '419931616553');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('183207521309', 'HYD', 'BARBARA', 'AA', 'BERONSKI', '1', '71457', 'Indian', '1986-3-18', 'Female', '450805939067');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('190030951732', 'HYD', 'THOMAS', 'EA', 'MYLES', '1', '33870', 'Indian', '1990-1-17', 'Male', '450805939067');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('199286222027', 'HYD', 'DOROTHY', 'IA', 'DUKES', '2', '20566', 'Indian', '1957-8-2', 'Female', '450805939067');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('233167041254', 'MUM', 'CLARA', 'AA', 'GERDES', '2', '71457', 'Indian', '1984-10-20', 'Female', '436837066216');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('244106032061', 'MUM', 'RALPH', 'CA', 'BAKER JR', '2', '33870', 'Indian', '2008-5-27', 'Male', '436837066216');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('247638008710', 'MUM', 'KAREN', 'SA', 'BOYD-GREATHOUSE', '2', '92327', 'Indian', '1950-1-3', 'Male', '436837066216');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('261514501173', 'BLR', 'RACHEL', 'EA', 'BROWN', '3', '18430', 'Indian', '2004-1-8', 'Female', '443459752216');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('277990544656', 'BLR', 'GISELLE', 'AA', 'CALDERON', '3', '65174', 'Indian', '1961-2-12', 'Male', '443459752216');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('373724464459', 'BLR', 'ANGELA', 'CA', 'CEREZO', '3', '93237', 'Indian', '1994-9-6', 'Female', '443459752216');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('375299003172', 'DEL', 'CHERYL', 'RA', 'DAVIS', '3', '69207', 'Indian', '1958-11-5', 'Female', '419931616553');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('383457629189', 'DEL', 'MONICA', 'MA', 'GARCIA', '3', '61042', 'Indian', '1973-5-10', 'Female', '419931616553');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('517745328168', 'DEL', 'ARTEE', 'A', 'PITTMAN', '5', '50667', 'Indian', '2003-4-1', 'Male', '956655099681');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('521624019670', 'MUM', 'ENRIQUE', 'A', 'RUIZ', '5', '20566', 'Indian', '1971-2-6', 'Male', '998808524131');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('540584527686', 'BLR', 'BRIDGETT', 'PA', 'SHORTER', '6', '71457', 'Indian', '1988-1-22', 'Male', '999820913949');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('551395948759', 'HYD', 'DWAYNE', 'JA', 'VALENTINE', '7', '33870', 'Indian', '1950-9-22', 'Male', '815733892734');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('563847876190', 'DEL', 'MYRNA', 'A', 'WEBB', '7', '20566', 'Indian', '1958-12-14', 'Male', '956655099681');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('572875339270', 'DEL', 'ARION', 'RA', 'BROWN', '7', '71457', 'Indian', '2001-7-11', 'Female', '956655099681');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('652320097439', 'MUM', 'BETTY', 'A', 'FLETCHER', '8', '33870', 'Indian', '1997-1-14', 'Female', '998808524131');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('654337056688', 'BLR', 'MARIO', 'A', 'GARCIA', '8', '20566', 'Indian', '2005-12-26', 'Female', '999820913949');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('654630609952', 'HYD', 'JUDITH', 'A', 'TOLLINCHI', '9', '71457', 'Indian', '2001-10-1', 'Female', '815733892734');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('723457504496', 'DEL', 'STANLEY', 'A', 'DANIEL', '9', '33870', 'Indian', '2015-9-11', 'Male', '956655099681');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('771582198504', 'BLR', 'ANTONIO', 'SA', 'AMARO', '9', '92327', 'Indian', '2008-10-3', 'Male', '999820913949');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('774572687679', 'MUM', 'DAVID', 'MA', 'BEHLING', '9', '18430', 'Indian', '1957-2-6', 'Male', '998808524131');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('836429038835', 'HYD', 'MICHAEL', 'LA', 'MOORE', '14', '43389', 'Indian', '1992-9-20', 'Male', '815733892734');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('856067038076', 'DEL', 'JESUS', 'A', 'ONTIVEROS', '15', '74604', 'Indian', '1960-12-4', 'Male', '956655099681');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('878403070017', 'MUM', 'SHERRY', 'A', 'ZABEL', '15', '17674', 'Indian', '1962-11-4', 'Female', '998808524131');
INSERT INTO `Airport_Database`.`Airport_Employees/CREWS` (`Aadhar_card_number`, `Working_Airport_IATA_CODE`, `First_Name`, `Minit`, `Last_Name`, `Experience`, `Salary`, `Nationality`, `DOB`, `Gender`, `Supervisor_Aadhar_card_number`) VALUES ('952765772249', 'HYD', 'GILBERTO', 'KA', 'PEREZ-PADILLA', '18', '14986', 'Indian', '1970-8-4', 'Male', '815733892734');


INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('572875339270', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('652320097439', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('654337056688', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('654630609952', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('723457504496', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('771582198504', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('774572687679', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('836429038835', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('856067038076', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('878403070017', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('952765772249', 'Management Operations');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('956655099681', 'Chief Manager');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('815733892733', 'Chief Manager');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('998808524131', 'Chief Manager');
INSERT INTO `Airport_Database`.`Management_and_operations_executives` (`Aadhar_card_number`, `Job_title`) VALUES ('999820913949', 'Chief Manager');


INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('137979359058', 'Security', '1');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('144269786726', 'Security', '2');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('149655844898', 'Security', '3');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('159961373889', 'Security', '4');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('183207521309', 'Security', '5');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('190030951732', 'Security', '6');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('199286222027', 'Security', '7');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('233167041254', 'Security', '8');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('244106032061', 'Security', '9');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('247638008710', 'Security', '10');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('261514501173', 'Security', '11');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('277990544656', 'Security', '12');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('373724464459', 'Security', '13');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('375299003172', 'Security', '14');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('383457629189', 'Security', '15');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('419931616553', 'Security Supervisor', '16');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('436837066216', 'Security Supervisor', '17');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('443459752216', 'Security Supervisor', '18');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('450805939067', 'Security Supervisor', '19');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('776852249050', 'Security Incharge', '20');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('815389550189', 'Security Incharge', '21');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('815733892733', 'Security Incharge', '22');
INSERT INTO `Airport_Database`.`Security` (`Aadhar_card_number`, `Designation`, `Security_ID_Number`) VALUES ('817550895816', 'Security Incharge', '23');


INSERT INTO `Airport_Database`.`Air_Traffic_Controller` (`Aadhar_card_number`, `Current_communication_Frequency`, `Training/Education`) VALUES ('517745328168', '560', 'MS');
INSERT INTO `Airport_Database`.`Air_Traffic_Controller` (`Aadhar_card_number`, `Current_communication_Frequency`, `Training/Education`) VALUES ('521624019670', '786', 'Btech');
INSERT INTO `Airport_Database`.`Air_Traffic_Controller` (`Aadhar_card_number`, `Current_communication_Frequency`, `Training/Education`) VALUES ('540584527686', '675', 'Mtech');
INSERT INTO `Airport_Database`.`Air_Traffic_Controller` (`Aadhar_card_number`, `Current_communication_Frequency`, `Training/Education`) VALUES ('551395948759', '956', 'Btech');
INSERT INTO `Airport_Database`.`Air_Traffic_Controller` (`Aadhar_card_number`, `Current_communication_Frequency`, `Training/Education`) VALUES ('563847876190', '842', 'PhD');


INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('1', 'DEL', 'MUM', '2020/10/06', '10:25', '8:20', '10:30', '8:25', '2:05', '0', '1350', '0', '345', 'Arrived', '427691459617', '701316776234');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('2', 'DEL', 'MUM', '2020/10/06', '11:30', '9:25', '11:35', '9:30', '2:05', '1', '1350', '0', '232', 'Arrived', '139446154652', '940190667854');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('3', 'DEL', 'MUM', '2020/10/06', '14:15', '12:10', '14:20', '12:15', '2:05', '0', '1350', '1', '642', 'Arrived', '816989698738', '727603019279');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('4', 'DEL', 'MUM', '2020/10/06', '17:15', '15:10', '17:20', '15:15', '2:05', '2', '1350', '0', '734', 'Arrived', '492889047751', '915403132186');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('5', 'DEL', 'MUM', '2020/10/06', '18:35', '16:30', '18:40', '16:35', '2:05', '0', '1350', '1', '875', 'Arrived', '740585609636', '562920204688');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('6', 'DEL', 'MUM', '2020/10/06', '19:15', '17:00', '19:20', '17:05', '2:15', '1', '1350', '0', '242', 'Arrived', '590695444281', '947056199545');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('7', 'HYD', 'MUM', '2020/10/06', '22:15', '20:00', '22:20', '20:05', '2:15', '0', '1350', '0', '435', 'Arrived', '998727690821', '357284469139');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('8', 'BLR', 'MUM', '2020/10/06', '22:05', '19:50', '22:10', '19:55', '2:15', '0', '1350', '0', '975', 'Arrived', '533489174577', '801202304690');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('9', 'BLR', 'MUM', '2020/10/06', '9:10', '6:45', '9:15', '6:50', '2:25', '1', '1350', '1', '645', 'Arrived', '895942302481', '341648440548');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('10', 'BLR', 'MUM', '2020/10/06', '13:15', '11:10', '13:20', '11:15', '2:05', '0', '1350', '0', '893', 'Arrived', '576404241274', '994162770130');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('11', 'BLR', 'MUM', '2020/10/06', '15:00', '12:55', '15:05', '13:00', '2:05', '1', '1350', '1', '234', 'Arrived', '351662528098', '984116856572');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('12', 'HYD', 'MUM', '2020/10/07', '17:40', '15:35', '17:45', '15:40', '2:05', '0', '1350', '0', '212', 'Arrived', '723531887630', '882529509704');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('13', 'HYD', 'MUM', '2020/10/07', '22:40', '20:35', '22:45', '20:40', '2:05', '1', '1350', '1', '673', 'Arrived', '271274517218', '910746441422');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('14', 'HYD', 'MUM', '2020/10/07', '8:05', '5:55', '8:10', '6:00', '2:05', '0', '1350', '0', '546', 'Arrived', '866295518182', '701316776234');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('15', 'DEL', 'HYD', '2020/10/07', '9:10', '7:15', '9:15', '7:20', '1:55', '0', '1023', '0', '343', 'Arrived', '728003163445', '940190667854');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('16', 'DEL', 'HYD', '2020/10/07', '9:25', '7:20', '9:30', '7:25', '2:05', '2', '1023', '0', '235', 'Arrived', '743180682606', '727603019279');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('17', 'DEL', 'HYD', '2020/10/07', '16:30', '14:20', '16:35', '14:25', '2:10', '1', '1023', '1', '232', 'Arrived', '725253952481', '915403132186');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('18', 'BLR', 'HYD', '2020/10/07', '12:15', '10:00', '12:20', '10:05', '2:15', '0', '1023', '0', '796', 'Arrived', '852751115441', '562920204688');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('19', 'BLR', 'HYD', '2020/10/08', '9:40', '7:30', '9:45', '7:35', '2:10', '0', '1023', '1', '878', 'Arrived', '324523567094', '947056199545');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('20', 'MUM', 'HYD', '2020/10/08', '13:15', '11:00', '13:20', '11:05', '2:15', '1', '1023', '0', '238', 'Arrived', '331235638977', '357284469139');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('21', 'MUM', 'HYD', '2020/10/08', '17:15', '15:00', '17:20', '15:05', '2:15', '0', '1023', '0', '124', 'Arrived', '427691459617', '801202304690');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('22', 'DEL', 'BLR', '2020/10/08', '15:10', '12:35', '15:15', '12:40', '2:35', '2', '1530', '1', '974', 'Arrived', '139446154652', '341648440548');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('23', 'MUM', 'BLR', '2020/10/08', '21:30', '18:45', '21:35', '18:50', '2:45', '0', '1530', '0', '642', 'Arrived', '816989698738', '994162770130');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('24', 'HYD', 'BLR', '2020/10/08', '22:30', '19:40', '22:35', '19:45', '2:50', '0', '1530', '0', '234', 'Arrived', '492889047751', '984116856572');
INSERT INTO `Airport_Database`.`Route` (`Route_ID`, `Source_IATA_CODE`, `Destination_IATA_CODE`, `Date`, `Scheduled_Arrival`, `Scheduled_Departure`, `Actual_Arrival_Time`, `Actual_Departure_Time`, `Time_duration`, `Take_off_runway_id`, `Distance_Travelled`, `Landing_Runway_ID`, `Registration_No.`, `Status`, `Pilot_Captain_Aadhar_card_number`, `Chief_Flight_Attendant_Aadhar_card_number`) VALUES ('25', 'DEL', 'BLR', '2020/10/08', '7:55', '5:20', '8:00', '5:25', '2:35', '2', '1530', '1', '236', 'Arrived', '740585609636', '882529509704');


INSERT INTO `Airport_Database`.`Stopover_Airports_of_Route` (`Route_ID`, `Stopover_Airport_IATA_CODE`) VALUES ('22', 'HYD');
INSERT INTO `Airport_Database`.`Stopover_Airports_of_Route` (`Route_ID`, `Stopover_Airport_IATA_CODE`) VALUES ('23', 'HYD');
INSERT INTO `Airport_Database`.`Stopover_Airports_of_Route` (`Route_ID`, `Stopover_Airport_IATA_CODE`) VALUES ('25', 'HYD');
INSERT INTO `Airport_Database`.`Stopover_Airports_of_Route` (`Route_ID`, `Stopover_Airport_IATA_CODE`) VALUES ('16', 'BLR');
INSERT INTO `Airport_Database`.`Stopover_Airports_of_Route` (`Route_ID`, `Stopover_Airport_IATA_CODE`) VALUES ('17', 'BLR');


INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('427691459617', '1');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('139446154652', '2');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('816989698738', '3');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('492889047751', '4');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('740585609636', '5');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('590695444281', '6');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('998727690821', '7');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('533489174577', '8');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('895942302481', '9');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('576404241274', '10');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('351662528098', '11');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('723531887630', '12');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('271274517218', '13');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('866295518182', '14');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('728003163445', '15');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('743180682606', '16');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('725253952481', '17');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('852751115441', '18');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('324523567094', '19');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('331235638977', '20');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('427691459617', '21');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('139446154652', '22');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('816989698738', '23');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('492889047751', '24');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('740585609636', '25');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('139446154652', '1');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('816989698738', '2');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('492889047751', '3');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('740585609636', '4');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('590695444281', '5');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('998727690821', '6');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('533489174577', '7');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('895942302481', '8');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('576404241274', '9');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('351662528098', '10');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('723531887630', '11');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('271274517218', '12');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('866295518182', '13');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('728003163445', '14');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('743180682606', '15');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('725253952481', '16');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('852751115441', '17');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('324523567094', '18');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('331235638977', '19');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('427691459617', '20');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('139446154652', '21');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('816989698738', '22');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('492889047751', '23');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('740585609636', '24');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('427691459617', '25');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('701316776234', '1');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('940190667854', '2');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('727603019279', '3');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('915403132186', '4');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('562920204688', '5');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('947056199545', '6');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('357284469139', '7');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('801202304690', '8');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('341648440548', '9');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('994162770130', '10');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('984116856572', '11');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('882529509704', '12');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('910746441422', '13');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('701316776234', '14');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('940190667854', '15');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('727603019279', '16');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('915403132186', '17');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('562920204688', '18');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('947056199545', '19');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('357284469139', '20');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('801202304690', '21');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('341648440548', '22');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('994162770130', '23');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('984116856572', '24');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('882529509704', '25');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('263894653433', '1');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('989795868900', '2');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('929409113318', '3');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('898590197215', '4');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('885349935083', '5');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('293071995777', '6');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('960473363810', '7');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('186480088941', '8');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('699936401511', '9');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('229570111446', '10');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('307444476492', '11');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('201895719396', '12');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('442222040823', '13');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('350063861992', '14');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('710069101922', '15');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('901079987005', '16');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('859876076991', '17');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('263894653433', '18');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('989795868900', '19');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('929409113318', '20');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('898590197215', '21');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('885349935083', '22');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('293071995777', '23');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('960473363810', '24');
INSERT INTO `Airport_Database`.`Flight_Crew_SERVES_ON_THE_Route` (`Aadhar_card_number`, `Route_ID`) VALUES ('186480088941', '25');


INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('427691459617', '139446154652', '701316776234', '263894653433', '4', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('139446154652', '816989698738', '940190667854', '989795868900', '3', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('816989698738', '492889047751', '727603019279', '929409113318', '4', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('492889047751', '740585609636', '915403132186', '898590197215', '3', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('740585609636', '590695444281', '562920204688', '885349935083', '4', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('590695444281', '998727690821', '947056199545', '293071995777', '2', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('998727690821', '533489174577', '357284469139', '960473363810', '4', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('533489174577', '895942302481', '801202304690', '186480088941', '3', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('895942302481', '576404241274', '341648440548', '699936401511', '4', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('576404241274', '351662528098', '994162770130', '229570111446', '3', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('351662528098', '723531887630', '984116856572', '307444476492', '2', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('723531887630', '271274517218', '882529509704', '201895719396', '4', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('271274517218', '866295518182', '910746441422', '442222040823', '2', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('866295518182', '728003163445', '701316776234', '350063861992', '3', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('728003163445', '743180682606', '940190667854', '710069101922', '4', '2');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('743180682606', '725253952481', '727603019279', '901079987005', '4', '1');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('725253952481', '852751115441', '915403132186', '859876076991', '5', '1');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('852751115441', '324523567094', '562920204688', '263894653433', '3', '1');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('324523567094', '331235638977', '947056199545', '989795868900', '3', '1');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('331235638977', '427691459617', '357284469139', '929409113318', '5', '1');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('427691459617', '139446154652', '801202304690', '898590197215', '3', '1');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('139446154652', '816989698738', '341648440548', '885349935083', '4', '1');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('816989698738', '492889047751', '994162770130', '293071995777', '2', '1');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('492889047751', '740585609636', '984116856572', '960473363810', '3', '1');
INSERT INTO `Airport_Database`.`Crew_has_worked_together` (`Pilot_Captain_Aadhar_card_number`, `Pilot_First_Officer_Aadhar_card_number`, `Flight_Attendant_Aadhar_card_number`, `Flight_Engineer_Aadhar_card_number`, `Avg_Competence_Rating`, `Number_of_Languages_spoken_overall`) VALUES ('740585609636', '427691459617', '882529509704', '186480088941', '2', '1');


INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YV0HA8', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KX9IH3', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PQ0VY2', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OX0FG9', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JX5FO0', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YD7UM4', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RK7LM5', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GO5PQ7', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZD0NA7', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DH0OY7', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GM3XT3', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HR8IG8', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YM8JU6', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PH3LH7', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DS9AE4', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DK6TA2', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AC1JO0', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GI3KF7', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TB1FT2', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WZ6TF5', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YY1DW4', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XR0KI5', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BA3NF7', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LU0LU7', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TX9HD7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AF9UJ3', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TW4LB0', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KW4HY7', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FC1IT0', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RT6VG6', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LQ9XI5', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UB3PM9', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YN2GE2', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KX8EM3', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XZ2LM3', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XL1SO9', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MW8VT8', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AT5WN9', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YC1UP3', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WB8DI0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RL2KS9', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UL1LP5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WI3JL6', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CB9BF8', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PW3IL6', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GS2TY8', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VN4PF6', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZN2SV8', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LY7KF6', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GV0AT7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LC7XI9', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YS3TA2', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GS8MF3', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZZ3KK8', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FY7YN7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LP7SE8', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AX3XH5', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YZ6KO7', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BP5ZN0', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XP9ZK4', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PX6XH8', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SM9MZ9', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NE4RW6', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GV7TS2', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RE1DD2', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HL6OE3', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VE9HD4', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HN1JF7', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AX4JN8', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DI9SU9', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QF5NM6', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TE7GR8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QS6JL0', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VE7NK6', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HQ5FC2', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XE7LH2', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AF3DR4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RC2UV9', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SN9EU2', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MF9DV5', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZB5OD5', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WS6GP3', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KR8RG0', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AE2CD6', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YT7KZ0', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SK5QK9', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LR0VQ7', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YQ4MA6', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FV1SJ5', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FW9IA3', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YS0MP7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YM2TA1', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PI8ZD1', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OD8FV6', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DT9SD5', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NF2UF9', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QG0AK8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FU8FR6', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BT3RN9', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KL0WV5', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AS3CL1', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LA2DI7', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TV1MR8', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TN7QG1', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VE1PQ7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QH1SX1', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FF1IJ4', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ON3KX8', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OY0LT7', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BO4BY5', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YJ9XI0', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KY8SW6', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DF5EF0', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VH4TK8', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HL4GJ9', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FS5JY1', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QA5FR8', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IP0WM3', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OZ6JF3', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZL7AY7', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DS4GI1', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BC6OJ1', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OC9RB5', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HO9NC7', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CQ9NN9', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SD2PJ4', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AP8HP6', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AX4JR7', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OD6VI6', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TF8SF4', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SB0XY6', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RU4YL4', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AR3XR2', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WZ5UE0', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GI8YH9', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GQ7RZ9', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CA2JQ1', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EI2GJ9', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JM6SE3', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YJ5BB3', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QF2RG0', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SY7WK5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XM2QT6', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HD4TY6', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FQ3PA8', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TU3KB0', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AU7ZO1', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZS8KO6', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CZ1UK9', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BF2IA1', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CA2ER4', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EP8TS7', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QH4PE0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('US0OD7', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EH2KO6', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OX0OX7', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QZ3PV4', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TH2YJ8', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MU6NH0', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HH5DE2', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HR1AG6', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EK5VZ5', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PO5WB8', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BU6BB3', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EW9BU1', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TN5AG5', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CC6DR3', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PO7ZJ7', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KA8TU9', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AR0AN5', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PL3TE2', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YF3QE3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CU4RC3', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HH5ZC4', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CO1CZ8', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CC0TY2', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KR1JN1', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LS5BG1', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JY5VS4', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZD8YN3', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QX6YD9', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CC1SO1', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BN3ND9', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KG3FZ5', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YP0RC4', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CE4WE6', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XK3UL7', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RK1KZ1', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HL2VT6', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZB8RU5', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JM7EA6', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TC4PB2', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GJ9QL5', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TM3IE1', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZZ4FH8', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PD5AK9', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IB6KS8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WF1JI4', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AZ4QY4', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EF2YW5', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RC1AK5', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WW3YC2', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FA1CT3', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JN4LY3', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YX4WB8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UU2YK8', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RE4WI9', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YN8NQ4', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AA6KE5', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MS0BN5', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XZ6OP8', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CM7FH1', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DP9ES4', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YX7WW7', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CK1OW5', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KY6AR6', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PG3BV0', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AA9JO8', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VE8VJ2', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GV9ZH2', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DD9WK9', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SK6MY2', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XV3IZ8', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZX5VX6', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UP9XU7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NV5XD2', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LN7TB4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IJ2ZR0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZN6OZ4', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OU2TY8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XY9UA8', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BA4IB2', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LO9FA0', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LQ3YU8', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VU9VE3', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VN0JM0', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZX6UD2', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BU6QI3', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XS1YG2', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RZ9KH0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FL1OD9', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AE4XE1', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WF4DO6', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EQ4QX5', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IX2VH6', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RB4GM9', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CH1VF3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OS8KJ8', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IN6ZO5', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CC5NP7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XO4FW3', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BJ6RQ5', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QO5EH9', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OO5JF1', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VK2ND5', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RG6ZM3', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HB1EM2', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CK6YI8', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XN4FN7', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SA6DV0', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WG4TM4', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OA1OE1', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QK4QX5', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XQ0FA5', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AA7NJ7', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CE3MV7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SW5YF5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YU6YW9', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DU3IJ0', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FI3ES5', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DC6QT2', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OH7DV3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YO1LE4', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TZ3MA0', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VA0UN4', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JX7KN3', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GI8JG4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CE1HM8', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AP9LT5', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JU3KL0', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RQ2QZ6', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KP6IO8', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OU4CC3', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OM8OJ3', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MP2LN4', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QQ5ID1', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PH6EA5', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LI7WH5', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YD1OI6', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IN3UZ2', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HP4LC0', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IA9LJ1', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SH1TY3', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OD0QK6', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GV2MV5', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GR8JS0', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HY5XN1', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VE3UX7', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MV4KJ0', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PU5CL9', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AY9LU6', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LB1QL4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FL4EI3', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GM9JB3', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WT9FV5', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LH8PH7', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PD5LQ2', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZV3LV8', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BG4DX8', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QN4GR5', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NQ3NP4', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JE8DM5', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JP1AR9', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GI1KQ5', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BC6WC4', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZO4SV3', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UH0ZV9', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IF6GS6', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FJ4CV1', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YT6KX8', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WX9KZ3', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QH7GV3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CH4TT1', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BX5RV5', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PO0TE3', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KI3VD2', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LI4JY9', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JI6JH8', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IR3WQ1', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DO0PR3', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YA2WP3', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VN6CA0', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZU0XE1', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KN0LH5', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PU8QP7', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LN4EK7', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UB5OM2', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RN6XW2', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JL1MQ8', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SH1TS3', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZG2AT7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DT7LK5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VB9CM3', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MJ8OG9', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QM7TZ6', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TK1RP3', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZI4TN5', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XR8CW6', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GU0WJ3', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ID2TN4', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VI1JH0', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WA3QA1', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MT8LO6', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FP4OF7', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DD6GK1', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ST0DI7', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SW4NH7', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UF0YS5', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SA9CH5', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CT6LX2', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BF7WP6', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AD0WI6', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VI1FW0', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SQ3GD0', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NF7SM6', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NW3CN7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UJ5XE2', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NU3NS2', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IT3JL0', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TH6VB4', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HY0VJ6', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PA2NF3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OF7AH9', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AV8ZC9', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BE8BF1', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UD7RU9', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GA9BW5', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KZ4AM4', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XG1US4', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WM7IZ8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AJ2BN6', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DI9RQ7', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QB0JG5', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SY4FF5', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PH4GN1', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OP6UH9', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VN6DE7', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EB4ER3', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YY9EA4', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZK8SK1', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IT9HT7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XH2HO4', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TJ6CX4', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EW2VF7', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TR8ZI6', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NG1TF2', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GV9FA8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QC6UT1', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QO5GO5', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UT3PV0', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YF4FT5', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JJ6VZ5', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZT4UT0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZJ7PC2', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NR2DR0', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PP0ZS9', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UV5UZ9', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SN2PP0', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IO0GO2', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZF7AZ8', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PB3FR5', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VM5YC3', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LI7XK4', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PX2CB9', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TK5KP3', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UZ7HX7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZQ4AH4', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HV6SG8', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ED4CV0', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XI8DQ4', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EE6BQ6', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NN1PE7', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WL5TC2', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HG2ZF3', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MF6ZE6', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IM6UW6', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EP4SR6', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VM0WM0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PO1DA2', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AN7FT7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JR4KA5', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NE3QW5', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XD8XX7', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GG4HV9', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MI8ZI8', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PF6OE8', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GG1UT7', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SG9IG3', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PB4PQ5', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OC9GJ0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NI7FY5', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GB8OX4', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CF5BU9', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TR8AJ2', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AN1DP2', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AB4KF2', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XR7TF6', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IZ8LQ5', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IQ4OX6', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IL1QQ3', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HV6BR7', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CF5FH4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TR6FO7', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KJ7WC9', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GS5ZO8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TT1OE6', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MS0HU2', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SA2NB0', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VH8HZ8', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TD1NJ2', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XM9WH9', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HR1BY5', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KC3DJ8', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NA1WR4', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EK8PN6', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CS4OF4', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SW1MA7', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MT7PA4', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MN8GH4', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RV2CE8', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NJ4PO9', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FD6RN8', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FC8UG4', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ME7AC1', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WF5XP1', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CQ0AF8', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RP4XB9', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DC4OZ2', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XN4RZ1', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XN9DC7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NC1LZ0', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VO5ED9', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MO8QI6', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RS5UH0', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YM0KH6', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VK3VA7', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VD6RK5', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PN5QI5', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TA8XQ9', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CW5CT0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QK8CY2', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DL9KX7', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CE9AH1', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PK4NA7', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DD8RR3', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YV4FX1', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SW9ER4', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KI7KO9', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VI1NO3', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PM2IC6', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CP5HW4', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FE5FK8', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YF2UR3', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YJ6KE6', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AC7LF6', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EC0AF0', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YI6QE8', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CV9XE1', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BG7VN9', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SV6XR3', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CT2IW4', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UW7KW4', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GY7TT3', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WA0KU2', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ES5JH7', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JA9EM0', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GK9MW5', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QS9RZ5', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PK0SW8', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PI0AX3', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YC5UX9', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GE9YQ0', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WR4FG8', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DD4KS3', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WE7RH7', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IY5FO6', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LB1MV9', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XT3DH9', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WF8ZH0', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BY7EN8', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EU7IY0', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RH4YV5', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BL5QO0', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SQ2XA8', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NG2XN5', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZE4IY0', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VT2SF1', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MV7VX4', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QH7XG4', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QU8MJ0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MD6BY7', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BM9YV3', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BH4OH9', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DY0EH5', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HK2WV8', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FS7AL3', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UZ1TA0', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HC7YQ2', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RM2EY7', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VD5JF8', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IY9HJ4', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WT1AH4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('EH7DT0', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PW1HC6', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZU8GW7', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QW7QA1', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OG2WJ1', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XJ5KB3', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MV8ZN9', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('FK9SO7', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZU6TB6', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HZ1KM8', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('AN4RN8', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ER1FG8', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TR5XK9', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XJ5SA8', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MS7NV9', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LS3PX5', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BJ3VM8', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JC1MB4', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RA2VH1', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GF5OQ9', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UZ3HE7', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NF6BY2', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KJ2MM5', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NM3IB3', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QP7QS4', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DS8ZN5', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YW7GB2', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LF8BN1', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DN2GK5', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('YK6ID6', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HR3SL0', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DP9VO6', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LR2MR2', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RE3ZA8', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZV8GC4', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NP4LJ5', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PU5QZ4', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KA8ZK6', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LE0KL1', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UM1SL6', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('DA0EN7', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TU7DR9', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TD9LK0', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VE9SU0', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LS6ZC7', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MS2TR5', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OV1UI7', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LX5OU1', '04:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KB4DB0', '07:40', '1', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('WW4FB1', '08:45', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SN0SO8', '11:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PB5PA4', '14:30', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('CC1TH0', '15:50', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('QT5BV8', '16:10', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('PR8GD2', '19:20', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('ZJ8KS2', '19:10', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('BP2LH6', '06:05', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('SU9KW5', '10:03', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('TT2TY4', '12:15', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('XB5LO3', '14:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IT9HQ6', '19:55', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('RB2EZ1', '05:15', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('GL1QH0', '06:35', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('NH2LG9', '06:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('VO3WK0', '13:40', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('MI6YZ3', '09:20', '2', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('JO3EQ6', '06:50', '1', 'Economy', 'BLR');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('OC3FJ7', '10:02', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('UO3NI8', '14:20', '1', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('KR3FK3', '11:55', '3', 'Economy', 'DEL');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('HQ4ZG3', '18:05', '3', 'Economy', 'MUM');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('LT0OL9', '19:00', '1', 'Economy', 'HYD');
INSERT INTO `Airport_Database`.`PNR_Info_Deduction` (`PNR_Number`, `Scheduled_Boarding_Time`, `Terminal_number`, `class_of_travel`, `Source_IATA_CODE`) VALUES ('IG5OZ6', '04:40', '1', 'Economy', 'DEL');


INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('493578734579', 'PH3LH7', '1', '878788802330', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('314598792608', 'TB1FT2', '1', '379405065549', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('286082233248', 'TX9HD7', '1', '487744883827', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('918318833665', 'DH0OY7', '1', '112222795509', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('469285323873', 'GM3XT3', '1', '607932019779', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('868368646308', 'WZ6TF5', '1', '668127242353', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('155550947675', 'HR8IG8', '1', '191968477066', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('895374202023', 'XR0KI5', '1', '991718823545', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('638308125943', 'YD7UM4', '1', '302739141189', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('145307190338', 'GI3KF7', '1', '545295423127', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('702080564028', 'DS9AE4', '1', '660672253823', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('962649919562', 'GO5PQ7', '1', '449200994374', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('178272962318', 'YM8JU6', '1', '588499828637', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('336186692620', 'YV0HA8', '1', '207090631573', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('163334419635', 'RK7LM5', '1', '152246692823', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('891480936192', 'YY1DW4', '1', '936808290378', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('946636753889', 'ZD0NA7', '1', '598578863608', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('389566212364', 'LU0LU7', '1', '289020936379', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('812576896285', 'BA3NF7', '1', '440611948707', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('890074283778', 'DK6TA2', '1', '962798560240', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('727922896521', 'AC1JO0', '1', '902907191536', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('126718861513', 'OX0FG9', '1', '906673823836', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('683148492425', 'JX5FO0', '1', '195743834667', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('782574139282', 'PQ0VY2', '1', '311872947944', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('318763452500', 'KX9IH3', '1', '150667941422', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('863961833114', 'YC1UP3', '2', '408924071666', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('620627729422', 'CB9BF8', '2', '808155753159', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('776640902468', 'GV0AT7', '2', '520697910564', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('674402674639', 'XZ2LM3', '2', '162620865752', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('524395999648', 'XL1SO9', '2', '980396674004', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('730655205007', 'PW3IL6', '2', '319875724256', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('623838053217', 'MW8VT8', '2', '530337723408', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('518853884275', 'VN4PF6', '2', '902484285179', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('103225949316', 'LQ9XI5', '2', '215945706305', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('798026813860', 'WI3JL6', '2', '562160131218', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('458671727752', 'WB8DI0', '2', '777509633526', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('819861071100', 'YN2GE2', '2', '998859180013', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('999572950176', 'AT5WN9', '2', '810365104449', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('867629954148', 'AF9UJ3', '2', '129418607536', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('161746617734', 'UB3PM9', '2', '434806690436', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('983628308073', 'GS2TY8', '2', '888111164019', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('802066871736', 'KX8EM3', '2', '516327813872', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('499101143983', 'LY7KF6', '2', '206394752118', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('694717059759', 'ZN2SV8', '2', '674120066554', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('665582097960', 'RL2KS9', '2', '382938575139', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('435901371196', 'UL1LP5', '2', '888243500387', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('565143525193', 'FC1IT0', '2', '729778449116', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('940398363227', 'RT6VG6', '2', '479755336220', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('680287147648', 'KW4HY7', '2', '653475904431', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('868840240943', 'TW4LB0', '2', '394856058451', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('315327129940', 'GV7TS2', '3', '844100237778', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('340000079103', 'AX4JN8', '3', '907985826328', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('480686574197', 'HQ5FC2', '3', '154217461963', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('530536807760', 'XP9ZK4', '3', '757815584875', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('700022661299', 'PX6XH8', '3', '284332550815', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('404207905670', 'DI9SU9', '3', '979333366244', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('701337300190', 'SM9MZ9', '3', '125748434671', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('173481184682', 'TE7GR8', '3', '301322176115', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('488609956213', 'LP7SE8', '3', '203484369343', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('138674460375', 'HN1JF7', '3', '227540062206', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('649300414285', 'RE1DD2', '3', '957032439716', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('973489068422', 'YZ6KO7', '3', '430661164482', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('928919284437', 'NE4RW6', '3', '843955864404', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('222463786344', 'LC7XI9', '3', '587464229547', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('530193017587', 'AX3XH5', '3', '220189353923', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('815585137337', 'QF5NM6', '3', '445003929423', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('587450519251', 'BP5ZN0', '3', '260665573547', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('442297174153', 'VE7NK6', '3', '295134364736', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('142936719787', 'QS6JL0', '3', '259920896017', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('931901169161', 'HL6OE3', '3', '162419083545', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('867793107613', 'VE9HD4', '3', '741430151992', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('132665148122', 'ZZ3KK8', '3', '769223717930', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('467927226802', 'FY7YN7', '3', '318832402857', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('999117231639', 'GS8MF3', '3', '746089352731', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('759198234127', 'YS3TA2', '3', '468577721871', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('646777824832', 'FV1SJ5', '4', '371260491044', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('652775517274', 'OD8FV6', '4', '806130121923', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('785418238415', 'KL0WV5', '4', '774989630671', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('296500466726', 'YT7KZ0', '4', '150509228378', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('868212324500', 'SK5QK9', '4', '172374668645', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('124046420782', 'DT9SD5', '4', '907801232948', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('964855356315', 'LR0VQ7', '4', '933234057203', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('980742846926', 'QG0AK8', '4', '328262674792', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('704963888626', 'ZB5OD5', '4', '841682687454', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('430453721631', 'PI8ZD1', '4', '261084200588', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('376132304353', 'FW9IA3', '4', '973408873868', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('881503357279', 'KR8RG0', '4', '878294842928', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('354345801948', 'YQ4MA6', '4', '966621709488', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('691916997562', 'XE7LH2', '4', '203561139409', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('659458811225', 'WS6GP3', '4', '392015460330', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('356626468729', 'NF2UF9', '4', '679162257152', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('429694772805', 'AE2CD6', '4', '827667444188', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('716951464037', 'BT3RN9', '4', '107641374236', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('792501711639', 'FU8FR6', '4', '998569191127', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('393686136440', 'YS0MP7', '4', '750432555990', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('356572383165', 'YM2TA1', '4', '147000504847', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('337863476362', 'SN9EU2', '4', '971332165381', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('709924508144', 'MF9DV5', '4', '601857496728', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('403079953789', 'RC2UV9', '4', '926549471832', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('846958108460', 'AF3DR4', '4', '185985522397', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('156876584980', 'VH4TK8', '5', '302202827631', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('596067397641', 'OZ6JF3', '5', '298272432716', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('132019229924', 'CQ9NN9', '5', '207577322706', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('445480295106', 'BO4BY5', '5', '632454512607', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('270204743515', 'YJ9XI0', '5', '199653002424', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('374525542961', 'ZL7AY7', '5', '684229221952', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('937510267559', 'KY8SW6', '5', '437785294956', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('514531487810', 'BC6OJ1', '5', '544819430528', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('594806515825', 'QH1SX1', '5', '317669172527', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('308021569759', 'IP0WM3', '5', '457213117949', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('245348119726', 'HL4GJ9', '5', '805768715675', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('371844132543', 'ON3KX8', '5', '664317092189', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('713449397622', 'DF5EF0', '5', '354061382498', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('786277752335', 'AS3CL1', '5', '504451253936', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('399059499708', 'FF1IJ4', '5', '789535029093', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('191522806281', 'DS4GI1', '5', '701960570247', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('810947917346', 'OY0LT7', '5', '693897522681', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('490556388647', 'HO9NC7', '5', '965446139948', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('366226452380', 'OC9RB5', '5', '642795041087', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('133475360983', 'FS5JY1', '5', '984773638854', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('579257420663', 'QA5FR8', '5', '283846350978', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('410591980378', 'TN7QG1', '5', '772536939567', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('488658475339', 'VE1PQ7', '5', '256760162370', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('802027928557', 'TV1MR8', '5', '879334963851', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('387881806942', 'LA2DI7', '5', '648534138100', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('857893918553', 'JM6SE3', '6', '785342807166', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('866869699065', 'HD4TY6', '6', '390021761050', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('552931226006', 'BF2IA1', '6', '473407148189', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('190215181143', 'GI8YH9', '6', '726117916587', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('992003656828', 'GQ7RZ9', '6', '714997361643', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('356954188538', 'FQ3PA8', '6', '370962119472', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('182604682933', 'CA2JQ1', '6', '333932767424', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('488710410315', 'AU7ZO1', '6', '142814815975', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('808557873258', 'SB0XY6', '6', '128556721392', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('539883185984', 'XM2QT6', '6', '942727915435', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('158115933012', 'YJ5BB3', '6', '326310748226', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('288801318703', 'AR3XR2', '6', '945874925582', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('226919219507', 'EI2GJ9', '6', '645125928635', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('159649992626', 'SD2PJ4', '6', '132625673917', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('811540065469', 'RU4YL4', '6', '733654590871', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('222750725106', 'TU3KB0', '6', '933688831340', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('329042727783', 'WZ5UE0', '6', '460081588423', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('315709013499', 'CZ1UK9', '6', '799245744506', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('445709970775', 'ZS8KO6', '6', '185092629829', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('587111132339', 'QF2RG0', '6', '612086734183', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('150289425668', 'SY7WK5', '6', '276511446130', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('323381803637', 'OD6VI6', '6', '384537713635', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('478022420339', 'TF8SF4', '6', '260533660905', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('478786438156', 'AX4JR7', '6', '107060275569', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('168800825118', 'AP8HP6', '6', '305031346364', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('931902324574', 'BU6BB3', '7', '770829328166', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('196395037054', 'KA8TU9', '7', '217994403774', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('979053274428', 'CO1CZ8', '7', '244307140758', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('350180946278', 'HH5DE2', '7', '903075418867', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('303866485161', 'HR1AG6', '7', '312614875041', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('462277042140', 'AR0AN5', '7', '437026515078', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('405145650491', 'EK5VZ5', '7', '671463840096', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('731767104872', 'YF3QE3', '7', '159502015807', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('303328846533', 'OX0OX7', '7', '231986540258', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('554996707068', 'PO7ZJ7', '7', '499033473365', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('290238429379', 'EW9BU1', '7', '816265849917', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('759354174900', 'TH2YJ8', '7', '228374455783', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('932330323688', 'PO5WB8', '7', '389930829279', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('197239082502', 'CA2ER4', '7', '263911246445', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('445170526426', 'QZ3PV4', '7', '869751629757', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('801484905883', 'PL3TE2', '7', '704452391342', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('467038411965', 'MU6NH0', '7', '483752157384', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('734484443203', 'HH5ZC4', '7', '355306902007', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('250670079354', 'CU4RC3', '7', '939132184139', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('267181887113', 'TN5AG5', '7', '676258172551', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('657167397452', 'CC6DR3', '7', '570770391644', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('160384380002', 'US0OD7', '7', '743475476997', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('545062611664', 'EH2KO6', '7', '581559418034', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('921045379999', 'QH4PE0', '7', '829850237368', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('960952371037', 'EP8TS7', '7', '430177754974', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('687287434818', 'HL2VT6', '8', '700378128427', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('330018884010', 'TM3IE1', '8', '479596918134', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('262379743927', 'EF2YW5', '8', '683907499097', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('663307312673', 'YP0RC4', '8', '799014571773', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('688437731984', 'CE4WE6', '8', '190606839341', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('621258266248', 'ZZ4FH8', '8', '899017946187', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('189274894532', 'XK3UL7', '8', '799369811759', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('894089402314', 'IB6KS8', '8', '420840242945', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('194954712007', 'QX6YD9', '8', '664942158462', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('115003109897', 'GJ9QL5', '8', '325439086346', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('382890987259', 'ZB8RU5', '8', '764692793635', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('776828312264', 'BN3ND9', '8', '352438233911', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('991718213673', 'RK1KZ1', '8', '276657105161', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('350775605503', 'CC0TY2', '8', '922124073348', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('784413494865', 'CC1SO1', '8', '230134262748', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('170680076762', 'PD5AK9', '8', '206458280011', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('540685652163', 'KG3FZ5', '8', '935776398461', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('218735860374', 'AZ4QY4', '8', '209740220526', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('597883913374', 'WF1JI4', '8', '683186566699', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('543173671967', 'JM7EA6', '8', '265125061865', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('269259256001', 'TC4PB2', '8', '304231210018', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('263326367253', 'JY5VS4', '8', '522919517233', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('769940864067', 'ZD8YN3', '8', '850131811619', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('765132546023', 'LS5BG1', '8', '199433440561', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('135036757316', 'KR1JN1', '8', '555131547468', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('882757727684', 'YX7WW7', '9', '403069128350', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('213099836826', 'VE8VJ2', '9', '592232310023', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('961148382687', 'UP9XU7', '9', '254526260713', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('415893329764', 'MS0BN5', '9', '508444378955', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('929134820727', 'XZ6OP8', '9', '705833330229', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('500091247862', 'GV9ZH2', '9', '539944676870', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('533487066500', 'CM7FH1', '9', '985069232535', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('869114390549', 'SK6MY2', '9', '999096482163', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('691616945282', 'UU2YK8', '9', '581478947596', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('490475271041', 'AA9JO8', '9', '360754673882', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('990995836345', 'CK1OW5', '9', '276334408607', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('240351883631', 'YN8NQ4', '9', '184608958723', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('731086147157', 'DP9ES4', '9', '476592469291', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('775156056977', 'RC1AK5', '9', '379410362813', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('503764150709', 'RE4WI9', '9', '149843027110', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('391069077858', 'DD9WK9', '9', '257477530607', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('501959465681', 'AA6KE5', '9', '349699324970', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('343347031074', 'ZX5VX6', '9', '801100703126', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('200099593507', 'XV3IZ8', '9', '426004588315', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('959532176112', 'KY6AR6', '9', '173088700264', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('809341505074', 'PG3BV0', '9', '418967534050', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('865744372725', 'JN4LY3', '9', '522729864898', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('803385761795', 'YX4WB8', '9', '512730411673', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('536417843558', 'FA1CT3', '9', '572227204768', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('512255902355', 'WW3YC2', '9', '516025128396', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('347735952794', 'XS1YG2', '10', '643441678252', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('310157643935', 'EQ4QX5', '10', '514602378618', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('457936024669', 'CC5NP7', '10', '129012135594', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('150288444640', 'VU9VE3', '10', '523450623482', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('116347131510', 'VN0JM0', '10', '821336829357', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('765392752054', 'IX2VH6', '10', '887127804408', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('587060487370', 'ZX6UD2', '10', '274026111101', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('987800586901', 'CH1VF3', '10', '765672822342', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('663655691880', 'XY9UA8', '10', '923700012332', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('999526962386', 'WF4DO6', '10', '325689985568', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('185079093237', 'RZ9KH0', '10', '849930510072', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('321281709013', 'LO9FA0', '10', '516386055911', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('985838452252', 'BU6QI3', '10', '405482480278', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('690609740118', 'NV5XD2', '10', '685306158418', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('992100865231', 'BA4IB2', '10', '275544326703', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('511532603955', 'RB4GM9', '10', '910932834215', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('619284010531', 'LQ3YU8', '10', '280279660706', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('260992718844', 'IN6ZO5', '10', '488077310542', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('588570901565', 'OS8KJ8', '10', '207939001028', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('630480270191', 'FL1OD9', '10', '465849559932', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('279315085611', 'AE4XE1', '10', '374047037851', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('700200611865', 'ZN6OZ4', '10', '375183930342', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('558916772894', 'OU2TY8', '10', '635610926316', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('650929845589', 'IJ2ZR0', '10', '102756400581', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('298330834911', 'LN7TB4', '10', '328987277297', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('794613048711', 'XQ0FA5', '11', '493259767701', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('734400595422', 'DU3IJ0', '11', '923192631750', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('405935248789', 'VA0UN4', '11', '957792348576', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('874489957948', 'SA6DV0', '11', '130320057105', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('139092136462', 'WG4TM4', '11', '136024895785', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('823101345102', 'FI3ES5', '11', '663476556400', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('872120206394', 'OA1OE1', '11', '451446195146', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('502735185858', 'OH7DV3', '11', '406931771979', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('683505983849', 'RG6ZM3', '11', '402451294104', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('302946269573', 'YU6YW9', '11', '916031128846', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('395164123086', 'AA7NJ7', '11', '675338023609', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('755359480493', 'CK6YI8', '11', '716866658134', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('879541905136', 'QK4QX5', '11', '425053423515', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('825841284451', 'XO4FW3', '11', '266506253523', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('953957194381', 'HB1EM2', '11', '594976747942', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('551404201151', 'DC6QT2', '11', '645099769325', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('616851926257', 'XN4FN7', '11', '103705643890', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('373135584771', 'TZ3MA0', '11', '505291410580', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('174092011576', 'YO1LE4', '11', '135611548844', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('350243125066', 'CE3MV7', '11', '133125586336', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('393850935081', 'SW5YF5', '11', '212249754488', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('429446005130', 'OO5JF1', '11', '254174657664', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('206930103837', 'VK2ND5', '11', '269853191621', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('554914840119', 'QO5EH9', '11', '923142389193', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('358637673063', 'BJ6RQ5', '11', '577016411776', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('194737584350', 'YD1OI6', '12', '243401059014', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('183570752669', 'OD0QK6', '12', '361383046390', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('469725257359', 'PU5CL9', '12', '833286637007', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('158882338787', 'MP2LN4', '12', '395618766916', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('948264000002', 'QQ5ID1', '12', '495699468168', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('885320754249', 'GV2MV5', '12', '813024926888', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('752340820203', 'PH6EA5', '12', '418129643827', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('364090003576', 'HY5XN1', '12', '401843241657', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('414234611044', 'RQ2QZ6', '12', '486334593278', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('343198690517', 'SH1TY3', '12', '754909536596', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('269357236685', 'IN3UZ2', '12', '299024915943', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('868721862443', 'OU4CC3', '12', '336423921567', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('733019124517', 'LI7WH5', '12', '355061452380', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('122122485606', 'JX7KN3', '12', '599196148588', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('604809543998', 'KP6IO8', '12', '699342170370', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('779070956132', 'GR8JS0', '12', '723269172686', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('132328314723', 'OM8OJ3', '12', '799509921430', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('941051652590', 'MV4KJ0', '12', '409565375077', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('823975970915', 'VE3UX7', '12', '391826987704', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('915263081294', 'HP4LC0', '12', '393303541607', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('654013713923', 'IA9LJ1', '12', '733063971604', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('723624762399', 'AP9LT5', '12', '191379608154', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('128282287414', 'JU3KL0', '12', '279067350735', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('546694359692', 'CE1HM8', '12', '718034221496', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('881638357973', 'GI8JG4', '12', '982706930849', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('421448932142', 'GI1KQ5', '13', '443779954453', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('130410651512', 'FJ4CV1', '13', '246466735580', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('306968323880', 'PO0TE3', '13', '811729698168', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('985495357674', 'QN4GR5', '13', '322045746657', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('259963933970', 'NQ3NP4', '13', '524072474465', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('674149292562', 'YT6KX8', '13', '421086145338', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('282624306561', 'JE8DM5', '13', '805899460746', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('117532195170', 'QH7GV3', '13', '744986677244', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('792144988458', 'LH8PH7', '13', '146027300121', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('238287262811', 'IF6GS6', '13', '340420114634', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('715716802260', 'BC6WC4', '13', '751529501416', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('710742072661', 'ZV3LV8', '13', '875699933257', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('569538653161', 'JP1AR9', '13', '691591994642', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('307107127257', 'AY9LU6', '13', '371258961953', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('202985516067', 'PD5LQ2', '13', '314274436742', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('358480164145', 'WX9KZ3', '13', '881346406347', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('178323403376', 'BG4DX8', '13', '474264207408', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('576436778983', 'BX5RV5', '13', '880083693169', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('787852722066', 'CH4TT1', '13', '324730020111', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('671290007421', 'ZO4SV3', '13', '452784325925', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('115362313995', 'UH0ZV9', '13', '641027662554', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('774959974462', 'GM9JB3', '13', '939988876625', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('890217047682', 'WT9FV5', '13', '190249883035', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('953996739262', 'FL4EI3', '13', '162599582043', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('437132517906', 'LB1QL4', '13', '963976634374', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('951113771850', 'JL1MQ8', '14', '565159997963', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('897011986012', 'MJ8OG9', '14', '216417595823', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('153000628774', 'ID2TN4', '14', '863491540958', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('563225169357', 'PU8QP7', '14', '529863560635', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('342179288358', 'LN4EK7', '14', '589385828532', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('492356588072', 'QM7TZ6', '14', '854567648069', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('414001585133', 'UB5OM2', '14', '605073995473', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('778870439315', 'ZI4TN5', '14', '222550017428', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('576904177480', 'YA2WP3', '14', '846633651714', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('113233926752', 'VB9CM3', '14', '714047739324', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('985823277548', 'SH1TS3', '14', '599953047020', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('978630032506', 'ZU0XE1', '14', '977635795160', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('135572012001', 'RN6XW2', '14', '485435021847', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('853755760339', 'KI3VD2', '14', '783990215496', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('105117211389', 'VN6CA0', '14', '875843798258', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('634689744260', 'TK1RP3', '14', '990601574360', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('262893384167', 'KN0LH5', '14', '764939034016', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('443923654273', 'GU0WJ3', '14', '464619640140', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('535559929165', 'XR8CW6', '14', '798872691742', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('878317542431', 'ZG2AT7', '14', '131888913314', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('713339502480', 'DT7LK5', '14', '450862785239', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('669864943886', 'IR3WQ1', '14', '501580228641', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('175438185176', 'DO0PR3', '14', '959133141129', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('781364348643', 'JI6JH8', '14', '983836236902', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('865796212535', 'LI4JY9', '14', '130015502919', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('905857112189', 'SQ3GD0', '15', '423602507442', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('763858680007', 'IT3JL0', '15', '167299490125', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('903242293342', 'BE8BF1', '15', '149106824972', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('951043230694', 'CT6LX2', '15', '170862696244', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('309331364651', 'BF7WP6', '15', '189987710798', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('698474688479', 'TH6VB4', '15', '707796540702', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('287419897883', 'AD0WI6', '15', '261605960961', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('245244443100', 'PA2NF3', '15', '958159755571', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('424400304804', 'ST0DI7', '15', '589422183921', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('765557793233', 'NU3NS2', '15', '979450501005', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('662633784712', 'NF7SM6', '15', '170450296187', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('599510087267', 'UF0YS5', '15', '704061898917', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('623094993176', 'VI1FW0', '15', '441172874397', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('968017782560', 'VI1JH0', '15', '985916710256', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('862578752471', 'SW4NH7', '15', '886560121125', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('171216400812', 'HY0VJ6', '15', '482262964829', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('577917975737', 'SA9CH5', '15', '104179493962', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('853127651451', 'AV8ZC9', '15', '243168117955', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('233915925872', 'OF7AH9', '15', '541641624287', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('573169972391', 'NW3CN7', '15', '793636550631', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('320236914955', 'UJ5XE2', '15', '914066692974', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('358453719801', 'FP4OF7', '15', '676592595463', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('127919884416', 'DD6GK1', '15', '228719603161', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('162069959690', 'MT8LO6', '15', '764374600564', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('530066539020', 'WA3QA1', '15', '532645477174', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('627965453133', 'YY9EA4', '16', '202021790034', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('854621303540', 'EW2VF7', '16', '804586711131', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('283089188078', 'UT3PV0', '16', '936639373849', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('628631865579', 'PH4GN1', '16', '400025703459', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('579509823832', 'OP6UH9', '16', '440001131615', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('454338725035', 'TR8ZI6', '16', '428998919149', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('117151364240', 'VN6DE7', '16', '878136462680', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('257565350709', 'GV9FA8', '16', '389735373652', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('689139419156', 'AJ2BN6', '16', '752940292349', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('238692814503', 'TJ6CX4', '16', '372329060520', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('402020469126', 'ZK8SK1', '16', '808212101025', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('812706612041', 'QB0JG5', '16', '323774827423', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('110842658219', 'EB4ER3', '16', '113077153487', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('624818885097', 'UD7RU9', '16', '403463020682', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('663567028775', 'DI9RQ7', '16', '367589096955', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('724195508740', 'NG1TF2', '16', '188505450326', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('817429930743', 'SY4FF5', '16', '308219994833', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('334195081593', 'QO5GO5', '16', '216659908856', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('737704401895', 'QC6UT1', '16', '848585699781', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('667390189799', 'IT9HT7', '16', '928945511419', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('207278864618', 'XH2HO4', '16', '206884774803', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('759121088821', 'XG1US4', '16', '186698056563', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('965630570379', 'WM7IZ8', '16', '436326180534', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('679027625854', 'KZ4AM4', '16', '290091299917', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('154855707561', 'GA9BW5', '16', '177651855359', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('158128866687', 'PX2CB9', '17', '310347651765', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('475051979036', 'ED4CV0', '17', '913958800262', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('838524393839', 'MF6ZE6', '17', '241118400901', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('429312121566', 'ZF7AZ8', '17', '914425773016', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('538166200014', 'PB3FR5', '17', '350978962723', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('958504962267', 'XI8DQ4', '17', '669269175847', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('306774454056', 'VM5YC3', '17', '312987312327', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('722264646771', 'NN1PE7', '17', '339845622042', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('636369838557', 'PP0ZS9', '17', '935657050194', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('621892733602', 'HV6SG8', '17', '670326241101', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('388216980825', 'TK5KP3', '17', '554474406890', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('872221894068', 'SN2PP0', '17', '871680105097', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('949822132003', 'LI7XK4', '17', '210559956668', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('280981940455', 'YF4FT5', '17', '304408994409', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('718058676890', 'UV5UZ9', '17', '428360413153', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('317209382627', 'EE6BQ6', '17', '926733050246', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('322081704459', 'IO0GO2', '17', '418995690390', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('367929222169', 'HG2ZF3', '17', '950192347902', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('907254829865', 'WL5TC2', '17', '110389763033', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('664832742677', 'UZ7HX7', '17', '533854538464', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('244728985145', 'ZQ4AH4', '17', '259618039621', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('471042672249', 'ZJ7PC2', '17', '911666046868', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('937255854460', 'NR2DR0', '17', '919795966723', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('520764377629', 'ZT4UT0', '17', '134221603957', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('406801909415', 'JJ6VZ5', '17', '553800691470', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('948228857701', 'PB4PQ5', '18', '519349054401', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('912047939306', 'TR8AJ2', '18', '613052191058', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('759030963698', 'IL1QQ3', '18', '575600102152', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('914653139682', 'MI8ZI8', '18', '680210835403', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('312069748330', 'PF6OE8', '18', '101298531821', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('439688408500', 'AN1DP2', '18', '717253160263', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('498924603060', 'GG1UT7', '18', '222120666506', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('417662381531', 'XR7TF6', '18', '839412129071', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('348930513159', 'JR4KA5', '18', '298499645654', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('201448026912', 'CF5BU9', '18', '712683921112', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('880121238583', 'OC9GJ0', '18', '545261384649', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('783602142983', 'XD8XX7', '18', '136081975666', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('699917275135', 'SG9IG3', '18', '403303397556', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('189262199777', 'IM6UW6', '18', '729993127502', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('270537018060', 'NE3QW5', '18', '710855939430', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('437606294891', 'AB4KF2', '18', '365542532592', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('750913583071', 'GG4HV9', '18', '752379148933', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('660246037225', 'IQ4OX6', '18', '767866964951', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('700930943983', 'IZ8LQ5', '18', '412438280015', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('506425180463', 'NI7FY5', '18', '713046704489', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('437487004643', 'GB8OX4', '18', '566450318372', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('535832112776', 'PO1DA2', '18', '516136490559', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('181979080249', 'AN7FT7', '18', '205236975261', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('489113719921', 'VM0WM0', '18', '136634002984', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('343168968638', 'EP4SR6', '18', '258481924250', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('255362879555', 'NA1WR4', '19', '641153913197', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('933983821265', 'MN8GH4', '19', '791914692790', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('957368529080', 'WF5XP1', '19', '690739132776', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('602950841147', 'TD1NJ2', '19', '551296431931', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('887400606125', 'XM9WH9', '19', '148132962680', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('525862613401', 'RV2CE8', '19', '692894146746', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('599284171536', 'HR1BY5', '19', '176738206383', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('851251732741', 'FD6RN8', '19', '648978121666', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('600442206110', 'TT1OE6', '19', '453716766261', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('551372341903', 'MT7PA4', '19', '726663590730', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('980867216005', 'EK8PN6', '19', '950457091189', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('698183041173', 'SA2NB0', '19', '828590806190', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('528201332747', 'KC3DJ8', '19', '931145853882', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('620025765892', 'HV6BR7', '19', '849457978278', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('524766026948', 'MS0HU2', '19', '645143135546', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('443257571023', 'NJ4PO9', '19', '869752894518', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('954801911519', 'VH8HZ8', '19', '337352454362', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('915217125370', 'ME7AC1', '19', '121047216054', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('446600328818', 'FC8UG4', '19', '714617728875', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('130316173414', 'CS4OF4', '19', '439772832509', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('905349102626', 'SW1MA7', '19', '678651389258', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('107072284427', 'KJ7WC9', '19', '947204999528', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('495885986309', 'GS5ZO8', '19', '867174718737', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('786661344049', 'TR6FO7', '19', '576742045215', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('832317437206', 'CF5FH4', '19', '339556067418', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('310626322680', 'TA8XQ9', '20', '786959024473', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('322753088065', 'PK4NA7', '20', '561772551695', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('932405799485', 'PM2IC6', '20', '715693795643', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('423938617047', 'YM0KH6', '20', '716114867039', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('363311217219', 'VK3VA7', '20', '913606150491', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('212420041725', 'DD8RR3', '20', '741468313641', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('465229840380', 'VD6RK5', '20', '294130071845', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('337539004667', 'SW9ER4', '20', '860551775276', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('878163440214', 'NC1LZ0', '20', '601398044491', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('471855763151', 'CE9AH1', '20', '875183697044', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('779910598501', 'CW5CT0', '20', '645699716206', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('582947258503', 'MO8QI6', '20', '321512669223', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('361747703048', 'PN5QI5', '20', '509778440794', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('141486736536', 'CQ0AF8', '20', '589370563933', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('752044057632', 'VO5ED9', '20', '642907618650', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('307326670744', 'YV4FX1', '20', '107019611963', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('854109863963', 'RS5UH0', '20', '136819979587', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('592055466306', 'VI1NO3', '20', '862889811144', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('568144641792', 'KI7KO9', '20', '428291995556', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('118846894755', 'QK8CY2', '20', '175210402456', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('286281877223', 'DL9KX7', '20', '257902008401', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('561126385517', 'XN4RZ1', '20', '464936417796', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('218321571575', 'XN9DC7', '20', '386511685329', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('745750078248', 'DC4OZ2', '20', '713195939696', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('766971528001', 'RP4XB9', '20', '909580032561', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('461772083696', 'WA0KU2', '21', '690215592887', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('209859607934', 'PK0SW8', '21', '207140910637', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('610816721450', 'WE7RH7', '21', '607356468995', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('650003404084', 'SV6XR3', '21', '521365848376', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('154863782367', 'CT2IW4', '21', '699886327005', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('167229622270', 'PI0AX3', '21', '523664328625', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('925595816207', 'UW7KW4', '21', '934989295164', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('822833853355', 'GE9YQ0', '21', '662959198584', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('207424683561', 'EC0AF0', '21', '860176084127', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('982539642689', 'QS9RZ5', '21', '800836524731', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('876823454259', 'ES5JH7', '21', '971283201003', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('615152049449', 'CV9XE1', '21', '491287140247', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('853658658635', 'GY7TT3', '21', '893747144553', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('723465687809', 'CP5HW4', '21', '783003418664', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('978831597516', 'YI6QE8', '21', '601482339783', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('867894979276', 'YC5UX9', '21', '245517595231', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('956921817354', 'BG7VN9', '21', '341812099313', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('192086127462', 'DD4KS3', '21', '796689682487', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('413124335598', 'WR4FG8', '21', '879927312101', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('823683901418', 'JA9EM0', '21', '657867899457', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('673537380990', 'GK9MW5', '21', '418379241731', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('902574050454', 'YJ6KE6', '21', '111960475707', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('996841737488', 'AC7LF6', '21', '495135970134', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('659354979581', 'YF2UR3', '21', '242699143557', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('769365712431', 'FE5FK8', '21', '558409114630', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('480405908599', 'QH7XG4', '22', '686492787709', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('856540658250', 'DY0EH5', '22', '935876364181', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('373919996474', 'VD5JF8', '22', '167653050874', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('736706076819', 'NG2XN5', '22', '191765361721', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('871763212847', 'ZE4IY0', '22', '130495950159', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('480393035680', 'HK2WV8', '22', '893084786475', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('990206999378', 'VT2SF1', '22', '282986902686', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('552647161807', 'UZ1TA0', '22', '470638228259', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('410214805539', 'EU7IY0', '22', '945413813294', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('439464978269', 'BH4OH9', '22', '128997587812', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('776778724924', 'QU8MJ0', '22', '785119924429', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('632038234409', 'BL5QO0', '22', '518803742083', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('480926328727', 'MV7VX4', '22', '135243236106', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('366456884478', 'IY5FO6', '22', '350440359135', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('889452443192', 'RH4YV5', '22', '816019368462', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('749473037120', 'FS7AL3', '22', '381906094020', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('223699584811', 'SQ2XA8', '22', '744666140937', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('642639679123', 'RM2EY7', '22', '123921371493', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('978064645865', 'HC7YQ2', '22', '517637145305', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('597972989716', 'MD6BY7', '22', '189695170901', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('111851786038', 'BM9YV3', '22', '437236982365', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('607142828482', 'WF8ZH0', '22', '442564806084', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('457371803160', 'BY7EN8', '22', '268718594885', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('620623426964', 'XT3DH9', '22', '931023970585', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('462299864188', 'LB1MV9', '22', '179284754966', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('555543198904', 'ER1FG8', '23', '673370860273', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('147753826530', 'BJ3VM8', '23', '316282413427', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('434280106095', 'KJ2MM5', '23', '545633838020', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('686175434432', 'FK9SO7', '23', '663553437995', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('687405036544', 'ZU6TB6', '23', '919579941038', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('113176313013', 'JC1MB4', '23', '812429922123', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('564195572323', 'HZ1KM8', '23', '686500867005', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('104507113839', 'GF5OQ9', '23', '985436151357', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('347727441929', 'QW7QA1', '23', '559801413072', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('802724950572', 'LS3PX5', '23', '763762432467', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('159331674694', 'TR5XK9', '23', '209485922351', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('313411556000', 'XJ5KB3', '23', '265977119189', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('247266556545', 'AN4RN8', '23', '986711043099', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('224227617354', 'IY9HJ4', '23', '703174042938', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('369497418692', 'OG2WJ1', '23', '836961527765', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('965856649167', 'RA2VH1', '23', '572635773372', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('185430086564', 'MV8ZN9', '23', '541388326361', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('182306842452', 'NF6BY2', '23', '886328868653', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('259431694497', 'UZ3HE7', '23', '317861556165', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('868412107186', 'XJ5SA8', '23', '404181987661', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('777020181556', 'MS7NV9', '23', '736452185434', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('402654710861', 'PW1HC6', '23', '734022970910', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('836031363043', 'ZU8GW7', '23', '241040032437', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('511568849722', 'EH7DT0', '23', '303479606899', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('452855093876', 'WT1AH4', '23', '636096799226', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('880370066181', 'PU5QZ4', '24', '635240527933', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('303331137180', 'TU7DR9', '24', '327199667689', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('401833515654', 'LX5OU1', '24', '956719693153', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('877551238903', 'LR2MR2', '24', '787278267783', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('418290408055', 'RE3ZA8', '24', '769769667221', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('731809410981', 'TD9LK0', '24', '874830705219', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('889194879156', 'ZV8GC4', '24', '744894538417', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('933200402776', 'LS6ZC7', '24', '652246103390', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('232592690972', 'DN2GK5', '24', '118189229995', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('595285231803', 'DA0EN7', '24', '791740392205', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('447647871031', 'KA8ZK6', '24', '673136379400', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('932660585943', 'HR3SL0', '24', '732365268990', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('129411001663', 'NP4LJ5', '24', '184821429551', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('117446785127', 'NM3IB3', '24', '638100866396', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('192789065129', 'YK6ID6', '24', '940777191539', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('808817057478', 'VE9SU0', '24', '903736875313', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('959024297965', 'DP9VO6', '24', '212455102579', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('261439311934', 'OV1UI7', '24', '874087351711', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('717415144977', 'MS2TR5', '24', '908697942407', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('546059475911', 'LE0KL1', '24', '763588488778', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('936666996023', 'UM1SL6', '24', '899260739031', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('855309856831', 'YW7GB2', '24', '150252408178', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('537130891577', 'LF8BN1', '24', '324909478494', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('176694330978', 'DS8ZN5', '24', '439283971237', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('616693143332', 'QP7QS4', '24', '464552628800', '25');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('139341658811', 'RB2EZ1', '25', '694638083777', '1');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('441275852225', 'JO3EQ6', '25', '773384598584', '2');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('782415194415', 'IG5OZ6', '25', '933509521853', '3');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('368774865837', 'SU9KW5', '25', '375664043754', '4');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('781144347894', 'TT2TY4', '25', '916051207970', '5');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('801843670728', 'OC3FJ7', '25', '824034095625', '6');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('630619369757', 'XB5LO3', '25', '575911254920', '7');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('869183522647', 'KR3FK3', '25', '196667604075', '8');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('300376991319', 'QT5BV8', '25', '858608715880', '9');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('398216613436', 'MI6YZ3', '25', '989226156177', '10');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('636913717311', 'GL1QH0', '25', '592974853834', '11');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('502403437211', 'ZJ8KS2', '25', '132713121669', '12');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('652892415866', 'IT9HQ6', '25', '660432735173', '13');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('423781213112', 'KB4DB0', '25', '136629210536', '14');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('529004156802', 'PR8GD2', '25', '588800101787', '15');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('292856684576', 'UO3NI8', '25', '155193386904', '16');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('545810192054', 'BP2LH6', '25', '835782902679', '17');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('888521656568', 'LT0OL9', '25', '217822079332', '18');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('962076660716', 'HQ4ZG3', '25', '595481438888', '19');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('726650445119', 'NH2LG9', '25', '606578752964', '20');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('832511295905', 'VO3WK0', '25', '668219397711', '21');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('783372067462', 'PB5PA4', '25', '181851193133', '22');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('572309720062', 'CC1TH0', '25', '293108456055', '23');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('905010593824', 'SN0SO8', '25', '834570806842', '24');
INSERT INTO `Airport_Database`.`Boarding_Pass` (`Barcode_No.`, `PNR_Number`, `Seat`, `Aadhar_card_number`, `Route_ID`) VALUES ('714499275410', 'WW4FB1', '25', '234986661373', '25');


INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('597017778744', '336186692620');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('825120260577', '318763452500');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('724978478770', '782574139282');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('247039067342', '126718861513');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('663269545598', '683148492425');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('807534688685', '638308125943');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('100239888586', '163334419635');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('798814488284', '962649919562');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('975567758635', '946636753889');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('307149114465', '918318833665');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('325792294635', '469285323873');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('211411879254', '155550947675');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('353901328583', '178272962318');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('271635869332', '493578734579');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('285552232478', '702080564028');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('492582304935', '890074283778');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('348683048147', '727922896521');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('341475788962', '145307190338');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('698587688230', '314598792608');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('127697467754', '868368646308');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('375017706981', '891480936192');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('725511621920', '895374202023');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('669231873692', '812576896285');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('956132431062', '389566212364');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('695695008845', '286082233248');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('945658360756', '867629954148');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('955655906844', '868840240943');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('999411077796', '680287147648');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('629110924624', '565143525193');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('928842346923', '940398363227');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('435553478716', '103225949316');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('712710661984', '161746617734');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('145037951285', '819861071100');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('965602770958', '802066871736');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('962151895679', '674402674639');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('523209637972', '524395999648');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('829228543519', '623838053217');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('383138620325', '999572950176');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('798556391687', '863961833114');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('143221517825', '458671727752');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('303761947568', '665582097960');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('394709410216', '435901371196');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('884273309026', '798026813860');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('488475351541', '620627729422');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('991958845875', '730655205007');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('351866314130', '983628308073');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('299145574400', '518853884275');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('574190087785', '694717059759');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('452803856163', '499101143983');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('200336279260', '776640902468');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('971827537308', '222463786344');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('783454086088', '759198234127');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('816629403746', '999117231639');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('503730766718', '132665148122');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('673775266491', '467927226802');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('212378236295', '488609956213');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('833584730806', '530193017587');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('264218105103', '973489068422');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('985962912608', '587450519251');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('535119202142', '530536807760');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('241670476958', '700022661299');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('950068136906', '701337300190');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('482988476118', '928919284437');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('312130011371', '315327129940');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('600351125025', '649300414285');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('871215903740', '931901169161');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('594421667754', '867793107613');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('825929605680', '138674460375');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('161451259426', '340000079103');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('467023470439', '404207905670');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('407817098430', '815585137337');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('964715489546', '173481184682');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('629592471375', '142936719787');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('187900835521', '442297174153');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('914821492910', '480686574197');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('897360777729', '691916997562');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('396544111467', '846958108460');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('420570060780', '403079953789');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('147302935486', '337863476362');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('397845821154', '709924508144');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('838139882709', '704963888626');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('405191933021', '659458811225');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('829632514877', '881503357279');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('422544323462', '429694772805');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('429688624600', '296500466726');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('251243043252', '868212324500');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('724630175545', '964855356315');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('938393203814', '354345801948');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('842898912156', '646777824832');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('704544429591', '376132304353');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('166522992939', '393686136440');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('370933841505', '356572383165');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('954816516348', '430453721631');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('780604360334', '652775517274');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('727366825035', '124046420782');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('868094275997', '356626468729');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('447969311469', '980742846926');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('876918103041', '792501711639');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('168394178669', '716951464037');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('906738217636', '785418238415');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('585302495210', '786277752335');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('885996128776', '387881806942');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('774363869402', '802027928557');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('805823704374', '410591980378');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('162858988393', '488658475339');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('496234826274', '594806515825');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('818216269905', '399059499708');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('299190666075', '371844132543');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('517014653475', '810947917346');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('978537089524', '445480295106');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('995661888683', '270204743515');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('127601600824', '937510267559');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('273599534403', '713449397622');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('272481573623', '156876584980');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('125922472491', '245348119726');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('157850996988', '133475360983');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('412547691931', '579257420663');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('202167970389', '308021569759');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('173953628701', '596067397641');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('582381696576', '374525542961');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('269021898459', '191522806281');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('276521963465', '514531487810');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('603981390066', '366226452380');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('272905788304', '490556388647');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('187534238349', '132019229924');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('802458720836', '159649992626');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('478159764144', '168800825118');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('416623994419', '478786438156');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('750915152072', '323381803637');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('670901091045', '478022420339');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('954446176114', '808557873258');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('631914658091', '811540065469');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('648451383595', '288801318703');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('120487231087', '329042727783');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('114268996228', '190215181143');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('848347517618', '992003656828');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('612286833085', '182604682933');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('102341345106', '226919219507');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('518158465706', '857893918553');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('681428766424', '158115933012');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('933106132646', '587111132339');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('166677624013', '150289425668');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('709098323236', '539883185984');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('166390588599', '866869699065');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('506032247863', '356954188538');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('612829830545', '222750725106');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('454411759851', '488710410315');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('535057996279', '445709970775');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('197406119833', '315709013499');
INSERT INTO `Airport_Database`.`Luggage` (`Baggage_ID`, `Barcode_No.`) VALUES ('881226059835', '552931226006');


INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('336186692620', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('318763452500', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('782574139282', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('126718861513', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('683148492425', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('638308125943', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('163334419635', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('962649919562', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('946636753889', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('918318833665', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('469285323873', 'XL SeatS');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('155550947675', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('178272962318', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('493578734579', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('702080564028', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('890074283778', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('727922896521', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('145307190338', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('314598792608', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('868368646308', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('891480936192', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('895374202023', 'Wheelchair');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('812576896285', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('389566212364', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('286082233248', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('867629954148', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('868840240943', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('680287147648', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('565143525193', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('940398363227', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('103225949316', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('161746617734', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('819861071100', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('802066871736', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('674402674639', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('524395999648', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('623838053217', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('999572950176', 'PRIORITY BOARDING');
INSERT INTO `Airport_Database`.`Boarding_Pass_Special_Services` (`Barcode_No.`, `Special_Services`) VALUES ('863961833114', 'PRIORITY BOARDING');
