from flask import Blueprint, request, jsonify
from db import get_conn

notifications_bp = Blueprint("notifications_bp", __name__, url_prefix="/api/notifications")


@notifications_bp.route("/<user_id>", methods=["GET"])
def get_notifications(user_id):
    """
    Get in-app notifications for a user.
    ---
    tags:
      - Notifications
    parameters:
      - name: user_id
        in: path
        required: true
        type: string
        description: User ID
      - name: unread_only
        in: query
        type: boolean
        default: false
        description: Return only unread notifications
      - name: limit
        in: query
        type: integer
        default: 20
        description: Maximum number of notifications to return
    responses:
      200:
        description: List of notifications
        schema:
          type: object
          properties:
            success:
              type: boolean
            notifications:
              type: array
              items:
                type: object
                properties:
                  notification_id:
                    type: integer
                  user_id:
                    type: string
                  type:
                    type: string
                  title:
                    type: string
                  body:
                    type: string
                  is_read:
                    type: boolean
                  channel:
                    type: string
                  created_at:
                    type: string
                    format: date-time
      500:
        description: Server error
    """
    unread_only = request.args.get("unread_only", "false").lower() == "true"
    limit = request.args.get("limit", 20, type=int)

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        query = """
            SELECT
                notification_id,
                user_id,
                type,
                title,
                body,
                is_read,
                channel,
                created_at
            FROM notifications
            WHERE user_id = %s
              AND channel = 'in_app'
        """
        params = [user_id]

        if unread_only:
            query += " AND is_read = 0"

        query += " ORDER BY created_at DESC LIMIT %s"
        params.append(limit)

        cursor.execute(query, tuple(params))
        notifications = cursor.fetchall()

        return jsonify({
            "success": True,
            "notifications": notifications
        }), 200

    except Exception as e:
        return jsonify({
            "success": False,
            "message": "Failed to fetch notifications",
            "error": str(e)
        }), 500

    finally:
        cursor.close()
        conn.close()


@notifications_bp.route("/unread-count/<user_id>", methods=["GET"])
def unread_count(user_id):
    """
    Get the count of unread notifications for a user.
    ---
    tags:
      - Notifications
    parameters:
      - name: user_id
        in: path
        required: true
        type: string
        description: User ID
    responses:
      200:
        description: Unread notification count
        schema:
          type: object
          properties:
            success:
              type: boolean
            unread_count:
              type: integer
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        query = """
            SELECT COUNT(*) AS unread_count
            FROM notifications
            WHERE user_id = %s
              AND channel = 'in_app'
              AND is_read = 0
        """
        cursor.execute(query, (user_id,))
        result = cursor.fetchone()

        return jsonify({
            "success": True,
            "unread_count": result["unread_count"]
        }), 200

    except Exception as e:
        return jsonify({
            "success": False,
            "message": "Failed to fetch unread count",
            "error": str(e)
        }), 500

    finally:
        cursor.close()
        conn.close()


@notifications_bp.route("/", methods=["POST"])
def create_notification():
    """
    Create a new in-app notification.
    ---
    tags:
      - Notifications
    parameters:
      - name: notification_data
        in: body
        required: true
        schema:
          type: object
          required:
            - user_id
            - title
          properties:
            user_id:
              type: string
              description: User ID to receive the notification
            type:
              type: string
              description: Type of notification
            title:
              type: string
              description: Notification title
            body:
              type: string
              description: Notification body content
            channel:
              type: string
              default: in_app
              description: Notification channel
    responses:
      201:
        description: Notification created successfully
        schema:
          type: object
          properties:
            success:
              type: boolean
            message:
              type: string
            notification_id:
              type: integer
      400:
        description: Missing required fields
      500:
        description: Server error
    """
    data = request.get_json()

    user_id = data.get("user_id")
    notif_type = data.get("type")
    title = data.get("title")
    body = data.get("body")
    channel = data.get("channel", "in_app")

    if not user_id or not title:
        return jsonify({
            "success": False,
            "message": "user_id and title are required"
        }), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        query = """
            INSERT INTO notifications (user_id, type, title, body, channel, is_read)
            VALUES (%s, %s, %s, %s, %s, 0)
        """
        cursor.execute(query, (user_id, notif_type, title, body, channel))
        conn.commit()

        return jsonify({
            "success": True,
            "message": "Notification created successfully",
            "notification_id": cursor.lastrowid
        }), 201

    except Exception as e:
        conn.rollback()
        return jsonify({
            "success": False,
            "message": "Failed to create notification",
            "error": str(e)
        }), 500

    finally:
        cursor.close()
        conn.close()


@notifications_bp.route("/mark-read/<int:notification_id>", methods=["PUT"])
def mark_notification_read(notification_id):
    """
    Mark a specific notification as read.
    ---
    tags:
      - Notifications
    parameters:
      - name: notification_id
        in: path
        required: true
        type: integer
        description: Notification ID to mark as read
    responses:
      200:
        description: Notification marked as read
        schema:
          type: object
          properties:
            success:
              type: boolean
            message:
              type: string
      404:
        description: Notification not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor()

    try:
        query = """
            UPDATE notifications
            SET is_read = 1
            WHERE notification_id = %s
        """
        cursor.execute(query, (notification_id,))
        conn.commit()

        if cursor.rowcount == 0:
            return jsonify({
                "success": False,
                "message": "Notification not found"
            }), 404

        return jsonify({
            "success": True,
            "message": "Notification marked as read"
        }), 200

    except Exception as e:
        conn.rollback()
        return jsonify({
            "success": False,
            "message": "Failed to update notification",
            "error": str(e)
        }), 500

    finally:
        cursor.close()
        conn.close()


@notifications_bp.route("/mark-all-read/<user_id>", methods=["PUT"])
def mark_all_notifications_read(user_id):
    """
    Mark all notifications as read for a user.
    ---
    tags:
      - Notifications
    parameters:
      - name: user_id
        in: path
        required: true
        type: string
        description: User ID
    responses:
      200:
        description: All notifications marked as read
        schema:
          type: object
          properties:
            success:
              type: boolean
            message:
              type: string
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor()

    try:
        query = """
            UPDATE notifications
            SET is_read = 1
            WHERE user_id = %s
              AND channel = 'in_app'
              AND is_read = 0
        """
        cursor.execute(query, (user_id,))
        conn.commit()

        return jsonify({
            "success": True,
            "message": "All notifications marked as read"
        }), 200

    except Exception as e:
        conn.rollback()
        return jsonify({
            "success": False,
            "message": "Failed to mark all notifications as read",
            "error": str(e)
        }), 500

    finally:
        cursor.close()
        conn.close()


@notifications_bp.route("/<int:notification_id>", methods=["DELETE"])
def delete_notification(notification_id):
    """
    Delete a specific notification.
    ---
    tags:
      - Notifications
    parameters:
      - name: notification_id
        in: path
        required: true
        type: integer
        description: Notification ID to delete
    responses:
      200:
        description: Notification deleted successfully
        schema:
          type: object
          properties:
            success:
              type: boolean
            message:
              type: string
      404:
        description: Notification not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor()

    try:
        query = "DELETE FROM notifications WHERE notification_id = %s"
        cursor.execute(query, (notification_id,))
        conn.commit()

        if cursor.rowcount == 0:
            return jsonify({
                "success": False,
                "message": "Notification not found"
            }), 404

        return jsonify({
            "success": True,
            "message": "Notification deleted"
        }), 200

    except Exception as e:
        conn.rollback()
        return jsonify({
            "success": False,
            "message": "Failed to delete notification",
            "error": str(e)
        }), 500

    finally:
        cursor.close()
        conn.close()