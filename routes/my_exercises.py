from flask import Blueprint, request, jsonify
from db import get_conn

my_exercises_bp = Blueprint("my_exercises", __name__)

@my_exercises_bp.route("/", methods=["GET"])
def get_my_exercises():
    """
    Get custom exercises created by a specific client.
    ---
    tags:
      - Exercises
    parameters:
      - name: client_id
        in: query
        required: true
        type: string
        description: Client ID who created the exercises
    responses:
      200:
        description: List of custom exercises
        schema:
          type: array
          items:
            type: object
            properties:
              exercise_id:
                type: integer
              exercise_name:
                type: string
              equipment:
                type: string
              muscle_group:
                type: string
              category:
                type: string
              example_video:
                type: string
              is_custom:
                type: boolean
              created_by:
                type: string
      500:
        description: Server error
    """

    editor_id = request.args.get("client_id")
    
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
       
        query = """
                SELECT *
                FROM exercises
                WHERE created_by = %s AND is_custom = 1
                ORDER BY exercise_name ASC
            """
    
        cursor.execute(query, (editor_id,))
        exercises = cursor.fetchall()
        
        return jsonify(exercises), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


