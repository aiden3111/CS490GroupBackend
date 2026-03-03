-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: fitappdb
-- ------------------------------------------------------
-- Server version	8.0.44

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
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin`
--

LOCK TABLES `admin` WRITE;
/*!40000 ALTER TABLE `admin` DISABLE KEYS */;
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
  UNIQUE KEY `email` (`email`),
  KEY `fk_client_coach` (`coach_id`),
  CONSTRAINT `fk_client_coach` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`coach_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `client`
--

LOCK TABLES `client` WRITE;
/*!40000 ALTER TABLE `client` DISABLE KEYS */;
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
  `specialty` enum('fitness','nutrition','both') DEFAULT NULL,
  `certifications` text,
  `availability` text,
  `status` enum('pending','active','suspended') DEFAULT 'pending',
  PRIMARY KEY (`coach_id`),
  CONSTRAINT `coach_ibfk_1` FOREIGN KEY (`coach_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach`
--

LOCK TABLES `coach` WRITE;
/*!40000 ALTER TABLE `coach` DISABLE KEYS */;
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
  KEY `client_id` (`client_id`),
  KEY `reviewed_by` (`reviewed_by`),
  CONSTRAINT `coach_applications_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `coach_applications_ibfk_2` FOREIGN KEY (`reviewed_by`) REFERENCES `admin` (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coach_applications`
--

LOCK TABLES `coach_applications` WRITE;
/*!40000 ALTER TABLE `coach_applications` DISABLE KEYS */;
/*!40000 ALTER TABLE `coach_applications` ENABLE KEYS */;
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
  KEY `created_by` (`created_by`),
  CONSTRAINT `exercises_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `exercises`
--

LOCK TABLES `exercises` WRITE;
/*!40000 ALTER TABLE `exercises` DISABLE KEYS */;
/*!40000 ALTER TABLE `exercises` ENABLE KEYS */;
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
  KEY `client_id` (`client_id`),
  CONSTRAINT `logging_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logging`
--

LOCK TABLES `logging` WRITE;
/*!40000 ALTER TABLE `logging` DISABLE KEYS */;
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
  KEY `client_id` (`client_id`),
  KEY `meal_id` (`meal_id`),
  CONSTRAINT `meal_log_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `meal_log_ibfk_2` FOREIGN KEY (`meal_id`) REFERENCES `meals` (`meal_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meal_log`
--

LOCK TABLES `meal_log` WRITE;
/*!40000 ALTER TABLE `meal_log` DISABLE KEYS */;
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
  KEY `nutrition_plan_id` (`nutrition_plan_id`),
  CONSTRAINT `meals_ibfk_1` FOREIGN KEY (`nutrition_plan_id`) REFERENCES `nutrition_plan` (`nutrition_plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `meals`
--

LOCK TABLES `meals` WRITE;
/*!40000 ALTER TABLE `meals` DISABLE KEYS */;
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
  KEY `sender_id` (`sender_id`),
  KEY `receiver_id` (`receiver_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
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
  KEY `client_id` (`client_id`),
  CONSTRAINT `mood_log_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mood_log`
--

LOCK TABLES `mood_log` WRITE;
/*!40000 ALTER TABLE `mood_log` DISABLE KEYS */;
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
  KEY `user_id` (`user_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
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
  KEY `client_id` (`client_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `nutrition_plan_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `nutrition_plan_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `coach` (`coach_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `nutrition_plan`
--

LOCK TABLES `nutrition_plan` WRITE;
/*!40000 ALTER TABLE `nutrition_plan` DISABLE KEYS */;
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
  KEY `reporter_id` (`reporter_id`),
  KEY `reported_user_id` (`reported_user_id`),
  KEY `reviewed_by` (`reviewed_by`),
  CONSTRAINT `reports_ibfk_1` FOREIGN KEY (`reporter_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `reports_ibfk_2` FOREIGN KEY (`reported_user_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `reports_ibfk_3` FOREIGN KEY (`reviewed_by`) REFERENCES `admin` (`admin_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reports`
--

LOCK TABLES `reports` WRITE;
/*!40000 ALTER TABLE `reports` DISABLE KEYS */;
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
  KEY `coach_id` (`coach_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`coach_id`) REFERENCES `coach` (`coach_id`),
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
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
  KEY `client_id` (`client_id`),
  KEY `exercise_id` (`exercise_id`),
  CONSTRAINT `workout_log_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `workout_log_ibfk_2` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`exercise_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_log`
--

LOCK TABLES `workout_log` WRITE;
/*!40000 ALTER TABLE `workout_log` DISABLE KEYS */;
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
  `nutrition_plan_id` int DEFAULT NULL,
  `created` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_draft` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`workout_plan_id`),
  KEY `client_id` (`client_id`),
  KEY `created_by` (`created_by`),
  KEY `nutrition_plan_id` (`nutrition_plan_id`),
  CONSTRAINT `workout_plan_ibfk_1` FOREIGN KEY (`client_id`) REFERENCES `client` (`client_id`),
  CONSTRAINT `workout_plan_ibfk_2` FOREIGN KEY (`created_by`) REFERENCES `coach` (`coach_id`),
  CONSTRAINT `workout_plan_ibfk_3` FOREIGN KEY (`nutrition_plan_id`) REFERENCES `nutrition_plan` (`nutrition_plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_plan`
--

LOCK TABLES `workout_plan` WRITE;
/*!40000 ALTER TABLE `workout_plan` DISABLE KEYS */;
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
  KEY `workout_plan_id` (`workout_plan_id`),
  KEY `exercise_id` (`exercise_id`),
  CONSTRAINT `workout_plan_exercises_ibfk_1` FOREIGN KEY (`workout_plan_id`) REFERENCES `workout_plan` (`workout_plan_id`),
  CONSTRAINT `workout_plan_exercises_ibfk_2` FOREIGN KEY (`exercise_id`) REFERENCES `exercises` (`exercise_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `workout_plan_exercises`
--

LOCK TABLES `workout_plan_exercises` WRITE;
/*!40000 ALTER TABLE `workout_plan_exercises` DISABLE KEYS */;
/*!40000 ALTER TABLE `workout_plan_exercises` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'fitappdb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-02 23:30:28
