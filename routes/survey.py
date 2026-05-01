from flask import jsonify, request, Blueprint
from db import get_conn

survey_bp = Blueprint("survey", __name__)
@survey_bp.route('/', methods=['POST'])
def submit_survey():
    """
    Submit the initial fitness survey to set a client's goals.
    ---
    tags:
      - Survey
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
            - goal_weight
            - time_active_per_day
            - steps_per_day
            - workout_days_per_week
          properties:
            client_id:
              type: string
            goal_weight:
              type: number
            time_active_per_day:
              type: integer
              description: Minutes active per day
            steps_per_day:
              type: integer
            workout_days_per_week:
              type: integer
    responses:
      200:
        description: Survey submitted successfully
      400:
        description: All fields are required
      500:
        description: Server error
    """
    data = request.get_json()
    client_id = data.get('client_id')
    goal_weight = data.get('goal_weight')
    time_active_per_day = data.get('time_active_per_day')
    steps_per_day = data.get('steps_per_day')
    workout_days_per_week = data.get('workout_days_per_week')

    if not all([client_id, goal_weight, time_active_per_day, steps_per_day, workout_days_per_week]):
        return jsonify({"error": "All fields are required."}), 400
    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute("INSERT INTO goals (client_id, goal_weight, time_active, steps, workout_days_per_week) VALUES (%s, %s, %s, %s, %s)",
                       (client_id, goal_weight, time_active_per_day, steps_per_day, workout_days_per_week))
        conn.commit()
        return jsonify({"message": "Survey submitted successfully."}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()