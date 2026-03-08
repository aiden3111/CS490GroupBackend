from flask import Blueprint, request, jsonify
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests
from db import get_conn
import os
from datetime import date


google_login_bp = Blueprint("google-login", __name__)

@google_login_bp.route('/', methods=['POST'])
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