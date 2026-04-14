-- UC 5.4: Add status column to client table -- Aiden
ALTER TABLE client 
ADD COLUMN status VARCHAR(20) DEFAULT 'active';