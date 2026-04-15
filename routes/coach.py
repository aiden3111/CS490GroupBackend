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


# use case 4.1 accept or declining client requests -- Aiden
@coach_bp.route("/client-request", methods=["PUT"])
def handle_client_request():
    data = request.get_json()

    coach_id = data.get("coach_id")
    client_id = data.get("client_id")
    action = data.get("action")  # "accept" or "decline" -- Aiden

    if not coach_id or not client_id or not action:
        return jsonify({"error": "coach_id, client_id, and action are required"}), 400

    conn = get_conn()
    cursor = conn.cursor()

    try:
        # check that client exists -- aiden
        cursor.execute("SELECT client_id FROM client WHERE client_id = %s", (client_id,))
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        # check if coach exists -- aiden
        cursor.execute("SELECT coach_id FROM coach WHERE coach_id = %s", (coach_id,))
        coach = cursor.fetchone()

        if not coach:
            return jsonify({"error": "Coach not found"}), 404

        if action == "accept":
            cursor.execute(
                "UPDATE client SET coach_id = %s WHERE client_id = %s",
                (coach_id, client_id)
            )
            message = "Client accepted"

        elif action == "decline":
            message = "Client request declined"

        else:
            return jsonify({"error": "Invalid action"}), 400

        conn.commit()

        return jsonify({"message": message}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@coach_bp.route("/client_progress/<string:client_id>", methods=["GET"])
def view_client_progress(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    # for steps
    cursor.execute("""
        SELECT CAST(log_date AS CHAR) as log_date, steps
        FROM logging
        WHERE client_id = %s
        ORDER BY log_date ASC
    """, (client_id,))
    steps = cursor.fetchall()

    # calories
    cursor.execute("""
        SELECT CAST(log_date AS CHAR) as log_date, actual_calories
        FROM meal_log
        WHERE client_id = %s
        ORDER BY log_date ASC
    """, (client_id,))
    calories = cursor.fetchall()

    return jsonify({
        "steps": steps,
        "calories": calories
    }), 200