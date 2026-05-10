-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: turntable.proxy.rlwy.net    Database: railway
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admin`
--

DROP TABLE IF EXISTS `admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `uq_admin_email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
INSERT INTO `admin` VALUES (1,'Alice','Admin','alice.admin@fitapp.com','adminpass',1),(2,'Brian','Manager','brian.manager@fitapp.com','adminpass',1);
/*!40000 ALTER TABLE `admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `client` (
  `client_id` varchar(50) NOT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `dob` date NOT NULL,
  `weight` decimal(5,2) DEFAULT NULL,
  `height` decimal(5,2) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `coach_id` varchar(50) DEFAULT NULL,
  `subscription` varchar(50) DEFAULT NULL,
  `role` enum('client','coach','admin') DEFAULT 'client',
  `email` varchar(255) NOT NULL,
  `phone_number` varchar(20) DEFAULT NULL,
  `signup_date` date DEFAULT (curdate()),
  `password` varchar(255) NOT NULL,
  `status` varchar(20) DEFAULT 'active',
  PRIMARY KEY (`client_id`),
  UNIQUE KEY `uq_client_email` (`email`),
  KEY `idx_client_coach_id` (`coach_id`),
  CONSTRAINT `fk_client_coach` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`coach_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
INSERT INTO `client` VALUES ('1c453b6c','Maiury','Dos Santos Eleuterio','1993-08-09',70.00,70.00,'Female',NULL,NULL,'client','md789@njit.edu','123456789','2026-05-07','123456789','active'),('32a33897','Carlos','Cabanilla','2002-07-25',170.00,67.00,'Male',NULL,NULL,'client','carloscabanilla09@gmail.com','0000000000','2026-05-10','pass123','active'),('6fbb7010','Carlos','Cabanilla','2002-07-25',190.00,67.00,'Male','cl017',NULL,'client','clc52@njit.edu','0000000000','2026-05-04','pass123','active'),('cl001','Frank','Torres','2001-05-12',175.50,70.00,'Male','cl017','premium','client','frank.torres@fitapp.com','9735551001','2026-03-01','pass123','active'),('cl002','Sarah','Johnson','1998-11-03',135.20,65.00,'Female','cl018','basic','client','sarah.johnson@fitapp.com','9735551002','2026-03-01','pass123','active'),('cl003','Michael','Chen','1995-07-22',182.00,72.50,'Male','cl019','premium','client','michael.chen@fitapp.com','9735551003','2026-03-02','pass123','active'),('cl004','Emily','Garcia','2000-09-14',125.75,64.00,'Female','cl020','basic','client','emily.garcia@fitapp.com','9735551004','2026-03-02','pass123','active'),('cl005','David','Smith','1997-03-30',190.10,73.00,'Male','cl017','premium','client','david.smith@fitapp.com','9735551005','2026-03-03','pass123','active'),('cl006','Olivia','Brown','2002-01-18',118.40,63.00,'Female','cl018','basic','client','olivia.brown@fitapp.com','9735551006','2026-03-03','pass123','active'),('cl007','James','Anderson','1996-04-28',185.30,71.50,'Male','cl019','premium','client','james.anderson@fitapp.com','9735551007','2026-03-04','pass123','active'),('cl008','Ava','Wilson','1999-12-05',130.60,66.00,'Female','cl020','basic','client','ava.wilson@fitapp.com','9735551008','2026-03-04','pass123','disabled'),('cl009','Noah','Taylor','1994-08-17',172.80,69.00,'Male','cl017','premium','client','noah.taylor@fitapp.com','9735551009','2026-03-05','pass123','active'),('cl010','Sophia','Moore','2001-02-09',122.30,64.50,'Female','cl018','basic','client','sophia.moore@fitapp.com','9735551010','2026-03-05','pass123','active'),('cl011','Liam','Jackson','1993-10-11',198.20,74.00,'Male','cl019','premium','client','liam.jackson@fitapp.com','9735551011','2026-03-06','pass123','active'),('cl012','Mia','White','2000-06-21',127.40,65.20,'Female','cl020','premium','client','mia.white@fitapp.com','9735551012','2026-03-06','pass123','active'),('cl013','Ethan','Harris','1998-01-07',188.90,72.00,'Male','cl017','basic','client','ethan.harris@fitapp.com','9735551013','2026-03-07','pass123','active'),('cl014','Charlotte','Martin','2002-07-19',119.50,63.70,'Female','cl018','premium','client','charlotte.martin@fitapp.com','9735551014','2026-03-07','pass123','active'),('cl015','Lucas','Thompson','1997-09-25',181.00,71.20,'Male','cl019','basic','client','lucas.thompson@fitapp.com','9735551015','2026-03-08','pass123','active'),('cl016','Amelia','Davis','1999-03-13',124.80,64.10,'Female',NULL,'premium','client','amelia.davis@fitapp.com','9735551016','2026-03-08','pass123','active'),('cl017','Daniel','Martinez','1994-06-11',205.00,74.00,'Male',NULL,'premium','coach','daniel.martinez@fitapp.com','9735551017','2026-03-09','pass123','active'),('cl018','Mia','Thomas','1999-08-19',120.00,64.50,'Female',NULL,'premium','coach','mia.thomas@fitapp.com','9735551018','2026-03-09','pass123','active'),('cl019','Chris','Walker','1992-12-02',210.40,75.00,'Male','cl017','premium','coach','chris.walker@fitapp.com','9735551019','2026-03-10','pass123','active'),('cl020','Grace','Lee','1996-05-27',126.10,65.80,'Female',NULL,'premium','coach','grace.lee@fitapp.com','9735551020','2026-03-10','pass123','active');
/*!40000 ALTER TABLE `client` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coach`
--

DROP TABLE IF EXISTS `coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach` (
  `coach_id` varchar(50) NOT NULL,
  `pricing` decimal(8,2) DEFAULT NULL,
  `availability` text,
  `status` enum('pending','active','suspended') DEFAULT 'pending',
  PRIMARY KEY (`coach_id`),
  CONSTRAINT `fk_coach_client` FOREIGN KEY (`coach_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach`
--

LOCK TABLES `coach` WRITE;
/*!40000 ALTER TABLE `coach` DISABLE KEYS */;
INSERT INTO `coach` VALUES ('cl017',89.99,'Mon-Fri mornings','active'),('cl018',99.99,'Tue-Sat afternoons','active'),('cl019',109.99,'Mon-Thu evenings','active'),('cl020',94.99,'Weekends + evenings','active');
/*!40000 ALTER TABLE `coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coach_applications`
--

DROP TABLE IF EXISTS `coach_applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach_applications` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `specialty` enum('fitness','nutrition','both') DEFAULT NULL,
  `certifications` text,
  `bio` text,
  `pricing` decimal(8,2) DEFAULT NULL,
  `status` enum('pending','approved','declined') DEFAULT 'pending',
  `submitted_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_by` int DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `availability` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`application_id`),
  KEY `idx_coach_app_client_id` (`client_id`),
  KEY `idx_coach_app_reviewed_by` (`reviewed_by`),
  CONSTRAINT `fk_coach_applications_admin` FOREIGN KEY (`reviewed_by`) REFERENCES `admin` (`admin_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach_applications`
--

LOCK TABLES `coach_applications` WRITE;
/*!40000 ALTER TABLE `coach_applications` DISABLE KEYS */;
INSERT INTO `coach_applications` VALUES (1,'cl009','fitness','ACE Personal Trainer','Interested in beginner strength coaching.',79.99,'pending','2026-03-08 14:00:00',NULL,NULL,NULL),(2,'cl011','both','NASM CPT, Nutrition Cert','Experienced in body recomposition.',95.00,'approved','2026-03-07 14:30:00',1,'2026-03-09 16:00:00',NULL),(3,'cl014','nutrition','Sports Nutrition Course','Focused on sustainable meal planning.',70.00,'declined','2026-03-06 19:15:00',2,'2026-03-08 20:45:00',NULL),(4,'72e8e430','nutrition','asdgfsag','dslkfjogjqwroeijg',100.00,'pending','2026-04-09 20:31:56',NULL,NULL,NULL),(5,'09f8b76e','nutrition','34rg4','tg34tg3',100.00,'pending','2026-04-09 21:07:04',NULL,NULL,NULL),(6,'40f3324c','nutrition','sfdg','dfg',80.00,'pending','2026-04-16 22:43:46',NULL,NULL,NULL),(9,'cl015','fitness','NASM CPT, CrossFit L1','Passionate about functional strength and helping beginners build a real foundation. I believe consistency beats intensity.',84.99,'pending','2026-05-07 14:00:00',NULL,NULL,'Mon-Fri afternoons'),(10,'cl016','nutrition','Precision Nutrition L1, RD Intern','I specialize in sustainable fat loss and helping clients build a healthy, long-term relationship with food. No crash diets.',74.99,'pending','2026-05-08 10:30:00',NULL,NULL,'Weekdays flexible');
/*!40000 ALTER TABLE `coach_applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coach_request`
--

DROP TABLE IF EXISTS `coach_request`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coach_request` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(100) NOT NULL,
  `coach_id` varchar(100) NOT NULL,
  `status` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `coach_request_coach_FK` (`coach_id`),
  KEY `coach_request_client_FK` (`client_id`),
  CONSTRAINT `coach_request_client_FK` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `coach_request_coach_FK` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`coach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach_request`
--

LOCK TABLES `coach_request` WRITE;
/*!40000 ALTER TABLE `coach_request` DISABLE KEYS */;
INSERT INTO `coach_request` VALUES (1,'cl002','cl017','pending'),(2,'cl004','cl019','pending'),(3,'cl006','cl017','accepted'),(4,'cl008','cl019','accepted'),(5,'cl010','cl020','rejected'),(6,'cl012','cl017','pending'),(7,'cl013','cl018','accepted'),(8,'cl015','cl020','rejected'),(9,'cl016','cl019','pending'),(10,'cl001','cl020','accepted'),(13,'cl001','cl018','accepted'),(14,'cl001','cl017','accepted'),(20,'6fbb7010','cl019','pending'),(21,'6fbb7010','cl017','accepted'),(22,'cl019','cl017','accepted'),(23,'cl019','cl017','accepted');
/*!40000 ALTER TABLE `coach_request` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `exercises`
--

DROP TABLE IF EXISTS `exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `exercises` (
  `exercise_id` int NOT NULL AUTO_INCREMENT,
  `exercise_name` varchar(150) NOT NULL,
  `equipment` varchar(100) DEFAULT NULL,
  `muscle_group` varchar(100) DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `example_video` varchar(255) DEFAULT NULL,
  `is_custom` tinyint(1) DEFAULT '0',
  `created_by` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`exercise_id`),
  KEY `idx_exercises_created_by` (`created_by`),
  CONSTRAINT `fk_exercises_created_by` FOREIGN KEY (`created_by`) REFERENCES `client` (`client_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercises`
--

LOCK TABLES `exercises` WRITE;
/*!40000 ALTER TABLE `exercises` DISABLE KEYS */;
INSERT INTO `exercises` VALUES (1,'Barbell Bench Press','Barbell','Chest','Strength','https://example.com/bench',0,NULL),(2,'Dumbbell Shoulder Press','Dumbbell','Shoulders','Strength','https://example.com/press',0,NULL),(3,'Lat Pulldown','Machine','Back','Strength','https://example.com/pulldown',0,NULL),(4,'Goblet Squat','Dumbbell','Legs','Strength','https://example.com/squat',0,NULL),(5,'Romanian Deadlift','Barbell','Hamstrings','Strength','https://example.com/rdl',0,NULL),(6,'Plank','Bodyweight','Core','Core','https://example.com/plank',0,NULL),(7,'Incline Walk','Treadmill','Cardio','Cardio','https://example.com/walk',0,NULL),(8,'Cable Tricep Pushdown','Cable','Arms','Strength','https://example.com/tricep',0,NULL),(9,'Glute Bridge','Bodyweight','Glutes','Strength','https://example.com/glute',1,'cl017'),(10,'Conditioning Circuit','None','Full Body','Conditioning','https://example.com/circuit',1,'cl018'),(11,'Seated Row','Machine','Back','Strength','https://example.com/row',0,NULL),(12,'Walking Lunges','Dumbbell','Legs','Strength','https://example.com/lunges',0,NULL),(13,'Custom','Barbell','Shoulders','Strength','https://www.youtube.com/watch?v=clLfwYp8dSQ',1,'cl001'),(14,'Custom','Barbell','Back','Strength','https://www.youtube.com/watch?v=clLfwYp8dSQ',1,NULL),(15,'Lazy yoga','Bodyweight','Core','Strength','https://www.youtube.com/watch?v=SvPKFsCiMsw',1,'cl006');
/*!40000 ALTER TABLE `exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fitness_coach`
--

DROP TABLE IF EXISTS `fitness_coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fitness_coach` (
  `coach_id` varchar(50) NOT NULL,
  `workout_id` int DEFAULT NULL,
  `certifications` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`coach_id`),
  KEY `fk_fitness_coach_workout` (`workout_id`),
  CONSTRAINT `fitness_coach_coach_FK` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`coach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fitness_coach`
--

LOCK TABLES `fitness_coach` WRITE;
/*!40000 ALTER TABLE `fitness_coach` DISABLE KEYS */;
INSERT INTO `fitness_coach` VALUES ('cl017',1,'NASM CPT'),('cl019',3,'ACE CPT, Sports Nutrition'),('cl020',4,'ISSA CPT');
/*!40000 ALTER TABLE `fitness_coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goals`
--

DROP TABLE IF EXISTS `goals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goals` (
  `goal_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `goal_weight` decimal(5,2) DEFAULT NULL,
  `steps` int DEFAULT NULL,
  `time_active` decimal(4,2) DEFAULT NULL,
  `workout_days_per_week` tinyint DEFAULT NULL,
  PRIMARY KEY (`goal_id`),
  KEY `idx_goals_client_id` (`client_id`),
  CONSTRAINT `fk_goals_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goals`
--

LOCK TABLES `goals` WRITE;
/*!40000 ALTER TABLE `goals` DISABLE KEYS */;
INSERT INTO `goals` VALUES (1,'cl001',168.00,9000,1.50,4),(2,'cl002',128.00,8000,1.00,3),(3,'cl003',175.00,10000,1.25,5),(4,'cl004',120.00,8500,1.00,4),(5,'cl005',185.00,9500,1.75,5),(6,'cl006',115.00,7000,0.75,3),(7,'cl007',178.00,9000,1.50,4),(8,'cl008',125.00,8200,1.00,3),(9,'cl009',168.00,10000,1.25,5),(10,'cl010',118.00,7800,1.00,3),(11,'cl011',190.00,10500,1.75,5),(12,'cl012',122.00,8400,1.25,4),(13,'cl013',180.00,8800,1.50,4),(14,'cl014',116.00,7600,0.75,3),(15,'cl015',176.00,9200,1.25,4),(16,'cl016',120.00,8000,1.00,3),(26,'6fbb7010',170.00,9000,60.00,4),(28,'1c453b6c',90.00,10000,45.00,1),(29,'32a33897',140.00,9000,60.00,5);
/*!40000 ALTER TABLE `goals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `invoice` (
  `invoice_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `amount` decimal(8,2) DEFAULT NULL,
  `billing_month` varchar(20) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`invoice_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `invoice_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=46 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `invoice`
--

LOCK TABLES `invoice` WRITE;
/*!40000 ALTER TABLE `invoice` DISABLE KEYS */;
INSERT INTO `invoice` VALUES (1,'cl001',89.99,'March 2026','2026-03-01 00:00:00'),(2,'cl001',89.99,'April 2026','2026-04-01 00:00:00'),(3,'cl001',89.99,'May 2026','2026-05-01 00:00:00'),(4,'cl002',99.99,'March 2026','2026-03-01 00:00:00'),(5,'cl002',99.99,'April 2026','2026-04-01 00:00:00'),(6,'cl002',99.99,'May 2026','2026-05-01 00:00:00'),(7,'cl003',109.99,'March 2026','2026-03-02 00:00:00'),(8,'cl003',109.99,'April 2026','2026-04-02 00:00:00'),(9,'cl005',89.99,'March 2026','2026-03-03 00:00:00'),(10,'cl005',89.99,'April 2026','2026-04-03 00:00:00'),(11,'cl007',109.99,'March 2026','2026-03-04 00:00:00'),(12,'cl007',109.99,'April 2026','2026-04-04 00:00:00'),(13,'cl009',89.99,'March 2026','2026-03-05 00:00:00'),(14,'cl009',89.99,'April 2026','2026-04-05 00:00:00'),(15,'cl011',109.99,'March 2026','2026-03-06 00:00:00'),(16,'cl011',109.99,'April 2026','2026-04-06 00:00:00'),(17,'6fbb7010',89.99,'May 2026','2026-05-04 00:00:00'),(18,'cl004',94.99,'March 2026','2026-03-02 00:00:00'),(19,'cl004',94.99,'April 2026','2026-03-02 00:00:00'),(20,'cl004',94.99,'May 2026','2026-03-02 00:00:00'),(21,'cl006',99.99,'March 2026','2026-03-03 00:00:00'),(22,'cl006',99.99,'April 2026','2026-03-03 00:00:00'),(23,'cl006',99.99,'May 2026','2026-03-03 00:00:00'),(24,'cl007',109.99,'May 2026','2026-05-01 00:00:00'),(25,'cl008',94.99,'March 2026','2026-03-04 00:00:00'),(26,'cl008',94.99,'April 2026','2026-03-04 00:00:00'),(27,'cl009',89.99,'May 2026','2026-05-01 00:00:00'),(28,'cl010',99.99,'March 2026','2026-03-05 00:00:00'),(29,'cl010',99.99,'April 2026','2026-03-05 00:00:00'),(30,'cl010',99.99,'May 2026','2026-03-05 00:00:00'),(31,'cl011',109.99,'May 2026','2026-05-01 00:00:00'),(32,'cl012',94.99,'March 2026','2026-03-06 00:00:00'),(33,'cl012',94.99,'April 2026','2026-03-06 00:00:00'),(34,'cl012',94.99,'May 2026','2026-03-06 00:00:00'),(35,'cl013',89.99,'March 2026','2026-03-07 00:00:00'),(36,'cl013',89.99,'April 2026','2026-03-07 00:00:00'),(37,'cl013',89.99,'May 2026','2026-03-07 00:00:00'),(38,'cl014',99.99,'March 2026','2026-03-07 00:00:00'),(39,'cl014',99.99,'April 2026','2026-03-07 00:00:00'),(40,'cl014',99.99,'May 2026','2026-03-07 00:00:00'),(41,'cl015',109.99,'March 2026','2026-03-08 00:00:00'),(42,'cl015',109.99,'April 2026','2026-03-08 00:00:00'),(43,'cl015',109.99,'May 2026','2026-03-08 00:00:00'),(44,'cl003',109.99,'May 2026','2026-05-02 00:00:00'),(45,'cl005',89.99,'May 2026','2026-05-03 00:00:00');
/*!40000 ALTER TABLE `invoice` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logging`
--

DROP TABLE IF EXISTS `logging`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `logging` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `log_date` date NOT NULL,
  `steps` int DEFAULT NULL,
  `calories` int DEFAULT NULL,
  PRIMARY KEY (`log_id`),
  KEY `idx_logging_client_id` (`client_id`),
  CONSTRAINT `fk_logging_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=331 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logging`
--

LOCK TABLES `logging` WRITE;
/*!40000 ALTER TABLE `logging` DISABLE KEYS */;
INSERT INTO `logging` VALUES (1,'cl001','2026-03-10',8421,2280),(2,'cl002','2026-03-10',7030,1825),(3,'cl003','2026-03-10',9650,2410),(4,'cl004','2026-03-10',8112,1770),(5,'cl005','2026-03-10',10245,2555),(6,'cl006','2026-03-10',6894,1690),(7,'cl007','2026-03-10',9340,2210),(8,'cl008','2026-03-10',7520,1800),(9,'cl009','2026-03-10',9985,2360),(10,'cl010','2026-03-10',7840,1755),(11,'cl011','2026-03-10',10820,2620),(12,'cl012','2026-03-10',8160,1845),(13,'cl013','2026-03-10',8890,2265),(14,'cl014','2026-03-10',7415,1710),(15,'cl015','2026-03-10',9120,2325),(16,'cl016','2026-03-10',7985,1790),(17,'cl001','2026-04-08',9500,2300),(18,'cl001','2026-04-09',8800,2150),(19,'cl006','2026-05-09',15000,NULL),(20,'cl016','2026-05-09',15000,NULL),(21,'cl001','2026-03-11',8650,2260),(22,'cl001','2026-03-12',7200,2100),(23,'cl001','2026-03-13',9100,2240),(24,'cl001','2026-03-14',8400,2180),(25,'cl001','2026-03-17',8900,2210),(26,'cl001','2026-03-18',7800,2150),(27,'cl001','2026-03-19',9300,2230),(28,'cl001','2026-03-20',8750,2195),(29,'cl001','2026-03-21',10100,2270),(30,'cl001','2026-03-24',8200,2160),(31,'cl001','2026-03-25',9500,2220),(32,'cl001','2026-03-26',8600,2180),(33,'cl001','2026-03-27',7900,2090),(34,'cl001','2026-03-28',9800,2250),(35,'cl001','2026-03-31',8300,2140),(36,'cl001','2026-04-01',9100,2200),(37,'cl001','2026-04-02',8700,2170),(38,'cl001','2026-04-03',9400,2190),(39,'cl001','2026-04-04',10200,2260),(40,'cl001','2026-04-07',8500,2150),(41,'cl001','2026-04-10',9700,2185),(42,'cl001','2026-04-11',8850,2170),(43,'cl001','2026-04-14',9200,2160),(44,'cl001','2026-04-15',8400,2130),(45,'cl001','2026-04-16',9600,2190),(46,'cl001','2026-04-17',8100,2090),(47,'cl001','2026-04-18',10300,2250),(48,'cl001','2026-04-21',8700,2140),(49,'cl001','2026-04-22',9100,2160),(50,'cl001','2026-04-23',8600,2110),(51,'cl001','2026-04-24',9300,2180),(52,'cl001','2026-04-25',10100,2230),(53,'cl001','2026-04-28',8900,2150),(54,'cl001','2026-04-29',9400,2165),(55,'cl001','2026-04-30',8200,2100),(56,'cl001','2026-05-01',9000,2150),(57,'cl001','2026-05-02',9800,2200),(58,'cl001','2026-05-05',8700,2130),(59,'cl001','2026-05-06',9500,2160),(60,'cl001','2026-05-08',10200,2200),(61,'cl001','2026-05-09',9100,2155),(62,'6fbb7010','2026-05-05',7500,2100),(63,'6fbb7010','2026-05-06',8200,2050),(64,'6fbb7010','2026-05-07',9100,2200),(65,'6fbb7010','2026-05-08',8600,2150),(66,'6fbb7010','2026-05-09',9300,2180),(67,'cl002','2026-03-13',8619,1607),(68,'cl002','2026-03-16',6102,1929),(69,'cl002','2026-03-20',7126,1675),(70,'cl002','2026-03-23',6914,1621),(71,'cl002','2026-03-27',6419,1896),(72,'cl002','2026-04-03',8233,1594),(73,'cl002','2026-04-10',8418,1766),(74,'cl002','2026-04-17',6130,1565),(75,'cl002','2026-04-24',6383,1661),(76,'cl002','2026-05-01',6952,1808),(77,'cl002','2026-05-04',8465,1563),(78,'cl002','2026-05-07',8298,1651),(79,'cl003','2026-03-13',11232,2482),(80,'cl003','2026-03-16',11172,2429),(81,'cl003','2026-03-20',10018,2262),(82,'cl003','2026-03-23',10139,2451),(83,'cl003','2026-03-27',9439,2564),(84,'cl003','2026-04-03',8326,2538),(85,'cl003','2026-04-10',8953,2507),(86,'cl003','2026-04-17',10031,2324),(87,'cl003','2026-04-24',9438,2229),(88,'cl003','2026-05-01',9181,2640),(89,'cl003','2026-05-04',9678,2202),(90,'cl003','2026-05-07',8679,2344),(91,'cl004','2026-03-13',7096,1683),(92,'cl004','2026-03-16',8108,1809),(93,'cl004','2026-03-20',7783,1913),(94,'cl004','2026-03-23',6877,1873),(95,'cl004','2026-03-27',8581,1774),(96,'cl004','2026-04-03',7211,1998),(97,'cl004','2026-04-10',8250,1540),(98,'cl004','2026-04-17',8961,1650),(99,'cl004','2026-04-24',9274,1816),(100,'cl004','2026-05-01',8181,1795),(101,'cl004','2026-05-04',7487,1860),(102,'cl004','2026-05-07',6984,1523),(103,'cl005','2026-03-13',11708,2416),(104,'cl005','2026-03-16',10185,2340),(105,'cl005','2026-03-20',9953,2743),(106,'cl005','2026-03-23',9413,2494),(107,'cl005','2026-03-27',10138,2532),(108,'cl005','2026-04-03',11603,2727),(109,'cl005','2026-04-10',10494,2383),(110,'cl005','2026-04-17',10516,2481),(111,'cl005','2026-04-24',9858,2643),(112,'cl005','2026-05-01',10093,2659),(113,'cl005','2026-05-04',11799,2631),(114,'cl005','2026-05-07',9292,2611),(115,'cl006','2026-03-13',8100,1517),(116,'cl006','2026-03-16',7687,1803),(117,'cl006','2026-03-20',6502,1513),(118,'cl006','2026-03-23',7393,1624),(119,'cl006','2026-03-27',6605,1903),(120,'cl006','2026-04-03',8121,1782),(121,'cl006','2026-04-10',7781,1542),(122,'cl006','2026-04-17',8304,1596),(123,'cl006','2026-04-24',5729,1547),(124,'cl006','2026-05-01',5631,1842),(125,'cl006','2026-05-04',6792,1635),(126,'cl006','2026-05-07',6596,1463),(127,'cl007','2026-03-13',8864,2417),(128,'cl007','2026-03-16',10323,2398),(129,'cl007','2026-03-20',10940,2111),(130,'cl007','2026-03-23',8870,2285),(131,'cl007','2026-03-27',10044,2152),(132,'cl007','2026-04-03',10633,2184),(133,'cl007','2026-04-10',8585,2085),(134,'cl007','2026-04-17',8571,2076),(135,'cl007','2026-04-24',10299,2225),(136,'cl007','2026-05-01',9076,2332),(137,'cl007','2026-05-04',10394,2169),(138,'cl007','2026-05-07',10390,2154),(139,'cl008','2026-03-13',7782,1662),(140,'cl008','2026-03-16',6866,1810),(141,'cl008','2026-03-20',8321,1596),(142,'cl008','2026-03-23',6492,1990),(143,'cl008','2026-03-27',6749,1628),(144,'cl008','2026-04-03',8870,1631),(145,'cl008','2026-04-10',9087,1766),(146,'cl008','2026-04-17',8742,1582),(147,'cl008','2026-04-24',7876,1745),(148,'cl008','2026-05-01',8740,1789),(149,'cl008','2026-05-04',8467,1678),(150,'cl008','2026-05-07',8566,1990),(151,'cl009','2026-03-13',8547,2448),(152,'cl009','2026-03-16',11452,2158),(153,'cl009','2026-03-20',11292,2553),(154,'cl009','2026-03-23',10699,2484),(155,'cl009','2026-03-27',9592,2493),(156,'cl009','2026-04-03',11125,2274),(157,'cl009','2026-04-10',8956,2250),(158,'cl009','2026-04-17',10280,2180),(159,'cl009','2026-04-24',10358,2101),(160,'cl009','2026-05-01',11457,2548),(161,'cl009','2026-05-04',11447,2234),(162,'cl009','2026-05-07',10550,2490),(163,'cl010','2026-03-13',7131,1759),(164,'cl010','2026-03-16',6835,1945),(165,'cl010','2026-03-20',8961,1652),(166,'cl010','2026-03-23',9017,1759),(167,'cl010','2026-03-27',8894,1601),(168,'cl010','2026-04-03',7026,1691),(169,'cl010','2026-04-10',7061,1776),(170,'cl010','2026-04-17',8572,1970),(171,'cl010','2026-04-24',6402,1806),(172,'cl010','2026-05-01',7727,1750),(173,'cl010','2026-05-04',6479,1557),(174,'cl010','2026-05-07',7886,1949),(175,'cl011','2026-03-13',10759,2492),(176,'cl011','2026-03-16',9737,2493),(177,'cl011','2026-03-20',11823,2854),(178,'cl011','2026-03-23',9822,2413),(179,'cl011','2026-03-27',12497,2618),(180,'cl011','2026-04-03',9783,2870),(181,'cl011','2026-04-10',11681,2762),(182,'cl011','2026-04-17',10015,2435),(183,'cl011','2026-04-24',12202,2613),(184,'cl011','2026-05-01',11751,2454),(185,'cl011','2026-05-04',10585,2640),(186,'cl011','2026-05-07',11984,2586),(187,'cl012','2026-03-13',7567,2065),(188,'cl012','2026-03-16',8908,1976),(189,'cl012','2026-03-20',9689,1943),(190,'cl012','2026-03-23',7523,1955),(191,'cl012','2026-03-27',7976,1794),(192,'cl012','2026-04-03',9451,1922),(193,'cl012','2026-04-10',8229,1814),(194,'cl012','2026-04-17',8819,1821),(195,'cl012','2026-04-24',7195,1716),(196,'cl012','2026-05-01',7620,1622),(197,'cl012','2026-05-04',8084,1600),(198,'cl012','2026-05-07',9109,1873),(199,'cl013','2026-03-13',8442,2311),(200,'cl013','2026-03-16',8402,2013),(201,'cl013','2026-03-20',7790,2372),(202,'cl013','2026-03-23',10084,2040),(203,'cl013','2026-03-27',8437,2044),(204,'cl013','2026-04-03',7628,2450),(205,'cl013','2026-04-10',8853,2046),(206,'cl013','2026-04-17',9605,2131),(207,'cl013','2026-04-24',8640,2352),(208,'cl013','2026-05-01',9488,2119),(209,'cl013','2026-05-04',9708,2077),(210,'cl013','2026-05-07',10462,2488),(211,'cl014','2026-03-13',8338,1745),(212,'cl014','2026-03-16',7936,1574),(213,'cl014','2026-03-20',7937,1863),(214,'cl014','2026-03-23',7667,1547),(215,'cl014','2026-03-27',6386,1499),(216,'cl014','2026-04-03',8699,1670),(217,'cl014','2026-04-10',7451,1666),(218,'cl014','2026-04-17',7683,1689),(219,'cl014','2026-04-24',8986,1477),(220,'cl014','2026-05-01',8758,1784),(221,'cl014','2026-05-04',8646,1500),(222,'cl014','2026-05-07',6248,1656),(223,'cl015','2026-03-13',10682,2243),(224,'cl015','2026-03-16',8147,2197),(225,'cl015','2026-03-20',8484,2167),(226,'cl015','2026-03-23',9896,2299),(227,'cl015','2026-03-27',8274,2286),(228,'cl015','2026-04-03',8451,2212),(229,'cl015','2026-04-10',9594,2197),(230,'cl015','2026-04-17',8008,2296),(231,'cl015','2026-04-24',9954,2120),(232,'cl015','2026-05-01',7907,2403),(233,'cl015','2026-05-04',9914,2498),(234,'cl015','2026-05-07',7760,2566),(235,'cl016','2026-03-13',6982,2014),(236,'cl016','2026-03-16',7568,1625),(237,'cl016','2026-03-20',8264,1788),(238,'cl016','2026-03-23',8571,1649),(239,'cl016','2026-03-27',8242,2002),(240,'cl016','2026-04-03',6840,1624),(241,'cl016','2026-04-10',8152,1541),(242,'cl016','2026-04-17',8199,1675),(243,'cl016','2026-04-24',8463,1686),(244,'cl016','2026-05-01',8332,1896),(245,'cl016','2026-05-04',9592,1941),(246,'cl016','2026-05-07',8876,1878),(247,'6fbb7010','2026-03-13',9942,2099),(248,'6fbb7010','2026-03-16',7634,1947),(249,'6fbb7010','2026-03-20',8215,1961),(250,'6fbb7010','2026-03-23',7239,2146),(251,'6fbb7010','2026-03-27',9220,1881),(252,'6fbb7010','2026-04-03',8284,1879),(253,'6fbb7010','2026-04-10',7205,2149),(254,'6fbb7010','2026-04-17',8952,2107),(255,'6fbb7010','2026-04-24',9175,1930),(256,'6fbb7010','2026-05-01',7232,2341),(257,'6fbb7010','2026-05-04',9080,1891),(258,'1c453b6c','2026-03-13',8261,1685),(259,'1c453b6c','2026-03-16',9937,1684),(260,'1c453b6c','2026-03-20',10265,2091),(261,'1c453b6c','2026-03-23',8463,1856),(262,'1c453b6c','2026-03-27',7991,2132),(263,'1c453b6c','2026-04-03',9833,1776),(264,'1c453b6c','2026-04-10',9871,1954),(265,'1c453b6c','2026-04-17',7662,1967),(266,'1c453b6c','2026-04-24',7835,1864),(267,'1c453b6c','2026-05-01',10192,1948),(268,'1c453b6c','2026-05-04',9815,1917),(269,'1c453b6c','2026-05-07',8795,2128),(270,'32a33897','2026-03-13',9068,2054),(271,'32a33897','2026-03-16',10743,2316),(272,'32a33897','2026-03-20',9286,2072),(273,'32a33897','2026-03-23',9087,2152),(274,'32a33897','2026-03-27',8536,2293),(275,'32a33897','2026-04-03',10643,2103),(276,'32a33897','2026-04-10',9872,2111),(277,'32a33897','2026-04-17',8297,1954),(278,'32a33897','2026-04-24',9877,2268),(279,'32a33897','2026-05-01',10306,2001),(280,'32a33897','2026-05-04',8300,2225),(281,'32a33897','2026-05-07',8873,2209),(282,'cl017','2026-03-13',10586,2617),(283,'cl017','2026-03-16',10929,3001),(284,'cl017','2026-03-20',9781,3000),(285,'cl017','2026-03-23',10500,2739),(286,'cl017','2026-03-27',10667,2630),(287,'cl017','2026-04-03',11294,2976),(288,'cl017','2026-04-10',11725,2910),(289,'cl017','2026-04-17',10739,2863),(290,'cl017','2026-04-24',12178,2820),(291,'cl017','2026-05-01',9532,2891),(292,'cl017','2026-05-04',11771,2703),(293,'cl017','2026-05-07',12217,2603),(294,'cl018','2026-03-13',7550,1785),(295,'cl018','2026-03-16',7472,2105),(296,'cl018','2026-03-20',7438,2030),(297,'cl018','2026-03-23',9266,1729),(298,'cl018','2026-03-27',8115,1794),(299,'cl018','2026-04-03',9477,1757),(300,'cl018','2026-04-10',9939,1825),(301,'cl018','2026-04-17',7833,2001),(302,'cl018','2026-04-24',9597,2086),(303,'cl018','2026-05-01',8081,1908),(304,'cl018','2026-05-04',9001,1778),(305,'cl018','2026-05-07',7208,1697),(306,'cl019','2026-03-13',13098,2866),(307,'cl019','2026-03-16',11633,2672),(308,'cl019','2026-03-20',10514,2820),(309,'cl019','2026-03-23',11035,2976),(310,'cl019','2026-03-27',11572,2732),(311,'cl019','2026-04-03',12309,2932),(312,'cl019','2026-04-10',13390,2868),(313,'cl019','2026-04-17',12797,2654),(314,'cl019','2026-04-24',10958,2688),(315,'cl019','2026-05-01',13330,3112),(316,'cl019','2026-05-04',11110,2929),(317,'cl019','2026-05-07',10647,3077),(318,'cl020','2026-03-13',9012,2148),(319,'cl020','2026-03-16',9763,1925),(320,'cl020','2026-03-20',9260,1915),(321,'cl020','2026-03-23',7671,2007),(322,'cl020','2026-03-27',8993,2310),(323,'cl020','2026-04-03',7663,2310),(324,'cl020','2026-04-10',8965,1957),(325,'cl020','2026-04-17',10293,1977),(326,'cl020','2026-04-24',10231,1902),(327,'cl020','2026-05-01',8948,2249),(328,'cl020','2026-05-04',9793,2302),(329,'cl020','2026-05-07',9164,2348),(330,'cl019','2026-05-10',20000,NULL);
/*!40000 ALTER TABLE `logging` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meal_log`
--

DROP TABLE IF EXISTS `meal_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meal_log` (
  `meal_log_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `meal_id` int DEFAULT NULL,
  `log_date` date NOT NULL,
  `actual_calories` int DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`meal_log_id`),
  KEY `idx_meal_log_client_id` (`client_id`),
  KEY `idx_meal_log_meal_id` (`meal_id`),
  CONSTRAINT `fk_meal_log_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_meal_log_meal` FOREIGN KEY (`meal_id`) REFERENCES `meals` (`meal_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=213 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meal_log`
--

LOCK TABLES `meal_log` WRITE;
/*!40000 ALTER TABLE `meal_log` DISABLE KEYS */;
INSERT INTO `meal_log` VALUES (1,'cl001',1,'2026-03-10',510,'Finished everything.','2026-03-10 12:20:00'),(2,'cl001',2,'2026-03-10',700,'Extra rice portion.','2026-03-10 17:15:00'),(3,'cl002',3,'2026-03-10',360,'Skipped granola.','2026-03-10 12:40:00'),(4,'cl002',4,'2026-03-10',500,'No dressing.','2026-03-10 16:50:00'),(5,'cl003',5,'2026-03-10',455,'As planned.','2026-03-10 16:20:00'),(6,'cl004',6,'2026-03-10',330,'Post workout shake.','2026-03-10 11:45:00'),(7,'cl005',7,'2026-03-10',735,'Large dinner.','2026-03-10 22:40:00'),(8,'cl006',8,'2026-03-10',400,'Used less avocado.','2026-03-10 13:25:00'),(9,'cl007',9,'2026-03-10',500,'Good breakfast.','2026-03-10 12:10:00'),(10,'cl008',10,'2026-03-10',420,'Light lunch.','2026-03-10 17:20:00'),(11,'cl001',NULL,'2026-04-09',1500,'34rg45tg4','2026-04-09 21:09:43'),(13,'cl006',14,'2026-05-09',200,'Followed Plan: Chicken Soup','2026-05-09 16:41:48'),(14,'cl001',1,'2026-03-12',520,'On plan, ate breakfast on time.','2026-03-12 08:30:00'),(15,'cl001',2,'2026-03-12',680,'Full chicken rice portion.','2026-03-12 13:15:00'),(16,'cl001',1,'2026-03-17',510,'Protein breakfast before morning workout.','2026-03-17 07:45:00'),(17,'cl001',2,'2026-03-17',700,'Lunch after the lift.','2026-03-17 13:00:00'),(18,'cl001',1,'2026-03-24',520,'Stuck to the plan today.','2026-03-24 08:00:00'),(19,'cl001',2,'2026-03-24',650,'Slightly less rice this time.','2026-03-24 13:30:00'),(20,'cl001',1,'2026-04-08',520,'Back on track after the weekend.','2026-04-08 08:00:00'),(21,'cl001',2,'2026-04-08',680,'Good lunch, full macros hit.','2026-04-08 13:00:00'),(22,'cl001',1,'2026-04-21',510,'Consistent morning routine.','2026-04-21 07:50:00'),(23,'cl001',2,'2026-04-21',680,'Chicken rice as usual.','2026-04-21 13:00:00'),(24,'cl001',1,'2026-05-05',520,'First meal of the week, on track.','2026-05-05 08:00:00'),(25,'cl001',2,'2026-05-05',660,'Lunch, slightly smaller rice portion.','2026-05-05 12:45:00'),(26,'cl001',1,'2026-05-08',520,'Great morning fuel before the workout.','2026-05-08 08:00:00'),(27,'cl001',2,'2026-05-08',680,'Post-workout lunch.','2026-05-08 13:30:00'),(28,'cl001',1,'2026-03-16',347,'Clean eating day.','2026-03-16 12:00:00'),(29,'cl001',2,'2026-03-23',334,'Clean eating day.','2026-03-23 12:00:00'),(30,'cl001',2,'2026-03-30',331,'On track today.','2026-03-30 12:00:00'),(31,'cl001',1,'2026-04-06',498,'On track today.','2026-04-06 12:00:00'),(32,'cl001',2,'2026-04-13',324,'Ate out but made a smart choice.','2026-04-13 12:00:00'),(33,'cl001',1,'2026-04-20',487,'Meal prepped, easy to stick to.','2026-04-20 12:00:00'),(34,'cl001',2,'2026-04-27',461,'On track today.','2026-04-27 12:00:00'),(35,'cl001',2,'2026-05-04',508,'Clean eating day.','2026-05-04 12:00:00'),(36,'cl002',3,'2026-03-16',462,'Hit my macros.','2026-03-16 12:00:00'),(37,'cl002',4,'2026-03-23',410,'Slightly over on carbs but fine.','2026-03-23 12:00:00'),(38,'cl002',3,'2026-03-30',331,'Hit my macros.','2026-03-30 12:00:00'),(39,'cl002',3,'2026-04-06',482,'Ate out but made a smart choice.','2026-04-06 12:00:00'),(40,'cl002',3,'2026-04-13',372,'Exactly as planned.','2026-04-13 12:00:00'),(41,'cl002',4,'2026-04-20',399,'Exactly as planned.','2026-04-20 12:00:00'),(42,'cl002',3,'2026-04-27',436,'On track today.','2026-04-27 12:00:00'),(43,'cl002',3,'2026-05-04',359,'Good energy from this.','2026-05-04 12:00:00'),(44,'cl003',5,'2026-03-16',414,'Good energy from this.','2026-03-16 12:00:00'),(45,'cl003',5,'2026-03-23',490,'On track today.','2026-03-23 12:00:00'),(46,'cl003',5,'2026-03-30',361,'On track today.','2026-03-30 12:00:00'),(47,'cl003',5,'2026-04-06',399,'Exactly as planned.','2026-04-06 12:00:00'),(48,'cl003',5,'2026-04-13',312,'Exactly as planned.','2026-04-13 12:00:00'),(49,'cl003',5,'2026-04-20',476,'Hit my macros.','2026-04-20 12:00:00'),(50,'cl003',5,'2026-04-27',408,'Followed the plan.','2026-04-27 12:00:00'),(51,'cl003',5,'2026-05-04',412,'Hit my macros.','2026-05-04 12:00:00'),(52,'cl004',6,'2026-03-16',322,'Hit my macros.','2026-03-16 12:00:00'),(53,'cl004',6,'2026-03-23',519,'Slightly over on carbs but fine.','2026-03-23 12:00:00'),(54,'cl004',6,'2026-03-30',520,'Exactly as planned.','2026-03-30 12:00:00'),(55,'cl004',6,'2026-04-06',496,'On track today.','2026-04-06 12:00:00'),(56,'cl004',6,'2026-04-13',330,'Exactly as planned.','2026-04-13 12:00:00'),(57,'cl004',6,'2026-04-20',312,'Clean eating day.','2026-04-20 12:00:00'),(58,'cl004',6,'2026-04-27',408,'Hit my macros.','2026-04-27 12:00:00'),(59,'cl004',6,'2026-05-04',323,'Meal prepped, easy to stick to.','2026-05-04 12:00:00'),(60,'cl005',7,'2026-03-16',491,'Followed the plan.','2026-03-16 12:00:00'),(61,'cl005',7,'2026-03-23',291,'Clean eating day.','2026-03-23 12:00:00'),(62,'cl005',7,'2026-03-30',476,'Good energy from this.','2026-03-30 12:00:00'),(63,'cl005',7,'2026-04-06',407,'Exactly as planned.','2026-04-06 12:00:00'),(64,'cl005',7,'2026-04-13',444,'Clean eating day.','2026-04-13 12:00:00'),(65,'cl005',7,'2026-04-20',342,'Good energy from this.','2026-04-20 12:00:00'),(66,'cl005',7,'2026-04-27',396,'On track today.','2026-04-27 12:00:00'),(67,'cl005',7,'2026-05-04',320,'Ate out but made a smart choice.','2026-05-04 12:00:00'),(68,'cl006',14,'2026-03-16',403,'Ate out but made a smart choice.','2026-03-16 12:00:00'),(69,'cl006',8,'2026-03-23',367,'Hit my macros.','2026-03-23 12:00:00'),(70,'cl006',14,'2026-03-30',500,'Meal prepped, easy to stick to.','2026-03-30 12:00:00'),(71,'cl006',14,'2026-04-06',382,'Hit my macros.','2026-04-06 12:00:00'),(72,'cl006',14,'2026-04-13',411,'Exactly as planned.','2026-04-13 12:00:00'),(73,'cl006',8,'2026-04-20',361,'Slightly over on carbs but fine.','2026-04-20 12:00:00'),(74,'cl006',14,'2026-04-27',311,'Clean eating day.','2026-04-27 12:00:00'),(75,'cl006',14,'2026-05-04',343,'Hit my macros.','2026-05-04 12:00:00'),(76,'cl007',9,'2026-03-16',292,'Clean eating day.','2026-03-16 12:00:00'),(77,'cl007',9,'2026-03-23',501,'Good energy from this.','2026-03-23 12:00:00'),(78,'cl007',9,'2026-03-30',501,'Hit my macros.','2026-03-30 12:00:00'),(79,'cl007',9,'2026-04-06',519,'Meal prepped, easy to stick to.','2026-04-06 12:00:00'),(80,'cl007',9,'2026-04-13',475,'Hit my macros.','2026-04-13 12:00:00'),(81,'cl007',9,'2026-04-20',411,'Ate out but made a smart choice.','2026-04-20 12:00:00'),(82,'cl007',9,'2026-04-27',505,'Clean eating day.','2026-04-27 12:00:00'),(83,'cl007',9,'2026-05-04',285,'On track today.','2026-05-04 12:00:00'),(84,'cl008',10,'2026-03-16',409,'Ate out but made a smart choice.','2026-03-16 12:00:00'),(85,'cl008',10,'2026-03-23',335,'Meal prepped, easy to stick to.','2026-03-23 12:00:00'),(86,'cl008',10,'2026-03-30',292,'Clean eating day.','2026-03-30 12:00:00'),(87,'cl008',10,'2026-04-06',432,'Ate out but made a smart choice.','2026-04-06 12:00:00'),(88,'cl008',10,'2026-04-13',417,'Followed the plan.','2026-04-13 12:00:00'),(89,'cl008',10,'2026-04-20',390,'Hit my macros.','2026-04-20 12:00:00'),(90,'cl008',10,'2026-04-27',466,'Meal prepped, easy to stick to.','2026-04-27 12:00:00'),(91,'cl008',10,'2026-05-04',373,'Followed the plan.','2026-05-04 12:00:00'),(92,'cl009',11,'2026-03-16',293,'Exactly as planned.','2026-03-16 12:00:00'),(93,'cl009',11,'2026-03-23',372,'Exactly as planned.','2026-03-23 12:00:00'),(94,'cl009',11,'2026-03-30',298,'Good energy from this.','2026-03-30 12:00:00'),(95,'cl009',11,'2026-04-06',475,'Exactly as planned.','2026-04-06 12:00:00'),(96,'cl009',11,'2026-04-13',491,'On track today.','2026-04-13 12:00:00'),(97,'cl009',11,'2026-04-20',304,'Good energy from this.','2026-04-20 12:00:00'),(98,'cl009',11,'2026-04-27',483,'Meal prepped, easy to stick to.','2026-04-27 12:00:00'),(99,'cl009',11,'2026-05-04',473,'Hit my macros.','2026-05-04 12:00:00'),(100,'cl010',12,'2026-03-16',434,'Exactly as planned.','2026-03-16 12:00:00'),(101,'cl010',12,'2026-03-23',408,'Followed the plan.','2026-03-23 12:00:00'),(102,'cl010',12,'2026-03-30',289,'Hit my macros.','2026-03-30 12:00:00'),(103,'cl010',12,'2026-04-06',485,'Ate out but made a smart choice.','2026-04-06 12:00:00'),(104,'cl010',12,'2026-04-13',318,'Exactly as planned.','2026-04-13 12:00:00'),(105,'cl010',12,'2026-04-20',363,'Meal prepped, easy to stick to.','2026-04-20 12:00:00'),(106,'cl010',12,'2026-04-27',380,'Clean eating day.','2026-04-27 12:00:00'),(107,'cl010',12,'2026-05-04',409,'Exactly as planned.','2026-05-04 12:00:00'),(108,'cl011',20,'2026-03-16',405,'Clean eating day.','2026-03-16 12:00:00'),(109,'cl011',19,'2026-03-23',488,'Followed the plan.','2026-03-23 12:00:00'),(110,'cl011',19,'2026-03-30',364,'On track today.','2026-03-30 12:00:00'),(111,'cl011',19,'2026-04-06',429,'Clean eating day.','2026-04-06 12:00:00'),(112,'cl011',20,'2026-04-13',503,'Followed the plan.','2026-04-13 12:00:00'),(113,'cl011',20,'2026-04-20',401,'Clean eating day.','2026-04-20 12:00:00'),(114,'cl011',20,'2026-04-27',480,'Slightly over on carbs but fine.','2026-04-27 12:00:00'),(115,'cl011',20,'2026-05-04',293,'Ate out but made a smart choice.','2026-05-04 12:00:00'),(116,'cl012',21,'2026-03-16',414,'Good energy from this.','2026-03-16 12:00:00'),(117,'cl012',21,'2026-03-23',490,'Slightly over on carbs but fine.','2026-03-23 12:00:00'),(118,'cl012',21,'2026-03-30',426,'On track today.','2026-03-30 12:00:00'),(119,'cl012',21,'2026-04-06',284,'Ate out but made a smart choice.','2026-04-06 12:00:00'),(120,'cl012',22,'2026-04-13',387,'Hit my macros.','2026-04-13 12:00:00'),(121,'cl012',22,'2026-04-20',456,'Slightly over on carbs but fine.','2026-04-20 12:00:00'),(122,'cl012',22,'2026-04-27',408,'Ate out but made a smart choice.','2026-04-27 12:00:00'),(123,'cl012',21,'2026-05-04',460,'Hit my macros.','2026-05-04 12:00:00'),(124,'cl013',23,'2026-03-16',423,'Meal prepped, easy to stick to.','2026-03-16 12:00:00'),(125,'cl013',24,'2026-03-23',414,'Good energy from this.','2026-03-23 12:00:00'),(126,'cl013',24,'2026-03-30',324,'Ate out but made a smart choice.','2026-03-30 12:00:00'),(127,'cl013',24,'2026-04-06',419,'Meal prepped, easy to stick to.','2026-04-06 12:00:00'),(128,'cl013',24,'2026-04-13',436,'Ate out but made a smart choice.','2026-04-13 12:00:00'),(129,'cl013',23,'2026-04-20',343,'Clean eating day.','2026-04-20 12:00:00'),(130,'cl013',24,'2026-04-27',337,'Clean eating day.','2026-04-27 12:00:00'),(131,'cl013',24,'2026-05-04',460,'Slightly over on carbs but fine.','2026-05-04 12:00:00'),(132,'cl014',26,'2026-03-16',361,'Ate out but made a smart choice.','2026-03-16 12:00:00'),(133,'cl014',26,'2026-03-23',423,'Clean eating day.','2026-03-23 12:00:00'),(134,'cl014',26,'2026-03-30',311,'Exactly as planned.','2026-03-30 12:00:00'),(135,'cl014',26,'2026-04-06',509,'Good energy from this.','2026-04-06 12:00:00'),(136,'cl014',26,'2026-04-13',477,'Hit my macros.','2026-04-13 12:00:00'),(137,'cl014',26,'2026-04-20',290,'Clean eating day.','2026-04-20 12:00:00'),(138,'cl014',25,'2026-04-27',368,'Ate out but made a smart choice.','2026-04-27 12:00:00'),(139,'cl014',26,'2026-05-04',471,'Ate out but made a smart choice.','2026-05-04 12:00:00'),(140,'cl015',27,'2026-03-16',331,'Exactly as planned.','2026-03-16 12:00:00'),(141,'cl015',28,'2026-03-23',518,'Exactly as planned.','2026-03-23 12:00:00'),(142,'cl015',28,'2026-03-30',315,'On track today.','2026-03-30 12:00:00'),(143,'cl015',27,'2026-04-06',342,'Followed the plan.','2026-04-06 12:00:00'),(144,'cl015',27,'2026-04-13',443,'Slightly over on carbs but fine.','2026-04-13 12:00:00'),(145,'cl015',27,'2026-04-20',305,'Good energy from this.','2026-04-20 12:00:00'),(146,'cl015',28,'2026-04-27',463,'Ate out but made a smart choice.','2026-04-27 12:00:00'),(147,'cl015',27,'2026-05-04',454,'Hit my macros.','2026-05-04 12:00:00'),(148,'cl016',29,'2026-03-16',420,'Hit my macros.','2026-03-16 12:00:00'),(149,'cl016',30,'2026-03-23',447,'Ate out but made a smart choice.','2026-03-23 12:00:00'),(150,'cl016',30,'2026-03-30',446,'Slightly over on carbs but fine.','2026-03-30 12:00:00'),(151,'cl016',30,'2026-04-06',362,'Clean eating day.','2026-04-06 12:00:00'),(152,'cl016',29,'2026-04-13',512,'On track today.','2026-04-13 12:00:00'),(153,'cl016',29,'2026-04-20',416,'Followed the plan.','2026-04-20 12:00:00'),(154,'cl016',29,'2026-04-27',386,'Hit my macros.','2026-04-27 12:00:00'),(155,'cl016',29,'2026-05-04',494,'Good energy from this.','2026-05-04 12:00:00'),(156,'6fbb7010',32,'2026-03-16',327,'Clean eating day.','2026-03-16 12:00:00'),(157,'6fbb7010',31,'2026-03-23',282,'Clean eating day.','2026-03-23 12:00:00'),(158,'6fbb7010',31,'2026-03-30',517,'Meal prepped, easy to stick to.','2026-03-30 12:00:00'),(159,'6fbb7010',32,'2026-04-06',396,'Exactly as planned.','2026-04-06 12:00:00'),(160,'6fbb7010',32,'2026-04-13',507,'Hit my macros.','2026-04-13 12:00:00'),(161,'6fbb7010',32,'2026-04-20',349,'Slightly over on carbs but fine.','2026-04-20 12:00:00'),(162,'6fbb7010',31,'2026-04-27',364,'Hit my macros.','2026-04-27 12:00:00'),(163,'6fbb7010',32,'2026-05-04',445,'Clean eating day.','2026-05-04 12:00:00'),(164,'1c453b6c',33,'2026-03-16',283,'Meal prepped, easy to stick to.','2026-03-16 12:00:00'),(165,'1c453b6c',34,'2026-03-23',425,'Slightly over on carbs but fine.','2026-03-23 12:00:00'),(166,'1c453b6c',33,'2026-03-30',436,'Good energy from this.','2026-03-30 12:00:00'),(167,'1c453b6c',34,'2026-04-06',411,'Meal prepped, easy to stick to.','2026-04-06 12:00:00'),(168,'1c453b6c',33,'2026-04-13',382,'On track today.','2026-04-13 12:00:00'),(169,'1c453b6c',33,'2026-04-20',315,'Ate out but made a smart choice.','2026-04-20 12:00:00'),(170,'1c453b6c',34,'2026-04-27',519,'Slightly over on carbs but fine.','2026-04-27 12:00:00'),(171,'1c453b6c',33,'2026-05-04',346,'Good energy from this.','2026-05-04 12:00:00'),(172,'32a33897',35,'2026-03-16',394,'Clean eating day.','2026-03-16 12:00:00'),(173,'32a33897',36,'2026-03-23',357,'Followed the plan.','2026-03-23 12:00:00'),(174,'32a33897',36,'2026-03-30',447,'Meal prepped, easy to stick to.','2026-03-30 12:00:00'),(175,'32a33897',35,'2026-04-06',295,'On track today.','2026-04-06 12:00:00'),(176,'32a33897',36,'2026-04-13',358,'Hit my macros.','2026-04-13 12:00:00'),(177,'32a33897',36,'2026-04-20',455,'Exactly as planned.','2026-04-20 12:00:00'),(178,'32a33897',36,'2026-04-27',456,'On track today.','2026-04-27 12:00:00'),(179,'32a33897',36,'2026-05-04',374,'Slightly over on carbs but fine.','2026-05-04 12:00:00'),(180,'cl017',37,'2026-03-16',314,'Ate out but made a smart choice.','2026-03-16 12:00:00'),(181,'cl017',37,'2026-03-23',396,'Meal prepped, easy to stick to.','2026-03-23 12:00:00'),(182,'cl017',38,'2026-03-30',459,'Exactly as planned.','2026-03-30 12:00:00'),(183,'cl017',38,'2026-04-06',473,'Exactly as planned.','2026-04-06 12:00:00'),(184,'cl017',37,'2026-04-13',475,'Slightly over on carbs but fine.','2026-04-13 12:00:00'),(185,'cl017',37,'2026-04-20',414,'Ate out but made a smart choice.','2026-04-20 12:00:00'),(186,'cl017',38,'2026-04-27',299,'On track today.','2026-04-27 12:00:00'),(187,'cl017',37,'2026-05-04',492,'Exactly as planned.','2026-05-04 12:00:00'),(188,'cl018',NULL,'2026-03-16',409,'Slightly over on carbs but fine.','2026-03-16 12:00:00'),(189,'cl018',NULL,'2026-03-23',426,'Exactly as planned.','2026-03-23 12:00:00'),(190,'cl018',NULL,'2026-03-30',318,'Hit my macros.','2026-03-30 12:00:00'),(191,'cl018',NULL,'2026-04-06',363,'Exactly as planned.','2026-04-06 12:00:00'),(192,'cl018',NULL,'2026-04-13',393,'On track today.','2026-04-13 12:00:00'),(193,'cl018',NULL,'2026-04-20',454,'Slightly over on carbs but fine.','2026-04-20 12:00:00'),(194,'cl018',NULL,'2026-04-27',463,'Ate out but made a smart choice.','2026-04-27 12:00:00'),(195,'cl018',NULL,'2026-05-04',303,'Exactly as planned.','2026-05-04 12:00:00'),(196,'cl019',40,'2026-03-16',487,'Followed the plan.','2026-03-16 12:00:00'),(197,'cl019',40,'2026-03-23',313,'Exactly as planned.','2026-03-23 12:00:00'),(198,'cl019',40,'2026-03-30',396,'Followed the plan.','2026-03-30 12:00:00'),(199,'cl019',40,'2026-04-06',452,'Clean eating day.','2026-04-06 12:00:00'),(200,'cl019',39,'2026-04-13',381,'Clean eating day.','2026-04-13 12:00:00'),(201,'cl019',39,'2026-04-20',470,'Slightly over on carbs but fine.','2026-04-20 12:00:00'),(202,'cl019',39,'2026-04-27',291,'Good energy from this.','2026-04-27 12:00:00'),(203,'cl019',40,'2026-05-04',459,'On track today.','2026-05-04 12:00:00'),(204,'cl020',41,'2026-03-16',519,'On track today.','2026-03-16 12:00:00'),(205,'cl020',42,'2026-03-23',288,'Clean eating day.','2026-03-23 12:00:00'),(206,'cl020',42,'2026-03-30',326,'Hit my macros.','2026-03-30 12:00:00'),(207,'cl020',42,'2026-04-06',375,'Good energy from this.','2026-04-06 12:00:00'),(208,'cl020',42,'2026-04-13',502,'Good energy from this.','2026-04-13 12:00:00'),(209,'cl020',42,'2026-04-20',300,'Exactly as planned.','2026-04-20 12:00:00'),(210,'cl020',41,'2026-04-27',447,'Meal prepped, easy to stick to.','2026-04-27 12:00:00'),(211,'cl020',41,'2026-05-04',325,'Exactly as planned.','2026-05-04 12:00:00');
/*!40000 ALTER TABLE `meal_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `meals`
--

DROP TABLE IF EXISTS `meals`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `meals` (
  `meal_id` int NOT NULL AUTO_INCREMENT,
  `nutrition_plan_id` int NOT NULL,
  `meal_name` varchar(150) DEFAULT NULL,
  `description` text,
  `calories` int DEFAULT NULL,
  `protein` decimal(5,2) DEFAULT NULL,
  `carbs` decimal(5,2) DEFAULT NULL,
  `fats` decimal(5,2) DEFAULT NULL,
  `time_of_day` time DEFAULT NULL,
  `day_number` int DEFAULT NULL,
  PRIMARY KEY (`meal_id`),
  KEY `idx_meals_nutrition_plan_id` (`nutrition_plan_id`),
  CONSTRAINT `fk_meals_nutrition_plan` FOREIGN KEY (`nutrition_plan_id`) REFERENCES `nutrition_plan` (`nutrition_plan_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meals`
--

LOCK TABLES `meals` WRITE;
/*!40000 ALTER TABLE `meals` DISABLE KEYS */;
INSERT INTO `meals` VALUES (1,1,'Protein Breakfast','Eggs, oats, fruit',520,35.00,48.00,18.00,'08:00:00',1),(2,1,'Chicken Rice Lunch','Chicken breast with rice',680,48.00,72.00,14.00,'13:00:00',1),(3,2,'Greek Yogurt Bowl','Yogurt, berries, granola',380,24.00,42.00,10.00,'08:30:00',1),(4,2,'Salmon Salad','Salmon with mixed greens',510,38.00,22.00,26.00,'12:30:00',1),(5,3,'Turkey Wrap','Turkey, tortilla, veggies',450,32.00,40.00,14.00,'12:00:00',1),(6,4,'Protein Smoothie','Whey, banana, almond milk',330,30.00,28.00,8.00,'07:30:00',1),(7,5,'Beef Pasta Bowl','Lean beef and pasta',710,46.00,76.00,18.00,'18:00:00',1),(8,6,'Avocado Toast','Toast, avocado, eggs',410,18.00,30.00,22.00,'09:00:00',1),(9,7,'Oatmeal Bowl','Oats, peanut butter, fruit',490,20.00,58.00,16.00,'08:00:00',1),(10,8,'Chicken Salad','Chicken with greens',430,36.00,18.00,20.00,'13:00:00',1),(11,9,'Rice and Steak','Steak with jasmine rice',690,44.00,70.00,16.00,'18:30:00',1),(12,10,'Cottage Cheese Bowl','Cottage cheese and fruit',320,26.00,24.00,8.00,'08:15:00',1),(14,13,'Chicken Soup','Chicken, Noodles, low salt',200,10.00,20.00,7.00,'12:00:00',1),(15,6,'Aspargus Risotto','Aspargus Risotto, 150 g',450,25.00,45.00,7.00,'12:00:00',7),(16,6,'Chicken Salad','Chicken Salad, mixed green, grilled chicken',300,25.00,12.00,10.00,'17:30:00',6),(17,6,'Greek Yogurt and Granola','Greek Yogurt and Granola, no sugar',250,27.00,30.00,9.00,'17:50:00',7),(18,11,'Protein Oats','Oats, whey protein, banana',450,34.00,55.00,12.00,'07:30:00',1),(19,11,'Grilled Chicken Bowl','Chicken, sweet potato, greens',580,48.00,62.00,12.00,'13:00:00',1),(20,11,'Beef Stir Fry','Lean beef, rice, mixed veg',650,45.00,70.00,15.00,'19:00:00',1),(21,12,'Smoothie Bowl','Acai, banana, granola, berries',360,18.00,52.00,12.00,'08:00:00',1),(22,12,'Turkey Sandwich','Turkey, whole grain bread, avocado',420,30.00,40.00,16.00,'12:30:00',1),(23,18,'Egg and Oat Breakfast','Scrambled eggs, oats, OJ',520,36.00,52.00,16.00,'08:00:00',1),(24,18,'Chicken Rice Bowl','Grilled chicken, jasmine rice, broccoli',660,46.00,68.00,14.00,'13:00:00',1),(25,19,'Greek Yogurt Parfait','Greek yogurt, berries, seeds',310,22.00,32.00,8.00,'08:00:00',1),(26,19,'Tuna Salad Bowl','Tuna, mixed greens, olive oil, lemon',390,38.00,10.00,20.00,'12:30:00',1),(27,20,'Overnight Oats','Oats, milk, chia seeds, honey',480,26.00,68.00,14.00,'07:30:00',1),(28,20,'Salmon and Quinoa','Grilled salmon, quinoa, asparagus',600,44.00,56.00,18.00,'13:00:00',1),(29,21,'Avocado Toast','Whole grain toast, avocado, poached egg',420,18.00,32.00,22.00,'08:30:00',1),(30,21,'Chicken Soup','Lean chicken, veg broth, noodles',310,26.00,28.00,8.00,'12:00:00',1),(31,22,'Protein Pancakes','Protein powder, oats, banana pancakes',490,32.00,58.00,14.00,'08:00:00',1),(32,22,'Chicken Rice Broccoli','Grilled chicken, white rice, broccoli',680,48.00,72.00,14.00,'13:00:00',1),(33,23,'Veggie Omelette','Eggs, peppers, onion, spinach',340,24.00,16.00,18.00,'08:00:00',1),(34,23,'Lentil Soup','Red lentils, tomato, cumin, bread',380,20.00,52.00,8.00,'12:30:00',1),(35,24,'Egg White Omelette','Egg whites, spinach, mushrooms',280,26.00,10.00,14.00,'08:00:00',1),(36,24,'Turkey Veggie Bowl','Ground turkey, zucchini, tomato, quinoa',390,34.00,24.00,14.00,'12:30:00',1),(37,25,'Pre-Workout Shake','Whey, oats, peanut butter, milk',520,38.00,55.00,16.00,'07:00:00',1),(38,25,'Steak and Rice','Sirloin, white rice, green beans',720,52.00,70.00,18.00,'13:00:00',1),(39,26,'Power Breakfast','Eggs, turkey bacon, whole grain toast',510,40.00,38.00,18.00,'07:30:00',1),(40,26,'Performance Lunch','Grilled chicken, brown rice, mixed veg',640,50.00,68.00,14.00,'12:30:00',1),(41,27,'Yogurt and Fruit','Greek yogurt, mixed fruit, granola',350,20.00,46.00,10.00,'08:00:00',1),(42,27,'Quinoa Power Bowl','Quinoa, roasted veg, hummus, feta',460,22.00,54.00,18.00,'13:00:00',1);
/*!40000 ALTER TABLE `meals` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `sender_id` varchar(50) NOT NULL,
  `receiver_id` varchar(50) NOT NULL,
  `content` text NOT NULL,
  `sent_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_read` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`message_id`),
  KEY `idx_messages_sender_id` (`sender_id`),
  KEY `idx_messages_receiver_id` (`receiver_id`),
  CONSTRAINT `fk_messages_receiver` FOREIGN KEY (`receiver_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_messages_sender` FOREIGN KEY (`sender_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=85 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'cl001','cl017','Hey coach, can we adjust my workout?','2026-03-10 14:00:00',1),(2,'cl017','cl001','Sure, let us reduce volume this week.','2026-03-10 14:15:00',1),(3,'cl002','cl018','Can I swap salmon for chicken?','2026-03-10 15:00:00',1),(4,'cl018','cl002','Yes, just keep protein about the same.','2026-03-10 15:05:00',0),(5,'cl011','cl019','Can we add another leg day?','2026-03-10 19:10:00',1),(6,'cl020','cl016','Reminder: focus on form this session.','2026-03-10 22:30:00',0),(7,'cl017','cl001','Hello','2026-04-16 22:10:37',0),(8,'cl001','cl017','Hello','2026-04-16 22:10:46',0),(9,'cl017','cl001','Hello','2026-05-04 00:31:11',0),(10,'cl017','cl001','Hello','2026-05-04 00:31:19',0),(11,'cl017','cl001','Hello','2026-05-04 00:49:56',0),(12,'cl001','cl017','How are you?','2026-05-04 00:50:06',0),(13,'cl001','cl017','Hey Daniel, hit 160 lbs on bench today. Should I push for 165 next week?','2026-03-17 19:05:00',1),(14,'cl017','cl001','Nice work Frank! Yes, try 165 ÔÇö but only if your form stays tight. Do not rush it.','2026-03-17 19:22:00',1),(15,'cl001','cl017','Understood. Also skipped Wednesday, had a long shift at work.','2026-03-17 19:30:00',1),(16,'cl017','cl001','It happens. Just get the Thursday session in and we are still on track.','2026-03-17 19:45:00',1),(17,'cl001','cl017','Weigh in this morning: 174.5 lbs. Down from 175.5. Slow but moving in the right direction.','2026-03-24 08:15:00',1),(18,'cl017','cl001','Good trend. Keep hitting the protein target and the scale will keep dropping. Check in Friday.','2026-03-24 09:00:00',1),(19,'cl001','cl017','Finished the week strong ÔÇö 4 sessions done, plus cardio on Saturday.','2026-03-29 20:10:00',1),(20,'cl017','cl001','That is exactly what I want to see. Sending an updated plan for April on Monday.','2026-03-29 20:30:00',1),(21,'cl001','cl017','Got the new plan. Looks tough but I am ready for it.','2026-04-01 18:00:00',1),(22,'cl017','cl001','You will do great. Hit me up if anything feels off during the lifts.','2026-04-01 18:45:00',1),(23,'cl001','cl017','Benched 165 lbs today ÔÇö 3 sets of 8, felt solid.','2026-04-08 21:00:00',1),(24,'cl017','cl001','Let us go! Try 170 next Monday. You are ahead of schedule.','2026-04-08 21:15:00',1),(25,'cl001','cl017','Weigh in: 173 lbs. Feeling the strongest I have in years.','2026-04-22 07:30:00',1),(26,'cl017','cl001','Solid progress Frank. Dial in sleep this week, that is where the recovery happens.','2026-04-22 08:00:00',1),(27,'cl001','cl017','Quick question ÔÇö should I add a second cardio day this week?','2026-05-05 17:00:00',0),(28,'cl017','cl001','Yeah, add a 20 min zone 2 session on Thursday. Nothing intense, just a brisk walk or light bike.','2026-05-05 17:20:00',0),(29,'cl002','cl018','Mia, tracked macros all week. Protein averaged 130g ÔÇö is that enough?','2026-03-18 12:00:00',1),(30,'cl018','cl002','Great job Sarah! Target 135-140g. Try adding a Greek yogurt after your workout.','2026-03-18 12:30:00',1),(31,'cl002','cl018','Noted! Also had a cheat day Saturday, hope that is okay.','2026-03-21 10:00:00',1),(32,'cl018','cl002','Totally fine. One day does not undo the week. Just get back on track Sunday.','2026-03-21 10:15:00',1),(33,'cl002','cl018','Down 3 lbs this month! The salmon salad has become my favorite meal.','2026-04-01 19:00:00',1),(34,'cl018','cl002','Love to hear it! Let us add a second protein meal option for variety next week.','2026-04-01 19:30:00',1),(35,'cl011','cl019','Chris, want to add a second leg day ÔÇö what do you think?','2026-03-19 18:30:00',1),(36,'cl019','cl011','Good call. Let us add lighter volume legs Wednesday so you are not wrecked for Friday.','2026-03-19 19:00:00',1),(37,'cl011','cl019','Makes sense. Also hit a deadlift PR today ÔÇö 315 lbs!','2026-03-26 20:00:00',1),(38,'cl019','cl011','Beast mode! New PR target is 335 by end of April. Let us build on this.','2026-03-26 20:10:00',1),(39,'cl003','cl019','Chris, feeling great this week. Deadlifts are clicking.','2026-03-20 18:00:00',1),(40,'cl019','cl003','Awesome Michael, let us go heavier next session.','2026-03-20 18:30:00',1),(41,'cl003','cl019','Ready for it. Should I add a rest day before Friday?','2026-04-10 19:00:00',1),(42,'cl019','cl003','Yes, take Thursday off. Show up fresh Friday.','2026-04-10 19:20:00',0),(43,'cl004','cl020','Grace, the plank holds are getting easier!','2026-03-22 10:00:00',1),(44,'cl020','cl004','Love it Emily! Let us go to 75 seconds next week.','2026-03-22 10:15:00',1),(45,'cl004','cl020','Also missed Tuesday. Can I make it up Saturday?','2026-04-15 09:00:00',0),(46,'cl020','cl004','Absolutely, do the same session and log it.','2026-04-15 09:30:00',0),(47,'cl005','cl017','Daniel, hit 225 on deadlift today!','2026-03-25 20:00:00',1),(48,'cl017','cl005','Let us go David! That is a solid number. Keep the form tight.','2026-03-25 20:10:00',1),(49,'cl005','cl017','Will do. Next target is 245 by end of April?','2026-04-12 18:00:00',1),(50,'cl017','cl005','That is the goal. We will get there.','2026-04-12 18:20:00',0),(51,'cl006','cl018','Mia, I tried the avocado toast recipe, loved it!','2026-03-18 11:00:00',1),(52,'cl018','cl006','So glad Olivia! It is one of my favorites. Try adding a soft-boiled egg.','2026-03-18 11:20:00',1),(53,'cl006','cl018','Good call. Also down 2 lbs this week!','2026-04-08 09:00:00',1),(54,'cl018','cl006','Amazing progress! Stay consistent and we will keep the trend going.','2026-04-08 09:30:00',0),(55,'cl007','cl019','Chris, the seated rows are really helping my posture.','2026-03-21 17:00:00',1),(56,'cl019','cl007','Great James, that is exactly the goal. Pull through the elbows.','2026-03-21 17:15:00',1),(57,'cl007','cl019','Planning a hiking trip ÔÇö will that count as cardio?','2026-04-20 12:00:00',0),(58,'cl019','cl007','100 percent. Log the time and elevation if you can.','2026-04-20 12:30:00',0),(59,'cl009','cl017','Hey Daniel, feeling a lot stronger this month.','2026-03-28 19:00:00',1),(60,'cl017','cl009','The data shows it Noah. Your squat numbers are moving up consistently.','2026-03-28 19:20:00',1),(61,'cl009','cl017','Should I add a fifth workout day or stick to four?','2026-04-18 18:00:00',0),(62,'cl017','cl009','Stick to four for now. Recovery is where the gains actually happen.','2026-04-18 18:30:00',0),(63,'cl010','cl018','Mia, is the cottage cheese bowl okay as a pre-sleep snack?','2026-03-20 21:00:00',1),(64,'cl018','cl010','Perfect actually Sophia. Casein protein is great before bed.','2026-03-20 21:10:00',1),(65,'cl010','cl018','Awesome. Also my energy is so much better since starting the plan.','2026-04-05 09:00:00',0),(66,'cl018','cl010','That is what we want to hear! The macro balance is doing its job.','2026-04-05 09:15:00',0),(67,'cl012','cl020','Grace, the walking lunges are killer but I love them.','2026-03-24 16:00:00',1),(68,'cl020','cl012','Ha that is a good sign Mia! Your glutes will thank you later.','2026-03-24 16:20:00',1),(69,'cl012','cl020','Any advice on soreness? Especially after leg day.','2026-04-14 10:00:00',0),(70,'cl020','cl012','Ice bath or contrast shower if you can. And eat enough protein that day.','2026-04-14 10:30:00',0),(71,'cl013','cl017','Daniel, bench finally crossed 185 today.','2026-04-01 21:00:00',1),(72,'cl017','cl013','That is huge Ethan! Took patience but you earned that number.','2026-04-01 21:15:00',1),(73,'cl013','cl017','Feeling great. Want to hit 200 before summer.','2026-04-22 19:00:00',0),(74,'cl017','cl013','At your current rate, that is very doable. Stay consistent.','2026-04-22 19:20:00',0),(75,'cl014','cl018','Mia, can I substitute the Greek yogurt for cottage cheese?','2026-03-19 10:00:00',1),(76,'cl018','cl014','Yes Charlotte, same macros roughly. Just watch the sodium.','2026-03-19 10:10:00',1),(77,'cl014','cl018','Down 5 lbs this month! The plan is really working.','2026-04-16 08:00:00',0),(78,'cl018','cl014','That is fantastic progress! Let us check in on calories next week.','2026-04-16 08:30:00',0),(79,'cl015','cl019','Chris, hit a new squat PR ÔÇö 275 lbs!','2026-04-05 19:00:00',1),(80,'cl019','cl015','Beast Lucas! Technique looked solid in the video you sent.','2026-04-05 19:20:00',1),(81,'cl015','cl019','Next goal is 300 by end of May. Realistic?','2026-04-25 18:00:00',0),(82,'cl019','cl015','With the current trajectory, absolutely. Let us program for it.','2026-04-25 18:30:00',0),(83,'6fbb7010','cl017','Hey Daniel, plan looks great. Starting Monday.','2026-05-09 02:00:00',1),(84,'cl017','6fbb7010','Let us go Carlos! Log everything and message me after the first session.','2026-05-09 08:00:00',0);
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mood_log`
--

DROP TABLE IF EXISTS `mood_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mood_log` (
  `mood_log_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `log_date` date NOT NULL,
  `mood_score` tinyint DEFAULT NULL,
  `mood_label` varchar(50) DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`mood_log_id`),
  KEY `idx_mood_log_client_id` (`client_id`),
  CONSTRAINT `fk_mood_log_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=297 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mood_log`
--

LOCK TABLES `mood_log` WRITE;
/*!40000 ALTER TABLE `mood_log` DISABLE KEYS */;
INSERT INTO `mood_log` VALUES (1,'cl001','2026-03-10',4,'Good','Strong workout today.','2026-03-11 00:00:00'),(2,'cl002','2026-03-10',3,'Okay','A little tired after work.','2026-03-11 00:10:00'),(3,'cl003','2026-03-10',5,'Great','Hit a new PR.','2026-03-11 00:20:00'),(4,'cl004','2026-03-10',2,'Low','Poor sleep last night.','2026-03-11 00:30:00'),(5,'cl005','2026-03-10',4,'Motivated','Meal plan is going well.','2026-03-11 00:40:00'),(6,'cl006','2026-03-10',3,'Neutral','Rest day.','2026-03-11 00:50:00'),(7,'cl016','2026-05-06',7,'All Good','Normal day','2026-05-06 22:10:32'),(8,'cl001','2026-05-07',7,'Good','Good day','2026-05-07 16:08:25'),(9,'cl001','2026-05-09',6,'Tired','Working','2026-05-09 15:46:19'),(10,'cl006','2026-05-09',5,'Tired','Too much work','2026-05-09 17:52:35'),(11,'cl016','2026-05-09',7,'Tired','Too much work','2026-05-09 19:39:01'),(12,'cl001','2026-03-11',4,'Good','Good session today. Bench felt strong.','2026-03-11 21:00:00'),(13,'cl001','2026-03-14',3,'Okay','Long week but held the diet.','2026-03-14 20:30:00'),(14,'cl001','2026-03-17',5,'Great','Best workout of the month so far.','2026-03-17 21:00:00'),(15,'cl001','2026-03-20',4,'Motivated','Down another half pound, trending the right way.','2026-03-20 20:00:00'),(16,'cl001','2026-03-24',3,'Neutral','Tough week at work but stayed on plan.','2026-03-24 21:30:00'),(17,'cl001','2026-03-28',5,'Energized','Saturday cardio outside felt amazing.','2026-03-28 12:00:00'),(18,'cl001','2026-04-01',4,'Good','Starting April strong.','2026-04-01 20:00:00'),(19,'cl001','2026-04-07',3,'Tired','Skipped sleep but still got the workout in.','2026-04-07 22:00:00'),(20,'cl001','2026-04-11',5,'Great','Hit 165 on bench ÔÇö new PR!','2026-04-11 21:00:00'),(21,'cl001','2026-04-15',4,'Good','Midweek check-in felt great.','2026-04-15 19:30:00'),(22,'cl001','2026-04-18',5,'Energized','Weekend sessions always hit different.','2026-04-18 11:30:00'),(23,'cl001','2026-04-22',4,'Motivated','Progress photos are showing real change.','2026-04-22 20:30:00'),(24,'cl001','2026-04-25',3,'Okay','Diet was not perfect this week but workouts were solid.','2026-04-25 21:00:00'),(25,'cl001','2026-04-29',4,'Good','Strong finish to April.','2026-04-29 20:00:00'),(26,'cl001','2026-05-02',5,'Great','Feeling the progress this week, clothes fitting different.','2026-05-02 19:30:00'),(27,'cl001','2026-05-05',4,'Motivated','Coach added cardio, challenge accepted.','2026-05-05 21:00:00'),(28,'cl001','2026-05-08',5,'Energized','Almost at goal weight. Pushing hard these last weeks.','2026-05-08 20:00:00'),(29,'6fbb7010','2026-05-05',4,'Good','Starting the week well.','2026-05-05 20:00:00'),(30,'6fbb7010','2026-05-06',3,'Neutral','Work was hectic, squeezed in a workout anyway.','2026-05-06 21:30:00'),(31,'6fbb7010','2026-05-08',5,'Energized','Great session with the plan Daniel set.','2026-05-08 20:00:00'),(32,'cl002','2026-03-13',7,'Energized','Best workout this month.','2026-03-13 20:00:00'),(33,'cl002','2026-03-16',4,'Good','Feeling the results now.','2026-03-16 20:00:00'),(34,'cl002','2026-03-20',4,'Good','Hard week but staying consistent.','2026-03-20 20:00:00'),(35,'cl002','2026-03-23',4,'Good','Steady progress, love the routine.','2026-03-23 20:00:00'),(36,'cl002','2026-03-27',4,'Good','Feeling the results now.','2026-03-27 20:00:00'),(37,'cl002','2026-04-03',6,'Motivated','Felt great today.','2026-04-03 20:00:00'),(38,'cl002','2026-04-10',4,'Good','Best workout this month.','2026-04-10 20:00:00'),(39,'cl002','2026-04-17',5,'Great','Steady progress, love the routine.','2026-04-17 20:00:00'),(40,'cl002','2026-04-24',6,'Motivated','Steady progress, love the routine.','2026-04-24 20:00:00'),(41,'cl002','2026-05-01',8,'Great','Hard week but staying consistent.','2026-05-01 20:00:00'),(42,'cl002','2026-05-04',8,'Great','Steady progress, love the routine.','2026-05-04 20:00:00'),(43,'cl002','2026-05-07',4,'Good','Nothing special, just got it done.','2026-05-07 20:00:00'),(44,'cl003','2026-03-13',4,'Good','Steady progress, love the routine.','2026-03-13 20:00:00'),(45,'cl003','2026-03-16',8,'Great','Solid day, hit my targets.','2026-03-16 20:00:00'),(46,'cl003','2026-03-20',6,'Motivated','Hard week but staying consistent.','2026-03-20 20:00:00'),(47,'cl003','2026-03-23',3,'Okay','Hard week but staying consistent.','2026-03-23 20:00:00'),(48,'cl003','2026-03-27',6,'Motivated','Motivation is high this week.','2026-03-27 20:00:00'),(49,'cl003','2026-04-03',4,'Good','Hard week but staying consistent.','2026-04-03 20:00:00'),(50,'cl003','2026-04-10',6,'Motivated','Tired but pushed through.','2026-04-10 20:00:00'),(51,'cl003','2026-04-17',5,'Great','Hard week but staying consistent.','2026-04-17 20:00:00'),(52,'cl003','2026-04-24',4,'Good','Motivation is high this week.','2026-04-24 20:00:00'),(53,'cl003','2026-05-01',3,'Okay','A bit sore but still showed up.','2026-05-01 20:00:00'),(54,'cl003','2026-05-04',4,'Good','Lots of energy, crushed it.','2026-05-04 20:00:00'),(55,'cl003','2026-05-07',5,'Great','Nothing special, just got it done.','2026-05-07 20:00:00'),(56,'cl004','2026-03-13',3,'Okay','Steady progress, love the routine.','2026-03-13 20:00:00'),(57,'cl004','2026-03-16',5,'Great','Tired but pushed through.','2026-03-16 20:00:00'),(58,'cl004','2026-03-20',8,'Great','Nutrition was on point.','2026-03-20 20:00:00'),(59,'cl004','2026-03-23',6,'Motivated','A bit sore but still showed up.','2026-03-23 20:00:00'),(60,'cl004','2026-03-27',7,'Energized','Tired but pushed through.','2026-03-27 20:00:00'),(61,'cl004','2026-04-03',3,'Okay','Solid day, hit my targets.','2026-04-03 20:00:00'),(62,'cl004','2026-04-10',5,'Great','Decent session overall.','2026-04-10 20:00:00'),(63,'cl004','2026-04-17',7,'Energized','Nothing special, just got it done.','2026-04-17 20:00:00'),(64,'cl004','2026-04-24',3,'Okay','Solid day, hit my targets.','2026-04-24 20:00:00'),(65,'cl004','2026-05-01',7,'Energized','Lots of energy, crushed it.','2026-05-01 20:00:00'),(66,'cl004','2026-05-04',5,'Great','Best workout this month.','2026-05-04 20:00:00'),(67,'cl004','2026-05-07',5,'Great','Lots of energy, crushed it.','2026-05-07 20:00:00'),(68,'cl005','2026-03-13',7,'Energized','Nutrition was on point.','2026-03-13 20:00:00'),(69,'cl005','2026-03-16',3,'Okay','Lots of energy, crushed it.','2026-03-16 20:00:00'),(70,'cl005','2026-03-20',7,'Energized','Motivation is high this week.','2026-03-20 20:00:00'),(71,'cl005','2026-03-23',5,'Great','Felt great today.','2026-03-23 20:00:00'),(72,'cl005','2026-03-27',8,'Great','Lots of energy, crushed it.','2026-03-27 20:00:00'),(73,'cl005','2026-04-03',3,'Okay','Nutrition was on point.','2026-04-03 20:00:00'),(74,'cl005','2026-04-10',7,'Energized','A bit sore but still showed up.','2026-04-10 20:00:00'),(75,'cl005','2026-04-17',8,'Great','Best workout this month.','2026-04-17 20:00:00'),(76,'cl005','2026-04-24',8,'Great','A bit sore but still showed up.','2026-04-24 20:00:00'),(77,'cl005','2026-05-01',4,'Good','Tired but pushed through.','2026-05-01 20:00:00'),(78,'cl005','2026-05-04',6,'Motivated','Solid day, hit my targets.','2026-05-04 20:00:00'),(79,'cl005','2026-05-07',8,'Great','Feeling the results now.','2026-05-07 20:00:00'),(80,'cl006','2026-03-13',5,'Great','Sleep was good, felt fresh.','2026-03-13 20:00:00'),(81,'cl006','2026-03-16',5,'Great','A bit sore but still showed up.','2026-03-16 20:00:00'),(82,'cl006','2026-03-20',3,'Okay','Best workout this month.','2026-03-20 20:00:00'),(83,'cl006','2026-03-23',5,'Great','Nutrition was on point.','2026-03-23 20:00:00'),(84,'cl006','2026-03-27',5,'Great','A bit sore but still showed up.','2026-03-27 20:00:00'),(85,'cl006','2026-04-03',6,'Motivated','Tired but pushed through.','2026-04-03 20:00:00'),(86,'cl006','2026-04-10',6,'Motivated','Best workout this month.','2026-04-10 20:00:00'),(87,'cl006','2026-04-17',5,'Great','Nutrition was on point.','2026-04-17 20:00:00'),(88,'cl006','2026-04-24',4,'Good','Motivation is high this week.','2026-04-24 20:00:00'),(89,'cl006','2026-05-01',6,'Motivated','A bit sore but still showed up.','2026-05-01 20:00:00'),(90,'cl006','2026-05-04',6,'Motivated','A bit sore but still showed up.','2026-05-04 20:00:00'),(91,'cl006','2026-05-07',8,'Great','Feeling the results now.','2026-05-07 20:00:00'),(92,'cl007','2026-03-13',4,'Good','Sleep was good, felt fresh.','2026-03-13 20:00:00'),(93,'cl007','2026-03-16',7,'Energized','Nothing special, just got it done.','2026-03-16 20:00:00'),(94,'cl007','2026-03-20',6,'Motivated','Nutrition was on point.','2026-03-20 20:00:00'),(95,'cl007','2026-03-23',3,'Okay','Nothing special, just got it done.','2026-03-23 20:00:00'),(96,'cl007','2026-03-27',5,'Great','Motivation is high this week.','2026-03-27 20:00:00'),(97,'cl007','2026-04-03',6,'Motivated','Steady progress, love the routine.','2026-04-03 20:00:00'),(98,'cl007','2026-04-10',7,'Energized','Sleep was good, felt fresh.','2026-04-10 20:00:00'),(99,'cl007','2026-04-17',8,'Great','Tired but pushed through.','2026-04-17 20:00:00'),(100,'cl007','2026-04-24',6,'Motivated','Off day but tomorrow is better.','2026-04-24 20:00:00'),(101,'cl007','2026-05-01',6,'Motivated','A bit sore but still showed up.','2026-05-01 20:00:00'),(102,'cl007','2026-05-04',4,'Good','Nutrition was on point.','2026-05-04 20:00:00'),(103,'cl007','2026-05-07',6,'Motivated','Steady progress, love the routine.','2026-05-07 20:00:00'),(104,'cl008','2026-03-13',8,'Great','Decent session overall.','2026-03-13 20:00:00'),(105,'cl008','2026-03-16',8,'Great','Solid day, hit my targets.','2026-03-16 20:00:00'),(106,'cl008','2026-03-20',5,'Great','Nutrition was on point.','2026-03-20 20:00:00'),(107,'cl008','2026-03-23',8,'Great','A bit sore but still showed up.','2026-03-23 20:00:00'),(108,'cl008','2026-03-27',7,'Energized','Tired but pushed through.','2026-03-27 20:00:00'),(109,'cl008','2026-04-03',3,'Okay','Hard week but staying consistent.','2026-04-03 20:00:00'),(110,'cl008','2026-04-10',4,'Good','A bit sore but still showed up.','2026-04-10 20:00:00'),(111,'cl008','2026-04-17',5,'Great','Motivation is high this week.','2026-04-17 20:00:00'),(112,'cl008','2026-04-24',4,'Good','Decent session overall.','2026-04-24 20:00:00'),(113,'cl008','2026-05-01',3,'Okay','Felt great today.','2026-05-01 20:00:00'),(114,'cl008','2026-05-04',4,'Good','Off day but tomorrow is better.','2026-05-04 20:00:00'),(115,'cl008','2026-05-07',7,'Energized','Hard week but staying consistent.','2026-05-07 20:00:00'),(116,'cl009','2026-03-13',3,'Okay','Off day but tomorrow is better.','2026-03-13 20:00:00'),(117,'cl009','2026-03-16',6,'Motivated','Feeling the results now.','2026-03-16 20:00:00'),(118,'cl009','2026-03-20',8,'Great','Sleep was good, felt fresh.','2026-03-20 20:00:00'),(119,'cl009','2026-03-23',4,'Good','Best workout this month.','2026-03-23 20:00:00'),(120,'cl009','2026-03-27',8,'Great','Lots of energy, crushed it.','2026-03-27 20:00:00'),(121,'cl009','2026-04-03',6,'Motivated','Lots of energy, crushed it.','2026-04-03 20:00:00'),(122,'cl009','2026-04-10',4,'Good','Decent session overall.','2026-04-10 20:00:00'),(123,'cl009','2026-04-17',8,'Great','Best workout this month.','2026-04-17 20:00:00'),(124,'cl009','2026-04-24',3,'Okay','Feeling the results now.','2026-04-24 20:00:00'),(125,'cl009','2026-05-01',3,'Okay','Steady progress, love the routine.','2026-05-01 20:00:00'),(126,'cl009','2026-05-04',6,'Motivated','Motivation is high this week.','2026-05-04 20:00:00'),(127,'cl009','2026-05-07',4,'Good','Steady progress, love the routine.','2026-05-07 20:00:00'),(128,'cl010','2026-03-13',8,'Great','Nutrition was on point.','2026-03-13 20:00:00'),(129,'cl010','2026-03-16',6,'Motivated','Felt great today.','2026-03-16 20:00:00'),(130,'cl010','2026-03-20',7,'Energized','Motivation is high this week.','2026-03-20 20:00:00'),(131,'cl010','2026-03-23',3,'Okay','Off day but tomorrow is better.','2026-03-23 20:00:00'),(132,'cl010','2026-03-27',4,'Good','Steady progress, love the routine.','2026-03-27 20:00:00'),(133,'cl010','2026-04-03',6,'Motivated','A bit sore but still showed up.','2026-04-03 20:00:00'),(134,'cl010','2026-04-10',7,'Energized','Nutrition was on point.','2026-04-10 20:00:00'),(135,'cl010','2026-04-17',7,'Energized','Tired but pushed through.','2026-04-17 20:00:00'),(136,'cl010','2026-04-24',6,'Motivated','Sleep was good, felt fresh.','2026-04-24 20:00:00'),(137,'cl010','2026-05-01',8,'Great','Feeling the results now.','2026-05-01 20:00:00'),(138,'cl010','2026-05-04',7,'Energized','Lots of energy, crushed it.','2026-05-04 20:00:00'),(139,'cl010','2026-05-07',7,'Energized','Off day but tomorrow is better.','2026-05-07 20:00:00'),(140,'cl011','2026-03-13',4,'Good','Best workout this month.','2026-03-13 20:00:00'),(141,'cl011','2026-03-16',6,'Motivated','Off day but tomorrow is better.','2026-03-16 20:00:00'),(142,'cl011','2026-03-20',5,'Great','Steady progress, love the routine.','2026-03-20 20:00:00'),(143,'cl011','2026-03-23',4,'Good','Hard week but staying consistent.','2026-03-23 20:00:00'),(144,'cl011','2026-03-27',8,'Great','Nothing special, just got it done.','2026-03-27 20:00:00'),(145,'cl011','2026-04-03',7,'Energized','Off day but tomorrow is better.','2026-04-03 20:00:00'),(146,'cl011','2026-04-10',8,'Great','Motivation is high this week.','2026-04-10 20:00:00'),(147,'cl011','2026-04-17',5,'Great','Off day but tomorrow is better.','2026-04-17 20:00:00'),(148,'cl011','2026-04-24',3,'Okay','Best workout this month.','2026-04-24 20:00:00'),(149,'cl011','2026-05-01',5,'Great','Motivation is high this week.','2026-05-01 20:00:00'),(150,'cl011','2026-05-04',5,'Great','Tired but pushed through.','2026-05-04 20:00:00'),(151,'cl011','2026-05-07',5,'Great','Feeling the results now.','2026-05-07 20:00:00'),(152,'cl012','2026-03-13',7,'Energized','Solid day, hit my targets.','2026-03-13 20:00:00'),(153,'cl012','2026-03-16',4,'Good','Decent session overall.','2026-03-16 20:00:00'),(154,'cl012','2026-03-20',4,'Good','Lots of energy, crushed it.','2026-03-20 20:00:00'),(155,'cl012','2026-03-23',8,'Great','Decent session overall.','2026-03-23 20:00:00'),(156,'cl012','2026-03-27',8,'Great','Motivation is high this week.','2026-03-27 20:00:00'),(157,'cl012','2026-04-03',3,'Okay','Lots of energy, crushed it.','2026-04-03 20:00:00'),(158,'cl012','2026-04-10',6,'Motivated','Tired but pushed through.','2026-04-10 20:00:00'),(159,'cl012','2026-04-17',7,'Energized','Off day but tomorrow is better.','2026-04-17 20:00:00'),(160,'cl012','2026-04-24',6,'Motivated','Felt great today.','2026-04-24 20:00:00'),(161,'cl012','2026-05-01',4,'Good','Hard week but staying consistent.','2026-05-01 20:00:00'),(162,'cl012','2026-05-04',6,'Motivated','Lots of energy, crushed it.','2026-05-04 20:00:00'),(163,'cl012','2026-05-07',7,'Energized','Best workout this month.','2026-05-07 20:00:00'),(164,'cl013','2026-03-13',3,'Okay','Hard week but staying consistent.','2026-03-13 20:00:00'),(165,'cl013','2026-03-16',7,'Energized','Lots of energy, crushed it.','2026-03-16 20:00:00'),(166,'cl013','2026-03-20',6,'Motivated','Felt great today.','2026-03-20 20:00:00'),(167,'cl013','2026-03-23',5,'Great','Nothing special, just got it done.','2026-03-23 20:00:00'),(168,'cl013','2026-03-27',6,'Motivated','Hard week but staying consistent.','2026-03-27 20:00:00'),(169,'cl013','2026-04-03',6,'Motivated','Nutrition was on point.','2026-04-03 20:00:00'),(170,'cl013','2026-04-10',8,'Great','Best workout this month.','2026-04-10 20:00:00'),(171,'cl013','2026-04-17',7,'Energized','Steady progress, love the routine.','2026-04-17 20:00:00'),(172,'cl013','2026-04-24',7,'Energized','Feeling the results now.','2026-04-24 20:00:00'),(173,'cl013','2026-05-01',4,'Good','Off day but tomorrow is better.','2026-05-01 20:00:00'),(174,'cl013','2026-05-04',4,'Good','Nothing special, just got it done.','2026-05-04 20:00:00'),(175,'cl013','2026-05-07',6,'Motivated','Off day but tomorrow is better.','2026-05-07 20:00:00'),(176,'cl014','2026-03-13',3,'Okay','Lots of energy, crushed it.','2026-03-13 20:00:00'),(177,'cl014','2026-03-16',5,'Great','A bit sore but still showed up.','2026-03-16 20:00:00'),(178,'cl014','2026-03-20',8,'Great','Steady progress, love the routine.','2026-03-20 20:00:00'),(179,'cl014','2026-03-23',6,'Motivated','Best workout this month.','2026-03-23 20:00:00'),(180,'cl014','2026-03-27',4,'Good','Hard week but staying consistent.','2026-03-27 20:00:00'),(181,'cl014','2026-04-03',6,'Motivated','Feeling the results now.','2026-04-03 20:00:00'),(182,'cl014','2026-04-10',4,'Good','Sleep was good, felt fresh.','2026-04-10 20:00:00'),(183,'cl014','2026-04-17',7,'Energized','Felt great today.','2026-04-17 20:00:00'),(184,'cl014','2026-04-24',6,'Motivated','Sleep was good, felt fresh.','2026-04-24 20:00:00'),(185,'cl014','2026-05-01',7,'Energized','A bit sore but still showed up.','2026-05-01 20:00:00'),(186,'cl014','2026-05-04',3,'Okay','Solid day, hit my targets.','2026-05-04 20:00:00'),(187,'cl014','2026-05-07',8,'Great','Lots of energy, crushed it.','2026-05-07 20:00:00'),(188,'cl015','2026-03-13',4,'Good','Hard week but staying consistent.','2026-03-13 20:00:00'),(189,'cl015','2026-03-16',6,'Motivated','Decent session overall.','2026-03-16 20:00:00'),(190,'cl015','2026-03-20',3,'Okay','Nothing special, just got it done.','2026-03-20 20:00:00'),(191,'cl015','2026-03-23',6,'Motivated','Tired but pushed through.','2026-03-23 20:00:00'),(192,'cl015','2026-03-27',4,'Good','Off day but tomorrow is better.','2026-03-27 20:00:00'),(193,'cl015','2026-04-03',5,'Great','Tired but pushed through.','2026-04-03 20:00:00'),(194,'cl015','2026-04-10',6,'Motivated','Nothing special, just got it done.','2026-04-10 20:00:00'),(195,'cl015','2026-04-17',6,'Motivated','Nothing special, just got it done.','2026-04-17 20:00:00'),(196,'cl015','2026-04-24',3,'Okay','Off day but tomorrow is better.','2026-04-24 20:00:00'),(197,'cl015','2026-05-01',3,'Okay','Best workout this month.','2026-05-01 20:00:00'),(198,'cl015','2026-05-04',7,'Energized','Felt great today.','2026-05-04 20:00:00'),(199,'cl015','2026-05-07',5,'Great','Motivation is high this week.','2026-05-07 20:00:00'),(200,'cl016','2026-03-13',8,'Great','Solid day, hit my targets.','2026-03-13 20:00:00'),(201,'cl016','2026-03-16',8,'Great','Felt great today.','2026-03-16 20:00:00'),(202,'cl016','2026-03-20',3,'Okay','Motivation is high this week.','2026-03-20 20:00:00'),(203,'cl016','2026-03-23',4,'Good','Hard week but staying consistent.','2026-03-23 20:00:00'),(204,'cl016','2026-03-27',3,'Okay','Sleep was good, felt fresh.','2026-03-27 20:00:00'),(205,'cl016','2026-04-03',4,'Good','Motivation is high this week.','2026-04-03 20:00:00'),(206,'cl016','2026-04-10',4,'Good','Off day but tomorrow is better.','2026-04-10 20:00:00'),(207,'cl016','2026-04-17',8,'Great','Solid day, hit my targets.','2026-04-17 20:00:00'),(208,'cl016','2026-04-24',7,'Energized','Motivation is high this week.','2026-04-24 20:00:00'),(209,'cl016','2026-05-01',6,'Motivated','Best workout this month.','2026-05-01 20:00:00'),(210,'cl016','2026-05-04',5,'Great','Steady progress, love the routine.','2026-05-04 20:00:00'),(211,'cl016','2026-05-07',5,'Great','Decent session overall.','2026-05-07 20:00:00'),(212,'6fbb7010','2026-03-13',7,'Energized','Sleep was good, felt fresh.','2026-03-13 20:00:00'),(213,'6fbb7010','2026-03-16',8,'Great','Best workout this month.','2026-03-16 20:00:00'),(214,'6fbb7010','2026-03-20',3,'Okay','Steady progress, love the routine.','2026-03-20 20:00:00'),(215,'6fbb7010','2026-03-23',4,'Good','Nothing special, just got it done.','2026-03-23 20:00:00'),(216,'6fbb7010','2026-03-27',3,'Okay','Sleep was good, felt fresh.','2026-03-27 20:00:00'),(217,'6fbb7010','2026-04-03',3,'Okay','Feeling the results now.','2026-04-03 20:00:00'),(218,'6fbb7010','2026-04-10',5,'Great','Sleep was good, felt fresh.','2026-04-10 20:00:00'),(219,'6fbb7010','2026-04-17',8,'Great','Feeling the results now.','2026-04-17 20:00:00'),(220,'6fbb7010','2026-04-24',6,'Motivated','Lots of energy, crushed it.','2026-04-24 20:00:00'),(221,'6fbb7010','2026-05-01',8,'Great','Motivation is high this week.','2026-05-01 20:00:00'),(222,'6fbb7010','2026-05-04',3,'Okay','Sleep was good, felt fresh.','2026-05-04 20:00:00'),(223,'6fbb7010','2026-05-07',8,'Great','Hard week but staying consistent.','2026-05-07 20:00:00'),(224,'1c453b6c','2026-03-13',8,'Great','Motivation is high this week.','2026-03-13 20:00:00'),(225,'1c453b6c','2026-03-16',3,'Okay','Best workout this month.','2026-03-16 20:00:00'),(226,'1c453b6c','2026-03-20',5,'Great','Hard week but staying consistent.','2026-03-20 20:00:00'),(227,'1c453b6c','2026-03-23',8,'Great','Sleep was good, felt fresh.','2026-03-23 20:00:00'),(228,'1c453b6c','2026-03-27',3,'Okay','Steady progress, love the routine.','2026-03-27 20:00:00'),(229,'1c453b6c','2026-04-03',7,'Energized','Steady progress, love the routine.','2026-04-03 20:00:00'),(230,'1c453b6c','2026-04-10',3,'Okay','Tired but pushed through.','2026-04-10 20:00:00'),(231,'1c453b6c','2026-04-17',7,'Energized','Lots of energy, crushed it.','2026-04-17 20:00:00'),(232,'1c453b6c','2026-04-24',8,'Great','Tired but pushed through.','2026-04-24 20:00:00'),(233,'1c453b6c','2026-05-01',3,'Okay','Nutrition was on point.','2026-05-01 20:00:00'),(234,'1c453b6c','2026-05-04',8,'Great','Tired but pushed through.','2026-05-04 20:00:00'),(235,'1c453b6c','2026-05-07',3,'Okay','Hard week but staying consistent.','2026-05-07 20:00:00'),(236,'32a33897','2026-03-13',6,'Motivated','Hard week but staying consistent.','2026-03-13 20:00:00'),(237,'32a33897','2026-03-16',6,'Motivated','Solid day, hit my targets.','2026-03-16 20:00:00'),(238,'32a33897','2026-03-20',6,'Motivated','Tired but pushed through.','2026-03-20 20:00:00'),(239,'32a33897','2026-03-23',8,'Great','Feeling the results now.','2026-03-23 20:00:00'),(240,'32a33897','2026-03-27',6,'Motivated','Best workout this month.','2026-03-27 20:00:00'),(241,'32a33897','2026-04-03',4,'Good','Lots of energy, crushed it.','2026-04-03 20:00:00'),(242,'32a33897','2026-04-10',4,'Good','Best workout this month.','2026-04-10 20:00:00'),(243,'32a33897','2026-04-17',7,'Energized','A bit sore but still showed up.','2026-04-17 20:00:00'),(244,'32a33897','2026-04-24',5,'Great','Sleep was good, felt fresh.','2026-04-24 20:00:00'),(245,'32a33897','2026-05-01',7,'Energized','Steady progress, love the routine.','2026-05-01 20:00:00'),(246,'32a33897','2026-05-04',6,'Motivated','Off day but tomorrow is better.','2026-05-04 20:00:00'),(247,'32a33897','2026-05-07',6,'Motivated','Hard week but staying consistent.','2026-05-07 20:00:00'),(248,'cl017','2026-03-13',8,'Great','Sleep was good, felt fresh.','2026-03-13 20:00:00'),(249,'cl017','2026-03-16',5,'Great','Tired but pushed through.','2026-03-16 20:00:00'),(250,'cl017','2026-03-20',4,'Good','Hard week but staying consistent.','2026-03-20 20:00:00'),(251,'cl017','2026-03-23',3,'Okay','Nothing special, just got it done.','2026-03-23 20:00:00'),(252,'cl017','2026-03-27',6,'Motivated','Motivation is high this week.','2026-03-27 20:00:00'),(253,'cl017','2026-04-03',6,'Motivated','Sleep was good, felt fresh.','2026-04-03 20:00:00'),(254,'cl017','2026-04-10',7,'Energized','A bit sore but still showed up.','2026-04-10 20:00:00'),(255,'cl017','2026-04-17',6,'Motivated','Tired but pushed through.','2026-04-17 20:00:00'),(256,'cl017','2026-04-24',3,'Okay','Off day but tomorrow is better.','2026-04-24 20:00:00'),(257,'cl017','2026-05-01',5,'Great','Decent session overall.','2026-05-01 20:00:00'),(258,'cl017','2026-05-04',6,'Motivated','Motivation is high this week.','2026-05-04 20:00:00'),(259,'cl017','2026-05-07',5,'Great','Steady progress, love the routine.','2026-05-07 20:00:00'),(260,'cl018','2026-03-13',5,'Great','Tired but pushed through.','2026-03-13 20:00:00'),(261,'cl018','2026-03-16',5,'Great','Feeling the results now.','2026-03-16 20:00:00'),(262,'cl018','2026-03-20',7,'Energized','Best workout this month.','2026-03-20 20:00:00'),(263,'cl018','2026-03-23',5,'Great','Nutrition was on point.','2026-03-23 20:00:00'),(264,'cl018','2026-03-27',3,'Okay','Nutrition was on point.','2026-03-27 20:00:00'),(265,'cl018','2026-04-03',4,'Good','Solid day, hit my targets.','2026-04-03 20:00:00'),(266,'cl018','2026-04-10',4,'Good','Best workout this month.','2026-04-10 20:00:00'),(267,'cl018','2026-04-17',6,'Motivated','Off day but tomorrow is better.','2026-04-17 20:00:00'),(268,'cl018','2026-04-24',7,'Energized','Steady progress, love the routine.','2026-04-24 20:00:00'),(269,'cl018','2026-05-01',4,'Good','Best workout this month.','2026-05-01 20:00:00'),(270,'cl018','2026-05-04',6,'Motivated','A bit sore but still showed up.','2026-05-04 20:00:00'),(271,'cl018','2026-05-07',8,'Great','Off day but tomorrow is better.','2026-05-07 20:00:00'),(272,'cl019','2026-03-13',6,'Motivated','Steady progress, love the routine.','2026-03-13 20:00:00'),(273,'cl019','2026-03-16',3,'Okay','Solid day, hit my targets.','2026-03-16 20:00:00'),(274,'cl019','2026-03-20',5,'Great','Motivation is high this week.','2026-03-20 20:00:00'),(275,'cl019','2026-03-23',6,'Motivated','Best workout this month.','2026-03-23 20:00:00'),(276,'cl019','2026-03-27',4,'Good','Nothing special, just got it done.','2026-03-27 20:00:00'),(277,'cl019','2026-04-03',8,'Great','Sleep was good, felt fresh.','2026-04-03 20:00:00'),(278,'cl019','2026-04-10',5,'Great','Off day but tomorrow is better.','2026-04-10 20:00:00'),(279,'cl019','2026-04-17',7,'Energized','Nutrition was on point.','2026-04-17 20:00:00'),(280,'cl019','2026-04-24',5,'Great','Lots of energy, crushed it.','2026-04-24 20:00:00'),(281,'cl019','2026-05-01',8,'Great','Nutrition was on point.','2026-05-01 20:00:00'),(282,'cl019','2026-05-04',5,'Great','Tired but pushed through.','2026-05-04 20:00:00'),(283,'cl019','2026-05-07',8,'Great','Off day but tomorrow is better.','2026-05-07 20:00:00'),(284,'cl020','2026-03-13',5,'Great','Nothing special, just got it done.','2026-03-13 20:00:00'),(285,'cl020','2026-03-16',5,'Great','Motivation is high this week.','2026-03-16 20:00:00'),(286,'cl020','2026-03-20',3,'Okay','Best workout this month.','2026-03-20 20:00:00'),(287,'cl020','2026-03-23',4,'Good','Tired but pushed through.','2026-03-23 20:00:00'),(288,'cl020','2026-03-27',3,'Okay','Best workout this month.','2026-03-27 20:00:00'),(289,'cl020','2026-04-03',7,'Energized','Steady progress, love the routine.','2026-04-03 20:00:00'),(290,'cl020','2026-04-10',8,'Great','Decent session overall.','2026-04-10 20:00:00'),(291,'cl020','2026-04-17',4,'Good','Motivation is high this week.','2026-04-17 20:00:00'),(292,'cl020','2026-04-24',8,'Great','Off day but tomorrow is better.','2026-04-24 20:00:00'),(293,'cl020','2026-05-01',5,'Great','Best workout this month.','2026-05-01 20:00:00'),(294,'cl020','2026-05-04',7,'Energized','Steady progress, love the routine.','2026-05-04 20:00:00'),(295,'cl020','2026-05-07',7,'Energized','Sleep was good, felt fresh.','2026-05-07 20:00:00'),(296,'cl019','2026-05-10',9,'Happy','Busy day but felt good','2026-05-10 07:27:08');
/*!40000 ALTER TABLE `mood_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notification_preferences`
--

DROP TABLE IF EXISTS `notification_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notification_preferences` (
  `preference_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `daily_water_reminder` tinyint(1) NOT NULL DEFAULT '1',
  `workout_today_reminder` tinyint(1) NOT NULL DEFAULT '1',
  `email_notifications` tinyint(1) NOT NULL DEFAULT '1',
  `in_app_notifications` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`preference_id`),
  UNIQUE KEY `client_id` (`client_id`),
  CONSTRAINT `fk_notification_preferences_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notification_preferences`
--

LOCK TABLES `notification_preferences` WRITE;
/*!40000 ALTER TABLE `notification_preferences` DISABLE KEYS */;
INSERT INTO `notification_preferences` VALUES (1,'cl017',1,1,1,1,'2026-05-03 00:17:30','2026-05-03 00:17:30'),(2,'cl018',1,1,1,1,'2026-05-08 23:09:51','2026-05-08 23:09:51'),(3,'cl001',1,1,1,1,'2026-03-01 10:00:00','2026-03-01 10:00:00'),(4,'6fbb7010',1,1,0,1,'2026-05-04 03:00:00','2026-05-04 03:00:00'),(5,'cl002',1,0,1,1,'2026-03-01 10:00:00','2026-03-01 10:00:00'),(6,'cl011',1,1,1,1,'2026-03-06 10:00:00','2026-03-06 10:00:00'),(7,'cl003',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(8,'cl004',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(9,'cl005',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(10,'cl006',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(11,'cl007',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(12,'cl008',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(13,'cl009',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(14,'cl010',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(15,'cl012',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(16,'cl013',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(17,'cl014',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(18,'cl015',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(19,'cl016',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(20,'1c453b6c',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(21,'32a33897',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(22,'cl019',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00'),(23,'cl020',1,1,1,1,'2026-03-10 10:00:00','2026-03-10 10:00:00');
/*!40000 ALTER TABLE `notification_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `notification_id` int NOT NULL AUTO_INCREMENT,
  `user_id` varchar(50) NOT NULL,
  `type` varchar(50) DEFAULT NULL,
  `title` varchar(150) DEFAULT NULL,
  `body` text,
  `is_read` tinyint(1) DEFAULT '0',
  `channel` enum('in_app','email','push') DEFAULT 'in_app',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`notification_id`),
  KEY `idx_notifications_user_id` (`user_id`),
  CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=64 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,'cl001','workout','Workout Reminder','Your workout is scheduled today.',1,'in_app','2026-03-10 11:00:00'),(2,'cl002','nutrition','Meal Reminder','Log your lunch.',1,'in_app','2026-03-10 16:00:00'),(3,'cl003','coach','Coach Message','You have a new message.',0,'in_app','2026-03-10 14:16:00'),(4,'cl010','system','Progress Check','Please update your weekly check-in.',0,'email','2026-03-11 13:00:00'),(5,'cl015','nutrition','Plan Updated','Your meal plan has been updated.',0,'in_app','2026-03-11 17:00:00'),(6,'cl001','coach','Plan Updated','Your coach updated your workout plan for this week. Check it out!',0,'in_app','2026-05-08 08:00:00'),(7,'cl001','workout','Workout Reminder','You have a session scheduled today. Do not forget to log it.',0,'in_app','2026-05-09 09:00:00'),(8,'cl001','nutrition','Meal Log','You have not logged today\'s lunch yet.',0,'in_app','2026-05-09 13:30:00'),(9,'cl001','system','Weekly Summary','Great week! You completed 4 of 4 planned workouts.',1,'in_app','2026-05-06 20:00:00'),(10,'cl017','coach','New Client Request','You have a new pending client request from Sophia Moore.',1,'in_app','2026-05-09 11:00:00'),(11,'cl017','coach','Client Message','Frank Torres sent you a new message.',1,'in_app','2026-05-05 17:10:00'),(12,'6fbb7010','coach','Plan Ready','Daniel set up your first workout plan. Head to Week at a Glance to view.',0,'in_app','2026-05-09 01:00:00'),(13,'6fbb7010','workout','Workout Reminder','Do not forget your session today!',0,'in_app','2026-05-09 09:00:00'),(14,'cl002','nutrition','Plan Updated','Mia updated your meal plan. Check out the new options!',0,'in_app','2026-05-08 10:00:00'),(15,'cl011','workout','New PR Logged','You logged a new personal best on Romanian Deadlift ÔÇö 315 lbs!',1,'in_app','2026-03-26 20:15:00'),(16,'cl001','coach','Coach Message','You have a new message from Daniel Martinez.',1,'in_app','2026-04-08 21:20:00'),(17,'cl016','system','Weekly Summary','You logged 15,000 steps yesterday ÔÇö personal best!',0,'in_app','2026-05-10 07:00:00'),(18,'cl002','system','Weekly Summary','You completed your workouts this week. Great job!',0,'in_app','2026-04-20 09:00:00'),(19,'cl002','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',0,'in_app','2026-05-05 09:00:00'),(20,'cl003','system','Weekly Summary','You completed your workouts this week. Great job!',1,'in_app','2026-05-01 09:00:00'),(21,'cl003','coach','New Message','You have a new message from your coach.',0,'in_app','2026-05-08 09:00:00'),(22,'cl004','coach','Coach Update','Your coach has updated your plan. Check it out!',1,'in_app','2026-05-01 09:00:00'),(23,'cl004','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',0,'in_app','2026-04-20 09:00:00'),(24,'cl005','system','Weekly Summary','You completed your workouts this week. Great job!',0,'in_app','2026-05-01 09:00:00'),(25,'cl005','workout','Workout Reminder','Your session is scheduled today. Do not forget to log it.',0,'in_app','2026-04-20 09:00:00'),(26,'cl006','coach','New Message','You have a new message from your coach.',1,'in_app','2026-05-09 09:00:00'),(27,'cl006','workout','Workout Reminder','Your session is scheduled today. Do not forget to log it.',0,'in_app','2026-05-01 09:00:00'),(28,'cl007','workout','Workout Reminder','Your session is scheduled today. Do not forget to log it.',1,'in_app','2026-05-01 09:00:00'),(29,'cl007','system','Weekly Summary','You completed your workouts this week. Great job!',0,'in_app','2026-04-20 09:00:00'),(30,'cl008','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',0,'in_app','2026-05-09 09:00:00'),(31,'cl008','coach','Coach Update','Your coach has updated your plan. Check it out!',1,'in_app','2026-05-09 09:00:00'),(32,'cl009','coach','New Message','You have a new message from your coach.',0,'in_app','2026-05-05 09:00:00'),(33,'cl009','coach','Coach Update','Your coach has updated your plan. Check it out!',0,'in_app','2026-05-09 09:00:00'),(34,'cl010','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',1,'in_app','2026-05-05 09:00:00'),(35,'cl010','system','Weekly Summary','You completed your workouts this week. Great job!',0,'in_app','2026-05-09 09:00:00'),(36,'cl011','coach','New Message','You have a new message from your coach.',1,'in_app','2026-05-09 09:00:00'),(37,'cl011','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',1,'in_app','2026-04-20 09:00:00'),(38,'cl012','coach','Coach Update','Your coach has updated your plan. Check it out!',1,'in_app','2026-05-08 09:00:00'),(39,'cl012','system','Weekly Summary','You completed your workouts this week. Great job!',1,'in_app','2026-05-01 09:00:00'),(40,'cl013','coach','Coach Update','Your coach has updated your plan. Check it out!',0,'in_app','2026-05-09 09:00:00'),(41,'cl013','system','Weekly Summary','You completed your workouts this week. Great job!',1,'in_app','2026-05-01 09:00:00'),(42,'cl014','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',0,'in_app','2026-05-08 09:00:00'),(43,'cl014','coach','Coach Update','Your coach has updated your plan. Check it out!',0,'in_app','2026-05-09 09:00:00'),(44,'cl015','system','Weekly Summary','You completed your workouts this week. Great job!',0,'in_app','2026-05-08 09:00:00'),(45,'cl015','coach','New Message','You have a new message from your coach.',0,'in_app','2026-05-05 09:00:00'),(46,'cl016','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',0,'in_app','2026-05-08 09:00:00'),(47,'cl016','coach','Coach Update','Your coach has updated your plan. Check it out!',1,'in_app','2026-04-20 09:00:00'),(48,'1c453b6c','coach','New Message','You have a new message from your coach.',0,'in_app','2026-05-05 09:00:00'),(49,'1c453b6c','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',1,'in_app','2026-05-09 09:00:00'),(50,'32a33897','coach','New Message','You have a new message from your coach.',0,'in_app','2026-05-01 09:00:00'),(51,'32a33897','workout','Workout Reminder','Your session is scheduled today. Do not forget to log it.',0,'in_app','2026-05-08 09:00:00'),(52,'cl018','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',1,'in_app','2026-04-20 09:00:00'),(53,'cl018','coach','Coach Update','Your coach has updated your plan. Check it out!',0,'in_app','2026-05-01 09:00:00'),(54,'cl019','workout','Workout Reminder','Your session is scheduled today. Do not forget to log it.',1,'in_app','2026-05-09 09:00:00'),(55,'cl019','system','Weekly Summary','You completed your workouts this week. Great job!',1,'in_app','2026-05-08 09:00:00'),(56,'cl020','nutrition','Meal Log Reminder','You have not logged today\'s meals yet.',1,'in_app','2026-05-08 09:00:00'),(57,'cl020','coach','Coach Update','Your coach has updated your plan. Check it out!',1,'in_app','2026-05-09 09:00:00'),(58,'cl019','coach','Request Accepted','Daniel Martinez accepted your request! You can now message them.',1,'in_app','2026-05-10 07:10:53'),(59,'cl017','coach','New Hire Request','Chris Walker wants to work with you.',1,'in_app','2026-05-10 07:15:07'),(60,'cl019','coach','Request Accepted','Daniel Martinez accepted your request! You can now message them.',1,'in_app','2026-05-10 07:15:42'),(61,'cl017','review','New Review','Chris Walker left you a 4-star review.',1,'in_app','2026-05-10 07:16:51'),(62,'cl019','workout','New Workout Plan','Daniel Martinez created a new workout plan for you.',1,'in_app','2026-05-10 07:18:38'),(63,'cl019','workout','New Workout Plan','Daniel Martinez created a new workout plan for you.',0,'in_app','2026-05-10 07:34:56');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nutrition_coach`
--

DROP TABLE IF EXISTS `nutrition_coach`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nutrition_coach` (
  `coach_id` varchar(50) NOT NULL,
  `meal_plan_id` int DEFAULT NULL,
  `certifications` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`coach_id`),
  KEY `fk_nutrition_coach_meal` (`meal_plan_id`),
  CONSTRAINT `nutrition_coach_coach_FK` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`coach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nutrition_coach`
--

LOCK TABLES `nutrition_coach` WRITE;
/*!40000 ALTER TABLE `nutrition_coach` DISABLE KEYS */;
INSERT INTO `nutrition_coach` VALUES ('cl018',1,'Precision Nutrition Level 1'),('cl019',3,'ACE Sports Nutrition');
/*!40000 ALTER TABLE `nutrition_coach` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `nutrition_plan`
--

DROP TABLE IF EXISTS `nutrition_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `nutrition_plan` (
  `nutrition_plan_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `created_by` varchar(50) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`nutrition_plan_id`),
  KEY `idx_nutrition_plan_client_id` (`client_id`),
  KEY `idx_nutrition_plan_created_by` (`created_by`),
  CONSTRAINT `fk_nutrition_plan_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_nutrition_plan_created_by` FOREIGN KEY (`created_by`) REFERENCES `nutrition_coach` (`coach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nutrition_plan`
--

LOCK TABLES `nutrition_plan` WRITE;
/*!40000 ALTER TABLE `nutrition_plan` DISABLE KEYS */;
INSERT INTO `nutrition_plan` VALUES (1,'cl001','cl018','Lean Bulk'),(2,'cl002','cl018','Fat Loss'),(3,'cl003','cl019','Maintenance'),(4,'cl004','cl018','Fat Loss'),(5,'cl005','cl018','Performance'),(6,'cl006','cl018','Light Deficit'),(7,'cl007','cl019','Maintenance'),(8,'cl008','cl018','Fat Loss'),(9,'cl009','cl018','Lean Bulk'),(10,'cl010','cl018','Fat Loss'),(11,'cl011','cl019','Performance'),(12,'cl012','cl018','Maintenance'),(13,'cl006','cl018','Flu Recovery'),(14,'cl007','cl019','Maintenance'),(15,'cl007','cl019','test'),(16,'cl011','cl019','Performance'),(17,'cl012','cl018','Maintenance'),(18,'cl013','cl018','Lean Bulk'),(19,'cl014','cl018','Fat Loss'),(20,'cl015','cl019','Performance'),(21,'cl016','cl018','Light Deficit'),(22,'6fbb7010','cl018','Lean Bulk'),(23,'1c453b6c','cl018','Maintenance'),(24,'32a33897','cl018','Fat Loss'),(25,'cl017','cl018','Performance'),(26,'cl019','cl019','Performance'),(27,'cl020','cl018','Maintenance');
/*!40000 ALTER TABLE `nutrition_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_method`
--

DROP TABLE IF EXISTS `payment_method`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_method` (
  `payment_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `card_type` varchar(20) DEFAULT NULL,
  `last4` char(4) DEFAULT NULL,
  `expiry_month` int DEFAULT NULL,
  `expiry_year` int DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`payment_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `payment_method_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_method`
--

LOCK TABLES `payment_method` WRITE;
/*!40000 ALTER TABLE `payment_method` DISABLE KEYS */;
INSERT INTO `payment_method` VALUES (2,'6fbb7010','Unknown','6543',9,30,1,'2026-05-04 03:34:41'),(3,'cl001','Visa','4242',12,2028,1,'2026-03-01 10:00:00'),(4,'cl002','Mastercard','5555',8,2027,1,'2026-03-01 10:05:00'),(5,'cl003','Visa','1234',6,2029,1,'2026-03-02 09:00:00'),(6,'cl005','Visa','9876',3,2028,1,'2026-03-03 11:00:00'),(7,'cl009','Mastercard','3333',11,2027,1,'2026-03-05 12:00:00'),(8,'cl011','Visa','7890',7,2030,1,'2026-03-06 10:30:00'),(9,'cl004','Visa','2211',5,2028,1,'2026-03-10 10:00:00'),(10,'cl006','Mastercard','8844',9,2027,1,'2026-03-10 10:00:00'),(11,'cl007','Visa','3322',3,2029,1,'2026-03-10 10:00:00'),(12,'cl008','Visa','5566',11,2027,1,'2026-03-10 10:00:00'),(13,'cl010','Mastercard','7711',7,2028,1,'2026-03-10 10:00:00'),(14,'cl012','Visa','4433',4,2030,1,'2026-03-10 10:00:00'),(15,'cl013','Mastercard','6655',8,2027,1,'2026-03-10 10:00:00'),(16,'cl014','Visa','9988',2,2029,1,'2026-03-10 10:00:00'),(17,'cl015','Mastercard','1177',6,2028,1,'2026-03-10 10:00:00'),(18,'cl016','Visa','3344',10,2027,1,'2026-03-10 10:00:00'),(19,'1c453b6c','Mastercard','2288',1,2029,1,'2026-03-10 10:00:00'),(20,'32a33897','Visa','5599',12,2028,1,'2026-03-10 10:00:00'),(21,'cl017','Visa','8800',5,2028,1,'2026-03-10 10:00:00'),(22,'cl018','Mastercard','4411',3,2029,1,'2026-03-10 10:00:00'),(23,'cl019','Visa','7722',8,2027,1,'2026-03-10 10:00:00'),(24,'cl020','Mastercard','6633',11,2028,1,'2026-03-10 10:00:00');
/*!40000 ALTER TABLE `payment_method` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `progress_photos`
--

DROP TABLE IF EXISTS `progress_photos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `progress_photos` (
  `photo_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `photo_type` enum('before','after') DEFAULT NULL,
  `image_url` varchar(255) DEFAULT NULL,
  `uploaded_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`photo_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `progress_photos_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `progress_photos`
--

LOCK TABLES `progress_photos` WRITE;
/*!40000 ALTER TABLE `progress_photos` DISABLE KEYS */;
INSERT INTO `progress_photos` VALUES (3,'cl016','before','cl016_before_Screenshot from 2026-05-09 16-17-01.png','2026-05-09 20:17:16');
/*!40000 ALTER TABLE `progress_photos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reports`
--

DROP TABLE IF EXISTS `reports`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reports` (
  `report_id` int NOT NULL AUTO_INCREMENT,
  `reporter_id` varchar(50) NOT NULL,
  `reported_user_id` varchar(50) NOT NULL,
  `reason` varchar(255) DEFAULT NULL,
  `details` text,
  `status` enum('open','reviewed','resolved','dismissed') DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `reviewed_by` int DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`report_id`),
  KEY `idx_reports_reporter_id` (`reporter_id`),
  KEY `idx_reports_reported_user_id` (`reported_user_id`),
  KEY `idx_reports_reviewed_by` (`reviewed_by`),
  CONSTRAINT `fk_reports_reported_user` FOREIGN KEY (`reported_user_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reports_reporter` FOREIGN KEY (`reporter_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reports_reviewed_by` FOREIGN KEY (`reviewed_by`) REFERENCES `admin` (`admin_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (1,'cl001','cl005','Spam','Repeated off-topic messages.','reviewed','2026-03-09 19:00:00',1,NULL),(2,'cl002','cl003','Harassment','Message tone felt inappropriate.','resolved','2026-03-08 22:20:00',2,'2026-03-10 13:00:00'),(3,'cl007','cl013','Inappropriate behavior','Left a rude and dismissive comment during a shared group session feedback form.','open','2026-05-08 15:00:00',NULL,NULL);
/*!40000 ALTER TABLE `reports` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `review_id` int NOT NULL AUTO_INCREMENT,
  `coach_id` varchar(50) NOT NULL,
  `client_id` varchar(50) NOT NULL,
  `rating` tinyint DEFAULT NULL,
  `comment` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`review_id`),
  KEY `idx_reviews_coach_id` (`coach_id`),
  KEY `idx_reviews_client_id` (`client_id`),
  CONSTRAINT `fk_reviews_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reviews_coach` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`coach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,'cl017','cl001',5,'Great coach.','2026-03-11 21:00:00'),(2,'cl018','cl002',4,'Helpful nutrition advice.','2026-03-11 21:10:00'),(3,'cl019','cl011',5,'Really motivating and helpful.','2026-03-11 21:20:00'),(4,'cl020','cl016',4,'Good explanations and support.','2026-03-11 21:30:00'),(5,'cl017','cl005',5,'Daniel pushed me hard and I hit my goal weight in 6 weeks. Completely changed my approach to training.','2026-03-15 09:00:00'),(6,'cl017','cl009',4,'Great programming and always responsive when I have questions. My squat numbers keep going up.','2026-03-18 11:30:00'),(7,'cl017','cl013',5,'Best coach I have ever worked with. Transformed my routine inside of two months.','2026-03-22 14:00:00'),(8,'cl018','cl006',5,'Mia redesigned my entire meal plan. My energy levels are through the roof and I actually enjoy eating this way.','2026-03-16 10:15:00'),(9,'cl018','cl010',4,'Very knowledgeable on macros. The meal plans are tasty and practical, not just chicken and broccoli.','2026-03-20 13:45:00'),(10,'cl018','cl014',5,'I lost 8 lbs in 5 weeks while eating more than I ever did on my own. Mia knows her stuff.','2026-03-25 16:00:00'),(11,'cl019','cl003',5,'Chris trains me hard but smartly. No injuries, steady gains every single week.','2026-03-17 08:45:00'),(12,'cl019','cl007',4,'Really professional coach who has both fitness and nutrition dialed in. Worth every dollar.','2026-03-21 15:20:00'),(13,'cl019','cl015',5,'Switched from another coach and the difference is night and day. Highly recommend Chris.','2026-03-28 10:00:00'),(14,'cl020','cl004',5,'Grace is so encouraging and knows exactly how to adapt workouts to my schedule and limitations.','2026-03-14 12:00:00'),(15,'cl020','cl012',4,'Steady progress every single week. She is very attentive and adjusts the plan based on my feedback.','2026-03-19 17:30:00'),(16,'cl017','cl019',4,'He was decent','2026-05-10 07:16:51');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workout_log`
--

DROP TABLE IF EXISTS `workout_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workout_log` (
  `log_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `exercise_id` int DEFAULT NULL,
  `log_date` date NOT NULL,
  `sets_completed` int DEFAULT NULL,
  `reps_completed` int DEFAULT NULL,
  `weight` decimal(6,2) DEFAULT NULL,
  `cardio_type` varchar(100) DEFAULT NULL,
  `cardio_duration` int DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`log_id`),
  KEY `idx_workout_log_client_id` (`client_id`),
  KEY `idx_workout_log_exercise_id` (`exercise_id`),
  CONSTRAINT `fk_workout_log_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_workout_log_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`exercise_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=399 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_log`
--

LOCK TABLES `workout_log` WRITE;
/*!40000 ALTER TABLE `workout_log` DISABLE KEYS */;
INSERT INTO `workout_log` VALUES (1,'cl001',1,'2026-03-10',4,8,155.00,NULL,NULL,'Bench felt smooth.','2026-03-10 22:00:00'),(2,'cl001',2,'2026-03-10',3,10,40.00,NULL,NULL,'Shoulders were fatigued.','2026-03-10 22:20:00'),(3,'cl002',4,'2026-03-10',3,12,35.00,NULL,NULL,'Good form today.','2026-03-10 21:30:00'),(4,'cl003',3,'2026-03-10',4,10,120.00,NULL,NULL,'Back pump was great.','2026-03-10 23:00:00'),(5,'cl003',5,'2026-03-10',4,8,185.00,NULL,NULL,'Solid hinge pattern.','2026-03-10 23:25:00'),(6,'cl002',7,'2026-03-11',NULL,NULL,NULL,'Incline Walk',20,'Cardio finish.','2026-03-11 20:00:00'),(7,'cl007',11,'2026-03-11',4,10,100.00,NULL,NULL,'Rows felt controlled.','2026-03-11 22:10:00'),(8,'cl008',12,'2026-03-11',3,12,20.00,NULL,NULL,'Lunges burned.','2026-03-11 22:30:00'),(9,'cl009',1,'2026-03-11',4,8,145.00,NULL,NULL,'Good tempo.','2026-03-11 23:00:00'),(10,'cl010',7,'2026-03-11',NULL,NULL,NULL,'Incline Walk',25,'Long cardio session.','2026-03-11 23:15:00'),(11,'cl011',5,'2026-03-11',4,6,205.00,NULL,NULL,'Heavy but solid.','2026-03-11 23:30:00'),(12,'cl012',2,'2026-03-11',3,10,30.00,NULL,NULL,'Shoulders felt good.','2026-03-11 23:40:00'),(16,'cl016',7,'2026-05-09',0,0,0.00,'Incline Walk',45,'Trail','2026-05-09 14:10:58'),(17,'cl001',1,'2026-03-12',4,8,160.00,NULL,NULL,'Up 5 lbs from last week, felt controlled.','2026-03-12 21:00:00'),(18,'cl001',2,'2026-03-12',3,10,45.00,NULL,NULL,'Shoulder press, warming up the weight.','2026-03-12 21:20:00'),(19,'cl001',7,'2026-03-14',NULL,NULL,NULL,'Incline Walk',25,'Easy cardio day.','2026-03-14 10:00:00'),(20,'cl001',1,'2026-03-17',4,8,160.00,NULL,NULL,'Matched last week. Going for 165 next session.','2026-03-17 20:00:00'),(21,'cl001',5,'2026-03-17',3,8,135.00,NULL,NULL,'RDL felt strong, good hamstring stretch.','2026-03-17 20:30:00'),(22,'cl001',3,'2026-03-19',3,12,110.00,NULL,NULL,'Lat pulldown, good contraction at bottom.','2026-03-19 19:45:00'),(23,'cl001',7,'2026-03-21',NULL,NULL,NULL,'Incline Walk',30,'Longer weekend cardio session.','2026-03-21 09:30:00'),(24,'cl001',1,'2026-03-24',4,8,165.00,NULL,NULL,'New PR! 165 went up clean all 4 sets.','2026-03-24 20:00:00'),(25,'cl001',6,'2026-03-24',3,60,NULL,NULL,NULL,'Plank holds, 60 seconds each.','2026-03-24 20:45:00'),(26,'cl001',2,'2026-03-26',3,10,45.00,NULL,NULL,'Shoulder press steady.','2026-03-26 19:30:00'),(27,'cl001',5,'2026-03-28',4,8,140.00,NULL,NULL,'RDL up 5 lbs, felt it in the hamstrings.','2026-03-28 10:00:00'),(28,'cl001',1,'2026-04-01',4,8,165.00,NULL,NULL,'Holding 165, focused on tempo.','2026-04-01 20:00:00'),(29,'cl001',3,'2026-04-03',3,12,115.00,NULL,NULL,'Lat pulldown, slight weight increase.','2026-04-03 19:30:00'),(30,'cl001',7,'2026-04-04',NULL,NULL,NULL,'Incline Walk',25,'Pre-weekend cardio.','2026-04-04 10:30:00'),(31,'cl001',1,'2026-04-08',4,8,165.00,NULL,NULL,'Consistent at 165, ready to push next week.','2026-04-08 20:00:00'),(32,'cl001',2,'2026-04-10',3,10,50.00,NULL,NULL,'Shoulder press up to 50 lbs.','2026-04-10 19:45:00'),(33,'cl001',1,'2026-04-14',4,8,170.00,NULL,NULL,'Tried 170 ÔÇö first two sets clean, last two grind.','2026-04-14 20:00:00'),(34,'cl001',5,'2026-04-16',4,8,145.00,NULL,NULL,'RDL moving well at 145.','2026-04-16 19:30:00'),(35,'cl001',7,'2026-04-18',NULL,NULL,NULL,'Incline Walk',35,'Longer cardio this weekend.','2026-04-18 09:30:00'),(36,'cl001',1,'2026-04-21',4,8,170.00,NULL,NULL,'All 4 sets at 170 locked in.','2026-04-21 20:00:00'),(37,'cl001',3,'2026-04-23',3,12,120.00,NULL,NULL,'Lat pulldown up to 120 lbs.','2026-04-23 19:30:00'),(38,'cl001',1,'2026-04-28',4,8,175.00,NULL,NULL,'Attempted 175, got 3 clean sets!','2026-04-28 20:00:00'),(39,'cl001',7,'2026-04-30',NULL,NULL,NULL,'Incline Walk',30,'End of April cardio.','2026-04-30 10:00:00'),(40,'cl001',1,'2026-05-05',4,8,175.00,NULL,NULL,'Solid at 175 ÔÇö all 4 sets clean.','2026-05-05 20:00:00'),(41,'cl001',2,'2026-05-07',3,10,52.50,NULL,NULL,'Shoulders at 52.5, feeling strong.','2026-05-07 19:30:00'),(42,'cl001',5,'2026-05-08',4,8,150.00,NULL,NULL,'RDL strong at 150.','2026-05-08 20:00:00'),(43,'6fbb7010',1,'2026-05-05',3,10,95.00,NULL,NULL,'First bench session with the plan, felt good.','2026-05-05 19:00:00'),(44,'6fbb7010',4,'2026-05-07',3,12,40.00,NULL,NULL,'Goblet squats ÔÇö legs were jello afterward.','2026-05-07 18:30:00'),(45,'6fbb7010',7,'2026-05-09',NULL,NULL,NULL,'Incline Walk',20,'Light cardio to close the week.','2026-05-09 10:00:00'),(46,'cl002',7,'2026-03-16',NULL,NULL,NULL,'Incline Walk',29,'Cardio session.','2026-03-16 18:00:00'),(47,'cl002',4,'2026-03-16',3,12,31.00,NULL,NULL,'Form was solid.','2026-03-16 18:00:00'),(48,'cl002',7,'2026-03-23',NULL,NULL,NULL,'Incline Walk',24,'Good steady walk.','2026-03-23 21:00:00'),(49,'cl002',4,'2026-03-23',3,12,21.00,NULL,NULL,'Good session today.','2026-03-23 21:00:00'),(50,'cl002',9,'2026-03-30',3,19,NULL,NULL,NULL,'Felt strong throughout.','2026-03-30 18:00:00'),(51,'cl002',7,'2026-03-30',NULL,NULL,NULL,'Incline Walk',20,'Zone 2 cardio.','2026-03-30 18:00:00'),(52,'cl002',7,'2026-04-06',NULL,NULL,NULL,'Incline Walk',34,'Good steady walk.','2026-04-06 20:00:00'),(53,'cl002',9,'2026-04-06',3,14,NULL,NULL,NULL,'Good session today.','2026-04-06 20:00:00'),(54,'cl002',7,'2026-04-13',NULL,NULL,NULL,'Incline Walk',22,'Good steady walk.','2026-04-13 17:00:00'),(55,'cl002',9,'2026-04-13',3,19,NULL,NULL,NULL,'Felt strong throughout.','2026-04-13 17:00:00'),(56,'cl002',9,'2026-04-20',3,14,NULL,NULL,NULL,'Cardio felt easy today.','2026-04-20 18:00:00'),(57,'cl002',4,'2026-04-20',3,12,29.00,NULL,NULL,'Felt strong throughout.','2026-04-20 18:00:00'),(58,'cl002',4,'2026-04-27',3,12,44.00,NULL,NULL,'Hit a small PR today.','2026-04-27 21:00:00'),(59,'cl002',9,'2026-04-27',3,15,NULL,NULL,NULL,'Consistent with last week.','2026-04-27 21:00:00'),(60,'cl002',7,'2026-05-04',NULL,NULL,NULL,'Incline Walk',29,'Zone 2 cardio.','2026-05-04 20:00:00'),(61,'cl002',9,'2026-05-04',3,18,NULL,NULL,NULL,'Energy was high.','2026-05-04 20:00:00'),(62,'cl003',11,'2026-03-16',3,10,93.00,NULL,NULL,'Felt strong throughout.','2026-03-16 21:00:00'),(63,'cl003',3,'2026-03-16',3,12,114.00,NULL,NULL,'Tougher than expected but got it done.','2026-03-16 21:00:00'),(64,'cl003',11,'2026-03-23',3,10,91.00,NULL,NULL,'Felt strong throughout.','2026-03-23 19:00:00'),(65,'cl003',3,'2026-03-23',3,12,95.00,NULL,NULL,'Tougher than expected but got it done.','2026-03-23 19:00:00'),(66,'cl003',3,'2026-03-30',3,12,90.00,NULL,NULL,'Hit a small PR today.','2026-03-30 18:00:00'),(67,'cl003',11,'2026-03-30',3,10,84.00,NULL,NULL,'Recovery was good going in.','2026-03-30 18:00:00'),(68,'cl003',11,'2026-04-06',3,10,71.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-06 19:00:00'),(69,'cl003',5,'2026-04-06',4,8,119.00,NULL,NULL,'Recovery was good going in.','2026-04-06 19:00:00'),(70,'cl003',5,'2026-04-13',4,8,131.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-13 17:00:00'),(71,'cl003',11,'2026-04-13',3,10,78.00,NULL,NULL,'Challenging but finished strong.','2026-04-13 17:00:00'),(72,'cl003',11,'2026-04-20',3,10,73.00,NULL,NULL,'Consistent with last week.','2026-04-20 20:00:00'),(73,'cl003',3,'2026-04-20',3,12,97.00,NULL,NULL,'Challenging but finished strong.','2026-04-20 20:00:00'),(74,'cl003',3,'2026-04-27',3,12,92.00,NULL,NULL,'Good session today.','2026-04-27 18:00:00'),(75,'cl003',5,'2026-04-27',4,8,115.00,NULL,NULL,'Energy was high.','2026-04-27 18:00:00'),(76,'cl003',11,'2026-05-04',3,10,73.00,NULL,NULL,'Good pump, happy with this.','2026-05-04 20:00:00'),(77,'cl003',5,'2026-05-04',4,8,132.00,NULL,NULL,'Energy was high.','2026-05-04 20:00:00'),(78,'cl004',7,'2026-03-16',NULL,NULL,NULL,'Incline Walk',37,'Good steady walk.','2026-03-16 21:00:00'),(79,'cl004',6,'2026-03-16',3,60,NULL,NULL,NULL,'Good pump, happy with this.','2026-03-16 21:00:00'),(80,'cl004',4,'2026-03-23',3,12,33.00,NULL,NULL,'Recovery was good going in.','2026-03-23 17:00:00'),(81,'cl004',9,'2026-03-23',3,17,NULL,NULL,NULL,'Cardio felt easy today.','2026-03-23 17:00:00'),(82,'cl004',9,'2026-03-30',3,15,NULL,NULL,NULL,'Challenging but finished strong.','2026-03-30 17:00:00'),(83,'cl004',4,'2026-03-30',3,12,38.00,NULL,NULL,'Cardio felt easy today.','2026-03-30 17:00:00'),(84,'cl004',4,'2026-04-06',3,12,38.00,NULL,NULL,'Good session today.','2026-04-06 19:00:00'),(85,'cl004',9,'2026-04-06',3,14,NULL,NULL,NULL,'Good pump, happy with this.','2026-04-06 19:00:00'),(86,'cl004',7,'2026-04-13',NULL,NULL,NULL,'Incline Walk',38,'Good steady walk.','2026-04-13 18:00:00'),(87,'cl004',6,'2026-04-13',3,60,NULL,NULL,NULL,'Challenging but finished strong.','2026-04-13 18:00:00'),(88,'cl004',7,'2026-04-20',NULL,NULL,NULL,'Incline Walk',31,'Good steady walk.','2026-04-20 20:00:00'),(89,'cl004',4,'2026-04-20',3,12,30.00,NULL,NULL,'Steady pace, no issues.','2026-04-20 20:00:00'),(90,'cl004',4,'2026-04-27',3,12,33.00,NULL,NULL,'Recovery was good going in.','2026-04-27 19:00:00'),(91,'cl004',7,'2026-04-27',NULL,NULL,NULL,'Incline Walk',35,'Good steady walk.','2026-04-27 19:00:00'),(92,'cl004',7,'2026-05-04',NULL,NULL,NULL,'Incline Walk',34,'Cardio session.','2026-05-04 17:00:00'),(93,'cl004',9,'2026-05-04',3,17,NULL,NULL,NULL,'Energy was high.','2026-05-04 17:00:00'),(94,'cl005',2,'2026-03-16',3,10,46.00,NULL,NULL,'Good session today.','2026-03-16 20:00:00'),(95,'cl005',1,'2026-03-16',4,8,146.00,NULL,NULL,'Consistent with last week.','2026-03-16 20:00:00'),(96,'cl005',2,'2026-03-23',3,10,36.00,NULL,NULL,'Consistent with last week.','2026-03-23 17:00:00'),(97,'cl005',5,'2026-03-23',4,8,121.00,NULL,NULL,'Cardio felt easy today.','2026-03-23 17:00:00'),(98,'cl005',2,'2026-03-30',3,10,36.00,NULL,NULL,'Energy was high.','2026-03-30 17:00:00'),(99,'cl005',5,'2026-03-30',4,8,127.00,NULL,NULL,'Form was solid.','2026-03-30 17:00:00'),(100,'cl005',2,'2026-04-06',3,10,33.00,NULL,NULL,'Good session today.','2026-04-06 20:00:00'),(101,'cl005',5,'2026-04-06',4,8,130.00,NULL,NULL,'Cardio felt easy today.','2026-04-06 20:00:00'),(102,'cl005',1,'2026-04-13',4,8,142.00,NULL,NULL,'Good session today.','2026-04-13 19:00:00'),(103,'cl005',5,'2026-04-13',4,8,127.00,NULL,NULL,'Hit a small PR today.','2026-04-13 19:00:00'),(104,'cl005',1,'2026-04-20',4,8,139.00,NULL,NULL,'Felt strong throughout.','2026-04-20 17:00:00'),(105,'cl005',5,'2026-04-20',4,8,130.00,NULL,NULL,'Form was solid.','2026-04-20 17:00:00'),(106,'cl005',2,'2026-04-27',3,10,52.00,NULL,NULL,'Energy was high.','2026-04-27 21:00:00'),(107,'cl005',5,'2026-04-27',4,8,123.00,NULL,NULL,'Good pump, happy with this.','2026-04-27 21:00:00'),(108,'cl005',2,'2026-05-04',3,10,47.00,NULL,NULL,'Form was solid.','2026-05-04 20:00:00'),(109,'cl005',1,'2026-05-04',4,8,137.00,NULL,NULL,'Tougher than expected but got it done.','2026-05-04 20:00:00'),(110,'cl006',7,'2026-03-16',NULL,NULL,NULL,'Incline Walk',28,'Good steady walk.','2026-03-16 17:00:00'),(111,'cl006',9,'2026-03-16',3,17,NULL,NULL,NULL,'Consistent with last week.','2026-03-16 17:00:00'),(112,'cl006',15,'2026-03-23',3,16,NULL,NULL,NULL,'Cardio felt easy today.','2026-03-23 19:00:00'),(113,'cl006',9,'2026-03-23',3,19,NULL,NULL,NULL,'Form was solid.','2026-03-23 19:00:00'),(114,'cl006',15,'2026-03-30',3,17,NULL,NULL,NULL,'Consistent with last week.','2026-03-30 19:00:00'),(115,'cl006',7,'2026-03-30',NULL,NULL,NULL,'Incline Walk',37,'Good steady walk.','2026-03-30 19:00:00'),(116,'cl006',15,'2026-04-06',3,15,NULL,NULL,NULL,'Cardio felt easy today.','2026-04-06 18:00:00'),(117,'cl006',7,'2026-04-06',NULL,NULL,NULL,'Incline Walk',32,'Cardio session.','2026-04-06 18:00:00'),(118,'cl006',15,'2026-04-13',3,19,NULL,NULL,NULL,'Recovery was good going in.','2026-04-13 19:00:00'),(119,'cl006',9,'2026-04-13',3,18,NULL,NULL,NULL,'Hit a small PR today.','2026-04-13 19:00:00'),(120,'cl006',7,'2026-04-20',NULL,NULL,NULL,'Incline Walk',21,'Cardio session.','2026-04-20 20:00:00'),(121,'cl006',9,'2026-04-20',3,20,NULL,NULL,NULL,'Cardio felt easy today.','2026-04-20 20:00:00'),(122,'cl006',15,'2026-04-27',3,13,NULL,NULL,NULL,'Consistent with last week.','2026-04-27 20:00:00'),(123,'cl006',9,'2026-04-27',3,19,NULL,NULL,NULL,'Good session today.','2026-04-27 20:00:00'),(124,'cl006',7,'2026-05-04',NULL,NULL,NULL,'Incline Walk',40,'Cardio session.','2026-05-04 20:00:00'),(125,'cl006',9,'2026-05-04',3,13,NULL,NULL,NULL,'Good pump, happy with this.','2026-05-04 20:00:00'),(126,'cl007',5,'2026-03-16',4,8,132.00,NULL,NULL,'Hit a small PR today.','2026-03-16 21:00:00'),(127,'cl007',1,'2026-03-16',4,8,145.00,NULL,NULL,'Felt strong throughout.','2026-03-16 21:00:00'),(128,'cl007',5,'2026-03-23',4,8,130.00,NULL,NULL,'Recovery was good going in.','2026-03-23 19:00:00'),(129,'cl007',1,'2026-03-23',4,8,149.00,NULL,NULL,'Good pump, happy with this.','2026-03-23 19:00:00'),(130,'cl007',1,'2026-03-30',4,8,127.00,NULL,NULL,'Tougher than expected but got it done.','2026-03-30 21:00:00'),(131,'cl007',11,'2026-03-30',3,10,90.00,NULL,NULL,'Challenging but finished strong.','2026-03-30 21:00:00'),(132,'cl007',5,'2026-04-06',4,8,123.00,NULL,NULL,'Felt strong throughout.','2026-04-06 17:00:00'),(133,'cl007',11,'2026-04-06',3,10,94.00,NULL,NULL,'Challenging but finished strong.','2026-04-06 17:00:00'),(134,'cl007',1,'2026-04-13',4,8,130.00,NULL,NULL,'Recovery was good going in.','2026-04-13 20:00:00'),(135,'cl007',11,'2026-04-13',3,10,79.00,NULL,NULL,'Good session today.','2026-04-13 20:00:00'),(136,'cl007',11,'2026-04-20',3,10,79.00,NULL,NULL,'Steady pace, no issues.','2026-04-20 17:00:00'),(137,'cl007',5,'2026-04-20',4,8,121.00,NULL,NULL,'Hit a small PR today.','2026-04-20 17:00:00'),(138,'cl007',11,'2026-04-27',3,10,83.00,NULL,NULL,'Cardio felt easy today.','2026-04-27 21:00:00'),(139,'cl007',1,'2026-04-27',4,8,146.00,NULL,NULL,'Form was solid.','2026-04-27 21:00:00'),(140,'cl007',11,'2026-05-04',3,10,89.00,NULL,NULL,'Hit a small PR today.','2026-05-04 17:00:00'),(141,'cl007',1,'2026-05-04',4,8,144.00,NULL,NULL,'Challenging but finished strong.','2026-05-04 17:00:00'),(142,'cl008',12,'2026-03-16',3,12,19.00,NULL,NULL,'Tougher than expected but got it done.','2026-03-16 21:00:00'),(143,'cl008',4,'2026-03-16',3,12,34.00,NULL,NULL,'Challenging but finished strong.','2026-03-16 21:00:00'),(144,'cl008',4,'2026-03-23',3,12,41.00,NULL,NULL,'Good session today.','2026-03-23 19:00:00'),(145,'cl008',7,'2026-03-23',NULL,NULL,NULL,'Incline Walk',34,'Good steady walk.','2026-03-23 19:00:00'),(146,'cl008',7,'2026-03-30',NULL,NULL,NULL,'Incline Walk',34,'Good steady walk.','2026-03-30 17:00:00'),(147,'cl008',12,'2026-03-30',3,12,33.00,NULL,NULL,'Energy was high.','2026-03-30 17:00:00'),(148,'cl008',7,'2026-04-06',NULL,NULL,NULL,'Incline Walk',34,'Good steady walk.','2026-04-06 19:00:00'),(149,'cl008',4,'2026-04-06',3,12,26.00,NULL,NULL,'Hit a small PR today.','2026-04-06 19:00:00'),(150,'cl008',4,'2026-04-13',3,12,32.00,NULL,NULL,'Cardio felt easy today.','2026-04-13 18:00:00'),(151,'cl008',12,'2026-04-13',3,12,26.00,NULL,NULL,'Cardio felt easy today.','2026-04-13 18:00:00'),(152,'cl008',4,'2026-04-20',3,12,41.00,NULL,NULL,'Hit a small PR today.','2026-04-20 17:00:00'),(153,'cl008',7,'2026-04-20',NULL,NULL,NULL,'Incline Walk',28,'Cardio session.','2026-04-20 17:00:00'),(154,'cl008',7,'2026-04-27',NULL,NULL,NULL,'Incline Walk',35,'Good steady walk.','2026-04-27 21:00:00'),(155,'cl008',12,'2026-04-27',3,12,39.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-27 21:00:00'),(156,'cl008',7,'2026-05-04',NULL,NULL,NULL,'Incline Walk',40,'Cardio session.','2026-05-04 18:00:00'),(157,'cl008',4,'2026-05-04',3,12,39.00,NULL,NULL,'Energy was high.','2026-05-04 18:00:00'),(158,'cl009',2,'2026-03-16',3,10,50.00,NULL,NULL,'Challenging but finished strong.','2026-03-16 17:00:00'),(159,'cl009',1,'2026-03-16',4,8,126.00,NULL,NULL,'Energy was high.','2026-03-16 17:00:00'),(160,'cl009',3,'2026-03-23',3,12,101.00,NULL,NULL,'Recovery was good going in.','2026-03-23 21:00:00'),(161,'cl009',1,'2026-03-23',4,8,129.00,NULL,NULL,'Felt strong throughout.','2026-03-23 21:00:00'),(162,'cl009',3,'2026-03-30',3,12,95.00,NULL,NULL,'Tougher than expected but got it done.','2026-03-30 20:00:00'),(163,'cl009',2,'2026-03-30',3,10,34.00,NULL,NULL,'Consistent with last week.','2026-03-30 20:00:00'),(164,'cl009',3,'2026-04-06',3,12,98.00,NULL,NULL,'Good pump, happy with this.','2026-04-06 18:00:00'),(165,'cl009',2,'2026-04-06',3,10,55.00,NULL,NULL,'Energy was high.','2026-04-06 18:00:00'),(166,'cl009',2,'2026-04-13',3,10,44.00,NULL,NULL,'Felt strong throughout.','2026-04-13 17:00:00'),(167,'cl009',3,'2026-04-13',3,12,94.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-13 17:00:00'),(168,'cl009',2,'2026-04-20',3,10,41.00,NULL,NULL,'Felt strong throughout.','2026-04-20 21:00:00'),(169,'cl009',3,'2026-04-20',3,12,115.00,NULL,NULL,'Hit a small PR today.','2026-04-20 21:00:00'),(170,'cl009',1,'2026-04-27',4,8,128.00,NULL,NULL,'Good pump, happy with this.','2026-04-27 21:00:00'),(171,'cl009',3,'2026-04-27',3,12,101.00,NULL,NULL,'Challenging but finished strong.','2026-04-27 21:00:00'),(172,'cl009',2,'2026-05-04',3,10,42.00,NULL,NULL,'Challenging but finished strong.','2026-05-04 21:00:00'),(173,'cl009',3,'2026-05-04',3,12,101.00,NULL,NULL,'Felt strong throughout.','2026-05-04 21:00:00'),(174,'cl010',4,'2026-03-16',3,12,20.00,NULL,NULL,'Cardio felt easy today.','2026-03-16 20:00:00'),(175,'cl010',7,'2026-03-16',NULL,NULL,NULL,'Incline Walk',37,'Good steady walk.','2026-03-16 20:00:00'),(176,'cl010',4,'2026-03-23',3,12,40.00,NULL,NULL,'Good pump, happy with this.','2026-03-23 17:00:00'),(177,'cl010',7,'2026-03-23',NULL,NULL,NULL,'Incline Walk',29,'Zone 2 cardio.','2026-03-23 17:00:00'),(178,'cl010',9,'2026-03-30',3,12,NULL,NULL,NULL,'Good session today.','2026-03-30 18:00:00'),(179,'cl010',7,'2026-03-30',NULL,NULL,NULL,'Incline Walk',29,'Good steady walk.','2026-03-30 18:00:00'),(180,'cl010',7,'2026-04-06',NULL,NULL,NULL,'Incline Walk',37,'Cardio session.','2026-04-06 18:00:00'),(181,'cl010',4,'2026-04-06',3,12,32.00,NULL,NULL,'Good pump, happy with this.','2026-04-06 18:00:00'),(182,'cl010',9,'2026-04-13',3,14,NULL,NULL,NULL,'Hit a small PR today.','2026-04-13 21:00:00'),(183,'cl010',4,'2026-04-13',3,12,40.00,NULL,NULL,'Felt strong throughout.','2026-04-13 21:00:00'),(184,'cl010',9,'2026-04-20',3,12,NULL,NULL,NULL,'Recovery was good going in.','2026-04-20 19:00:00'),(185,'cl010',4,'2026-04-20',3,12,31.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-20 19:00:00'),(186,'cl010',9,'2026-04-27',3,17,NULL,NULL,NULL,'Felt strong throughout.','2026-04-27 18:00:00'),(187,'cl010',4,'2026-04-27',3,12,41.00,NULL,NULL,'Steady pace, no issues.','2026-04-27 18:00:00'),(188,'cl010',4,'2026-05-04',3,12,32.00,NULL,NULL,'Energy was high.','2026-05-04 17:00:00'),(189,'cl010',9,'2026-05-04',3,15,NULL,NULL,NULL,'Felt strong throughout.','2026-05-04 17:00:00'),(190,'cl011',1,'2026-03-16',4,8,145.00,NULL,NULL,'Challenging but finished strong.','2026-03-16 18:00:00'),(191,'cl011',5,'2026-03-16',4,8,129.00,NULL,NULL,'Good session today.','2026-03-16 18:00:00'),(192,'cl011',5,'2026-03-23',4,8,114.00,NULL,NULL,'Cardio felt easy today.','2026-03-23 18:00:00'),(193,'cl011',1,'2026-03-23',4,8,131.00,NULL,NULL,'Felt strong throughout.','2026-03-23 18:00:00'),(194,'cl011',11,'2026-03-30',3,10,76.00,NULL,NULL,'Tougher than expected but got it done.','2026-03-30 21:00:00'),(195,'cl011',5,'2026-03-30',4,8,120.00,NULL,NULL,'Form was solid.','2026-03-30 21:00:00'),(196,'cl011',11,'2026-04-06',3,10,74.00,NULL,NULL,'Form was solid.','2026-04-06 19:00:00'),(197,'cl011',5,'2026-04-06',4,8,127.00,NULL,NULL,'Energy was high.','2026-04-06 19:00:00'),(198,'cl011',5,'2026-04-13',4,8,114.00,NULL,NULL,'Good session today.','2026-04-13 17:00:00'),(199,'cl011',11,'2026-04-13',3,10,81.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-13 17:00:00'),(200,'cl011',11,'2026-04-20',3,10,75.00,NULL,NULL,'Energy was high.','2026-04-20 17:00:00'),(201,'cl011',1,'2026-04-20',4,8,126.00,NULL,NULL,'Form was solid.','2026-04-20 17:00:00'),(202,'cl011',11,'2026-04-27',3,10,73.00,NULL,NULL,'Recovery was good going in.','2026-04-27 21:00:00'),(203,'cl011',1,'2026-04-27',4,8,127.00,NULL,NULL,'Good pump, happy with this.','2026-04-27 21:00:00'),(204,'cl011',1,'2026-05-04',4,8,143.00,NULL,NULL,'Felt strong throughout.','2026-05-04 21:00:00'),(205,'cl011',11,'2026-05-04',3,10,84.00,NULL,NULL,'Consistent with last week.','2026-05-04 21:00:00'),(206,'cl012',2,'2026-03-16',3,10,39.00,NULL,NULL,'Good pump, happy with this.','2026-03-16 21:00:00'),(207,'cl012',12,'2026-03-16',3,12,35.00,NULL,NULL,'Good session today.','2026-03-16 21:00:00'),(208,'cl012',2,'2026-03-23',3,10,43.00,NULL,NULL,'Challenging but finished strong.','2026-03-23 20:00:00'),(209,'cl012',9,'2026-03-23',3,13,NULL,NULL,NULL,'Good pump, happy with this.','2026-03-23 20:00:00'),(210,'cl012',12,'2026-03-30',3,12,17.00,NULL,NULL,'Steady pace, no issues.','2026-03-30 17:00:00'),(211,'cl012',9,'2026-03-30',3,14,NULL,NULL,NULL,'Felt strong throughout.','2026-03-30 17:00:00'),(212,'cl012',2,'2026-04-06',3,10,50.00,NULL,NULL,'Cardio felt easy today.','2026-04-06 21:00:00'),(213,'cl012',9,'2026-04-06',3,20,NULL,NULL,NULL,'Recovery was good going in.','2026-04-06 21:00:00'),(214,'cl012',9,'2026-04-13',3,20,NULL,NULL,NULL,'Energy was high.','2026-04-13 21:00:00'),(215,'cl012',12,'2026-04-13',3,12,29.00,NULL,NULL,'Consistent with last week.','2026-04-13 21:00:00'),(216,'cl012',12,'2026-04-20',3,12,40.00,NULL,NULL,'Recovery was good going in.','2026-04-20 17:00:00'),(217,'cl012',9,'2026-04-20',3,13,NULL,NULL,NULL,'Challenging but finished strong.','2026-04-20 17:00:00'),(218,'cl012',12,'2026-04-27',3,12,29.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-27 20:00:00'),(219,'cl012',2,'2026-04-27',3,10,43.00,NULL,NULL,'Steady pace, no issues.','2026-04-27 20:00:00'),(220,'cl012',9,'2026-05-04',3,13,NULL,NULL,NULL,'Steady pace, no issues.','2026-05-04 20:00:00'),(221,'cl012',12,'2026-05-04',3,12,28.00,NULL,NULL,'Steady pace, no issues.','2026-05-04 20:00:00'),(222,'cl013',8,'2026-03-16',3,12,34.00,NULL,NULL,'Challenging but finished strong.','2026-03-16 19:00:00'),(223,'cl013',3,'2026-03-16',3,12,105.00,NULL,NULL,'Felt strong throughout.','2026-03-16 19:00:00'),(224,'cl013',1,'2026-03-23',4,8,138.00,NULL,NULL,'Felt strong throughout.','2026-03-23 17:00:00'),(225,'cl013',8,'2026-03-23',3,12,53.00,NULL,NULL,'Recovery was good going in.','2026-03-23 17:00:00'),(226,'cl013',3,'2026-03-30',3,12,91.00,NULL,NULL,'Cardio felt easy today.','2026-03-30 21:00:00'),(227,'cl013',1,'2026-03-30',4,8,142.00,NULL,NULL,'Consistent with last week.','2026-03-30 21:00:00'),(228,'cl013',3,'2026-04-06',3,12,101.00,NULL,NULL,'Challenging but finished strong.','2026-04-06 20:00:00'),(229,'cl013',1,'2026-04-06',4,8,149.00,NULL,NULL,'Hit a small PR today.','2026-04-06 20:00:00'),(230,'cl013',8,'2026-04-13',3,12,49.00,NULL,NULL,'Energy was high.','2026-04-13 19:00:00'),(231,'cl013',1,'2026-04-13',4,8,136.00,NULL,NULL,'Felt strong throughout.','2026-04-13 19:00:00'),(232,'cl013',8,'2026-04-20',3,12,51.00,NULL,NULL,'Good pump, happy with this.','2026-04-20 18:00:00'),(233,'cl013',1,'2026-04-20',4,8,132.00,NULL,NULL,'Felt strong throughout.','2026-04-20 18:00:00'),(234,'cl013',3,'2026-04-27',3,12,114.00,NULL,NULL,'Energy was high.','2026-04-27 17:00:00'),(235,'cl013',8,'2026-04-27',3,12,48.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-27 17:00:00'),(236,'cl013',3,'2026-05-04',3,12,111.00,NULL,NULL,'Recovery was good going in.','2026-05-04 21:00:00'),(237,'cl013',1,'2026-05-04',4,8,133.00,NULL,NULL,'Good session today.','2026-05-04 21:00:00'),(238,'cl014',4,'2026-03-16',3,12,30.00,NULL,NULL,'Steady pace, no issues.','2026-03-16 19:00:00'),(239,'cl014',6,'2026-03-16',3,60,NULL,NULL,NULL,'Good session today.','2026-03-16 19:00:00'),(240,'cl014',4,'2026-03-23',3,12,41.00,NULL,NULL,'Hit a small PR today.','2026-03-23 21:00:00'),(241,'cl014',7,'2026-03-23',NULL,NULL,NULL,'Incline Walk',22,'Cardio session.','2026-03-23 21:00:00'),(242,'cl014',7,'2026-03-30',NULL,NULL,NULL,'Incline Walk',36,'Cardio session.','2026-03-30 17:00:00'),(243,'cl014',4,'2026-03-30',3,12,32.00,NULL,NULL,'Hit a small PR today.','2026-03-30 17:00:00'),(244,'cl014',6,'2026-04-06',3,60,NULL,NULL,NULL,'Steady pace, no issues.','2026-04-06 18:00:00'),(245,'cl014',7,'2026-04-06',NULL,NULL,NULL,'Incline Walk',29,'Zone 2 cardio.','2026-04-06 18:00:00'),(246,'cl014',6,'2026-04-13',3,60,NULL,NULL,NULL,'Form was solid.','2026-04-13 17:00:00'),(247,'cl014',4,'2026-04-13',3,12,25.00,NULL,NULL,'Cardio felt easy today.','2026-04-13 17:00:00'),(248,'cl014',4,'2026-04-20',3,12,34.00,NULL,NULL,'Challenging but finished strong.','2026-04-20 19:00:00'),(249,'cl014',7,'2026-04-20',NULL,NULL,NULL,'Incline Walk',33,'Good steady walk.','2026-04-20 19:00:00'),(250,'cl014',7,'2026-04-27',NULL,NULL,NULL,'Incline Walk',28,'Cardio session.','2026-04-27 20:00:00'),(251,'cl014',6,'2026-04-27',3,60,NULL,NULL,NULL,'Consistent with last week.','2026-04-27 20:00:00'),(252,'cl014',4,'2026-05-04',3,12,23.00,NULL,NULL,'Energy was high.','2026-05-04 20:00:00'),(253,'cl014',6,'2026-05-04',3,60,NULL,NULL,NULL,'Challenging but finished strong.','2026-05-04 20:00:00'),(254,'cl015',1,'2026-03-16',4,8,146.00,NULL,NULL,'Energy was high.','2026-03-16 21:00:00'),(255,'cl015',11,'2026-03-16',3,10,71.00,NULL,NULL,'Tougher than expected but got it done.','2026-03-16 21:00:00'),(256,'cl015',11,'2026-03-23',3,10,76.00,NULL,NULL,'Energy was high.','2026-03-23 17:00:00'),(257,'cl015',5,'2026-03-23',4,8,116.00,NULL,NULL,'Form was solid.','2026-03-23 17:00:00'),(258,'cl015',11,'2026-03-30',3,10,73.00,NULL,NULL,'Good session today.','2026-03-30 19:00:00'),(259,'cl015',1,'2026-03-30',4,8,140.00,NULL,NULL,'Recovery was good going in.','2026-03-30 19:00:00'),(260,'cl015',11,'2026-04-06',3,10,82.00,NULL,NULL,'Consistent with last week.','2026-04-06 18:00:00'),(261,'cl015',5,'2026-04-06',4,8,132.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-06 18:00:00'),(262,'cl015',1,'2026-04-13',4,8,137.00,NULL,NULL,'Recovery was good going in.','2026-04-13 17:00:00'),(263,'cl015',11,'2026-04-13',3,10,71.00,NULL,NULL,'Hit a small PR today.','2026-04-13 17:00:00'),(264,'cl015',5,'2026-04-20',4,8,120.00,NULL,NULL,'Cardio felt easy today.','2026-04-20 17:00:00'),(265,'cl015',11,'2026-04-20',3,10,83.00,NULL,NULL,'Cardio felt easy today.','2026-04-20 17:00:00'),(266,'cl015',11,'2026-04-27',3,10,73.00,NULL,NULL,'Hit a small PR today.','2026-04-27 19:00:00'),(267,'cl015',1,'2026-04-27',4,8,125.00,NULL,NULL,'Steady pace, no issues.','2026-04-27 19:00:00'),(268,'cl015',5,'2026-05-04',4,8,112.00,NULL,NULL,'Hit a small PR today.','2026-05-04 19:00:00'),(269,'cl015',11,'2026-05-04',3,10,73.00,NULL,NULL,'Tougher than expected but got it done.','2026-05-04 19:00:00'),(270,'cl016',9,'2026-03-16',3,13,NULL,NULL,NULL,'Hit a small PR today.','2026-03-16 21:00:00'),(271,'cl016',6,'2026-03-16',3,60,NULL,NULL,NULL,'Energy was high.','2026-03-16 21:00:00'),(272,'cl016',6,'2026-03-23',3,60,NULL,NULL,NULL,'Steady pace, no issues.','2026-03-23 18:00:00'),(273,'cl016',9,'2026-03-23',3,14,NULL,NULL,NULL,'Felt strong throughout.','2026-03-23 18:00:00'),(274,'cl016',6,'2026-03-30',3,60,NULL,NULL,NULL,'Consistent with last week.','2026-03-30 21:00:00'),(275,'cl016',7,'2026-03-30',NULL,NULL,NULL,'Incline Walk',26,'Good steady walk.','2026-03-30 21:00:00'),(276,'cl016',9,'2026-04-06',3,13,NULL,NULL,NULL,'Form was solid.','2026-04-06 18:00:00'),(277,'cl016',7,'2026-04-06',NULL,NULL,NULL,'Incline Walk',28,'Cardio session.','2026-04-06 18:00:00'),(278,'cl016',7,'2026-04-13',NULL,NULL,NULL,'Incline Walk',25,'Zone 2 cardio.','2026-04-13 17:00:00'),(279,'cl016',6,'2026-04-13',3,60,NULL,NULL,NULL,'Good pump, happy with this.','2026-04-13 17:00:00'),(280,'cl016',9,'2026-04-20',3,17,NULL,NULL,NULL,'Challenging but finished strong.','2026-04-20 21:00:00'),(281,'cl016',6,'2026-04-20',3,60,NULL,NULL,NULL,'Steady pace, no issues.','2026-04-20 21:00:00'),(282,'cl016',7,'2026-04-27',NULL,NULL,NULL,'Incline Walk',35,'Good steady walk.','2026-04-27 17:00:00'),(283,'cl016',9,'2026-04-27',3,16,NULL,NULL,NULL,'Energy was high.','2026-04-27 17:00:00'),(284,'cl016',6,'2026-05-04',3,60,NULL,NULL,NULL,'Consistent with last week.','2026-05-04 19:00:00'),(285,'cl016',7,'2026-05-04',NULL,NULL,NULL,'Incline Walk',22,'Good steady walk.','2026-05-04 19:00:00'),(286,'6fbb7010',4,'2026-03-16',3,12,21.00,NULL,NULL,'Steady pace, no issues.','2026-03-16 17:00:00'),(287,'6fbb7010',7,'2026-03-16',NULL,NULL,NULL,'Incline Walk',29,'Cardio session.','2026-03-16 17:00:00'),(288,'6fbb7010',7,'2026-03-23',NULL,NULL,NULL,'Incline Walk',39,'Zone 2 cardio.','2026-03-23 21:00:00'),(289,'6fbb7010',1,'2026-03-23',4,8,137.00,NULL,NULL,'Good pump, happy with this.','2026-03-23 21:00:00'),(290,'6fbb7010',7,'2026-03-30',NULL,NULL,NULL,'Incline Walk',38,'Zone 2 cardio.','2026-03-30 20:00:00'),(291,'6fbb7010',1,'2026-03-30',4,8,131.00,NULL,NULL,'Steady pace, no issues.','2026-03-30 20:00:00'),(292,'6fbb7010',7,'2026-04-06',NULL,NULL,NULL,'Incline Walk',24,'Cardio session.','2026-04-06 21:00:00'),(293,'6fbb7010',4,'2026-04-06',3,12,34.00,NULL,NULL,'Felt strong throughout.','2026-04-06 21:00:00'),(294,'6fbb7010',4,'2026-04-13',3,12,40.00,NULL,NULL,'Form was solid.','2026-04-13 21:00:00'),(295,'6fbb7010',1,'2026-04-13',4,8,126.00,NULL,NULL,'Tougher than expected but got it done.','2026-04-13 21:00:00'),(296,'6fbb7010',7,'2026-04-20',NULL,NULL,NULL,'Incline Walk',36,'Zone 2 cardio.','2026-04-20 20:00:00'),(297,'6fbb7010',4,'2026-04-20',3,12,39.00,NULL,NULL,'Form was solid.','2026-04-20 20:00:00'),(298,'6fbb7010',4,'2026-04-27',3,12,32.00,NULL,NULL,'Hit a small PR today.','2026-04-27 19:00:00'),(299,'6fbb7010',7,'2026-04-27',NULL,NULL,NULL,'Incline Walk',30,'Zone 2 cardio.','2026-04-27 19:00:00'),(300,'6fbb7010',7,'2026-05-04',NULL,NULL,NULL,'Incline Walk',22,'Good steady walk.','2026-05-04 19:00:00'),(301,'6fbb7010',1,'2026-05-04',4,8,128.00,NULL,NULL,'Consistent with last week.','2026-05-04 19:00:00'),(302,'1c453b6c',4,'2026-03-16',3,12,28.00,NULL,NULL,'Recovery was good going in.','2026-03-16 19:00:00'),(303,'1c453b6c',9,'2026-03-16',3,14,NULL,NULL,NULL,'Steady pace, no issues.','2026-03-16 19:00:00'),(304,'1c453b6c',7,'2026-03-23',NULL,NULL,NULL,'Incline Walk',29,'Zone 2 cardio.','2026-03-23 19:00:00'),(305,'1c453b6c',4,'2026-03-23',3,12,42.00,NULL,NULL,'Challenging but finished strong.','2026-03-23 19:00:00'),(306,'1c453b6c',9,'2026-03-30',3,13,NULL,NULL,NULL,'Energy was high.','2026-03-30 21:00:00'),(307,'1c453b6c',7,'2026-03-30',NULL,NULL,NULL,'Incline Walk',37,'Good steady walk.','2026-03-30 21:00:00'),(308,'1c453b6c',4,'2026-04-06',3,12,41.00,NULL,NULL,'Recovery was good going in.','2026-04-06 18:00:00'),(309,'1c453b6c',9,'2026-04-06',3,20,NULL,NULL,NULL,'Felt strong throughout.','2026-04-06 18:00:00'),(310,'1c453b6c',4,'2026-04-13',3,12,31.00,NULL,NULL,'Good session today.','2026-04-13 21:00:00'),(311,'1c453b6c',9,'2026-04-13',3,17,NULL,NULL,NULL,'Energy was high.','2026-04-13 21:00:00'),(312,'1c453b6c',7,'2026-04-20',NULL,NULL,NULL,'Incline Walk',35,'Cardio session.','2026-04-20 19:00:00'),(313,'1c453b6c',4,'2026-04-20',3,12,27.00,NULL,NULL,'Form was solid.','2026-04-20 19:00:00'),(314,'1c453b6c',7,'2026-04-27',NULL,NULL,NULL,'Incline Walk',23,'Zone 2 cardio.','2026-04-27 19:00:00'),(315,'1c453b6c',4,'2026-04-27',3,12,44.00,NULL,NULL,'Consistent with last week.','2026-04-27 19:00:00'),(316,'1c453b6c',4,'2026-05-04',3,12,44.00,NULL,NULL,'Cardio felt easy today.','2026-05-04 19:00:00'),(317,'1c453b6c',7,'2026-05-04',NULL,NULL,NULL,'Incline Walk',24,'Zone 2 cardio.','2026-05-04 19:00:00'),(318,'32a33897',2,'2026-03-16',3,10,35.00,NULL,NULL,'Recovery was good going in.','2026-03-16 18:00:00'),(319,'32a33897',1,'2026-03-16',4,8,149.00,NULL,NULL,'Cardio felt easy today.','2026-03-16 18:00:00'),(320,'32a33897',1,'2026-03-23',4,8,138.00,NULL,NULL,'Steady pace, no issues.','2026-03-23 17:00:00'),(321,'32a33897',2,'2026-03-23',3,10,51.00,NULL,NULL,'Recovery was good going in.','2026-03-23 17:00:00'),(322,'32a33897',1,'2026-03-30',4,8,134.00,NULL,NULL,'Recovery was good going in.','2026-03-30 21:00:00'),(323,'32a33897',2,'2026-03-30',3,10,55.00,NULL,NULL,'Good pump, happy with this.','2026-03-30 21:00:00'),(324,'32a33897',1,'2026-04-06',4,8,150.00,NULL,NULL,'Good pump, happy with this.','2026-04-06 19:00:00'),(325,'32a33897',7,'2026-04-06',NULL,NULL,NULL,'Incline Walk',26,'Good steady walk.','2026-04-06 19:00:00'),(326,'32a33897',7,'2026-04-13',NULL,NULL,NULL,'Incline Walk',29,'Good steady walk.','2026-04-13 20:00:00'),(327,'32a33897',2,'2026-04-13',3,10,46.00,NULL,NULL,'Consistent with last week.','2026-04-13 20:00:00'),(328,'32a33897',2,'2026-04-20',3,10,55.00,NULL,NULL,'Cardio felt easy today.','2026-04-20 18:00:00'),(329,'32a33897',1,'2026-04-20',4,8,129.00,NULL,NULL,'Energy was high.','2026-04-20 18:00:00'),(330,'32a33897',1,'2026-04-27',4,8,142.00,NULL,NULL,'Felt strong throughout.','2026-04-27 19:00:00'),(331,'32a33897',2,'2026-04-27',3,10,52.00,NULL,NULL,'Consistent with last week.','2026-04-27 19:00:00'),(332,'32a33897',1,'2026-05-04',4,8,149.00,NULL,NULL,'Form was solid.','2026-05-04 17:00:00'),(333,'32a33897',2,'2026-05-04',3,10,38.00,NULL,NULL,'Good pump, happy with this.','2026-05-04 17:00:00'),(334,'cl017',2,'2026-03-16',3,10,37.00,NULL,NULL,'Good pump, happy with this.','2026-03-16 17:00:00'),(335,'cl017',11,'2026-03-16',3,10,81.00,NULL,NULL,'Good session today.','2026-03-16 17:00:00'),(336,'cl017',11,'2026-03-23',3,10,86.00,NULL,NULL,'Steady pace, no issues.','2026-03-23 20:00:00'),(337,'cl017',1,'2026-03-23',4,8,132.00,NULL,NULL,'Hit a small PR today.','2026-03-23 20:00:00'),(338,'cl017',1,'2026-03-30',4,8,125.00,NULL,NULL,'Steady pace, no issues.','2026-03-30 18:00:00'),(339,'cl017',2,'2026-03-30',3,10,33.00,NULL,NULL,'Recovery was good going in.','2026-03-30 18:00:00'),(340,'cl017',5,'2026-04-06',4,8,111.00,NULL,NULL,'Energy was high.','2026-04-06 18:00:00'),(341,'cl017',1,'2026-04-06',4,8,140.00,NULL,NULL,'Recovery was good going in.','2026-04-06 18:00:00'),(342,'cl017',2,'2026-04-13',3,10,44.00,NULL,NULL,'Cardio felt easy today.','2026-04-13 20:00:00'),(343,'cl017',5,'2026-04-13',4,8,110.00,NULL,NULL,'Felt strong throughout.','2026-04-13 20:00:00'),(344,'cl017',1,'2026-04-20',4,8,129.00,NULL,NULL,'Consistent with last week.','2026-04-20 18:00:00'),(345,'cl017',2,'2026-04-20',3,10,53.00,NULL,NULL,'Cardio felt easy today.','2026-04-20 18:00:00'),(346,'cl017',11,'2026-04-27',3,10,77.00,NULL,NULL,'Energy was high.','2026-04-27 19:00:00'),(347,'cl017',1,'2026-04-27',4,8,128.00,NULL,NULL,'Good session today.','2026-04-27 19:00:00'),(348,'cl017',2,'2026-05-04',3,10,44.00,NULL,NULL,'Felt strong throughout.','2026-05-04 21:00:00'),(349,'cl017',11,'2026-05-04',3,10,73.00,NULL,NULL,'Good pump, happy with this.','2026-05-04 21:00:00'),(350,'cl018',4,'2026-03-16',3,12,38.00,NULL,NULL,'Tougher than expected but got it done.','2026-03-16 21:00:00'),(351,'cl018',9,'2026-03-16',3,14,NULL,NULL,NULL,'Energy was high.','2026-03-16 21:00:00'),(352,'cl018',7,'2026-03-23',NULL,NULL,NULL,'Incline Walk',31,'Cardio session.','2026-03-23 21:00:00'),(353,'cl018',4,'2026-03-23',3,12,38.00,NULL,NULL,'Hit a small PR today.','2026-03-23 21:00:00'),(354,'cl018',6,'2026-03-30',3,60,NULL,NULL,NULL,'Consistent with last week.','2026-03-30 17:00:00'),(355,'cl018',9,'2026-03-30',3,17,NULL,NULL,NULL,'Felt strong throughout.','2026-03-30 17:00:00'),(356,'cl018',4,'2026-04-06',3,12,21.00,NULL,NULL,'Challenging but finished strong.','2026-04-06 20:00:00'),(357,'cl018',6,'2026-04-06',3,60,NULL,NULL,NULL,'Hit a small PR today.','2026-04-06 20:00:00'),(358,'cl018',9,'2026-04-13',3,17,NULL,NULL,NULL,'Felt strong throughout.','2026-04-13 17:00:00'),(359,'cl018',6,'2026-04-13',3,60,NULL,NULL,NULL,'Steady pace, no issues.','2026-04-13 17:00:00'),(360,'cl018',6,'2026-04-20',3,60,NULL,NULL,NULL,'Cardio felt easy today.','2026-04-20 17:00:00'),(361,'cl018',9,'2026-04-20',3,17,NULL,NULL,NULL,'Form was solid.','2026-04-20 17:00:00'),(362,'cl018',4,'2026-04-27',3,12,30.00,NULL,NULL,'Challenging but finished strong.','2026-04-27 21:00:00'),(363,'cl018',6,'2026-04-27',3,60,NULL,NULL,NULL,'Form was solid.','2026-04-27 21:00:00'),(364,'cl018',7,'2026-05-04',NULL,NULL,NULL,'Incline Walk',40,'Cardio session.','2026-05-04 20:00:00'),(365,'cl018',9,'2026-05-04',3,14,NULL,NULL,NULL,'Felt strong throughout.','2026-05-04 20:00:00'),(366,'cl019',12,'2026-03-16',3,12,21.00,NULL,NULL,'Good session today.','2026-03-16 19:00:00'),(367,'cl019',1,'2026-03-16',4,8,150.00,NULL,NULL,'Tougher than expected but got it done.','2026-03-16 19:00:00'),(368,'cl019',1,'2026-03-23',4,8,141.00,NULL,NULL,'Hit a small PR today.','2026-03-23 19:00:00'),(369,'cl019',5,'2026-03-23',4,8,127.00,NULL,NULL,'Good pump, happy with this.','2026-03-23 19:00:00'),(370,'cl019',11,'2026-03-30',3,10,79.00,NULL,NULL,'Steady pace, no issues.','2026-03-30 18:00:00'),(371,'cl019',1,'2026-03-30',4,8,149.00,NULL,NULL,'Good session today.','2026-03-30 18:00:00'),(372,'cl019',11,'2026-04-06',3,10,95.00,NULL,NULL,'Steady pace, no issues.','2026-04-06 17:00:00'),(373,'cl019',5,'2026-04-06',4,8,123.00,NULL,NULL,'Hit a small PR today.','2026-04-06 17:00:00'),(374,'cl019',12,'2026-04-13',3,12,20.00,NULL,NULL,'Good pump, happy with this.','2026-04-13 19:00:00'),(375,'cl019',5,'2026-04-13',4,8,132.00,NULL,NULL,'Good pump, happy with this.','2026-04-13 19:00:00'),(376,'cl019',11,'2026-04-20',3,10,95.00,NULL,NULL,'Felt strong throughout.','2026-04-20 19:00:00'),(377,'cl019',12,'2026-04-20',3,12,38.00,NULL,NULL,'Hit a small PR today.','2026-04-20 19:00:00'),(378,'cl019',1,'2026-04-27',4,8,130.00,NULL,NULL,'Consistent with last week.','2026-04-27 21:00:00'),(379,'cl019',5,'2026-04-27',4,8,119.00,NULL,NULL,'Steady pace, no issues.','2026-04-27 21:00:00'),(380,'cl019',1,'2026-05-04',4,8,146.00,NULL,NULL,'Energy was high.','2026-05-04 19:00:00'),(381,'cl019',12,'2026-05-04',3,12,24.00,NULL,NULL,'Good pump, happy with this.','2026-05-04 19:00:00'),(382,'cl020',7,'2026-03-16',NULL,NULL,NULL,'Incline Walk',31,'Good steady walk.','2026-03-16 20:00:00'),(383,'cl020',4,'2026-03-16',3,12,21.00,NULL,NULL,'Recovery was good going in.','2026-03-16 20:00:00'),(384,'cl020',12,'2026-03-23',3,12,23.00,NULL,NULL,'Challenging but finished strong.','2026-03-23 20:00:00'),(385,'cl020',7,'2026-03-23',NULL,NULL,NULL,'Incline Walk',21,'Cardio session.','2026-03-23 20:00:00'),(386,'cl020',7,'2026-03-30',NULL,NULL,NULL,'Incline Walk',25,'Cardio session.','2026-03-30 21:00:00'),(387,'cl020',9,'2026-03-30',3,14,NULL,NULL,NULL,'Cardio felt easy today.','2026-03-30 21:00:00'),(388,'cl020',7,'2026-04-06',NULL,NULL,NULL,'Incline Walk',22,'Cardio session.','2026-04-06 18:00:00'),(389,'cl020',4,'2026-04-06',3,12,44.00,NULL,NULL,'Challenging but finished strong.','2026-04-06 18:00:00'),(390,'cl020',12,'2026-04-13',3,12,33.00,NULL,NULL,'Good session today.','2026-04-13 20:00:00'),(391,'cl020',9,'2026-04-13',3,14,NULL,NULL,NULL,'Challenging but finished strong.','2026-04-13 20:00:00'),(392,'cl020',7,'2026-04-20',NULL,NULL,NULL,'Incline Walk',34,'Cardio session.','2026-04-20 19:00:00'),(393,'cl020',9,'2026-04-20',3,14,NULL,NULL,NULL,'Consistent with last week.','2026-04-20 19:00:00'),(394,'cl020',12,'2026-04-27',3,12,35.00,NULL,NULL,'Energy was high.','2026-04-27 19:00:00'),(395,'cl020',9,'2026-04-27',3,15,NULL,NULL,NULL,'Felt strong throughout.','2026-04-27 19:00:00'),(396,'cl020',4,'2026-05-04',3,12,35.00,NULL,NULL,'Consistent with last week.','2026-05-04 18:00:00'),(397,'cl020',12,'2026-05-04',3,12,27.00,NULL,NULL,'Consistent with last week.','2026-05-04 18:00:00');
/*!40000 ALTER TABLE `workout_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workout_plan`
--

DROP TABLE IF EXISTS `workout_plan`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workout_plan` (
  `workout_plan_id` int NOT NULL AUTO_INCREMENT,
  `client_id` varchar(50) NOT NULL,
  `created_by` varchar(50) DEFAULT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `difficulty` varchar(50) DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_draft` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`workout_plan_id`),
  KEY `idx_workout_plan_client_id` (`client_id`),
  KEY `idx_workout_plan_created_by` (`created_by`),
  CONSTRAINT `fk_workout_plan_client` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `workout_plan_client_FK` FOREIGN KEY (`created_by`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_plan`
--

LOCK TABLES `workout_plan` WRITE;
/*!40000 ALTER TABLE `workout_plan` DISABLE KEYS */;
INSERT INTO `workout_plan` VALUES (1,'cl001','cl017','4x/week','Intermediate','2026-03-05 14:00:00',0),(2,'cl002','cl017','3x/week','Beginner','2026-03-05 14:15:00',0),(3,'cl003','cl019','5x/week','Intermediate','2026-03-05 14:30:00',0),(4,'cl004','cl020','4x/week','Beginner','2026-03-05 14:45:00',0),(5,'cl005','cl017','5x/week','Advanced','2026-03-05 15:00:00',0),(6,'cl006','cl017','3x/week','Beginner','2026-03-05 15:15:00',1),(7,'cl007','cl019','4x/week','Intermediate','2026-03-05 15:30:00',0),(8,'cl008','cl020','3x/week','Beginner','2026-03-05 15:45:00',0),(9,'cl009','cl017','4x/week','Intermediate','2026-03-05 16:00:00',0),(10,'cl010','cl017','3x/week','Beginner','2026-03-05 16:15:00',0),(11,'cl011','cl019','5x/week','Advanced','2026-03-05 16:30:00',0),(12,'cl012','cl020','4x/week','Intermediate','2026-03-05 16:45:00',0),(14,'cl013','cl017','3','Intermediate','2026-04-09 21:09:10',0),(17,'cl001','cl017','4','Beginner','2026-05-08 22:02:02',1),(18,'6fbb7010','cl017','3x per week','Beginner','2026-05-09 00:57:51',1),(19,'cl019','cl017','3','Intermediate','2026-05-10 07:18:38',0);
/*!40000 ALTER TABLE `workout_plan` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `workout_plan_exercises`
--

DROP TABLE IF EXISTS `workout_plan_exercises`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `workout_plan_exercises` (
  `id` int NOT NULL AUTO_INCREMENT,
  `workout_plan_id` int NOT NULL,
  `exercise_id` int NOT NULL,
  `day_of_week` enum('Mon','Tue','Wed','Thu','Fri','Sat','Sun') DEFAULT NULL,
  `sets` int DEFAULT NULL,
  `repetitions` int DEFAULT NULL,
  `order_in_day` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_workout_plan_exercises_workout_plan_id` (`workout_plan_id`),
  KEY `idx_workout_plan_exercises_exercise_id` (`exercise_id`),
  CONSTRAINT `fk_workout_plan_exercises_exercise` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`exercise_id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_workout_plan_exercises_workout_plan` FOREIGN KEY (`workout_plan_id`) REFERENCES `workout_plan` (`workout_plan_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_plan_exercises`
--

LOCK TABLES `workout_plan_exercises` WRITE;
/*!40000 ALTER TABLE `workout_plan_exercises` DISABLE KEYS */;
INSERT INTO `workout_plan_exercises` VALUES (1,1,1,'Mon',4,8,1),(2,1,2,'Mon',3,10,2),(3,1,6,'Mon',3,45,3),(4,2,4,'Tue',3,12,1),(5,3,3,'Wed',4,10,1),(6,3,5,'Wed',4,8,2),(7,4,6,'Thu',3,30,1),(8,5,1,'Fri',5,5,1),(9,5,5,'Fri',4,6,2),(10,6,9,'Sat',3,15,1),(11,7,11,'Mon',4,10,1),(12,8,12,'Tue',3,12,1),(13,9,1,'Wed',4,8,1),(14,10,7,'Thu',1,20,1),(15,11,5,'Fri',4,6,1),(16,12,2,'Sat',3,10,1),(17,17,1,'Mon',3,10,1),(18,19,12,'Mon',5,2,1),(19,19,2,'Mon',1,10,2),(20,19,9,'Wed',1,5,1);
/*!40000 ALTER TABLE `workout_plan_exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'railway'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-10  4:28:30
