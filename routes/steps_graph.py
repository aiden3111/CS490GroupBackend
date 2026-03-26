from flask import Blueprint, request, jsonify
from db import get_conn

steps_graph_bp = Blueprint("steps_graph", __name__)

@steps_graph_bp.route("/<string:client_id>", methods=["GET"])
def get_steps(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        
        cursor.execute("""
            SELECT 
                CAST(log_date AS CHAR) as log_date,
                steps
            FROM logging
            WHERE client_id = %s
            ORDER BY log_date ASC
        """, (client_id,))
        
        step_data = cursor.fetchall()

        if not step_data:
            return jsonify([]), 200 

        return jsonify(step_data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()