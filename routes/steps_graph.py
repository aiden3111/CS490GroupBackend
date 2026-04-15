from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import datetime, timedelta

steps_graph_bp = Blueprint("steps_graph", __name__)

@steps_graph_bp.route("/<string:client_id>", methods=["GET"])
def get_steps(client_id):

    range_type = request.args.get("range", "week") # added range filter to specify day, week, or month -- Aiden
    today = datetime.today()

    if range_type == "day":
        start_date = today.date()
        end_date = today.date()

    elif range_type == "week":
        start_date = (today - timedelta(days=today.weekday())).date() 
        end_date = start_date + timedelta(days=6)

    elif range_type == "month":
        start_date = today.replace(day=1)
        end_date = today

    else:
        return jsonify({"error": "Invalid range"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        
        cursor.execute("""
            SELECT 
                CAST(log_date AS CHAR) as log_date,
                steps
            FROM logging
            WHERE client_id = %s AND DATE(log_date) BETWEEN %s AND %s
            ORDER BY log_date ASC
        """, (client_id, start_date, end_date))
        
        step_data = cursor.fetchall()

        if not step_data:
            return jsonify([]), 200 

        return jsonify(step_data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()