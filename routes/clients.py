from flask import Blueprint, request, jsonify
from db import get_conn

# routes for:
# retrieve info on single client
# update client information
# delete a client
# view all clients
# assign only one coach per client

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

#view all client list
@clients_bp.route("/", methods=["GET"])
def get_all_clients():
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
            ORDER BY last_name, first_name
        """)

        clients = cursor.fetchall()

        return jsonify(clients), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@clients_bp.route("/<string:client_id>/assign-coach", methods=["PUT"])
def assign_coach(client_id):
    data = request.get_json()
    new_coach_id = data.get("coach_id")

    if not new_coach_id:
        return jsonify({"error": "coach_id is required"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT client_id, coach_id
            FROM client
            WHERE client_id = %s
        """, (client_id,))
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        cursor.execute("""
            SELECT coach_id
            FROM coach
            WHERE coach_id = %s
        """, (new_coach_id,))
        coach = cursor.fetchone()

        if not coach:
            return jsonify({"error": "Coach not found"}), 404

        if client["coach_id"] is not None:
            return jsonify({"error": "Client already has a coach"}), 400

        cursor.execute("""
            UPDATE client
            SET coach_id = %s
            WHERE client_id = %s
        """, (new_coach_id, client_id))

        conn.commit()
        return jsonify({"message": "Coach assigned successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()