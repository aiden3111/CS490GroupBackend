from flask import Blueprint, request, jsonify
from db import get_conn

#The notification preferences are for
# Daily reminder to drink water
# reminder to workout
# email notifications (on/off)
# in app notifications (on/off)




notification_preferences_bp = Blueprint(
    "notification_preferences",
    __name__
)


def row_to_dict(row):
    return {
        "preference_id": row[0],
        "client_id": row[1],
        "daily_water_reminder": bool(row[2]),
        "workout_today_reminder": bool(row[3]),
        "email_notifications": bool(row[4]),
        "in_app_notifications": bool(row[5]),
        "created_at": str(row[6]) if row[6] else None,
        "updated_at": str(row[7]) if row[7] else None
    }


@notification_preferences_bp.route("/", methods=["POST"])
def create_notification_preferences():
    """
    Create notification preferences for a client.
    ---
    tags:
      - Notification Preferences
    parameters:
      - name: preference_data
        in: body
        required: true
        schema:
          type: object
          required:
            - client_id
          properties:
            client_id:
              type: string
              description: Client ID
            daily_water_reminder:
              type: boolean
              default: true
              description: Daily water reminder notifications
            workout_today_reminder:
              type: boolean
              default: true
              description: Workout reminder notifications
            email_notifications:
              type: boolean
              default: true
              description: Email notifications enabled
            in_app_notifications:
              type: boolean
              default: true
              description: In-app notifications enabled
    responses:
      201:
        description: Notification preferences created successfully
        schema:
          type: object
          properties:
            message:
              type: string
            preferences:
              type: object
              properties:
                preference_id:
                  type: integer
                client_id:
                  type: string
                daily_water_reminder:
                  type: boolean
                workout_today_reminder:
                  type: boolean
                email_notifications:
                  type: boolean
                in_app_notifications:
                  type: boolean
                created_at:
                  type: string
                  format: date-time
                updated_at:
                  type: string
                  format: date-time
      400:
        description: Missing client_id
      404:
        description: Client not found
      409:
        description: Preferences already exist for this client
      500:
        description: Server error
    """
    data = request.get_json()

    if not data or "client_id" not in data:
        return jsonify({"error": "client_id is required"}), 400

    client_id = data["client_id"]
    daily_water_reminder = data.get("daily_water_reminder", True)
    workout_today_reminder = data.get("workout_today_reminder", True)
    email_notifications = data.get("email_notifications", True)
    in_app_notifications = data.get("in_app_notifications", True)

    conn = get_conn()
    cursor = conn.cursor()

    try:
        # Check that the client exists
        cursor.execute("SELECT client_id FROM client WHERE client_id = %s", (client_id,))
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        # Prevent duplicate preference rows
        cursor.execute(
            "SELECT preference_id FROM notification_preferences WHERE client_id = %s",
            (client_id,)
        )
        existing = cursor.fetchone()

        if existing:
            return jsonify({
                "error": "Notification preferences already exist for this client"
            }), 409

        cursor.execute("""
            INSERT INTO notification_preferences (
                client_id,
                daily_water_reminder,
                workout_today_reminder,
                email_notifications,
                in_app_notifications
            )
            VALUES (%s, %s, %s, %s, %s)
        """, (
            client_id,
            int(bool(daily_water_reminder)),
            int(bool(workout_today_reminder)),
            int(bool(email_notifications)),
            int(bool(in_app_notifications))
        ))

        conn.commit()

        cursor.execute("""
            SELECT preference_id, client_id, daily_water_reminder,
                   workout_today_reminder, email_notifications,
                   in_app_notifications, created_at, updated_at
            FROM notification_preferences
            WHERE client_id = %s
        """, (client_id,))
        new_row = cursor.fetchone()

        return jsonify({
            "message": "Notification preferences created successfully",
            "preferences": row_to_dict(new_row)
        }), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@notification_preferences_bp.route("/<string:client_id>", methods=["GET"])
def get_notification_preferences(client_id):
    """
    Get notification preferences for a client.
    ---
    tags:
      - Notification Preferences
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
    responses:
      200:
        description: Notification preferences
        schema:
          type: object
          properties:
            preference_id:
              type: integer
            client_id:
              type: string
            daily_water_reminder:
              type: boolean
            workout_today_reminder:
              type: boolean
            email_notifications:
              type: boolean
            in_app_notifications:
              type: boolean
            created_at:
              type: string
              format: date-time
            updated_at:
              type: string
              format: date-time
      404:
        description: Preferences not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            SELECT preference_id, client_id, daily_water_reminder,
                   workout_today_reminder, email_notifications,
                   in_app_notifications, created_at, updated_at
            FROM notification_preferences
            WHERE client_id = %s
        """, (client_id,))
        row = cursor.fetchone()

        if not row:
            return jsonify({"error": "Notification preferences not found"}), 404

        return jsonify(row_to_dict(row)), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@notification_preferences_bp.route("/<string:client_id>", methods=["PUT"])
def update_notification_preferences(client_id):
    """
    Update notification preferences for a client.
    ---
    tags:
      - Notification Preferences
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
      - name: preference_updates
        in: body
        required: true
        schema:
          type: object
          properties:
            daily_water_reminder:
              type: boolean
              description: Daily water reminder notifications
            workout_today_reminder:
              type: boolean
              description: Workout reminder notifications
            email_notifications:
              type: boolean
              description: Email notifications enabled
            in_app_notifications:
              type: boolean
              description: In-app notifications enabled
    responses:
      200:
        description: Notification preferences updated successfully
        schema:
          type: object
          properties:
            message:
              type: string
            preferences:
              type: object
              properties:
                preference_id:
                  type: integer
                client_id:
                  type: string
                daily_water_reminder:
                  type: boolean
                workout_today_reminder:
                  type: boolean
                email_notifications:
                  type: boolean
                in_app_notifications:
                  type: boolean
                created_at:
                  type: string
                  format: date-time
                updated_at:
                  type: string
                  format: date-time
      400:
        description: No valid fields provided
      404:
        description: Preferences not found
      500:
        description: Server error
    """
    data = request.get_json()

    if not data:
        return jsonify({"error": "No data provided"}), 400

    allowed_fields = {
        "daily_water_reminder",
        "workout_today_reminder",
        "email_notifications",
        "in_app_notifications"
    }

    updates = []
    values = []

    for field in allowed_fields:
        if field in data:
            updates.append(f"{field} = %s")
            values.append(int(bool(data[field])))

    if not updates:
        return jsonify({
            "error": "No valid fields provided. Allowed fields: daily_water_reminder, workout_today_reminder, email_notifications, in_app_notifications"
        }), 400

    values.append(client_id)

    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT preference_id FROM notification_preferences WHERE client_id = %s",
            (client_id,)
        )
        existing = cursor.fetchone()

        if not existing:
            return jsonify({"error": "Notification preferences not found"}), 404

        query = f"""
            UPDATE notification_preferences
            SET {', '.join(updates)}
            WHERE client_id = %s
        """
        cursor.execute(query, tuple(values))
        conn.commit()

        cursor.execute("""
            SELECT preference_id, client_id, daily_water_reminder,
                   workout_today_reminder, email_notifications,
                   in_app_notifications, created_at, updated_at
            FROM notification_preferences
            WHERE client_id = %s
        """, (client_id,))
        updated_row = cursor.fetchone()

        return jsonify({
            "message": "Notification preferences updated successfully",
            "preferences": row_to_dict(updated_row)
        }), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()