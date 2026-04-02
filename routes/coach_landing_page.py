from flask import Blueprint, request, jsonify
from db import get_conn

coach_landing_page_bp = Blueprint("coach_landing_page", __name__)

#Display the coaches landing page with all information about the coach
@coach_landing_page_bp.route("/<string:coach_id>", methods=["GET"])
def get_coach_landing_page(coach_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                c.coach_id,
                c.availability,
                c.status,
                c.pricing,
                cl.first_name,
                cl.last_name,
                fc.certifications AS fitness_certifications,
                nc.certifications AS nutrition_certifications,
                CASE
                    WHEN fc.coach_id IS NOT NULL AND nc.coach_id IS NOT NULL THEN 'both'
                    WHEN fc.coach_id IS NOT NULL THEN 'fitness'
                    WHEN nc.coach_id IS NOT NULL THEN 'nutrition'
                    ELSE 'none'
                END AS specialty
            FROM coach c
            JOIN client cl ON c.coach_id = cl.client_id
            LEFT JOIN fitness_coach fc ON c.coach_id = fc.coach_id
            LEFT JOIN nutrition_coach nc ON c.coach_id = nc.coach_id
            WHERE c.coach_id = %s
        """, (coach_id,))
        coach_info = cursor.fetchone()

        if not coach_info:
            return jsonify({"error": "Coach not found"}), 404

        cursor.execute("""
            SELECT review_id, rating, comment, created_at
            FROM reviews
            WHERE coach_id = %s
        """, (coach_id,))
        coach_info["reviews"] = cursor.fetchall()

        return jsonify(coach_info), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


#Send a hire request to the coach
@coach_landing_page_bp.route("/<string:coach_id>/request", methods=["POST"])
def send_hire_request(coach_id):
    data = request.get_json()
    client_id = data.get("client_id") if data else None

    if not client_id:
        return jsonify({"error": "client_id is required"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        # Check coach exists
        cursor.execute("SELECT coach_id FROM coach WHERE coach_id = %s", (coach_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Coach not found"}), 404

        # Check for an existing pending request
        cursor.execute("""
            SELECT request_id FROM coach_request
            WHERE coach_id = %s AND client_id = %s AND status = 'pending'
        """, (coach_id, client_id))
        if cursor.fetchone():
            return jsonify({"error": "A pending request already exists"}), 409

        cursor.execute("""
            INSERT INTO coach_request (coach_id, client_id, status)
            VALUES (%s, %s, 'pending')
        """, (coach_id, client_id))
        conn.commit()

        return jsonify({"message": "Hire request sent successfully", "request_id": cursor.lastrowid}), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()
