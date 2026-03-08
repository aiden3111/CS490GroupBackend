from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import date

register_bp = Blueprint("register", __name__)

@register_bp.route('/', methods=['POST'])
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
        cursor.execute("INSERT INTO client (email, password, first_name, last_name, dob, gender, phone_number, height, weight, signupDate) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
                       (email, password, first_name, last_name, dob, gender, phone_number, height, weight, signupDate))
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "User registered successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500