from flask import jsonify, request, Blueprint
from db import get_conn

messaging_bp = Blueprint("messaging", __name__)
#using flask-socketio

#returns all the messages between two users for chat history
@messaging_bp.route("/<string:sender_id>/<string:receiver_id>", methods=["GET"])
def get_messages(sender_id, receiver_id):
    """
    Get all messages between two users.
    ---
    tags:
      - Messaging
    parameters:
      - name: sender_id
        in: path
        required: true
        type: string
        description: ID of one user
      - name: receiver_id
        in: path
        required: true
        type: string
        description: ID of the other user
    responses:
      200:
        description: List of messages
        schema:
          type: array
          items:
            type: object
            properties:
              message_id:
                type: integer
              sender_id:
                type: string
              receiver_id:
                type: string
              content:
                type: string
              sent_at:
                type: string
                format: date-time
              is_read:
                type: boolean
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute(
            "SELECT message_id, sender_id, receiver_id, content, sent_at, is_read FROM messages WHERE (sender_id = %s AND receiver_id = %s) OR (sender_id = %s AND receiver_id = %s) ORDER BY sent_at ASC",
            (sender_id, receiver_id, receiver_id, sender_id)
        )
        messages = cursor.fetchall()
        return jsonify(messages), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

#Returns list of all conversations for a user, with the most recent message and timestamp for each conversation
@messaging_bp.route("/conversations/<string:client_id>", methods=["GET"])
def get_conversations(client_id):
    """
    Get all conversations for a user with the latest message.
    ---
    tags:
      - Messaging
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: The client ID
    responses:
      200:
        description: List of conversations
        schema:
          type: array
          items:
            type: object
            properties:
              other_user_id:
                type: string
              first_name:
                type: string
              last_name:
                type: string
              last_message:
                type: string
              last_sent:
                type: string
                format: date-time
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT
                other_user_id,
                cl.first_name,
                cl.last_name,
                m.content AS last_message,
                m.sent_at AS last_sent
            FROM (
                SELECT
                    CASE 
                        WHEN sender_id = %s THEN receiver_id 
                        ELSE sender_id 
                    END AS other_user_id,
                    MAX(message_id) AS latest_message_id
                FROM messages
                WHERE sender_id = %s OR receiver_id = %s
                GROUP BY other_user_id
            ) AS latest
            JOIN messages m ON m.message_id = latest.latest_message_id
            JOIN client cl ON cl.client_id = latest.other_user_id
            ORDER BY m.sent_at DESC
        """, (client_id, client_id, client_id))
        conversations = cursor.fetchall()
        return jsonify(conversations), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()