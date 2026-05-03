-- UC: Before/After Progress Photos

CREATE TABLE IF NOT EXISTS progress_photos (
    photo_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(50) NOT NULL,
    photo_type ENUM('before', 'after'),
    image_url VARCHAR(255),
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (client_id) REFERENCES client(client_id)
);