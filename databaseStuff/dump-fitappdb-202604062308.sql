-- MySQL dump 10.13  Distrib 9.6.0, for macos26.3 (arm64)
--
-- Host: localhost    Database: fitappdb
-- ------------------------------------------------------
-- Server version	9.6.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '9e8fccdc-31f4-11f1-822d-aa92dda088c9:1-120';

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
INSERT INTO `client` VALUES ('cl001','Frank','Torres','2001-05-12',175.50,70.00,'Male','cl017','premium','client','frank.torres@fitapp.com','9735551001','2026-03-01','pass123'),('cl002','Sarah','Johnson','1998-11-03',135.20,65.00,'Female','cl018','basic','client','sarah.johnson@fitapp.com','9735551002','2026-03-01','pass123'),('cl003','Michael','Chen','1995-07-22',182.00,72.50,'Male','cl019','premium','client','michael.chen@fitapp.com','9735551003','2026-03-02','pass123'),('cl004','Emily','Garcia','2000-09-14',125.75,64.00,'Female','cl020','basic','client','emily.garcia@fitapp.com','9735551004','2026-03-02','pass123'),('cl005','David','Smith','1997-03-30',190.10,73.00,'Male','cl017','premium','client','david.smith@fitapp.com','9735551005','2026-03-03','pass123'),('cl006','Olivia','Brown','2002-01-18',118.40,63.00,'Female','cl018','basic','client','olivia.brown@fitapp.com','9735551006','2026-03-03','pass123'),('cl007','James','Anderson','1996-04-28',185.30,71.50,'Male','cl019','premium','client','james.anderson@fitapp.com','9735551007','2026-03-04','pass123'),('cl008','Ava','Wilson','1999-12-05',130.60,66.00,'Female','cl020','basic','client','ava.wilson@fitapp.com','9735551008','2026-03-04','pass123'),('cl009','Noah','Taylor','1994-08-17',172.80,69.00,'Male','cl017','premium','client','noah.taylor@fitapp.com','9735551009','2026-03-05','pass123'),('cl010','Sophia','Moore','2001-02-09',122.30,64.50,'Female','cl018','basic','client','sophia.moore@fitapp.com','9735551010','2026-03-05','pass123'),('cl011','Liam','Jackson','1993-10-11',198.20,74.00,'Male','cl019','premium','client','liam.jackson@fitapp.com','9735551011','2026-03-06','pass123'),('cl012','Mia','White','2000-06-21',127.40,65.20,'Female','cl020','premium','client','mia.white@fitapp.com','9735551012','2026-03-06','pass123'),('cl013','Ethan','Harris','1998-01-07',188.90,72.00,'Male','cl017','basic','client','ethan.harris@fitapp.com','9735551013','2026-03-07','pass123'),('cl014','Charlotte','Martin','2002-07-19',119.50,63.70,'Female','cl018','premium','client','charlotte.martin@fitapp.com','9735551014','2026-03-07','pass123'),('cl015','Lucas','Thompson','1997-09-25',181.00,71.20,'Male','cl019','basic','client','lucas.thompson@fitapp.com','9735551015','2026-03-08','pass123'),('cl016','Amelia','Davis','1999-03-13',124.80,64.10,'Female','cl020','premium','client','amelia.davis@fitapp.com','9735551016','2026-03-08','pass123'),('cl017','Daniel','Martinez','1994-06-11',205.00,74.00,'Male',NULL,'premium','coach','daniel.martinez@fitapp.com','9735551017','2026-03-09','pass123'),('cl018','Mia','Thomas','1999-08-19',120.00,64.50,'Female',NULL,'premium','coach','mia.thomas@fitapp.com','9735551018','2026-03-09','pass123'),('cl019','Chris','Walker','1992-12-02',210.40,75.00,'Male',NULL,'premium','coach','chris.walker@fitapp.com','9735551019','2026-03-10','pass123'),('cl020','Grace','Lee','1996-05-27',126.10,65.80,'Female',NULL,'premium','coach','grace.lee@fitapp.com','9735551020','2026-03-10','pass123');
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
  PRIMARY KEY (`application_id`),
  KEY `idx_coach_app_client_id` (`client_id`),
  KEY `idx_coach_app_reviewed_by` (`reviewed_by`),
  CONSTRAINT `fk_coach_applications_admin` FOREIGN KEY (`reviewed_by`) REFERENCES `admin` (`admin_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach_applications`
--

LOCK TABLES `coach_applications` WRITE;
/*!40000 ALTER TABLE `coach_applications` DISABLE KEYS */;
INSERT INTO `coach_applications` VALUES (1,'cl009','fitness','ACE Personal Trainer','Interested in beginner strength coaching.',79.99,'pending','2026-03-08 14:00:00',NULL,NULL),(2,'cl011','both','NASM CPT, Nutrition Cert','Experienced in body recomposition.',95.00,'approved','2026-03-07 14:30:00',1,'2026-03-09 16:00:00'),(3,'cl014','nutrition','Sports Nutrition Course','Focused on sustainable meal planning.',70.00,'declined','2026-03-06 19:15:00',2,'2026-03-08 20:45:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach_request`
--

LOCK TABLES `coach_request` WRITE;
/*!40000 ALTER TABLE `coach_request` DISABLE KEYS */;
INSERT INTO `coach_request` VALUES (1,'cl002','cl017','pending'),(2,'cl004','cl019','pending'),(3,'cl006','cl017','accepted'),(4,'cl008','cl019','accepted'),(5,'cl010','cl020','rejected'),(6,'cl012','cl017','pending'),(7,'cl013','cl018','accepted'),(8,'cl015','cl020','rejected'),(9,'cl016','cl019','pending'),(10,'cl001','cl020','accepted');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercises`
--

LOCK TABLES `exercises` WRITE;
/*!40000 ALTER TABLE `exercises` DISABLE KEYS */;
INSERT INTO `exercises` VALUES (1,'Barbell Bench Press','Barbell','Chest','Strength','https://example.com/bench',0,NULL),(2,'Dumbbell Shoulder Press','Dumbbell','Shoulders','Strength','https://example.com/press',0,NULL),(3,'Lat Pulldown','Machine','Back','Strength','https://example.com/pulldown',0,NULL),(4,'Goblet Squat','Dumbbell','Legs','Strength','https://example.com/squat',0,NULL),(5,'Romanian Deadlift','Barbell','Hamstrings','Strength','https://example.com/rdl',0,NULL),(6,'Plank','Bodyweight','Core','Core','https://example.com/plank',0,NULL),(7,'Incline Walk','Treadmill','Cardio','Cardio','https://example.com/walk',0,NULL),(8,'Cable Tricep Pushdown','Cable','Arms','Strength','https://example.com/tricep',0,NULL),(9,'Glute Bridge','Bodyweight','Glutes','Strength','https://example.com/glute',1,'cl017'),(10,'Conditioning Circuit','None','Full Body','Conditioning','https://example.com/circuit',1,'cl018'),(11,'Seated Row','Machine','Back','Strength','https://example.com/row',0,NULL),(12,'Walking Lunges','Dumbbell','Legs','Strength','https://example.com/lunges',0,NULL);
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goals`
--

LOCK TABLES `goals` WRITE;
/*!40000 ALTER TABLE `goals` DISABLE KEYS */;
INSERT INTO `goals` VALUES (1,'cl001',168.00,9000,1.50,4),(2,'cl002',128.00,8000,1.00,3),(3,'cl003',175.00,10000,1.25,5),(4,'cl004',120.00,8500,1.00,4),(5,'cl005',185.00,9500,1.75,5),(6,'cl006',115.00,7000,0.75,3),(7,'cl007',178.00,9000,1.50,4),(8,'cl008',125.00,8200,1.00,3),(9,'cl009',168.00,10000,1.25,5),(10,'cl010',118.00,7800,1.00,3),(11,'cl011',190.00,10500,1.75,5),(12,'cl012',122.00,8400,1.25,4),(13,'cl013',180.00,8800,1.50,4),(14,'cl014',116.00,7600,0.75,3),(15,'cl015',176.00,9200,1.25,4),(16,'cl016',120.00,8000,1.00,3);
/*!40000 ALTER TABLE `goals` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logging`
--

LOCK TABLES `logging` WRITE;
/*!40000 ALTER TABLE `logging` DISABLE KEYS */;
INSERT INTO `logging` VALUES (1,'cl001','2026-03-10',8421,2280),(2,'cl002','2026-03-10',7030,1825),(3,'cl003','2026-03-10',9650,2410),(4,'cl004','2026-03-10',8112,1770),(5,'cl005','2026-03-10',10245,2555),(6,'cl006','2026-03-10',6894,1690),(7,'cl007','2026-03-10',9340,2210),(8,'cl008','2026-03-10',7520,1800),(9,'cl009','2026-03-10',9985,2360),(10,'cl010','2026-03-10',7840,1755),(11,'cl011','2026-03-10',10820,2620),(12,'cl012','2026-03-10',8160,1845),(13,'cl013','2026-03-10',8890,2265),(14,'cl014','2026-03-10',7415,1710),(15,'cl015','2026-03-10',9120,2325),(16,'cl016','2026-03-10',7985,1790);
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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meal_log`
--

LOCK TABLES `meal_log` WRITE;
/*!40000 ALTER TABLE `meal_log` DISABLE KEYS */;
INSERT INTO `meal_log` VALUES (1,'cl001',1,'2026-03-10',510,'Finished everything.','2026-03-10 12:20:00'),(2,'cl001',2,'2026-03-10',700,'Extra rice portion.','2026-03-10 17:15:00'),(3,'cl002',3,'2026-03-10',360,'Skipped granola.','2026-03-10 12:40:00'),(4,'cl002',4,'2026-03-10',500,'No dressing.','2026-03-10 16:50:00'),(5,'cl003',5,'2026-03-10',455,'As planned.','2026-03-10 16:20:00'),(6,'cl004',6,'2026-03-10',330,'Post workout shake.','2026-03-10 11:45:00'),(7,'cl005',7,'2026-03-10',735,'Large dinner.','2026-03-10 22:40:00'),(8,'cl006',8,'2026-03-10',400,'Used less avocado.','2026-03-10 13:25:00'),(9,'cl007',9,'2026-03-10',500,'Good breakfast.','2026-03-10 12:10:00'),(10,'cl008',10,'2026-03-10',420,'Light lunch.','2026-03-10 17:20:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meals`
--

LOCK TABLES `meals` WRITE;
/*!40000 ALTER TABLE `meals` DISABLE KEYS */;
INSERT INTO `meals` VALUES (1,1,'Protein Breakfast','Eggs, oats, fruit',520,35.00,48.00,18.00,'08:00:00',1),(2,1,'Chicken Rice Lunch','Chicken breast with rice',680,48.00,72.00,14.00,'13:00:00',1),(3,2,'Greek Yogurt Bowl','Yogurt, berries, granola',380,24.00,42.00,10.00,'08:30:00',1),(4,2,'Salmon Salad','Salmon with mixed greens',510,38.00,22.00,26.00,'12:30:00',1),(5,3,'Turkey Wrap','Turkey, tortilla, veggies',450,32.00,40.00,14.00,'12:00:00',1),(6,4,'Protein Smoothie','Whey, banana, almond milk',330,30.00,28.00,8.00,'07:30:00',1),(7,5,'Beef Pasta Bowl','Lean beef and pasta',710,46.00,76.00,18.00,'18:00:00',1),(8,6,'Avocado Toast','Toast, avocado, eggs',410,18.00,30.00,22.00,'09:00:00',1),(9,7,'Oatmeal Bowl','Oats, peanut butter, fruit',490,20.00,58.00,16.00,'08:00:00',1),(10,8,'Chicken Salad','Chicken with greens',430,36.00,18.00,20.00,'13:00:00',1),(11,9,'Rice and Steak','Steak with jasmine rice',690,44.00,70.00,16.00,'18:30:00',1),(12,10,'Cottage Cheese Bowl','Cottage cheese and fruit',320,26.00,24.00,8.00,'08:15:00',1);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'cl001','cl017','Hey coach, can we adjust my workout?','2026-03-10 14:00:00',1),(2,'cl017','cl001','Sure, let us reduce volume this week.','2026-03-10 14:15:00',1),(3,'cl002','cl018','Can I swap salmon for chicken?','2026-03-10 15:00:00',1),(4,'cl018','cl002','Yes, just keep protein about the same.','2026-03-10 15:05:00',0),(5,'cl011','cl019','Can we add another leg day?','2026-03-10 19:10:00',1),(6,'cl020','cl016','Reminder: focus on form this session.','2026-03-10 22:30:00',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mood_log`
--

LOCK TABLES `mood_log` WRITE;
/*!40000 ALTER TABLE `mood_log` DISABLE KEYS */;
INSERT INTO `mood_log` VALUES (1,'cl001','2026-03-10',4,'Good','Strong workout today.','2026-03-11 00:00:00'),(2,'cl002','2026-03-10',3,'Okay','A little tired after work.','2026-03-11 00:10:00'),(3,'cl003','2026-03-10',5,'Great','Hit a new PR.','2026-03-11 00:20:00'),(4,'cl004','2026-03-10',2,'Low','Poor sleep last night.','2026-03-11 00:30:00'),(5,'cl005','2026-03-10',4,'Motivated','Meal plan is going well.','2026-03-11 00:40:00'),(6,'cl006','2026-03-10',3,'Neutral','Rest day.','2026-03-11 00:50:00');
/*!40000 ALTER TABLE `mood_log` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,'cl001','workout','Workout Reminder','Your workout is scheduled today.',0,'in_app','2026-03-10 11:00:00'),(2,'cl002','nutrition','Meal Reminder','Log your lunch.',1,'in_app','2026-03-10 16:00:00'),(3,'cl003','coach','Coach Message','You have a new message.',0,'in_app','2026-03-10 14:16:00'),(4,'cl010','system','Progress Check','Please update your weekly check-in.',0,'email','2026-03-11 13:00:00'),(5,'cl015','nutrition','Plan Updated','Your meal plan has been updated.',0,'in_app','2026-03-11 17:00:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nutrition_plan`
--

LOCK TABLES `nutrition_plan` WRITE;
/*!40000 ALTER TABLE `nutrition_plan` DISABLE KEYS */;
INSERT INTO `nutrition_plan` VALUES (1,'cl001','cl018','Lean Bulk'),(2,'cl002','cl018','Fat Loss'),(3,'cl003','cl019','Maintenance'),(4,'cl004','cl018','Fat Loss'),(5,'cl005','cl018','Performance'),(6,'cl006','cl018','Light Deficit'),(7,'cl007','cl019','Maintenance'),(8,'cl008','cl018','Fat Loss'),(9,'cl009','cl018','Lean Bulk'),(10,'cl010','cl018','Fat Loss'),(11,'cl011','cl019','Performance'),(12,'cl012','cl018','Maintenance');
/*!40000 ALTER TABLE `nutrition_plan` ENABLE KEYS */;
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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
INSERT INTO `reports` VALUES (1,'cl001','cl005','Spam','Repeated off-topic messages.','reviewed','2026-03-09 19:00:00',1,NULL),(2,'cl002','cl003','Harassment','Message tone felt inappropriate.','resolved','2026-03-08 22:20:00',2,'2026-03-10 13:00:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,'cl017','cl001',5,'Great coach.','2026-03-11 21:00:00'),(2,'cl018','cl002',4,'Helpful nutrition advice.','2026-03-11 21:10:00'),(3,'cl019','cl011',5,'Really motivating and helpful.','2026-03-11 21:20:00'),(4,'cl020','cl016',4,'Good explanations and support.','2026-03-11 21:30:00');
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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_log`
--

LOCK TABLES `workout_log` WRITE;
/*!40000 ALTER TABLE `workout_log` DISABLE KEYS */;
INSERT INTO `workout_log` VALUES (1,'cl001',1,'2026-03-10',4,8,155.00,NULL,NULL,'Bench felt smooth.','2026-03-10 22:00:00'),(2,'cl001',2,'2026-03-10',3,10,40.00,NULL,NULL,'Shoulders were fatigued.','2026-03-10 22:20:00'),(3,'cl002',4,'2026-03-10',3,12,35.00,NULL,NULL,'Good form today.','2026-03-10 21:30:00'),(4,'cl003',3,'2026-03-10',4,10,120.00,NULL,NULL,'Back pump was great.','2026-03-10 23:00:00'),(5,'cl003',5,'2026-03-10',4,8,185.00,NULL,NULL,'Solid hinge pattern.','2026-03-10 23:25:00'),(6,'cl002',7,'2026-03-11',NULL,NULL,NULL,'Incline Walk',20,'Cardio finish.','2026-03-11 20:00:00'),(7,'cl007',11,'2026-03-11',4,10,100.00,NULL,NULL,'Rows felt controlled.','2026-03-11 22:10:00'),(8,'cl008',12,'2026-03-11',3,12,20.00,NULL,NULL,'Lunges burned.','2026-03-11 22:30:00'),(9,'cl009',1,'2026-03-11',4,8,145.00,NULL,NULL,'Good tempo.','2026-03-11 23:00:00'),(10,'cl010',7,'2026-03-11',NULL,NULL,NULL,'Incline Walk',25,'Long cardio session.','2026-03-11 23:15:00'),(11,'cl011',5,'2026-03-11',4,6,205.00,NULL,NULL,'Heavy but solid.','2026-03-11 23:30:00'),(12,'cl012',2,'2026-03-11',3,10,30.00,NULL,NULL,'Shoulders felt good.','2026-03-11 23:40:00');
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
  CONSTRAINT `fk_workout_plan_created_by` FOREIGN KEY (`created_by`) REFERENCES `fitness_coach` (`coach_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_plan`
--

LOCK TABLES `workout_plan` WRITE;
/*!40000 ALTER TABLE `workout_plan` DISABLE KEYS */;
INSERT INTO `workout_plan` VALUES (1,'cl001','cl017','4x/week','Intermediate','2026-03-05 14:00:00',0),(2,'cl002','cl017','3x/week','Beginner','2026-03-05 14:15:00',0),(3,'cl003','cl019','5x/week','Intermediate','2026-03-05 14:30:00',0),(4,'cl004','cl020','4x/week','Beginner','2026-03-05 14:45:00',0),(5,'cl005','cl017','5x/week','Advanced','2026-03-05 15:00:00',0),(6,'cl006','cl017','3x/week','Beginner','2026-03-05 15:15:00',1),(7,'cl007','cl019','4x/week','Intermediate','2026-03-05 15:30:00',0),(8,'cl008','cl020','3x/week','Beginner','2026-03-05 15:45:00',0),(9,'cl009','cl017','4x/week','Intermediate','2026-03-05 16:00:00',0),(10,'cl010','cl017','3x/week','Beginner','2026-03-05 16:15:00',0),(11,'cl011','cl019','5x/week','Advanced','2026-03-05 16:30:00',0),(12,'cl012','cl020','4x/week','Intermediate','2026-03-05 16:45:00',0);
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
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_plan_exercises`
--

LOCK TABLES `workout_plan_exercises` WRITE;
/*!40000 ALTER TABLE `workout_plan_exercises` DISABLE KEYS */;
INSERT INTO `workout_plan_exercises` VALUES (1,1,1,'Mon',4,8,1),(2,1,2,'Mon',3,10,2),(3,1,6,'Mon',3,45,3),(4,2,4,'Tue',3,12,1),(5,3,3,'Wed',4,10,1),(6,3,5,'Wed',4,8,2),(7,4,6,'Thu',3,30,1),(8,5,1,'Fri',5,5,1),(9,5,5,'Fri',4,6,2),(10,6,9,'Sat',3,15,1),(11,7,11,'Mon',4,10,1),(12,8,12,'Tue',3,12,1),(13,9,1,'Wed',4,8,1),(14,10,7,'Thu',1,20,1),(15,11,5,'Fri',4,6,1),(16,12,2,'Sat',3,10,1);
/*!40000 ALTER TABLE `workout_plan_exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'fitappdb'
--
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-04-06 23:08:35
