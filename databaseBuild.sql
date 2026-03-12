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
  UNIQUE KEY (email)
);

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
  UNIQUE KEY (email)
);

-- ======================
-- COACH
-- ======================

CREATE TABLE coach (
  coach_id VARCHAR(50) NOT NULL,
  pricing DECIMAL(8,2),
  specialty ENUM('fitness','nutrition','both'),
  certifications TEXT,
  availability TEXT,
  status ENUM('pending','active','suspended') DEFAULT 'pending',
  PRIMARY KEY (coach_id),
  CONSTRAINT coach_ibfk_1
    FOREIGN KEY (coach_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
);

ALTER TABLE client
ADD CONSTRAINT fk_client_coach
FOREIGN KEY (coach_id)
REFERENCES coach(coach_id)
ON DELETE SET NULL;

-- ======================
-- EXERCISES
-- ======================

CREATE TABLE exercises (
  exercise_id INT AUTO_INCREMENT PRIMARY KEY,
  exercise_name VARCHAR(150) NOT NULL,
  equipment VARCHAR(100),
  muscle_group VARCHAR(100),
  category VARCHAR(100),
  example_video VARCHAR(255),
  is_custom TINYINT(1) DEFAULT 0,
  created_by VARCHAR(50),
  FOREIGN KEY (created_by)
  REFERENCES client(client_id)
  ON DELETE SET NULL
);

-- ======================
-- GOALS
-- ======================

CREATE TABLE goals (
  goal_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  goal_weight DECIMAL(5,2),
  steps INT,
  time_active DECIMAL(4,2),
  workout_days_per_week TINYINT,
  FOREIGN KEY (client_id)
  REFERENCES client(client_id)
  ON DELETE CASCADE
);

-- ======================
-- LOGGING
-- ======================

CREATE TABLE logging (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  log_date DATE NOT NULL,
  steps INT,
  calories INT,
  FOREIGN KEY (client_id)
  REFERENCES client(client_id)
  ON DELETE CASCADE
);

-- ======================
-- NUTRITION PLAN
-- ======================

CREATE TABLE nutrition_plan (
  nutrition_plan_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  created_by VARCHAR(50) NOT NULL,
  category VARCHAR(100),
  FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE,
  FOREIGN KEY (created_by)
    REFERENCES coach(coach_id)
    ON DELETE CASCADE
);

-- ======================
-- MEALS
-- ======================

CREATE TABLE meals (
  meal_id INT AUTO_INCREMENT PRIMARY KEY,
  nutrition_plan_id INT NOT NULL,
  meal_name VARCHAR(150),
  description TEXT,
  calories INT,
  protein DECIMAL(5,2),
  carbs DECIMAL(5,2),
  fats DECIMAL(5,2),
  time_of_day TIME,
  day_number INT,
  FOREIGN KEY (nutrition_plan_id)
    REFERENCES nutrition_plan(nutrition_plan_id)
    ON DELETE CASCADE
);

-- ======================
-- MEAL LOG
-- ======================

CREATE TABLE meal_log (
  meal_log_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  meal_id INT,
  log_date DATE NOT NULL,
  actual_calories INT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE,
  FOREIGN KEY (meal_id)
    REFERENCES meals(meal_id)
);

-- ======================
-- MESSAGES
-- ======================

CREATE TABLE messages (
  message_id INT AUTO_INCREMENT PRIMARY KEY,
  sender_id VARCHAR(50) NOT NULL,
  receiver_id VARCHAR(50) NOT NULL,
  content TEXT NOT NULL,
  sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_read TINYINT(1) DEFAULT 0,
  FOREIGN KEY (sender_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE,
  FOREIGN KEY (receiver_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
);

-- ======================
-- MOOD LOG
-- ======================

CREATE TABLE mood_log (
  mood_log_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  log_date DATE NOT NULL,
  mood_score TINYINT,
  mood_label VARCHAR(50),
  notes TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
);

-- ======================
-- NOTIFICATIONS
-- ======================

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(50) NOT NULL,
  type VARCHAR(50),
  title VARCHAR(150),
  body TEXT,
  is_read TINYINT(1) DEFAULT 0,
  channel ENUM('in_app','email','push') DEFAULT 'in_app',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
);

-- ======================
-- REPORTS
-- ======================

CREATE TABLE reports (
  report_id INT AUTO_INCREMENT PRIMARY KEY,
  reporter_id VARCHAR(50) NOT NULL,
  reported_user_id VARCHAR(50) NOT NULL,
  reason VARCHAR(255),
  details TEXT,
  status ENUM('open','reviewed','resolved','dismissed') DEFAULT 'open',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  reviewed_by INT,
  resolved_at TIMESTAMP NULL,
  FOREIGN KEY (reporter_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE,
  FOREIGN KEY (reported_user_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE,
  FOREIGN KEY (reviewed_by)
    REFERENCES admin(admin_id)
);

-- ======================
-- REVIEWS
-- ======================

CREATE TABLE reviews (
  review_id INT AUTO_INCREMENT PRIMARY KEY,
  coach_id VARCHAR(50) NOT NULL,
  client_id VARCHAR(50) NOT NULL,
  rating TINYINT,
  comment TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (coach_id)
    REFERENCES coach(coach_id)
    ON DELETE CASCADE,
  FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE
);

-- ======================
-- WORKOUT PLAN
-- ======================

CREATE TABLE workout_plan (
  workout_plan_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id VARCHAR(50) NOT NULL,
  created_by VARCHAR(50),
  frequency VARCHAR(50),
  difficulty VARCHAR(50),
  nutrition_plan_id INT,
  created TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  is_draft TINYINT(1) DEFAULT 1,
  FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE,
  FOREIGN KEY (created_by)
    REFERENCES coach(coach_id)
    ON DELETE CASCADE,
  FOREIGN KEY (nutrition_plan_id)
    REFERENCES nutrition_plan(nutrition_plan_id)
    ON DELETE SET NULL
);

-- ======================
-- WORKOUT LOG
-- ======================

CREATE TABLE workout_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
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
  FOREIGN KEY (client_id)
    REFERENCES client(client_id)
    ON DELETE CASCADE,
  FOREIGN KEY (exercise_id)
    REFERENCES exercises(exercise_id)
);

-- ======================
-- WORKOUT PLAN EXERCISES
-- ======================

CREATE TABLE workout_plan_exercises (
  id INT AUTO_INCREMENT PRIMARY KEY,
  workout_plan_id INT NOT NULL,
  exercise_id INT NOT NULL,
  day_of_week ENUM('Mon','Tue','Wed','Thu','Fri','Sat','Sun'),
  sets INT,
  repetitions INT,
  order_in_day INT,
  FOREIGN KEY (workout_plan_id)
    REFERENCES workout_plan(workout_plan_id)
    ON DELETE CASCADE,
  FOREIGN KEY (exercise_id)
    REFERENCES exercises(exercise_id)
);

SET FOREIGN_KEY_CHECKS = 1;