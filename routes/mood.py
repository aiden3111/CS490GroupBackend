from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import date

mood_bp = Blueprint("mood", __name__)

@mood_bp.route("/<string:client_id>", methods=["GET"])
def get_my_mood(client_id):
    """
    Get all mood logs for a client.
    ---
    tags:
      - Mood
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
    responses:
        200:
          description: List of mood logs. Returns an empty list if no mood logs exist.
          schema:
            type: array
            items:
              type: object
              properties:
                mood_log_id:
                  type: integer
                log_date:
                  type: string
                  format: date
                mood_score:
                  type: integer
                  minimum: 1
                  maximum: 5
                mood_label:
                  type: string
                notes:
                  type: string
      500:
        description: Server error
    """
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
          return jsonify([]), 200
        
        return jsonify(moodlog), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@mood_bp.route("/<int:log_id>", methods=["DELETE"]) # Add deleting mood logs -- Aiden
def delete_mood_log(log_id):
    """
    Delete a mood log entry.
    ---
    tags:
      - Mood
    parameters:
      - name: log_id
        in: path
        required: true
        type: integer
        description: Mood log ID
    responses:
      200:
        description: Mood log deleted successfully
      404:
        description: Log not found
      500:
        description: Server error
    """
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
    """
    Create a new mood log entry.
    ---
    tags:
      - Mood
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
            - mood_score
          properties:
            client_id:
              type: string
              description: Client ID
            log_date:
              type: string
              format: date
              description: Date of the mood entry (defaults to today)
            mood_score:
              type: integer
              minimum: 1
              maximum: 5
              description: Mood score from 1-5
            mood_label:
              type: string
              description: Optional mood label
            notes:
              type: string
              description: Optional notes
    responses:
      201:
        description: Mood entry created successfully
        schema:
          type: object
          properties:
            message:
              type: string
            mood_log_id:
              type: integer
      400:
        description: Missing required fields or invalid data
      404:
        description: Client not found
      409:
        description: Mood entry already exists for this date
      500:
        description: Server error
    """
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

        if not isinstance(mood_score, int) or mood_score < 1 or mood_score > 10:
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
    """
    Update an existing mood log entry.
    ---
    tags:
      - Mood
    parameters:
      - name: log_id
        in: path
        required: true
        type: integer
        description: Mood log ID
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            mood_score:
              type: integer
              minimum: 1
              maximum: 5
            mood_label:
              type: string
            notes:
              type: string
    responses:
      200:
        description: Mood log updated successfully
      400:
        description: Nothing to update or invalid data
      404:
        description: Log not found
      500:
        description: Server error
    """
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