from flask import Blueprint, request, jsonify
from db import get_conn

exercises_bp = Blueprint("exercises", __name__)


# Get all exercises
@exercises_bp.route("/", methods=["GET"])
def get_exercises():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                exercise_id,
                exercise_name,
                equipment,
                muscle_group,
                category,
                example_video,
                is_custom,
                created_by
            FROM exercises
            ORDER BY exercise_name ASC
        """)
        exercises = cursor.fetchall()
        return jsonify(exercises), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# Get one exercise by id
@exercises_bp.route("/<int:exercise_id>", methods=["GET"])
def get_exercise(exercise_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                exercise_id,
                exercise_name,
                equipment,
                muscle_group,
                category,
                example_video,
                is_custom,
                created_by
            FROM exercises
            WHERE exercise_id = %s
        """, (exercise_id,))
        exercise = cursor.fetchone()

        if not exercise:
            return jsonify({"error": "Exercise not found"}), 404

        return jsonify(exercise), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# Create a new exercise
@exercises_bp.route("/", methods=["POST"])
def create_exercise():
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body is required"}), 400

    exercise_name = data.get("exercise_name")
    equipment = data.get("equipment")
    muscle_group = data.get("muscle_group")
    category = data.get("category")
    example_video = data.get("example_video")
    is_custom = data.get("is_custom", 0)
    created_by = data.get("created_by")

    if not exercise_name:
        return jsonify({"error": "exercise_name is required"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            INSERT INTO exercises (
                exercise_name,
                equipment,
                muscle_group,
                category,
                example_video,
                is_custom,
                created_by
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            exercise_name,
            equipment,
            muscle_group,
            category,
            example_video,
            is_custom,
            created_by
        ))

        conn.commit()

        return jsonify({
            "message": "Exercise created successfully",
            "exercise_id": cursor.lastrowid
        }), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# Update an exercise
@exercises_bp.route("/<int:exercise_id>", methods=["PUT"])
def update_exercise(exercise_id):
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body is required"}), 400

    exercise_name = data.get("exercise_name")
    equipment = data.get("equipment")
    muscle_group = data.get("muscle_group")
    category = data.get("category")
    example_video = data.get("example_video")
    is_custom = data.get("is_custom")
    created_by = data.get("created_by")

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT exercise_id
            FROM exercises
            WHERE exercise_id = %s
        """, (exercise_id,))
        exercise = cursor.fetchone()

        if not exercise:
            return jsonify({"error": "Exercise not found"}), 404

        cursor.execute("""
            UPDATE exercises
            SET
                exercise_name = %s,
                equipment = %s,
                muscle_group = %s,
                category = %s,
                example_video = %s,
                is_custom = %s,
                created_by = %s
            WHERE exercise_id = %s
        """, (
            exercise_name,
            equipment,
            muscle_group,
            category,
            example_video,
            is_custom,
            created_by,
            exercise_id
        ))

        conn.commit()
        return jsonify({"message": "Exercise updated successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# Delete an exercise
@exercises_bp.route("/<int:exercise_id>", methods=["DELETE"])
def delete_exercise(exercise_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT exercise_id
            FROM exercises
            WHERE exercise_id = %s
        """, (exercise_id,))
        exercise = cursor.fetchone()

        if not exercise:
            return jsonify({"error": "Exercise not found"}), 404

        cursor.execute("""
            DELETE FROM exercises
            WHERE exercise_id = %s
        """, (exercise_id,))

        conn.commit()
        return jsonify({"message": "Exercise deleted successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()