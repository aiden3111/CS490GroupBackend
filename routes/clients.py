from flask import Blueprint, request, jsonify
from db import get_conn

# routes for:
# retrieve info on single client
# update client information
# delete a client

clients_bp = Blueprint("clients", __name__)


# Get a single client by client_id
@clients_bp.route("/<string:client_id>", methods=["GET"])
def get_client(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT 
                client_id,
                first_name,
                last_name,
                dob,
                weight,
                height,
                gender,
                coach_id,
                subscription,
                role,
                email,
                phone_number,
                signup_date
            FROM client
            WHERE client_id = %s
        """, (client_id,))
        
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        return jsonify(client), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# Update the client profile
@clients_bp.route("/<string:client_id>", methods=["PUT"])
def update_client(client_id):
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body is required"}), 400

    first_name = data.get("first_name")
    last_name = data.get("last_name")
    dob = data.get("dob")
    weight = data.get("weight")
    height = data.get("height")
    gender = data.get("gender")
    coach_id = data.get("coach_id")
    subscription = data.get("subscription")
    email = data.get("email")
    phone_number = data.get("phone_number")

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT client_id
            FROM client
            WHERE client_id = %s
        """, (client_id,))
        
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        cursor.execute("""
            UPDATE client
            SET first_name = %s,
                last_name = %s,
                dob = %s,
                weight = %s,
                height = %s,
                gender = %s,
                coach_id = %s,
                subscription = %s,
                email = %s,
                phone_number = %s
            WHERE client_id = %s
        """, (
            first_name,
            last_name,
            dob,
            weight,
            height,
            gender,
            coach_id,
            subscription,
            email,
            phone_number,
            client_id
        ))

        conn.commit()
        return jsonify({"message": "Client updated successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# Delete a client account
@clients_bp.route("/<string:client_id>", methods=["DELETE"])
def delete_client(client_id):
    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute("DELETE FROM client WHERE client_id = %s", (client_id,))
        conn.commit()

        if cursor.rowcount == 0:
            return jsonify({"error": "Client not found"}), 404

        return jsonify({"message": "Client account deleted"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()