from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import datetime, timedelta

calorie_graph_bp = Blueprint("calorie_graph", __name__)

@calorie_graph_bp.route("/<string:client_id>", methods=["GET"])
def calorie_graph(client_id):

    range_type = request.args.get("range", "week") # get range for filter -- Aiden
    today = datetime.today()

    if range_type == "day":
        start_date = today.date()
        end_date = today.date()

    elif range_type == "week":
        start_date = (today - timedelta(days=today.weekday())).date() # Start of the week (Monday) -- Aiden
        end_date = start_date + timedelta(days=6) # End of the week (Sunday) -- Aiden

    elif range_type == "month":
        start_date = today.replace(day=1).date()
        end_date = today.date()

    else:
        return jsonify({"error": "Invalid range"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        
        cursor.execute("""
            SELECT 
                meal_log_id,
                CAST(log_date AS CHAR) as log_date,
                actual_calories,
                notes
            FROM meal_log
            WHERE client_id = %s AND DATE(log_date) BETWEEN %s AND %s
            ORDER BY log_date ASC
        """, (client_id, start_date, end_date)) 
        # added log_date filter to only get logs within the specified range -- Aiden
        cal_graph = cursor.fetchall()

        if not cal_graph:
            return jsonify([]), 404

        return jsonify(cal_graph), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close() 

