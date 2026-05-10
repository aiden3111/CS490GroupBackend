from flask import Blueprint, request, jsonify
from db import get_conn
from routes.notify import push_notification

workoutPlansPage = Blueprint("workoutPlansPage", __name__)

@workoutPlansPage.route("/", methods=["POST"])
def create_workout_plan():
    """
    Create a new workout plan.
    ---
    tags:
      - Workout Plans
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - frequency
            - client_id
            - difficulty
          properties:
            created_by:
              type: string
              description: Coach or client ID who created the plan
            frequency:
              type: string
              example: 3x per week
            client_id:
              type: string
              description: Client ID for whom the plan is created
            difficulty:
              type: string
              example: Beginner
            is_draft:
              type: boolean
              default: true
    responses:
      201:
        description: Workout plan created successfully
        schema:
          type: object
          properties:
            message:
              type: string
            workout_plan_id:
              type: integer
      400:
        description: Required fields missing
      500:
        description: Server error
    """
    data = request.get_json()

    created_by = data.get("created_by")
    frequency = data.get("frequency")
    client_id = data.get("client_id")
    difficulty = data.get("difficulty")
    is_draft = data.get("is_draft", 1)

    if not all([frequency, client_id, difficulty]):
        return jsonify({"error": "Required fields are missing."}), 400

    try:
        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute(
            """
            INSERT INTO workout_plan
            (created, created_by, frequency, client_id, difficulty, is_draft)
            VALUES (NOW(), %s, %s, %s, %s, %s)
            """,
            (created_by, frequency, client_id, difficulty, is_draft)
        )
        new_id = cursor.lastrowid

        # Notify client if a coach created the plan for them
        if created_by and created_by != client_id:
            cursor2 = conn.cursor(dictionary=True)
            cursor2.execute("SELECT first_name, last_name FROM client WHERE client_id = %s", (created_by,))
            coach_row = cursor2.fetchone()
            cursor2.close()
            coach_name = f"{coach_row['first_name']} {coach_row['last_name']}" if coach_row else "Your coach"
            push_notification(cursor, client_id, "workout", "New Workout Plan", f"{coach_name} created a new workout plan for you.")

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({
            "message": "Workout plan created successfully.",
            "workout_plan_id": new_id
        }), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@workoutPlansPage.route("/client/<string:client_id>", methods=["GET"])
def get_client_workout_plans(client_id):
    """
    Get all workout plans for a specific client.
    ---
    tags:
      - Workout Plans
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: The client ID
    responses:
      200:
        description: List of workout plans
        schema:
          type: object
          properties:
            workout_plans:
              type: array
              items:
                type: object
                properties:
                  workout_plan_id:
                    type: integer
                  created:
                    type: string
                    format: date-time
                  created_by:
                    type: string
                  frequency:
                    type: string
                  client_id:
                    type: string
                  difficulty:
                    type: string
                  is_draft:
                    type: boolean
      500:
        description: Server error
    """
    try:
        conn = get_conn()
        cursor = conn.cursor(dictionary=True)

        cursor.execute(
            """
            SELECT
                workout_plan_id,
                created,
                created_by,
                frequency,
                client_id,
                difficulty,
                is_draft
            FROM workout_plan
            WHERE client_id = %s
            ORDER BY created DESC
            """,
            (client_id,)
        )
        plans = cursor.fetchall()
        cursor.close()
        conn.close()

        return jsonify({"workout_plans": plans})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@workoutPlansPage.route("/<int:workout_plan_id>", methods=["GET"])
def get_workout_plan(workout_plan_id):
    """
    Get a specific workout plan with its exercises grouped by day.
    ---
    tags:
      - Workout Plans
    parameters:
      - name: workout_plan_id
        in: path
        required: true
        type: integer
        description: The workout plan ID
    responses:
      200:
        description: Workout plan with exercises
        schema:
          type: object
          properties:
            workout_plan:
              type: object
              properties:
                workout_plan_id:
                  type: integer
                created:
                  type: string
                  format: date-time
                created_by:
                  type: string
                frequency:
                  type: string
                client_id:
                  type: string
                difficulty:
                  type: string
                is_draft:
                  type: boolean
            exercises_by_day:
              type: object
              additionalProperties:
                type: array
                items:
                  type: object
                  properties:
                    id:
                      type: integer
                    workout_plan_id:
                      type: integer
                    day_of_week:
                      type: string
                    order_in_day:
                      type: integer
                    sets:
                      type: integer
                    repetitions:
                      type: integer
                    exercise_id:
                      type: integer
                    exercise_name:
                      type: string
                    muscle_group:
                      type: string
                    equipment:
                      type: string
                    category:
                      type: string
                    example_video:
                      type: string
                    is_custom:
                      type: boolean
      404:
        description: Workout plan not found
      500:
        description: Server error
    """
    try:
        conn = get_conn()
        cursor = conn.cursor(dictionary=True)

        cursor.execute(
            """
            SELECT
                workout_plan_id,
                created,
                created_by,
                frequency,
                client_id,
                difficulty,
                is_draft
            FROM workout_plan
            WHERE workout_plan_id = %s
            """,
            (workout_plan_id,)
        )
        plan = cursor.fetchone()

        if not plan:
            cursor.close()
            conn.close()
            return jsonify({"error": "Workout plan not found."}), 404

        cursor.execute(
            """
            SELECT
                wpe.id,
                wpe.workout_plan_id,
                wpe.day_of_week,
                wpe.order_in_day,
                wpe.sets,
                wpe.repetitions,
                wpe.exercise_id,
                e.exercise_name,
                e.muscle_group,
                e.equipment,
                e.category,
                e.example_video,
                e.is_custom
            FROM workout_plan_exercises wpe
            JOIN exercises e ON wpe.exercise_id = e.exercise_id
            WHERE wpe.workout_plan_id = %s
            ORDER BY
                FIELD(wpe.day_of_week, 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'),
                wpe.order_in_day ASC
            """,
            (workout_plan_id,)
        )
        plan_exercises = cursor.fetchall()

        grouped = {}
        for item in plan_exercises:
            day = item["day_of_week"]
            if day not in grouped:
                grouped[day] = []
            grouped[day].append(item)

        cursor.close()
        conn.close()

        return jsonify({
            "workout_plan": plan,
            "exercises_by_day": grouped
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@workoutPlansPage.route("/<int:workout_plan_id>", methods=["PUT"])
def update_workout_plan(workout_plan_id):
    """
    Update an existing workout plan.
    ---
    tags:
      - Workout Plans
    parameters:
      - name: workout_plan_id
        in: path
        required: true
        type: integer
        description: The workout plan ID
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            frequency:
              type: string
            difficulty:
              type: string
            is_draft:
              type: boolean
    responses:
      200:
        description: Workout plan updated successfully
      404:
        description: Workout plan not found
      500:
        description: Server error
    """
    data = request.get_json()

    frequency = data.get("frequency")
    difficulty = data.get("difficulty")
    is_draft = data.get("is_draft")

    try:
        conn = get_conn()
        cursor = conn.cursor()

        # Fetch plan info for notification before updating
        cursor.execute(
            "SELECT client_id, created_by FROM workout_plan WHERE workout_plan_id = %s",
            (workout_plan_id,)
        )
        plan_info = cursor.fetchone()

        cursor.execute(
            """
            UPDATE workout_plan
            SET frequency = %s,
                difficulty = %s,
                is_draft = %s
            WHERE workout_plan_id = %s
            """,
            (frequency, difficulty, is_draft, workout_plan_id)
        )

        if cursor.rowcount == 0:
            conn.commit()
            cursor.close()
            conn.close()
            return jsonify({"error": "Workout plan not found."}), 404

        # Notify client if a coach updated their plan
        # plan_info is a tuple: (client_id, created_by)
        if plan_info and plan_info[1] and plan_info[1] != plan_info[0]:
            push_notification(
                cursor, plan_info[0], "workout",
                "Workout Plan Updated", "Your workout plan has been updated by your coach.",
            )

        conn.commit()
        cursor.close()
        conn.close()

        return jsonify({"message": "Workout plan updated successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@workoutPlansPage.route("/<int:workout_plan_id>", methods=["DELETE"])
def delete_workout_plan(workout_plan_id):
    """
    Delete a workout plan and all its associated exercises.
    ---
    tags:
      - Workout Plans
    parameters:
      - name: workout_plan_id
        in: path
        required: true
        type: integer
        description: The workout plan ID
    responses:
      200:
        description: Workout plan deleted successfully
      404:
        description: Workout plan not found
      500:
        description: Server error
    """
    try:
        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute(
            "DELETE FROM workout_plan_exercises WHERE workout_plan_id = %s",
            (workout_plan_id,)
        )
        cursor.execute(
            "DELETE FROM workout_plan WHERE workout_plan_id = %s",
            (workout_plan_id,)
        )
        conn.commit()

        if cursor.rowcount == 0:
            cursor.close()
            conn.close()
            return jsonify({"error": "Workout plan not found."}), 404

        cursor.close()
        conn.close()

        return jsonify({"message": "Workout plan deleted successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500