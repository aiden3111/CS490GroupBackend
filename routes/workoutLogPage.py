from flask import Blueprint, request, jsonify
from db import get_conn

# Allow clients to log, edit their workouts, and display their workout history.
workoutLogPage = Blueprint("workoutLogPage", __name__)

@workoutLogPage.route('/', methods=['POST'])
def log_workout():
    data = request.get_json()
    client_id = data.get('client_id')
    log_date = data.get('log_date')
    exercise_id = data.get('exercise_id')  # fixed typo: excerise_id -> exercise_id
    sets = data.get('sets')
    reps = data.get('reps')
    weight = data.get('weight')
    cardio_type = data.get('cardio_type')
    cardio_duration = data.get('cardio_duration')
    notes = data.get('notes')

    if not all([client_id, log_date, exercise_id]):
        return jsonify({"error": "Required fields are missing."}), 400
    
    try:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO workout_log (client_id, log_date, exercise_id, sets_completed, reps_completed, weight, cardio_type, cardio_duration, notes) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)",
            (client_id, log_date, exercise_id, sets, reps, weight, cardio_type, cardio_duration, notes)
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "Workout logged successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@workoutLogPage.route('/<int:log_id>', methods=['PUT'])
def edit_workout(log_id):
    data = request.get_json()
    sets = data.get('sets')
    reps = data.get('reps')
    weight = data.get('weight')
    cardio_type = data.get('cardio_type')
    cardio_duration = data.get('cardio_duration')
    notes = data.get('notes')

    try:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE workout_log SET sets_completed=%s, reps_completed=%s, weight=%s, cardio_type=%s, cardio_duration=%s, notes=%s WHERE log_id=%s",
            (sets, reps, weight, cardio_type, cardio_duration, notes, log_id)
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "Workout log updated successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@workoutLogPage.route('/<int:log_id>', methods=['DELETE'])
def delete_workout(log_id):
    try:
        conn = get_conn()
        cursor = conn.cursor()
        cursor.execute(
            "SELECT log_id FROM workout_log WHERE log_id=%s",
            (log_id,)
        )
        if cursor.fetchone() is None:
            cursor.close()
            conn.close()
            return jsonify({"error": "Workout log not found."}), 404
 
        cursor.execute(
            "DELETE FROM workout_log WHERE log_id=%s",
            (log_id,)
        )
        conn.commit()
        cursor.close()
        conn.close()
        return jsonify({"message": "Workout log deleted successfully."})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@workoutLogPage.route('/history/<string:client_id>', methods=['GET'])
def workout_history(client_id):
    try:
        conn = get_conn()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            """
            SELECT log_id, log_date, exercise_id, sets_completed, 
                   reps_completed, weight, cardio_type, cardio_duration, notes 
            FROM workout_log 
            WHERE client_id=%s 
            ORDER BY log_date DESC, log_id ASC
            """,
            (client_id,)
        )
        logs = cursor.fetchall()
        cursor.close()
        conn.close()

        # Group by date
        grouped = {}
        for log in logs:
            date = str(log["log_date"])
            if date not in grouped:
                grouped[date] = []
            grouped[date].append(log)

        return jsonify({"workout_history": grouped})
    except Exception as e:
        return jsonify({"error": str(e)}), 500