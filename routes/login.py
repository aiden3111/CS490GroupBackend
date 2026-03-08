from flask import jsonify, request, Blueprint
from db import get_conn

login_bp = Blueprint("login", __name__)


@login_bp.route('/', methods=['POST'])
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