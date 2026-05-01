from flask import Blueprint, request, jsonify
from db import get_conn #imports -- Aiden

profile_bp = Blueprint("profile", __name__) # create blueprint for profile page --Aiden

@profile_bp.route("/", methods=["GET"])
def get_profile():
    """
    Get a user's profile by client_id.
    ---
    tags:
      - Profile
    parameters:
      - name: client_id
        in: query
        required: true
        type: string
        description: The client's unique ID
    responses:
      200:
        description: User profile data
      400:
        description: client_id is required
      404:
        description: User not found
    """
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
    """
    Update a user's weight and/or height.
    ---
    tags:
      - Profile
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
          properties:
            client_id:
              type: string
            weight:
              type: number
              example: 175.5
            height:
              type: number
              example: 70.0
    responses:
      200:
        description: Physical info updated successfully
      400:
        description: client_id required or no fields provided
      404:
        description: User not found
      500:
        description: Server error
    """
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
    """
    Update a client's fitness goals.
    ---
    tags:
      - Profile
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
          properties:
            client_id:
              type: string
            goal_weight:
              type: number
            steps_per_day:
              type: integer
            time_active_per_day:
              type: integer
            workout_days_per_week:
              type: integer
    responses:
      200:
        description: Goals updated successfully
      400:
        description: client_id required or no goal fields provided
      404:
        description: No goals found — complete survey first
      500:
        description: Server error
    """
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
    """
    Update a coach's certifications.
    ---
    tags:
      - Profile
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
            - certifications
          properties:
            client_id:
              type: string
            certifications:
              type: string
    responses:
      200:
        description: Certifications updated successfully
      400:
        description: Required fields missing
      404:
        description: Coach not found
      500:
        description: Server error
    """
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
    """
    Get a client's fitness goals.
    ---
    tags:
      - Profile
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
    responses:
      200:
        description: Goals data, or zeros if no goals set
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT * FROM goals WHERE client_id = %s", (client_id,))
        goals = cursor.fetchone()

        if not goals:
            return jsonify({
                "goal_weight": 0,
                "steps": 0,
                "time_active": 0,
                "workout_days_per_week": 0
            }), 200

        return jsonify(goals), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@profile_bp.route("/coach/<string:coach_id>", methods=["GET", "PUT"])
def manage_coach_data(coach_id):
    """
    Get or update a coach's pricing and availability.
    ---
    tags:
      - Profile
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
      - in: body
        name: body
        required: false
        schema:
          type: object
          properties:
            pricing:
              type: number
            availability:
              type: string
    responses:
      200:
        description: Coach data retrieved or updated
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    if request.method == "GET":
        # We ONLY select the editable fields. No reviews.
        cursor.execute("SELECT pricing, availability, status FROM coach WHERE coach_id = %s", (coach_id,))
        return jsonify(cursor.fetchone()), 200

    if request.method == "PUT":
        data = request.get_json()
        cursor.execute("""
            UPDATE coach
            SET pricing = %s, availability = %s
            WHERE coach_id = %s
        """, (data['pricing'], data['availability'], coach_id))
        conn.commit()
        return jsonify({"message": "Profile updated"}), 200

@profile_bp.route("/fitness_coach/<string:coach_id>", methods=["GET", "PUT"])
def manage_fitness_coach(coach_id):
    """
    Get or update a fitness coach's certifications.
    ---
    tags:
      - Profile
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
      - in: body
        name: body
        required: false
        schema:
          type: object
          properties:
            certifications:
              type: string
    responses:
      200:
        description: Fitness coach data retrieved or updated
      400:
        description: Coach not in fitness table
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        if request.method == "GET":
            cursor.execute("SELECT * FROM fitness_coach WHERE coach_id = %s", (coach_id,))
            data = cursor.fetchone()
            if not data:
                return jsonify({"Error: Coach not in fitness table"}), 400
            return jsonify(data), 200

        if request.method == "PUT":
            data = request.get_json()
            certifications = data.get("certifications", "")

            cursor.execute("SELECT 1 FROM fitness_coach WHERE coach_id = %s", (coach_id,))
            exists = cursor.fetchone()

            if exists:
                cursor.execute("""
                    UPDATE fitness_coach
                    SET certifications = %s
                    WHERE coach_id = %s
                """, (certifications, coach_id))
            else:
                cursor.execute("""
                    INSERT INTO fitness_coach (coach_id, certifications)
                    VALUES (%s, %s)
                """, (coach_id, certifications))

            conn.commit()
            return jsonify({"message": "Fitness profile updated successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@profile_bp.route("/nutrition_coach/<string:coach_id>", methods=["GET", "PUT"])
def manage_nutrition_coach(coach_id):
    """
    Get or update a nutrition coach's certifications.
    ---
    tags:
      - Profile
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
      - in: body
        name: body
        required: false
        schema:
          type: object
          properties:
            certifications:
              type: string
    responses:
      200:
        description: Nutrition coach data retrieved or updated
      400:
        description: Coach not in nutrition table
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        if request.method == "GET":
            cursor.execute("SELECT * FROM nutrition_coach WHERE coach_id = %s", (coach_id,))
            data = cursor.fetchone()
            if not data:
                return jsonify({"Error: not in nutrition table"}), 400
            return jsonify(data), 200

        if request.method == "PUT":
            data = request.get_json()
            certifications = data.get("certifications", "")

            cursor.execute("SELECT 1 FROM nutrition_coach WHERE coach_id = %s", (coach_id,))
            exists = cursor.fetchone()

            if exists:
                cursor.execute("""
                    UPDATE nutrition_coach
                    SET certifications = %s
                    WHERE coach_id = %s
                """, (certifications, coach_id))
            else:
                cursor.execute("""
                    INSERT INTO nutrition_coach (coach_id, certifications)
                    VALUES (%s, %s)
                """, (coach_id, certifications))

            conn.commit()
            return jsonify({"message": "nutrition profile updated successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# use case 1.6 logout -- Aiden
@profile_bp.route("/logout", methods=["POST"])
def logout():
    """
    Log out the current user (session-less placeholder).
    ---
    tags:
      - Authentication
    responses:
      200:
        description: Logged out successfully
    """
    return jsonify({"message": "Logged out successfully"}), 200

# use case 1.7 deleting -- Aiden
@profile_bp.route("/", methods=["DELETE"])
def delete_account():
    """
    Delete a user account and all associated data.
    ---
    tags:
      - Profile
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
          properties:
            client_id:
              type: string
    responses:
      200:
        description: Account deleted successfully
      400:
        description: client_id is required
      404:
        description: User not found
      500:
        description: Server error
    """
    data = request.get_json()

    if not data or "client_id" not in data:
        return jsonify({"error": "client_id is required"}), 400

    client_id = data.get("client_id")

    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute("SELECT client_id FROM client WHERE client_id = %s", (client_id,))
        user = cursor.fetchone()

        if not user:
            return jsonify({"error": "User not found"}), 404

        # delete dependencies first -- aiden

        cursor.execute("DELETE FROM messages WHERE sender_id = %s OR receiver_id = %s", (client_id, client_id))
        cursor.execute("DELETE FROM logging WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM meal_log WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM mood_log WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM notifications WHERE user_id = %s", (client_id,))
        cursor.execute("DELETE FROM nutrition_plan WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM reports WHERE reporter_id = %s OR reported_user_id = %s", (client_id, client_id))
        cursor.execute("DELETE FROM reviews WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM workout_log WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM workout_plan WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM coach_applications WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM exercises WHERE created_by = %s", (client_id,))
        cursor.execute("DELETE FROM coach WHERE coach_id = %s", (client_id,))
        cursor.execute("DELETE FROM client WHERE client_id = %s", (client_id,))

        conn.commit()

        return jsonify({"message": "Account deleted successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()
