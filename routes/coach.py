from flask import Blueprint, request, jsonify
from db import get_conn


coach_bp = Blueprint("coach", __name__)

@coach_bp.route("/<string:coach_id>/settings", methods=["PUT"])
def update_coach_settings(coach_id):
    """
    Update a coach's settings (pricing, availability, specialty, certifications, status).
    ---
    tags:
      - Coach
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            pricing:
              type: number
            availability:
              type: string
            specialty:
              type: string
              enum: [fitness, nutrition, both]
            certifications:
              type: string
            status:
              type: string
              enum: [active, suspended]
    responses:
      200:
        description: Coach settings updated successfully
      404:
        description: Coach not found
      500:
        description: Server error
    """
    data = request.get_json()

    pricing = data.get("pricing")
    availability = data.get("availability")
    specialty = data.get("specialty")
    certifications = data.get("certifications")
    status = data.get("status")

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT coach_id FROM coach WHERE coach_id = %s", (coach_id,))
        coach = cursor.fetchone()

        if not coach:
            return jsonify({"error": "Coach not found"}), 404

        cursor.execute("""
            UPDATE coach
            SET pricing = %s, availability = %s, specialty = %s, certifications = %s, status = %s
            WHERE coach_id = %s
        """, (pricing, availability, specialty, certifications, status, coach_id))

        conn.commit()
        return jsonify({"message": "Coach settings updated successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@coach_bp.route("/client-request", methods=["PUT"])
def handle_client_request():
    """
    Accept or decline a client's request to work with a coach.
    ---
    tags:
      - Coach
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - coach_id
            - client_id
            - action
          properties:
            coach_id:
              type: string
            client_id:
              type: string
            action:
              type: string
              enum: [accept, decline]
    responses:
      200:
        description: Client accepted or request declined
      400:
        description: Required fields missing or invalid action
      404:
        description: Client or coach not found
      500:
        description: Server error
    """
    data = request.get_json()

    coach_id = data.get("coach_id")
    client_id = data.get("client_id")
    action = data.get("action")

    if not coach_id or not client_id or not action:
        return jsonify({"error": "coach_id, client_id, and action are required"}), 400

    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT client_id FROM client WHERE client_id = %s", (client_id,))
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        cursor.execute("SELECT coach_id FROM coach WHERE coach_id = %s", (coach_id,))
        coach = cursor.fetchone()

        if not coach:
            return jsonify({"error": "Coach not found"}), 404

        if action == "accept":
            cursor.execute("UPDATE client SET coach_id = %s WHERE client_id = %s", (coach_id, client_id))
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
    """
    View a client's full progress: steps, calorie logs, and workout history.
    ---
    tags:
      - Coach
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
    responses:
      200:
        description: Client progress data including steps, calories, and workouts
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT first_name, last_name FROM client WHERE client_id = %s", (client_id,))
    client_info = cursor.fetchone()

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
    SELECT
        CAST(log_date AS CHAR) as log_date,
        actual_calories,
        protein,
        carbs,
        fats,
        notes
    FROM meal_log
    WHERE client_id = %s
    ORDER BY log_date ASC
    """, (client_id,))
    calories = cursor.fetchall()
    # I alsso need workout - prof requirements
    cursor.execute("""
        SELECT log_id, CAST(log_date AS CHAR) as log_date, exercise_id,
               sets_completed, reps_completed, weight, cardio_type, cardio_duration, notes
        FROM workout_log
        WHERE client_id = %s
        ORDER BY log_date DESC
    """, (client_id,))
    workouts = cursor.fetchall()

    return jsonify({
        "client_name": f"{client_info['first_name']} {client_info['last_name']}",
        "steps": steps,
        "calories": calories,
        "workouts": workouts
    }), 200
