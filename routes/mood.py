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
                mood_log_id, 
                log_date,
                mood_score,
                mood_label,
                notes
            FROM mood_log
            WHERE client_id = %s
        """, (client_id,)) # added mood_log_id since thats in the DB but wasnt in the query -- Aiden
        
        moodlog = cursor.fetchall()

        if not moodlog:
            return jsonify([]), 404

        return jsonify(moodlog), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@mood_bp.route("/<int:log_id>", methods=["DELETE"]) # Add deleting mood logs -- Aiden
def delete_mood_log(log_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            DELETE FROM mood_log
            WHERE mood_log_id = %s
        """, (log_id,))

        conn.commit()

        if cursor.rowcount == 0:
            return jsonify({"error": "Log not found"}), 404
        
        return jsonify({"message": "Log successfuly deleted"}), 200
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    finally: 
        cursor.close()
        conn.close()