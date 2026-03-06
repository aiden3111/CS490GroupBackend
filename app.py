from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
import os
from dotenv import load_dotenv
from datetime import date

load_dotenv()

app = Flask(__name__)
CORS(app)

def get_conn():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME")
    )

@app.route('/api/login', methods=['POST'])
def login():
    data = request.get_json()
    clientEmail = data.get('clientEmail')
    password = data.get('password')
    
    if not clientEmail or not password:
        return jsonify({"error": "Email and password are required."}), 400
    
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM landing WHERE clientEmail = %s AND password = %s", (clientEmail, password))
    user_data = cursor.fetchone()
    cursor.close()
    conn.close()
    
    if user_data:
        return jsonify(user_data)
    else:
        return jsonify({"error": "Invalid email or password."}), 401

@app.route('/api/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    first_name = data.get('first_name')
    last_name = data.get('last_name')
    dob = data.get('dob')
    gender = data.get('gender')
    phone_number = data.get('phone_number')
    height = data.get('height')
    weight = data.get('weight')
    signupDate = date.today().strftime("%Y-%m-%d")

    if not all([email, password, first_name, last_name, dob, gender, phone_number, height, weight]):
        return jsonify({"error": "All fields are required."}), 400
    try:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO landing (email, password, first_name, last_name, dob, gender, phone_number, height, weight, signupDate) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                       (email, password, first_name, last_name, dob, gender, phone_number, height, weight, signupDate))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "User registered successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
