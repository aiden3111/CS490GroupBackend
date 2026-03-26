from flask import Blueprint, request, jsonify
from db import get_conn

coach_applications_bp = Blueprint("coach_applications", __name__)


@coach_applications_bp.route("/apply", methods=["POST"])
def apply_to_become_coach():
    data = request.get_json()

    client_id = data.get("client_id")
    bio = data.get("bio")
    specialty = data.get("specialty")
    certifications = data.get("certifications")
    pricing = data.get("pricing")

    if not client_id:
        return jsonify({"error": "client_id is required"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        # make sure client exists
        cursor.execute("""
            SELECT client_id, role
            FROM client
            WHERE client_id = %s
        """, (client_id,))
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        # make sure they are not already a coach
        if client["role"] == "coach":
            return jsonify({"error": "User is already a coach"}), 400

        # prevent duplicate pending applications
        cursor.execute("""
            SELECT application_id
            FROM coach_applications
            WHERE client_id = %s AND status = 'pending'
        """, (client_id,))
        existing_application = cursor.fetchone()

        if existing_application:
            return jsonify({"error": "You already have a pending application"}), 400

        # insert application
        cursor.execute("""
            INSERT INTO coach_applications (
                client_id,
                bio,
                specialty,
                certifications,
                pricing,
                status,
                submitted_at,
                reviewed_by,
                reviewed_at
            )
            VALUES (%s, %s, %s, %s, %s, 'pending', NOW(), NULL, NULL)
        """, (
            client_id,
            bio,
            specialty,
            certifications,
            pricing
        ))

        conn.commit()
        return jsonify({"message": "Coach application submitted successfully"}), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()