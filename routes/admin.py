from flask import Blueprint, request, jsonify
from db import get_conn


admin_bp = Blueprint("admin", __name__)
#allow an admin to view all accounts and be able to delete any account
@admin_bp.route('/accounts', methods=['GET'])
def get_all_accounts():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("SELECT client_id, first_name, last_name, email FROM clients")
        clients = cursor.fetchall()
        return jsonify({"clients": clients}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@admin_bp.route('/accounts/<string:client_id>', methods=['DELETE'])
def delete_account(client_id):
    conn = get_conn()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM clients WHERE client_id = %s", (client_id,))
        if cursor.rowcount == 0:
            return jsonify({"error": "Client not found"}), 404
        conn.commit()
        return jsonify({"message": "Client deleted successfully"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()