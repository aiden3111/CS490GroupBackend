from flask import Blueprint, request, jsonify
from db import get_conn


mood_bp = Blueprint("mood", __name__)

@mood_bp.route("/<string:client_id>", methods=["GET"])
def get_my_mood(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                log_date,
                mood_score,
                mood_label,
                notes
            FROM mood_log
            WHERE client_id = %s
        """, (client_id,))
        
        moodlog = cursor.fetchall()

        if not moodlog:
            return jsonify({"message": "No mood log found"}), 404

        return jsonify(moodlog), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


