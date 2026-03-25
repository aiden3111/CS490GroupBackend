from flask import Blueprint, request, jsonify
from db import get_conn #imports -- Aiden

profile_bp = Blueprint("profile", __name__) # create blueprint for profile page --Aiden

@profile_bp.route("/", methods=["GET"])
def get_profile():

    client_id = request.args.get("client_id")

    if not client_id:
        return jsonify({"error": "clientID is required"}), 400 # throw error if no client id -- Aiden
    
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        """
        SELECT client_id, first_name, last_name, email, dob, gender, phone_number, height, weight, role, signup_date
        FROM client
        WHERE client_id = %s
        """,
        (client_id,)
    )
    user = cursor.fetchone()

    cursor.close()
    conn.close()

    if not user:
        return jsonify({"error": "User not found"}), 404 #throw error if no user -- Aiden
    
    return jsonify(user)


# use case 2.2 - updating weight and height -- Aiden
@profile_bp.route("/physical", methods=["PUT"])
def update_physical():
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body is required"}), 400
    
    client_id = data.get("client_id")
    weight = data.get("weight")
    height = data.get("height")

    if not client_id:
        return jsonify({"error": "clientID is required"}), 400
    
    if weight is None and height is None:
        return jsonify({"error": "Must provide weight and/or height to update"}), 400
    
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        # check if user exists -- Aiden
        cursor.execute("SELECT client_id FROM client WHERE client_id = %s", (client_id,))
        user = cursor.fetchone()

        if not user: 
            return jsonify({"error": "User not found"}), 404
        
        # build update query dynamically based on provided -- Aiden

        fields = []
        values = []

        if weight is not None:
            fields.append("weight = %s")
            values.append(weight)
        if height is not None:
            fields.append("height = %s")
            values.append(height)

        values.append(client_id)

        cursor.execute(
            f"UPDATE client SET {', '.join(fields)} WHERE client_id = %s",
            tuple(values)
        )
        conn.commit()

        return jsonify({"message": "Physical info updated successfully"}), 200
    
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    
    finally: 
        cursor.close()
        conn.close()

# updating fitness goals -- Aiden

@profile_bp.route("/goals", methods=["PUT"])
def update_goals():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Request body is required"}), 400
    client_id = data.get("client_id")
    if not client_id:
        return jsonify({"error": "client_id is required"}), 400
    
    goal_weight = data.get("goal_weight")
    steps_per_day = data.get("steps_per_day")
    time_active_per_day = data.get("time_active_per_day")
    workout_days_per_week = data.get("workout_days_per_week")

    #make sure >= 1 goal field provided -- aiden
    if all(v is None for v in [goal_weight, steps_per_day, time_active_per_day, workout_days_per_week]):
        return jsonify({"error": "Must provide at least one goal field to update"}), 400
    
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        # check if goals exist for this client -- aiden
        cursor.execute("SELECT goal_id FROM goals WHERE client_id = %s", (client_id,))
        goal = cursor.fetchone()

        if not goal:
            return jsonify({"error": "No goals found for this client. Complete the survey first."}), 404
        
        # build the update query dynamically

        fields = []
        values = []

        if goal_weight is not None:
            fields.append("goal_weight = %s")
            values.append(goal_weight)
        if steps_per_day is not None:
            fields.append("steps = %s")
            values.append(steps_per_day)
        if time_active_per_day is not None:
            fields.append("time_active = %s")
            values.append(time_active_per_day)
        if workout_days_per_week is not None:
            fields.append("workout_days_per_week = %s")
            values.append(workout_days_per_week)

        values.append(client_id)

        cursor.execute(
            f"UPDATE goals SET {', '.join(fields)} WHERE client_id = %s",
            tuple(values)
        )
        conn.commit()

        return jsonify({"message": "Goals updated successfully"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    
    finally: 
        cursor.close()
        conn.close()

# use case 2.3 - updating coach qualifications/certifications -- Aiden'
@profile_bp.route("/certifications", methods=["PUT"])
def update_certifications():
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body is required"}), 400
    
    client_id = data.get("client_id")
    certifications = data.get("certifications")

    if not client_id:
        return jsonify({"error": "client_id is required"}), 400
    
    if certifications is None:
        return jsonify({"error": "certifications field is required"}), 400
    
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try: 
        # check if client is a coach -- Aiden
        cursor.execute("SELECT coach_id FROM coach WHERE coach_id = %s", (client_id,))
        coach = cursor.fetchone()

        if not coach:
            return jsonify({"error": "Coach not found. Only coaches can update certifications."}), 404

        cursor.execute(
            "UPDATE coach SET certifications = %s WHERE coach_id = %s",
            (certifications, client_id)
        )
        conn.commit()

        return jsonify({"message": "Certifications updated successfully"}), 200
    
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    
    finally:
        cursor.close()
        conn.close()
        
# goals (GET)
@profile_bp.route("/goals/<string:client_id>", methods=["GET"])
def get_goals(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM goals WHERE client_id = %s", (client_id,))
        goals = cursor.fetchone()

        if not goals:
            return jsonify({"error": "Goals not found"}), 404
        
        return jsonify(goals), 200
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@profile_bp.route("/coach/<string:coach_id>", methods=["GET", "PUT"])
def manage_coach_data(coach_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    if request.method == "GET":
        # We ONLY select the editable fields. No reviews.
        cursor.execute("SELECT pricing, specialty, certifications, availability, status FROM coach WHERE coach_id = %s", (coach_id,))
        return jsonify(cursor.fetchone()), 200

    if request.method == "PUT":
        data = request.get_json()
        cursor.execute("""
            UPDATE coach 
            SET pricing = %s, specialty = %s, certifications = %s, availability = %s 
            WHERE coach_id = %s
        """, (data['pricing'], data['specialty'], data['certifications'], data['availability'], coach_id))
        conn.commit()
        return jsonify({"message": "Profile updated"}), 200