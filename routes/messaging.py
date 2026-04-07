from flask import jsonify, request, Blueprint
from db import get_conn

messaging_bp = Blueprint("messaging", __name__)
#allows client to message their coaches and coaches to message their clients
@messaging_bp.route('/<string:sender_id>/<string:receiver_id>', methods=['POST'])
def send_message(sender_id, receiver_id):
    data = request.get_json()
    message = data.get('message')
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("INSERT INTO messages (sender_id, receiver_id, content) VALUES (%s, %s, %s)", (sender_id, receiver_id, message))
        conn.commit()
        return jsonify({"message": "Message sent successfully"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()