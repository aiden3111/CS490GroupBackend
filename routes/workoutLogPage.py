from flask import Blueprint, request, jsonify
from db import get_conn

# Allow clients to log, edit their workouts, and display their workout history.
workoutLogPage = Blueprint("workoutLogPage", __name__)

@workoutLogPage.route('', methods=['POST'])
def log_workout():
    """
    Log a workout entry for a client.
    ---
    tags:
      - Workout Logs
    parameters:
      - name: workout_data
        in: body
        required: true
        schema:
          type: object
          required:
            - client_id
            - log_date
            - exercise_id
          properties:
            client_id:
              type: string
              description: Client ID
            log_date:
              type: string
              format: date
              description: Date of the workout
            exercise_id:
              type: integer
              description: Exercise ID
            sets:
              type: integer
              description: Number of sets completed
            reps:
              type: integer
              description: Number of reps completed
            weight:
              type: number
              description: Weight used
            cardio_type:
              type: string
              description: Type of cardio exercise
            cardio_duration:
              type: integer
              description: Duration of cardio in minutes
            notes:
              type: string
              description: Additional notes
    responses:
      200:
        description: Workout logged successfully
        schema:
          type: object
          properties:
            message:
              type: string
      400:
        description: Required fields are missing
      500:
        description: Server error
    """
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
    """
    Edit an existing workout log entry.
    ---
    tags:
      - Workout Logs
    parameters:
      - name: log_id
        in: path
        required: true
        type: integer
        description: Workout log ID
      - name: workout_updates
        in: body
        required: true
        schema:
          type: object
          properties:
            sets:
              type: integer
              description: Number of sets completed
            reps:
              type: integer
              description: Number of reps completed
            weight:
              type: number
              description: Weight used
            cardio_type:
              type: string
              description: Type of cardio exercise
            cardio_duration:
              type: integer
              description: Duration of cardio in minutes
            notes:
              type: string
              description: Additional notes
    responses:
      200:
        description: Workout log updated successfully
        schema:
          type: object
          properties:
            message:
              type: string
      500:
        description: Server error
    """
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
    """
    Delete a workout log entry.
    ---
    tags:
      - Workout Logs
    parameters:
      - name: log_id
        in: path
        required: true
        type: integer
        description: Workout log ID to delete
    responses:
      200:
        description: Workout log deleted successfully
        schema:
          type: object
          properties:
            message:
              type: string
      404:
        description: Workout log not found
      500:
        description: Server error
    """
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
    """
    Get workout history for a client, grouped by date.
    ---
    tags:
      - Workout Logs
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
    responses:
      200:
        description: Workout history grouped by date
        schema:
          type: object
          properties:
            workout_history:
              type: object
              description: Object with dates as keys and arrays of workout logs as values
              additionalProperties:
                type: array
                items:
                  type: object
                  properties:
                    log_id:
                      type: integer
                    log_date:
                      type: string
                      format: date
                    exercise_id:
                      type: integer
                    sets_completed:
                      type: integer
                    reps_completed:
                      type: integer
                    weight:
                      type: number
                    cardio_type:
                      type: string
                    cardio_duration:
                      type: integer
                    notes:
                      type: string
      500:
        description: Server error
    """
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