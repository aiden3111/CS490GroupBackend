SET FOREIGN_KEY_CHECKS = 0;

-- coach inherits from client
ALTER TABLE coach
DROP FOREIGN KEY coach_ibfk_1,
ADD CONSTRAINT coach_ibfk_1
FOREIGN KEY (coach_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- coach applications
ALTER TABLE coach_applications
DROP FOREIGN KEY coach_applications_ibfk_1,
ADD CONSTRAINT coach_applications_ibfk_1
FOREIGN KEY (client_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- logging
ALTER TABLE logging
DROP FOREIGN KEY logging_ibfk_1,
ADD CONSTRAINT logging_ibfk_1
FOREIGN KEY (client_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- meal log
ALTER TABLE meal_log
DROP FOREIGN KEY meal_log_ibfk_1,
ADD CONSTRAINT meal_log_ibfk_1
FOREIGN KEY (client_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- mood log
ALTER TABLE mood_log
DROP FOREIGN KEY mood_log_ibfk_1,
ADD CONSTRAINT mood_log_ibfk_1
FOREIGN KEY (client_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- notifications
ALTER TABLE notifications
DROP FOREIGN KEY notifications_ibfk_1,
ADD CONSTRAINT notifications_ibfk_1
FOREIGN KEY (user_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- nutrition plan
ALTER TABLE nutrition_plan
DROP FOREIGN KEY nutrition_plan_ibfk_1,
ADD CONSTRAINT nutrition_plan_ibfk_1
FOREIGN KEY (client_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- reports reporter
ALTER TABLE reports
DROP FOREIGN KEY reports_ibfk_1,
ADD CONSTRAINT reports_ibfk_1
FOREIGN KEY (reporter_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- reports reported user
ALTER TABLE reports
DROP FOREIGN KEY reports_ibfk_2,
ADD CONSTRAINT reports_ibfk_2
FOREIGN KEY (reported_user_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- reviews client
ALTER TABLE reviews
DROP FOREIGN KEY reviews_ibfk_2,
ADD CONSTRAINT reviews_ibfk_2
FOREIGN KEY (client_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- workout log
ALTER TABLE workout_log
DROP FOREIGN KEY workout_log_ibfk_1,
ADD CONSTRAINT workout_log_ibfk_1
FOREIGN KEY (client_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- workout plan
ALTER TABLE workout_plan
DROP FOREIGN KEY workout_plan_ibfk_1,
ADD CONSTRAINT workout_plan_ibfk_1
FOREIGN KEY (client_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- client coach relationship (important: DO NOT CASCADE)
-- deleting a coach should not delete all their clients
ALTER TABLE client
DROP FOREIGN KEY fk_client_coach,
ADD CONSTRAINT fk_client_coach
FOREIGN KEY (coach_id)
REFERENCES coach(coach_id)
ON DELETE SET NULL
ON UPDATE CASCADE;

-- messages sender
ALTER TABLE messages
DROP FOREIGN KEY messages_ibfk_1,
ADD CONSTRAINT messages_ibfk_1
FOREIGN KEY (sender_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- messages receiver
ALTER TABLE messages
DROP FOREIGN KEY messages_ibfk_2,
ADD CONSTRAINT messages_ibfk_2
FOREIGN KEY (receiver_id)
REFERENCES client(client_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

SET FOREIGN_KEY_CHECKS = 1;