from flask import Flask, jsonify, request
from flask_cors import CORS
import mysql.connector
import os
from dotenv import load_dotenv
from datetime import date
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests

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
    
    '''
    front End:
    Add the Google Sign-In button to the front page
    Send the ID token to POST http://localhost:5000/api/google-login
    Use GOOGLE_CLIENT_ID on their end
    '''
@app.route('/api/google-login', methods=['POST'])
def google_login():
    data = request.get_json()
    token = data.get('token')
    
    if not token:
        return jsonify({"error": "Token is required."}), 400
    
    #Send token to google for verification and get user info
    try:
        id_info = id_token.verify_oauth2_token(token, 
                                               google_requests.Request(), 
                                               os.getenv("GOOGLE_CLIENT_ID"))
        
        #Pulls user information
        email = id_info.get('email')
        first_name = id_info.get('given_name')
        last_name = id_info.get('family_name')
    
    except ValueError:
        return jsonify({"error": "Invalid token."}), 401
    
    #checking if user exists in database, if not create new user with google info and return user data
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM landing WHERE clientEmail = %s", (email,))
    user_data = cursor.fetchone()

    #if not a user send back info to frontend for registration
    if not user_data:
        return jsonify({
            "needs registration": True,
            "email": email,
            "first_name": first_name,
            "last_name": last_name,
            "signupDate": date.today().strftime("%Y-%m-%d")
        }), 200

    cursor.close()
    conn.close()
    return jsonify(user_data)
    
if __name__ == "__main__":
    app.run(debug=True)
