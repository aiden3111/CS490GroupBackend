from flask import Blueprint, request, jsonify
from db import get_conn #imports -- Aiden

profile_bp = Blueprint("profile", __name__) # create blueprint for profile page --Aiden

@profile_bp.route("/", methods=["GET"])
def get_profile():

    email = request.args.get("email")

    if not email:
        return jsonify({"error": "Email is required"}), 400 # throw error if no email -- Aiden
    
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT client_id, first_name, last_name, email, dob, gender, phone_number, height, weight, role, signup_date
        FROM client
        WHERE email = %s
        """,
        (email,)
    )
    user = cursor.fetchone()

    cursor.close()
    conn.close()

    if not user:
        return jsonify({"error": "User not found"}), 404 #throw error if no user -- Aiden
    
    return jsonify(user)
