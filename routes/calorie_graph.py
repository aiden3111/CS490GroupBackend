from flask import Blueprint, request, jsonify
from db import get_conn


calorie_graph_bp = Blueprint("calorie_graph", __name__)

@calorie_graph_bp.route("/<string:client_id>", methods=["GET"])
def calorie_graph(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        
        cursor.execute("""
            SELECT 
                CAST(log_date AS CHAR) as log_date,
                actual_calories,
                notes
            FROM meal_log
            WHERE client_id = %s
            ORDER BY log_date ASC
        """, (client_id,))
        
        cal_graph = cursor.fetchall()

        if not cal_graph:
            return jsonify({"message": "No meals logged yet"}), 404

        return jsonify(cal_graph), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()