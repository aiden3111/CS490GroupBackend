DROP DATABASE IF EXISTS fitappdb;
CREATE DATABASE fitappdb;
USE fitappdb;

SET FOREIGN_KEY_CHECKS = 0;

-- ======================
-- ADMIN
-- ======================

CREATE TABLE admin (
  admin_id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL,
  password VARCHAR(255) NOT NULL,
  is_active TINYINT(1) DEFAULT 1,
  PRIMARY KEY (admin_id),
  UNIQUE KEY uq_admin_email (email)
) ENGINE=InnoDB;

-- ======================
-- CLIENT
-- ======================

CREATE TABLE client (
  client_id VARCHAR(50) NOT NULL,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  dob DATE NOT NULL,
  weight DECIMAL(5,2),
  height DECIMAL(5,2),
  gender VARCHAR(20),
  coach_id VARCHAR(50),
  subscription VARCHAR(50),
  role ENUM('client','coach','admin') DEFAULT 'client',
  email VARCHAR(255) NOT NULL,
  phone_number VARCHAR(20),
  signup_date DATE DEFAULT (CURDATE()),
  password VARCHAR(255) NOT NULL,
  PRIMARY KEY (client_id),
  UNIQUE KEY uq_client_email (email),
  KEY idx_client_coach_id (coach_id)
) ENGINE=InnoDB;

-- ======================
-- COACH
-- coach_id must already exist in client
-- ======================

CREATE TABLE coach (
  coach_id VARCHAR(50) NOT NULL,
  pricing DECIMAL(8,2),
  specialty ENUM('fitness','nutrition','both'),
  certifications TEXT,
  availability TEXT,
  status ENUM('pending','active','suspended') DEFAULT 'pending',
  PRIMARY KEY (coach_id),
  CONSTRAINT fk_coach_client
    FOREIGN KEY (coach_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- client -> assigned coach
ALTER TABLE client
ADD CONSTRAINT fk_client_coach
FOREIGN KEY (coach_id)
REFERENCES coach(coach_id)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- ======================
-- COACH APPLICATIONS
-- ======================

CREATE TABLE coach_applications (
  application_id INT NOT NULL AUTO_INCREMENT,
  client_id VARCHAR(50) NOT NULL,
  specialty ENUM('fitness','nutrition','both'),
  certifications TEXT,
  bio TEXT,
  pricing DECIMAL(8,2),
  status ENUM('pending','approved','declined') DEFAULT 'pending',
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  reviewed_by INT DEFAULT NULL,
  reviewed_at TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (application_id),
  KEY idx_coach_app_client_id (client_id),
  KEY idx_coach_app_reviewed_by (reviewed_by),
  CONSTRAINT fk_coach_applications_client
    FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_coach_applications_admin
    FOREIGN KEY (reviewed_by)
    REFERENCES admin(admin_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- EXERCISES
-- ======================

CREATE TABLE exercises (
  exercise_id INT NOT NULL AUTO_INCREMENT,
  exercise_name VARCHAR(150) NOT NULL,
  equipment VARCHAR(100),
  muscle_group VARCHAR(100),
  category VARCHAR(100),
  example_video VARCHAR(255),
  is_custom TINYINT(1) DEFAULT 0,
  created_by VARCHAR(50),
  PRIMARY KEY (exercise_id),
  KEY idx_exercises_created_by (created_by),
  CONSTRAINT fk_exercises_created_by
    FOREIGN KEY (created_by)
    REFERENCES client(client_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- GOALS
-- ======================

CREATE TABLE goals (
  goal_id INT NOT NULL AUTO_INCREMENT,
  client_id VARCHAR(50) NOT NULL,
  goal_weight DECIMAL(5,2),
  steps INT,
  time_active DECIMAL(4,2),
  workout_days_per_week TINYINT,
  PRIMARY KEY (goal_id),
  KEY idx_goals_client_id (client_id),
  CONSTRAINT fk_goals_client
    FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- LOGGING
-- ======================

CREATE TABLE logging (
  log_id INT NOT NULL AUTO_INCREMENT,
  client_id VARCHAR(50) NOT NULL,
  log_date DATE NOT NULL,
  steps INT,
  calories INT,
  PRIMARY KEY (log_id),
  KEY idx_logging_client_id (client_id),
  CONSTRAINT fk_logging_client
    FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- NUTRITION PLAN
-- ======================

CREATE TABLE nutrition_plan (
  nutrition_plan_id INT NOT NULL AUTO_INCREMENT,
  client_id VARCHAR(50) NOT NULL,
  created_by VARCHAR(50) NOT NULL,
  category VARCHAR(100),
  PRIMARY KEY (nutrition_plan_id),
  KEY idx_nutrition_plan_client_id (client_id),
  KEY idx_nutrition_plan_created_by (created_by),
  CONSTRAINT fk_nutrition_plan_client
    FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_nutrition_plan_created_by
    FOREIGN KEY (created_by)
    REFERENCES coach(coach_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- MEALS
-- ======================

CREATE TABLE meals (
  meal_id INT NOT NULL AUTO_INCREMENT,
  nutrition_plan_id INT NOT NULL,
  meal_name VARCHAR(150),
  description TEXT,
  calories INT,
  protein DECIMAL(5,2),
  carbs DECIMAL(5,2),
  fats DECIMAL(5,2),
  time_of_day TIME,
  day_number INT,
  PRIMARY KEY (meal_id),
  KEY idx_meals_nutrition_plan_id (nutrition_plan_id),
  CONSTRAINT fk_meals_nutrition_plan
    FOREIGN KEY (nutrition_plan_id)
    REFERENCES nutrition_plan(nutrition_plan_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- MEAL LOG
-- ======================

CREATE TABLE meal_log (
  meal_log_id INT NOT NULL AUTO_INCREMENT,
  client_id VARCHAR(50) NOT NULL,
  meal_id INT DEFAULT NULL,
  log_date DATE NOT NULL,
  actual_calories INT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (meal_log_id),
  KEY idx_meal_log_client_id (client_id),
  KEY idx_meal_log_meal_id (meal_id),
  CONSTRAINT fk_meal_log_client
    FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_meal_log_meal
    FOREIGN KEY (meal_id)
    REFERENCES meals(meal_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- MESSAGES
-- ======================

CREATE TABLE messages (
  message_id INT NOT NULL AUTO_INCREMENT,
  sender_id VARCHAR(50) NOT NULL,
  receiver_id VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_read TINYINT(1) DEFAULT 0,
  PRIMARY KEY (message_id),
  KEY idx_messages_sender_id (sender_id),
  KEY idx_messages_receiver_id (receiver_id),
  CONSTRAINT fk_messages_sender
    FOREIGN KEY (sender_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_messages_receiver
    FOREIGN KEY (receiver_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- MOOD LOG
-- ======================

CREATE TABLE mood_log (
  mood_log_id INT NOT NULL AUTO_INCREMENT,
  client_id VARCHAR(50) NOT NULL,
  log_date DATE NOT NULL,
  mood_score TINYINT,
  mood_label VARCHAR(50),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (mood_log_id),
  KEY idx_mood_log_client_id (client_id),
  CONSTRAINT fk_mood_log_client
    FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- NOTIFICATIONS
-- ======================

CREATE TABLE notifications (
  notification_id INT NOT NULL AUTO_INCREMENT,
  user_id VARCHAR(50) NOT NULL,
  type VARCHAR(50),
  title VARCHAR(150),
  body TEXT,
  is_read TINYINT(1) DEFAULT 0,
  channel ENUM('in_app','email','push') DEFAULT 'in_app',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (notification_id),
  KEY idx_notifications_user_id (user_id),
  CONSTRAINT fk_notifications_user
    FOREIGN KEY (user_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- REPORTS
-- ======================

CREATE TABLE reports (
  report_id INT NOT NULL AUTO_INCREMENT,
  reporter_id VARCHAR(50) NOT NULL,
  reported_user_id VARCHAR(50) NOT NULL,
  reason VARCHAR(255),
  details TEXT,
  status ENUM('open','reviewed','resolved','dismissed') DEFAULT 'open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  reviewed_by INT,
  resolved_at TIMESTAMP NULL,
  PRIMARY KEY (report_id),
  KEY idx_reports_reporter_id (reporter_id),
  KEY idx_reports_reported_user_id (reported_user_id),
  KEY idx_reports_reviewed_by (reviewed_by),
  CONSTRAINT fk_reports_reporter
    FOREIGN KEY (reporter_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_reports_reported_user
    FOREIGN KEY (reported_user_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_reports_reviewed_by
    FOREIGN KEY (reviewed_by)
    REFERENCES admin(admin_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- REVIEWS
-- ======================

CREATE TABLE reviews (
  review_id INT NOT NULL AUTO_INCREMENT,
  coach_id VARCHAR(50) NOT NULL,
  client_id VARCHAR(50) NOT NULL,
  rating TINYINT,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (review_id),
  KEY idx_reviews_coach_id (coach_id),
  KEY idx_reviews_client_id (client_id),
  CONSTRAINT fk_reviews_coach
    FOREIGN KEY (coach_id)
    REFERENCES coach(coach_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_reviews_client
    FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- WORKOUT PLAN
-- ======================

CREATE TABLE workout_plan (
  workout_plan_id INT NOT NULL AUTO_INCREMENT,
  client_id VARCHAR(50) NOT NULL,
  created_by VARCHAR(50),
  frequency VARCHAR(50),
  difficulty VARCHAR(50),
  nutrition_plan_id INT,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_draft TINYINT(1) DEFAULT 1,
  PRIMARY KEY (workout_plan_id),
  KEY idx_workout_plan_client_id (client_id),
  KEY idx_workout_plan_created_by (created_by),
  KEY idx_workout_plan_nutrition_plan_id (nutrition_plan_id),
  CONSTRAINT fk_workout_plan_client
    FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_workout_plan_created_by
    FOREIGN KEY (created_by)
    REFERENCES coach(coach_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_workout_plan_nutrition_plan
    FOREIGN KEY (nutrition_plan_id)
    REFERENCES nutrition_plan(nutrition_plan_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- WORKOUT LOG
-- ======================

CREATE TABLE workout_log (
  log_id INT NOT NULL AUTO_INCREMENT,
  client_id VARCHAR(50) NOT NULL,
  exercise_id INT,
  log_date DATE NOT NULL,
  sets_completed INT,
  reps_completed INT,
  weight DECIMAL(6,2),
  cardio_type VARCHAR(100),
  cardio_duration INT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (log_id),
  KEY idx_workout_log_client_id (client_id),
  KEY idx_workout_log_exercise_id (exercise_id),
  CONSTRAINT fk_workout_log_client
    FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_workout_log_exercise
    FOREIGN KEY (exercise_id)
    REFERENCES exercises(exercise_id)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE=InnoDB;

-- ======================
-- WORKOUT PLAN EXERCISES
-- ======================

CREATE TABLE workout_plan_exercises (
  id INT NOT NULL AUTO_INCREMENT,
  workout_plan_id INT NOT NULL,
  exercise_id INT NOT NULL,
  day_of_week ENUM('Mon','Tue','Wed','Thu','Fri','Sat','Sun'),
  sets INT,
  repetitions INT,
  order_in_day INT,
  PRIMARY KEY (id),
  KEY idx_workout_plan_exercises_workout_plan_id (workout_plan_id),
  KEY idx_workout_plan_exercises_exercise_id (exercise_id),
  CONSTRAINT fk_workout_plan_exercises_workout_plan
    FOREIGN KEY (workout_plan_id)
    REFERENCES workout_plan(workout_plan_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT fk_workout_plan_exercises_exercise
    FOREIGN KEY (exercise_id)
    REFERENCES exercises(exercise_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;