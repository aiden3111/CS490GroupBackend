USE fitappdb;

CREATE TABLE notification_preferences (
    preference_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(50) NOT NULL UNIQUE,
    daily_water_reminder TINYINT(1) NOT NULL DEFAULT 1,
    workout_today_reminder TINYINT(1) NOT NULL DEFAULT 1,
    email_notifications TINYINT(1) NOT NULL DEFAULT 1,
    in_app_notifications TINYINT(1) NOT NULL DEFAULT 1,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_notification_preferences_client
        FOREIGN KEY (client_id) REFERENCES client(client_id)
        ON DELETE CASCADE
);