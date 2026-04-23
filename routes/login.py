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

    try: 
        cursor.execute("SELECT * FROM client WHERE email = %s AND password = %s", (clientEmail, password))
        user_data = cursor.fetchone()

        if user_data:
            if user_data.get('role') == 'coach':
                coach_id = user_data['client_id']

                cursor.execute("SELECT 1 FROM nutrition_coach WHERE coach_id = %s", (coach_id,))
                specialty_nutrition = cursor.fetchone()

                cursor.execute("SELECT 1 FROM fitness_coach WHERE coach_id = %s", (coach_id,))
                specialty_fitness = cursor.fetchone()

                if specialty_nutrition and specialty_fitness:
                    user_data['specialty'] = 'both'
                elif specialty_fitness:
                    user_data['specialty'] = 'fitness'
                elif specialty_nutrition:
                    user_data['specialty'] = 'nutrition'
                else:
                    user_data['specialty'] = None
            else:
                user_data['specialty'] = None
            # If the user is an admin (stored in client table), include admin_id for admin actions
            if user_data.get("role") == "admin":
                cursor.execute("SELECT admin_id, is_active FROM admin WHERE email = %s", (clientEmail,))
                admin_row = cursor.fetchone()
                if admin_row:
                    user_data["admin_id"] = admin_row["admin_id"]
                    user_data["admin_is_active"] = admin_row["is_active"]
                
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
    finally:
        cursor.close()
        conn.close()