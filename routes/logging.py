from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import date

logging_bp = Blueprint("logging", __name__)

# use case  8.2 Log cardio activity -- Aiden
@logging_bp.route("/", methods=["POST"])
def log_cardio():
    data = request.get_json()

    client_id = data.get("client_id")
    steps = data.get("steps")
    calories = data.get("calories")
    log_date = data.get("log_date") or date.today().strftime("%Y-%m-%d")

    if not client_id:
        return jsonify({"error": "client_id is required"}), 400

    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT client_id FROM client WHERE client_id = %s",
            (client_id,)
        )
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        cursor.execute(
            """
            INSERT INTO logging (client_id, log_date, steps, calories)
            VALUES (%s, %s, %s, %s)
            """,
            (client_id, log_date, steps, calories)
        )

        conn.commit()
        return jsonify({"message": "Cardio activity logged"}), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()