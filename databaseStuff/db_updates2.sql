-- UC 13.1 uploading and managing payment methods, have to create the table

CREATE TABLE IF NOT EXISTS payment_method (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(50) NOT NULL,
    card_type VARCHAR(20),
    last4 CHAR(4),
    expiry_month INT,
    expiry_year INT,
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES client(client_id)
);

-- uc 13.2 monthly invoices
CREATE TABLE IF NOT EXISTS invoice(
    invoice_id INT AUTO_INCREMENT PRIMARY KEY,
    client_id VARCHAR(50) NOT NULL,
    amount DECIMAL(8,2),
    billing_month VARCHAR(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (client_id) REFERENCES client(client_id)
);