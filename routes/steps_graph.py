from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import datetime, timedelta

steps_graph_bp = Blueprint("steps_graph", __name__)

@steps_graph_bp.route("/<string:client_id>", methods=["GET"])
def get_steps(client_id):
    """
    Get steps data for a client with optional date range filtering.
    ---
    tags:
      - Analytics
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
      - name: range
        in: query
        type: string
        enum: [day, week, month]
        description: Date range filter
    responses:
      200:
        description: List of steps entries
        schema:
          type: array
          items:
            type: object
            properties:
              log_date:
                type: string
                format: date
              steps:
                type: integer
      400:
        description: Invalid range parameter
      500:
        description: Server error
    """

    range_type = request.args.get("range") # added range filter to specify day, week, or month -- Aiden
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
                CAST(log_date AS CHAR) as log_date,
                steps
            FROM logging
            WHERE client_id = %s
        """
                       
        params = [client_id]

        if range_type:
            query += " AND DATE(log_date) BETWEEN %s AND %s"
            params.extend([start_date, end_date])

        query += " ORDER BY log_date ASC"
        
        cursor.execute(query, tuple(params))

        step_data = cursor.fetchall()

        return jsonify(step_data), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()