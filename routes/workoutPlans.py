from flask import Blueprint, request, jsonify
from db import get_conn

workoutPlansPage = Blueprint("workoutPlansPage", __name__)

@workoutPlansPage.route("/", methods=["POST"])
def create_workout_plan():
    data = request.get_json()

    created_by = data.get("created_by")
    frequency = data.get("frequency")
    client_id = data.get("client_id")
    difficulty = data.get("difficulty")
    is_draft = data.get("is_draft", 1)

    if not all([created_by, frequency, client_id, difficulty]):
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
        conn.commit()

        new_id = cursor.lastrowid
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
    data = request.get_json()

    frequency = data.get("frequency")
    difficulty = data.get("difficulty")
    is_draft = data.get("is_draft")

    try:
        conn = get_conn()
        cursor = conn.cursor()

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
        conn.commit()

        if cursor.rowcount == 0:
            cursor.close()
            conn.close()
            return jsonify({"error": "Workout plan not found."}), 404

        cursor.close()
        conn.close()

        return jsonify({"message": "Workout plan updated successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@workoutPlansPage.route("/<int:workout_plan_id>", methods=["DELETE"])
def delete_workout_plan(workout_plan_id):
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