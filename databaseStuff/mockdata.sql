USE fitappdb;

SET FOREIGN_KEY_CHECKS = 0;

DELETE FROM workout_plan_exercises;
DELETE FROM workout_log;
DELETE FROM workout_plan;
DELETE FROM reviews;
DELETE FROM reports;
DELETE FROM notifications;
DELETE FROM mood_log;
DELETE FROM messages;
DELETE FROM meal_log;
DELETE FROM meals;
DELETE FROM nutrition_plan;
DELETE FROM logging;
DELETE FROM goals;
DELETE FROM exercises;
DELETE FROM coach_request;
DELETE FROM coach_applications;
DELETE FROM coach;
DELETE FROM client;
DELETE FROM admin;

SET FOREIGN_KEY_CHECKS = 1;

-- =====================
-- 1. ADMIN
-- =====================
INSERT INTO admin (admin_id, first_name, last_name, email, password, is_active)
VALUES
(1, 'Alice', 'Admin', 'alice.admin@fitapp.com', 'adminpass', 1),
(2, 'Brian', 'Manager', 'brian.manager@fitapp.com', 'adminpass', 1);

-- =====================
-- 2. CLIENT
-- 20 total rows: 16 regular clients + 4 coach accounts
-- =====================
INSERT INTO client (
  client_id,
  first_name,
  last_name,
  dob,
  weight,
  height,
  gender,
  coach_id,
  subscription,
  role,
  email,
  phone_number,
  signup_date,
  password
) VALUES
('cl001', 'Frank',    'Torres',    '2001-05-12', 175.50, 70.00, 'Male',   NULL, 'premium', 'client', 'frank.torres@fitapp.com',      '9735551001', '2026-03-01', 'pass123'),
('cl002', 'Sarah',    'Johnson',   '1998-11-03', 135.20, 65.00, 'Female', NULL, 'basic',   'client', 'sarah.johnson@fitapp.com',    '9735551002', '2026-03-01', 'pass123'),
('cl003', 'Michael',  'Chen',      '1995-07-22', 182.00, 72.50, 'Male',   NULL, 'premium', 'client', 'michael.chen@fitapp.com',     '9735551003', '2026-03-02', 'pass123'),
('cl004', 'Emily',    'Garcia',    '2000-09-14', 125.75, 64.00, 'Female', NULL, 'basic',   'client', 'emily.garcia@fitapp.com',     '9735551004', '2026-03-02', 'pass123'),
('cl005', 'David',    'Smith',     '1997-03-30', 190.10, 73.00, 'Male',   NULL, 'premium', 'client', 'david.smith@fitapp.com',      '9735551005', '2026-03-03', 'pass123'),
('cl006', 'Olivia',   'Brown',     '2002-01-18', 118.40, 63.00, 'Female', NULL, 'basic',   'client', 'olivia.brown@fitapp.com',     '9735551006', '2026-03-03', 'pass123'),
('cl007', 'James',    'Anderson',  '1996-04-28', 185.30, 71.50, 'Male',   NULL, 'premium', 'client', 'james.anderson@fitapp.com',   '9735551007', '2026-03-04', 'pass123'),
('cl008', 'Ava',      'Wilson',    '1999-12-05', 130.60, 66.00, 'Female', NULL, 'basic',   'client', 'ava.wilson@fitapp.com',       '9735551008', '2026-03-04', 'pass123'),
('cl009', 'Noah',     'Taylor',    '1994-08-17', 172.80, 69.00, 'Male',   NULL, 'premium', 'client', 'noah.taylor@fitapp.com',      '9735551009', '2026-03-05', 'pass123'),
('cl010', 'Sophia',   'Moore',     '2001-02-09', 122.30, 64.50, 'Female', NULL, 'basic',   'client', 'sophia.moore@fitapp.com',     '9735551010', '2026-03-05', 'pass123'),
('cl011', 'Liam',     'Jackson',   '1993-10-11', 198.20, 74.00, 'Male',   NULL, 'premium', 'client', 'liam.jackson@fitapp.com',     '9735551011', '2026-03-06', 'pass123'),
('cl012', 'Mia',      'White',     '2000-06-21', 127.40, 65.20, 'Female', NULL, 'premium', 'client', 'mia.white@fitapp.com',        '9735551012', '2026-03-06', 'pass123'),
('cl013', 'Ethan',    'Harris',    '1998-01-07', 188.90, 72.00, 'Male',   NULL, 'basic',   'client', 'ethan.harris@fitapp.com',     '9735551013', '2026-03-07', 'pass123'),
('cl014', 'Charlotte','Martin',    '2002-07-19', 119.50, 63.70, 'Female', NULL, 'premium', 'client', 'charlotte.martin@fitapp.com', '9735551014', '2026-03-07', 'pass123'),
('cl015', 'Lucas',    'Thompson',  '1997-09-25', 181.00, 71.20, 'Male',   NULL, 'basic',   'client', 'lucas.thompson@fitapp.com',   '9735551015', '2026-03-08', 'pass123'),
('cl016', 'Amelia',   'Davis',     '1999-03-13', 124.80, 64.10, 'Female', NULL, 'premium', 'client', 'amelia.davis@fitapp.com',     '9735551016', '2026-03-08', 'pass123'),
('cl017', 'Daniel',   'Martinez',  '1994-06-11', 205.00, 74.00, 'Male',   NULL, 'premium', 'coach',  'daniel.martinez@fitapp.com',  '9735551017', '2026-03-09', 'pass123'),
('cl018', 'Mia',      'Thomas',    '1999-08-19', 120.00, 64.50, 'Female', NULL, 'premium', 'coach',  'mia.thomas@fitapp.com',       '9735551018', '2026-03-09', 'pass123'),
('cl019', 'Chris',    'Walker',    '1992-12-02', 210.40, 75.00, 'Male',   NULL, 'premium', 'coach',  'chris.walker@fitapp.com',     '9735551019', '2026-03-10', 'pass123'),
('cl020', 'Grace',    'Lee',       '1996-05-27', 126.10, 65.80, 'Female', NULL, 'premium', 'coach',  'grace.lee@fitapp.com',        '9735551020', '2026-03-10', 'pass123');

-- =====================
-- 3. COACH
-- =====================
INSERT INTO coach (
  coach_id,
  pricing,
  specialty,
  certifications,
  availability,
  status
) VALUES
('cl017', 89.99,  'fitness',   'NASM CPT',                    'Mon-Fri mornings',    'active'),
('cl018', 99.99,  'nutrition', 'Precision Nutrition Level 1', 'Tue-Sat afternoons',  'active'),
('cl019', 109.99, 'both',      'ACE CPT, Sports Nutrition',   'Mon-Thu evenings',    'active'),
('cl020', 94.99,  'fitness',   'ISSA CPT',                    'Weekends + evenings', 'active');

-- =====================
-- 4. UPDATE CLIENT COACH ASSIGNMENTS
-- =====================
UPDATE client SET coach_id = 'cl017' WHERE client_id IN ('cl001', 'cl005', 'cl009', 'cl013');
UPDATE client SET coach_id = 'cl018' WHERE client_id IN ('cl002', 'cl006', 'cl010', 'cl014');
UPDATE client SET coach_id = 'cl019' WHERE client_id IN ('cl003', 'cl007', 'cl011', 'cl015');
UPDATE client SET coach_id = 'cl020' WHERE client_id IN ('cl004', 'cl008', 'cl012', 'cl016');

-- =====================
-- 5. COACH APPLICATIONS
-- =====================
INSERT INTO coach_applications (
  application_id,
  client_id,
  specialty,
  certifications,
  bio,
  pricing,
  status,
  submitted_at,
  reviewed_by,
  reviewed_at
) VALUES
(1, 'cl009', 'fitness',   'ACE Personal Trainer',     'Interested in beginner strength coaching.', 79.99, 'pending',  '2026-03-08 10:00:00', NULL, NULL),
(2, 'cl011', 'both',      'NASM CPT, Nutrition Cert', 'Experienced in body recomposition.',        95.00, 'approved', '2026-03-07 09:30:00', 1, '2026-03-09 12:00:00'),
(3, 'cl014', 'nutrition', 'Sports Nutrition Course',  'Focused on sustainable meal planning.',     70.00, 'declined', '2026-03-06 14:15:00', 2, '2026-03-08 16:45:00');

-- =====================
-- 6. EXERCISES
-- =====================
INSERT INTO exercises (
  exercise_id,
  exercise_name,
  equipment,
  muscle_group,
  category,
  example_video,
  is_custom,
  created_by
) VALUES
(1,  'Barbell Bench Press',     'Barbell',    'Chest',      'Strength',     'https://example.com/bench',    0, NULL),
(2,  'Dumbbell Shoulder Press', 'Dumbbell',   'Shoulders',  'Strength',     'https://example.com/press',    0, NULL),
(3,  'Lat Pulldown',            'Machine',    'Back',       'Strength',     'https://example.com/pulldown', 0, NULL),
(4,  'Goblet Squat',            'Dumbbell',   'Legs',       'Strength',     'https://example.com/squat',    0, NULL),
(5,  'Romanian Deadlift',       'Barbell',    'Hamstrings', 'Strength',     'https://example.com/rdl',      0, NULL),
(6,  'Plank',                   'Bodyweight', 'Core',       'Core',         'https://example.com/plank',    0, NULL),
(7,  'Incline Walk',            'Treadmill',  'Cardio',     'Cardio',       'https://example.com/walk',     0, NULL),
(8,  'Cable Tricep Pushdown',   'Cable',      'Arms',       'Strength',     'https://example.com/tricep',   0, NULL),
(9,  'Glute Bridge',            'Bodyweight', 'Glutes',     'Strength',     'https://example.com/glute',    1, 'cl017'),
(10, 'Conditioning Circuit',    'None',       'Full Body',  'Conditioning', 'https://example.com/circuit',  1, 'cl018'),
(11, 'Seated Row',              'Machine',    'Back',       'Strength',     'https://example.com/row',      0, NULL),
(12, 'Walking Lunges',          'Dumbbell',   'Legs',       'Strength',     'https://example.com/lunges',   0, NULL);

-- =====================
-- 7. GOALS
-- =====================
INSERT INTO goals (
  goal_id,
  client_id,
  goal_weight,
  steps,
  time_active,
  workout_days_per_week
) VALUES
(1,  'cl001', 168.00,  9000, 1.50, 4),
(2,  'cl002', 128.00,  8000, 1.00, 3),
(3,  'cl003', 175.00, 10000, 1.25, 5),
(4,  'cl004', 120.00,  8500, 1.00, 4),
(5,  'cl005', 185.00,  9500, 1.75, 5),
(6,  'cl006', 115.00,  7000, 0.75, 3),
(7,  'cl007', 178.00,  9000, 1.50, 4),
(8,  'cl008', 125.00,  8200, 1.00, 3),
(9,  'cl009', 168.00, 10000, 1.25, 5),
(10, 'cl010', 118.00,  7800, 1.00, 3),
(11, 'cl011', 190.00, 10500, 1.75, 5),
(12, 'cl012', 122.00,  8400, 1.25, 4),
(13, 'cl013', 180.00,  8800, 1.50, 4),
(14, 'cl014', 116.00,  7600, 0.75, 3),
(15, 'cl015', 176.00,  9200, 1.25, 4),
(16, 'cl016', 120.00,  8000, 1.00, 3);

-- =====================
-- 8. LOGGING
-- =====================
INSERT INTO logging (
  log_id,
  client_id,
  log_date,
  steps,
  calories
) VALUES
(1,  'cl001', '2026-03-10',  8421, 2280),
(2,  'cl002', '2026-03-10',  7030, 1825),
(3,  'cl003', '2026-03-10',  9650, 2410),
(4,  'cl004', '2026-03-10',  8112, 1770),
(5,  'cl005', '2026-03-10', 10245, 2555),
(6,  'cl006', '2026-03-10',  6894, 1690),
(7,  'cl007', '2026-03-10',  9340, 2210),
(8,  'cl008', '2026-03-10',  7520, 1800),
(9,  'cl009', '2026-03-10',  9985, 2360),
(10, 'cl010', '2026-03-10',  7840, 1755),
(11, 'cl011', '2026-03-10', 10820, 2620),
(12, 'cl012', '2026-03-10',  8160, 1845),
(13, 'cl013', '2026-03-10',  8890, 2265),
(14, 'cl014', '2026-03-10',  7415, 1710),
(15, 'cl015', '2026-03-10',  9120, 2325),
(16, 'cl016', '2026-03-10',  7985, 1790);

-- =====================
-- 9. NUTRITION PLAN
-- =====================
INSERT INTO nutrition_plan (
  nutrition_plan_id,
  client_id,
  created_by,
  category
) VALUES
(1,  'cl001', 'cl018', 'Lean Bulk'),
(2,  'cl002', 'cl018', 'Fat Loss'),
(3,  'cl003', 'cl018', 'Maintenance'),
(4,  'cl004', 'cl018', 'Fat Loss'),
(5,  'cl005', 'cl018', 'Performance'),
(6,  'cl006', 'cl018', 'Light Deficit'),
(7,  'cl007', 'cl018', 'Maintenance'),
(8,  'cl008', 'cl018', 'Fat Loss'),
(9,  'cl009', 'cl018', 'Lean Bulk'),
(10, 'cl010', 'cl018', 'Fat Loss'),
(11, 'cl011', 'cl018', 'Performance'),
(12, 'cl012', 'cl018', 'Maintenance');

-- =====================
-- 10. MEALS
-- =====================
INSERT INTO meals (
  meal_id,
  nutrition_plan_id,
  meal_name,
  description,
  calories,
  protein,
  carbs,
  fats,
  time_of_day,
  day_number
) VALUES
(1,  1, 'Protein Breakfast', 'Eggs, oats, fruit',         520, 35.00, 48.00, 18.00, '08:00:00', 1),
(2,  1, 'Chicken Rice Lunch','Chicken breast with rice',  680, 48.00, 72.00, 14.00, '13:00:00', 1),
(3,  2, 'Greek Yogurt Bowl', 'Yogurt, berries, granola',  380, 24.00, 42.00, 10.00, '08:30:00', 1),
(4,  2, 'Salmon Salad',      'Salmon with mixed greens',  510, 38.00, 22.00, 26.00, '12:30:00', 1),
(5,  3, 'Turkey Wrap',       'Turkey, tortilla, veggies', 450, 32.00, 40.00, 14.00, '12:00:00', 1),
(6,  4, 'Protein Smoothie',  'Whey, banana, almond milk', 330, 30.00, 28.00,  8.00, '07:30:00', 1),
(7,  5, 'Beef Pasta Bowl',   'Lean beef and pasta',       710, 46.00, 76.00, 18.00, '18:00:00', 1),
(8,  6, 'Avocado Toast',     'Toast, avocado, eggs',      410, 18.00, 30.00, 22.00, '09:00:00', 1),
(9,  7, 'Oatmeal Bowl',      'Oats, peanut butter, fruit',490, 20.00, 58.00, 16.00, '08:00:00', 1),
(10, 8, 'Chicken Salad',     'Chicken with greens',       430, 36.00, 18.00, 20.00, '13:00:00', 1),
(11, 9, 'Rice and Steak',    'Steak with jasmine rice',   690, 44.00, 70.00, 16.00, '18:30:00', 1),
(12,10, 'Cottage Cheese Bowl','Cottage cheese and fruit', 320, 26.00, 24.00,  8.00, '08:15:00', 1);

-- =====================
-- 11. MEAL LOG
-- =====================
INSERT INTO meal_log (
  meal_log_id,
  client_id,
  meal_id,
  log_date,
  actual_calories,
  notes,
  created_at
) VALUES
(1,  'cl001', 1,  '2026-03-10', 510, 'Finished everything.', '2026-03-10 08:20:00'),
(2,  'cl001', 2,  '2026-03-10', 700, 'Extra rice portion.',  '2026-03-10 13:15:00'),
(3,  'cl002', 3,  '2026-03-10', 360, 'Skipped granola.',     '2026-03-10 08:40:00'),
(4,  'cl002', 4,  '2026-03-10', 500, 'No dressing.',         '2026-03-10 12:50:00'),
(5,  'cl003', 5,  '2026-03-10', 455, 'As planned.',          '2026-03-10 12:20:00'),
(6,  'cl004', 6,  '2026-03-10', 330, 'Post workout shake.',  '2026-03-10 07:45:00'),
(7,  'cl005', 7,  '2026-03-10', 735, 'Large dinner.',        '2026-03-10 18:40:00'),
(8,  'cl006', 8,  '2026-03-10', 400, 'Used less avocado.',   '2026-03-10 09:25:00'),
(9,  'cl007', 9,  '2026-03-10', 500, 'Good breakfast.',      '2026-03-10 08:10:00'),
(10, 'cl008', 10, '2026-03-10', 420, 'Light lunch.',         '2026-03-10 13:20:00');

-- =====================
-- 12. MESSAGES
-- =====================
INSERT INTO messages (
  message_id,
  sender_id,
  receiver_id,
  content,
  sent_at,
  is_read
) VALUES
(1, 'cl001', 'cl017', 'Hey coach, can we adjust my workout?',        '2026-03-10 10:00:00', 1),
(2, 'cl017', 'cl001', 'Sure, let us reduce volume this week.',       '2026-03-10 10:15:00', 1),
(3, 'cl002', 'cl018', 'Can I swap salmon for chicken?',              '2026-03-10 11:00:00', 1),
(4, 'cl018', 'cl002', 'Yes, just keep protein about the same.',      '2026-03-10 11:05:00', 0),
(5, 'cl011', 'cl019', 'Can we add another leg day?',                 '2026-03-10 15:10:00', 1),
(6, 'cl020', 'cl016', 'Reminder: focus on form this session.',       '2026-03-10 18:30:00', 0);

-- =====================
-- 13. MOOD LOG
-- =====================
INSERT INTO mood_log (
  mood_log_id,
  client_id,
  log_date,
  mood_score,
  mood_label,
  notes,
  created_at
) VALUES
(1, 'cl001', '2026-03-10', 4, 'Good',      'Strong workout today.',      '2026-03-10 20:00:00'),
(2, 'cl002', '2026-03-10', 3, 'Okay',      'A little tired after work.', '2026-03-10 20:10:00'),
(3, 'cl003', '2026-03-10', 5, 'Great',     'Hit a new PR.',              '2026-03-10 20:20:00'),
(4, 'cl004', '2026-03-10', 2, 'Low',       'Poor sleep last night.',     '2026-03-10 20:30:00'),
(5, 'cl005', '2026-03-10', 4, 'Motivated', 'Meal plan is going well.',   '2026-03-10 20:40:00'),
(6, 'cl006', '2026-03-10', 3, 'Neutral',   'Rest day.',                  '2026-03-10 20:50:00');

-- =====================
-- 14. NOTIFICATIONS
-- =====================
INSERT INTO notifications (
  notification_id,
  user_id,
  type,
  title,
  body,
  is_read,
  channel,
  created_at
) VALUES
(1, 'cl001', 'workout',   'Workout Reminder', 'Your workout is scheduled today.', 0, 'in_app', '2026-03-10 07:00:00'),
(2, 'cl002', 'nutrition', 'Meal Reminder',    'Log your lunch.',                   1, 'in_app', '2026-03-10 12:00:00'),
(3, 'cl003', 'coach',     'Coach Message',    'You have a new message.',           0, 'in_app', '2026-03-10 10:16:00'),
(4, 'cl010', 'system',    'Progress Check',   'Please update your weekly check-in.',0,'email',  '2026-03-11 09:00:00'),
(5, 'cl015', 'nutrition', 'Plan Updated',     'Your meal plan has been updated.',  0, 'in_app', '2026-03-11 13:00:00');

-- =====================
-- 15. REPORTS
-- =====================
INSERT INTO reports (
  report_id,
  reporter_id,
  reported_user_id,
  reason,
  details,
  status,
  created_at,
  reviewed_by,
  resolved_at
) VALUES
(1, 'cl001', 'cl005', 'Spam',       'Repeated off-topic messages.',      'reviewed', '2026-03-09 15:00:00', 1, NULL),
(2, 'cl002', 'cl003', 'Harassment', 'Message tone felt inappropriate.',  'resolved', '2026-03-08 18:20:00', 2, '2026-03-10 09:00:00');

-- =====================
-- 16. REVIEWS
-- =====================
INSERT INTO reviews (
  review_id,
  coach_id,
  client_id,
  rating,
  comment,
  created_at
) VALUES
(1, 'cl017', 'cl001', 5, 'Great coach.',                    '2026-03-11 17:00:00'),
(2, 'cl018', 'cl002', 4, 'Helpful nutrition advice.',      '2026-03-11 17:10:00'),
(3, 'cl019', 'cl011', 5, 'Really motivating and helpful.', '2026-03-11 17:20:00'),
(4, 'cl020', 'cl016', 4, 'Good explanations and support.', '2026-03-11 17:30:00');

-- =====================
-- 17. WORKOUT PLAN
-- =====================
INSERT INTO workout_plan (
  workout_plan_id,
  client_id,
  created_by,
  frequency,
  difficulty,
  nutrition_plan_id,
  created,
  is_draft
) VALUES
(1, 'cl001', 'cl017', '4x/week', 'Intermediate', 1,  '2026-03-05 09:00:00', 0),
(2, 'cl002', 'cl017', '3x/week', 'Beginner',     2,  '2026-03-05 09:15:00', 0),
(3, 'cl003', 'cl019', '5x/week', 'Intermediate', 3,  '2026-03-05 09:30:00', 0),
(4, 'cl004', 'cl020', '4x/week', 'Beginner',     4,  '2026-03-05 09:45:00', 0),
(5, 'cl005', 'cl017', '5x/week', 'Advanced',     5,  '2026-03-05 10:00:00', 0),
(6, 'cl006', 'cl018', '3x/week', 'Beginner',     6,  '2026-03-05 10:15:00', 1),
(7, 'cl007', 'cl019', '4x/week', 'Intermediate', 7,  '2026-03-05 10:30:00', 0),
(8, 'cl008', 'cl020', '3x/week', 'Beginner',     8,  '2026-03-05 10:45:00', 0),
(9, 'cl009', 'cl017', '4x/week', 'Intermediate', 9,  '2026-03-05 11:00:00', 0),
(10,'cl010', 'cl018', '3x/week', 'Beginner',     10, '2026-03-05 11:15:00', 0),
(11,'cl011', 'cl019', '5x/week', 'Advanced',     11, '2026-03-05 11:30:00', 0),
(12,'cl012', 'cl020', '4x/week', 'Intermediate', 12, '2026-03-05 11:45:00', 0);

-- =====================
-- 18. WORKOUT PLAN EXERCISES
-- =====================
INSERT INTO workout_plan_exercises (
  id,
  workout_plan_id,
  exercise_id,
  day_of_week,
  sets,
  repetitions,
  order_in_day
) VALUES
(1,  1, 1,  'Mon', 4,  8, 1),
(2,  1, 2,  'Mon', 3, 10, 2),
(3,  1, 6,  'Mon', 3, 45, 3),
(4,  2, 4,  'Tue', 3, 12, 1),
(5,  3, 3,  'Wed', 4, 10, 1),
(6,  3, 5,  'Wed', 4,  8, 2),
(7,  4, 6,  'Thu', 3, 30, 1),
(8,  5, 1,  'Fri', 5,  5, 1),
(9,  5, 5,  'Fri', 4,  6, 2),
(10, 6, 9,  'Sat', 3, 15, 1),
(11, 7, 11, 'Mon', 4, 10, 1),
(12, 8, 12, 'Tue', 3, 12, 1),
(13, 9, 1,  'Wed', 4,  8, 1),
(14,10, 7,  'Thu', 1, 20, 1),
(15,11, 5,  'Fri', 4,  6, 1),
(16,12, 2,  'Sat', 3, 10, 1);

-- =====================
-- 19. WORKOUT LOG
-- =====================
INSERT INTO workout_log (
  log_id,
  client_id,
  exercise_id,
  log_date,
  sets_completed,
  reps_completed,
  weight,
  cardio_type,
  cardio_duration,
  notes,
  created_at
) VALUES
(1,  'cl001', 1,  '2026-03-10', 4,  8, 155.00, NULL,          NULL, 'Bench felt smooth.',       '2026-03-10 18:00:00'),
(2,  'cl001', 2,  '2026-03-10', 3, 10,  40.00, NULL,          NULL, 'Shoulders were fatigued.', '2026-03-10 18:20:00'),
(3,  'cl002', 4,  '2026-03-10', 3, 12,  35.00, NULL,          NULL, 'Good form today.',         '2026-03-10 17:30:00'),
(4,  'cl003', 3,  '2026-03-10', 4, 10, 120.00, NULL,          NULL, 'Back pump was great.',     '2026-03-10 19:00:00'),
(5,  'cl003', 5,  '2026-03-10', 4,  8, 185.00, NULL,          NULL, 'Solid hinge pattern.',     '2026-03-10 19:25:00'),
(6,  'cl002', 7,  '2026-03-11', NULL, NULL, NULL, 'Incline Walk', 20, 'Cardio finish.',         '2026-03-11 16:00:00'),
(7,  'cl007', 11, '2026-03-11', 4, 10, 100.00, NULL,          NULL, 'Rows felt controlled.',    '2026-03-11 18:10:00'),
(8,  'cl008', 12, '2026-03-11', 3, 12,  20.00, NULL,          NULL, 'Lunges burned.',           '2026-03-11 18:30:00'),
(9,  'cl009', 1,  '2026-03-11', 4,  8, 145.00, NULL,          NULL, 'Good tempo.',              '2026-03-11 19:00:00'),
(10, 'cl010', 7,  '2026-03-11', NULL, NULL, NULL, 'Incline Walk', 25, 'Long cardio session.',   '2026-03-11 19:15:00'),
(11, 'cl011', 5,  '2026-03-11', 4,  6, 205.00, NULL,          NULL, 'Heavy but solid.',         '2026-03-11 19:30:00'),
(12, 'cl012', 2,  '2026-03-11', 3, 10,  30.00, NULL,          NULL, 'Shoulders felt good.',     '2026-03-11 19:40:00');

-- =====================
-- 20. COACH REQUESTS
-- =====================
INSERT INTO coach_request (client_id, coach_id, status) VALUES
('cl002', 'cl017', 'pending'),
('cl004', 'cl019', 'pending'),
('cl006', 'cl017', 'accepted'),
('cl008', 'cl019', 'accepted'),
('cl010', 'cl020', 'rejected'),
('cl012', 'cl017', 'pending'),
('cl013', 'cl018', 'accepted'),
('cl015', 'cl020', 'rejected'),
('cl016', 'cl019', 'pending'),
('cl001', 'cl020', 'accepted');

-- sanity checks
SELECT COUNT(*) AS admin_count FROM admin;
SELECT COUNT(*) AS client_count FROM client;
SELECT COUNT(*) AS coach_count FROM coach;
SELECT COUNT(*) AS coach_applications_count FROM coach_applications;
SELECT COUNT(*) AS exercise_count FROM exercises;
SELECT COUNT(*) AS workout_log_count FROM workout_log;