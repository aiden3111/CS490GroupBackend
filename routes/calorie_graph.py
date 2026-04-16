from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import datetime, timedelta

calorie_graph_bp = Blueprint("calorie_graph", __name__)

@calorie_graph_bp.route("/<string:client_id>", methods=["GET"])
def calorie_graph(client_id):

    range_type = request.args.get("range") # get range for filter -- Aiden
    today = datetime.today()

    start_date = None
    end_date = None

    if range_type:
        if range_type == "day":
            start_date = today.date()
            end_date = today.date()

        elif range_type == "week":
            start_date = (today - timedelta(days=today.weekday())).date()
            end_date = start_date + timedelta(days=6)

        elif range_type == "month":
            start_date = today.replace(day=1).date()
            end_date = today.date()

        else:
            return jsonify({"error": "Invalid range"}), 400
        
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        query = """
            SELECT 
                meal_log_id,
                CAST(log_date AS CHAR) as log_date,
                actual_calories,
                notes
            FROM meal_log                
            WHERE client_id = %s
        """

        params = [client_id]

        if range_type:
            query += " AND DATE(log_date) BETWEEN %s AND %s"
            params.extend([start_date, end_date])

        query += " ORDER BY log_date ASC"

        cursor.execute(query, tuple(params))

        cal_graph = cursor.fetchall()

        return jsonify(cal_graph), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close() 

