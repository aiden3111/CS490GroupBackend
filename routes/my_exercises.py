from flask import Blueprint, request, jsonify
from db import get_conn

my_exercises_bp = Blueprint("my_exercises", __name__)

@my_exercises_bp.route("/", methods=["GET"])
def get_my_exercises():

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


