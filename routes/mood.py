from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import date

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


#create a mood entry

@mood_bp.route("/", methods=["POST"])
def create_mood_log():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "Request body is required"}), 400

        client_id = data.get("client_id")
        log_date = data.get("log_date") or str(date.today())
        mood_score = data.get("mood_score")
        mood_label = data.get("mood_label")
        notes = data.get("notes")

        if not client_id or mood_score is None:
            return jsonify({"error": "client_id and mood_score are required"}), 400

        if not isinstance(mood_score, int) or mood_score < 1 or mood_score > 5:
            return jsonify({"error": "mood_score must be between 1 and 5"}), 400

        # Check client exists
        cursor.execute("SELECT client_id FROM client WHERE client_id = %s", (client_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Client not found"}), 404

        # Prevent duplicate daily entry
        cursor.execute("""
            SELECT mood_log_id FROM mood_log
            WHERE client_id = %s AND log_date = %s
        """, (client_id, log_date))

        if cursor.fetchone():
            return jsonify({"error": "Mood entry already exists for this date"}), 409

        cursor.execute("""
            INSERT INTO mood_log (client_id, log_date, mood_score, mood_label, notes)
            VALUES (%s, %s, %s, %s, %s)
        """, (client_id, log_date, mood_score, mood_label, notes))

        conn.commit()

        return jsonify({
            "message": "Mood entry created",
            "mood_log_id": cursor.lastrowid
        }), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


#update the mood entry
@mood_bp.route("/<int:log_id>", methods=["PUT"])
def update_mood_log(log_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "Request body is required"}), 400

        mood_score = data.get("mood_score")
        mood_label = data.get("mood_label")
        notes = data.get("notes")

        if mood_score is None and mood_label is None and notes is None:
            return jsonify({"error": "Nothing to update"}), 400

        # Check log exists
        cursor.execute("""
            SELECT mood_log_id FROM mood_log
            WHERE mood_log_id = %s
        """, (log_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Log not found"}), 404

        update_fields = []
        params = []

        if mood_score is not None:
            if not isinstance(mood_score, int) or mood_score < 1 or mood_score > 5:
                return jsonify({"error": "mood_score must be between 1 and 5"}), 400
            update_fields.append("mood_score = %s")
            params.append(mood_score)

        if mood_label is not None:
            update_fields.append("mood_label = %s")
            params.append(mood_label)

        if notes is not None:
            update_fields.append("notes = %s")
            params.append(notes)

        params.append(log_id)

        query = f"""
            UPDATE mood_log
            SET {", ".join(update_fields)}
            WHERE mood_log_id = %s
        """

        cursor.execute(query, tuple(params))
        conn.commit()

        return jsonify({"message": "Mood log updated"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()