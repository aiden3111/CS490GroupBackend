from flask import Blueprint, request, jsonify
from db import get_conn

coach_landing_page_bp = Blueprint("coach_landing_page", __name__)

#Display the coaches landing page with all information about the coach
@coach_landing_page_bp.route("/<int:coach_id>", methods=["GET"])
def get_coach_landing_page(coach_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                coach_id,
                specialty,
                certifications,
                availability,
                status
            FROM coach
            WHERE coach_id = %s
        """, (coach_id,))
        coach_info = cursor.fetchone()

        if not coach_info:
            return jsonify({"error": "Coach not found"}), 404

        return jsonify(coach_info), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()