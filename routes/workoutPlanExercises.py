from flask import Blueprint, request, jsonify
from db import get_conn

workoutPlanExercisesPage = Blueprint("workoutPlanExercisesPage", __name__)

@workoutPlanExercisesPage.route("/<int:workout_plan_id>/exercises", methods=["POST"])
def add_exercise_to_plan(workout_plan_id):
    data = request.get_json()

    exercise_id = data.get("exercise_id")
    day_of_week = data.get("day_of_week")
    order_in_day = data.get("order_in_day")
    sets = data.get("sets")
    repetitions = data.get("repetitions")

    if not all([exercise_id, day_of_week, order_in_day, sets, repetitions]):
        return jsonify({"error": "Required fields are missing."}), 400

    try:
        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute(
            """
            INSERT INTO workout_plan_exercises
            (workout_plan_id, order_in_day, sets, day_of_week, repetitions, exercise_id)
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (
                workout_plan_id,
                order_in_day,
                sets,
                day_of_week,
                repetitions,
                exercise_id
            )
        )
        conn.commit()

        new_id = cursor.lastrowid

        cursor.close()
        conn.close()

        return jsonify({
            "message": "Exercise added to workout plan successfully.",
            "id": new_id
        }), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@workoutPlanExercisesPage.route("/entry/<int:id>", methods=["PUT"])
def update_plan_exercise(id):
    data = request.get_json()

    exercise_id = data.get("exercise_id")
    day_of_week = data.get("day_of_week")
    order_in_day = data.get("order_in_day")
    sets = data.get("sets")
    repetitions = data.get("repetitions")

    try:
        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute(
            """
            UPDATE workout_plan_exercises
            SET exercise_id = %s,
                day_of_week = %s,
                order_in_day = %s,
                sets = %s,
                repetitions = %s
            WHERE id = %s
            """,
            (
                exercise_id,
                day_of_week,
                order_in_day,
                sets,
                repetitions,
                id
            )
        )
        conn.commit()

        if cursor.rowcount == 0:
            cursor.close()
            conn.close()
            return jsonify({"error": "Workout plan exercise not found."}), 404

        cursor.close()
        conn.close()

        return jsonify({"message": "Workout plan exercise updated successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@workoutPlanExercisesPage.route("/entry/<int:id>", methods=["DELETE"])
def delete_plan_exercise(id):
    try:
        conn = get_conn()
        cursor = conn.cursor()

        cursor.execute("DELETE FROM workout_plan_exercises WHERE id = %s", (id,))
        conn.commit()

        if cursor.rowcount == 0:
            cursor.close()
            conn.close()
            return jsonify({"error": "Workout plan exercise not found."}), 404

        cursor.close()
        conn.close()

        return jsonify({"message": "Workout plan exercise deleted successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500


@workoutPlanExercisesPage.route("/<int:workout_plan_id>/day/<string:day_of_week>", methods=["GET"])
def get_plan_day(workout_plan_id, day_of_week):
    try:
        conn = get_conn()
        cursor = conn.cursor(dictionary=True)

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
            JOIN exercises e
                ON wpe.exercise_id = e.exercise_id
            WHERE wpe.workout_plan_id = %s
              AND wpe.day_of_week = %s
            ORDER BY wpe.order_in_day ASC
            """,
            (workout_plan_id, day_of_week)
        )
        exercises = cursor.fetchall()

        cursor.close()
        conn.close()

        return jsonify({"day_of_week": day_of_week, "exercises": exercises})
    except Exception as e:
        return jsonify({"error": str(e)}), 500