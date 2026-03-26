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

    # Check client table first
    cursor.execute("SELECT * FROM client WHERE email = %s AND password = %s", (clientEmail, password))
    user_data = cursor.fetchone()

    if user_data:
        cursor.close()
        conn.close()
        return jsonify(user_data)

    # Check admin table if not found in client
    cursor.execute("SELECT * FROM admin WHERE email = %s AND password = %s", (clientEmail, password))
    admin_data = cursor.fetchone()

    cursor.close()
    conn.close()

    if admin_data:
        admin_data["role"] = "admin"
        return jsonify(admin_data)

    return jsonify({"error": "Invalid email or password."}), 401