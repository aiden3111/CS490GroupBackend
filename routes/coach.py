from flask import Blueprint, request, jsonify
from db import get_conn


coach_bp = Blueprint("coach", __name__)

@coach_bp.route("/<string:coach_id>/settings", methods=["PUT"])
def update_coach_settings(coach_id):
    data = request.get_json()

    pricing = data.get("pricing")
    availability = data.get("availability")
    specialty = data.get("specialty")
    certifications = data.get("certifications")
    status = data.get("status")

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT coach_id
            FROM coach
            WHERE coach_id = %s
        """, (coach_id,))
        coach = cursor.fetchone()

        if not coach:
            return jsonify({"error": "Coach not found"}), 404

        cursor.execute("""
            UPDATE coach
            SET pricing = %s,
                availability = %s,
                specialty = %s,
                certifications = %s,
                status = %s
            WHERE coach_id = %s
        """, (
            pricing,
            availability,
            specialty,
            certifications,
            status,
            coach_id
        ))

        conn.commit()
        return jsonify({"message": "Coach settings updated successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()