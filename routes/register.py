from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import date
import uuid

register_bp = Blueprint("register", __name__)

@register_bp.route('/', methods=['POST'])
def register():
    """
    Register a new client account.
    ---
    tags:
      - Authentication
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - email
            - password
            - first_name
            - last_name
            - dob
          properties:
            email:
              type: string
              example: user@example.com
            password:
              type: string
            first_name:
              type: string
            last_name:
              type: string
            dob:
              type: string
              example: "1995-06-15"
            gender:
              type: string
              example: Male
            phone_number:
              type: string
            height:
              type: number
            weight:
              type: number
    responses:
      200:
        description: User registered successfully, returns generated client_id
      400:
        description: Required fields are missing
      409:
        description: Email already exists
      500:
        description: Server error
    """
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
    signup_date = date.today().strftime("%Y-%m-%d") # changed name to match the one in the DB -- Aiden

    if not all([email, password, first_name, last_name, dob]): # DB Doesn't require 'gender', 'phone number', 'height' or 'weight' and they can remain NULL without causing issues, so removed them -- Aiden
        return jsonify({"error": "Required fields are missing."}), 400
    
    client_id = str(uuid.uuid4())[:8] # gen unique client ID using uuid + shorten it to 8 chars -- Aiden
    try:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute("INSERT INTO client (client_id, email, password, first_name, last_name, dob, gender, phone_number, height, weight, signup_date) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)", # added client_id -- Aiden
                       (client_id, email, password, first_name, last_name, dob, gender, phone_number, height, weight, signup_date)) # added client_id -- Aiden
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "User registered successfully.",
                        "client_id": client_id}) # added client_id -- Aiden
    except Exception as e:
      error_message = str(e).lower()

      if "duplicate" in error_message or "unique" in error_message:
          return jsonify({"error": "Email already exists."}), 409

      return jsonify({"error": str(e)}), 500