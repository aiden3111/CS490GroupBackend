from flask import Blueprint, request, jsonify
from db import get_conn


my_coach_bp = Blueprint("my_coach", __name__)

@my_coach_bp.route("/<string:client_id>", methods=["GET"])
def get_my_coach(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                c.coach_id,
                cl_coach.first_name,
                cl_coach.last_name,
                c.specialty,
                c.certifications,
                c.availability,
                c.pricing
            FROM client cl_user
            JOIN coach c ON cl_user.coach_id = c.coach_id
            JOIN client cl_coach ON c.coach_id = cl_coach.client_id
            WHERE cl_user.client_id = %s
        """, (client_id,))
        
        assigned_coach = cursor.fetchone()

        if not assigned_coach:
            return jsonify({"message": "No coach found"}), 404

        return jsonify(assigned_coach), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()



@my_coach_bp.route("/<string:client_id>", methods=["PUT"])
def remove_my_coach(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            UPDATE client
            SET coach_id = NULL
            WHERE client_id = %s
        """, (client_id,))
    
        conn.commit()

        return jsonify({"message": "Coach removed successfully"}), 200
        
        

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()