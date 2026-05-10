from flask import Blueprint, request, jsonify
from db import get_conn

clients_bp = Blueprint("clients", __name__)


@clients_bp.route("/<string:client_id>", methods=["GET"])
def get_client(client_id):
    """
    Get a single client by ID.
    ---
    tags:
      - Clients
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
    responses:
      200:
        description: Client data
      404:
        description: Client not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                client_id, first_name, last_name, dob, weight, height,
                gender, coach_id, subscription, role, email, phone_number, signup_date
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


@clients_bp.route("/coach/<string:coach_id>/<string:client_id>", methods=["DELETE"])
def remove_client_from_coach(coach_id, client_id):
    """
    Remove a client from a coach roster.
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute(
            "SELECT client_id FROM client WHERE client_id = %s AND coach_id = %s",
            (client_id, coach_id),
        )
        client = cursor.fetchone()
        if not client:
            return jsonify({"error": "Client is not assigned to this coach"}), 404

        cursor.execute(
            "UPDATE client SET coach_id = NULL WHERE client_id = %s AND coach_id = %s",
            (client_id, coach_id),
        )
        conn.commit()
        return jsonify({"message": "Client removed from roster"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@clients_bp.route("/<string:client_id>", methods=["PUT"])
def update_client(client_id):
    """
    Update a client's full profile.
    ---
    tags:
      - Clients
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            first_name:
              type: string
            last_name:
              type: string
            dob:
              type: string
            weight:
              type: number
            height:
              type: number
            gender:
              type: string
            coach_id:
              type: string
            subscription:
              type: string
            email:
              type: string
            phone_number:
              type: string
    responses:
      200:
        description: Client updated successfully
      400:
        description: Request body is required
      404:
        description: Client not found
      500:
        description: Server error
    """
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
        cursor.execute("SELECT client_id FROM client WHERE client_id = %s", (client_id,))
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        fields = []
        values = []

        if first_name is not None:
            fields.append("first_name = %s")
            values.append(first_name)

        if last_name is not None:
            fields.append("last_name = %s")
            values.append(last_name)

        if dob is not None:
            fields.append("dob = %s")
            values.append(dob)

        if weight is not None:
            fields.append("weight = %s")
            values.append(weight)

        if height is not None:
            fields.append("height = %s")
            values.append(height)

        if gender is not None:
            fields.append("gender = %s")
            values.append(gender)

        if coach_id is not None:
            fields.append("coach_id = %s")
            values.append(coach_id)

        if subscription is not None:
            fields.append("subscription = %s")
            values.append(subscription)

        if email is not None:
            fields.append("email = %s")
            values.append(email)

        if phone_number is not None:
            fields.append("phone_number = %s")
            values.append(phone_number)

        if not fields:
            return jsonify({"error": "No fields to update"}), 400

        query = f"UPDATE client SET {', '.join(fields)} WHERE client_id = %s"
        values.append(client_id)

        cursor.execute(query, tuple(values))

        conn.commit()
        return jsonify({"message": "Client updated successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@clients_bp.route("/<string:client_id>", methods=["DELETE"])
def delete_client(client_id):
    """
    Delete a client account.
    ---
    tags:
      - Clients
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
    responses:
      200:
        description: Client account deleted
      404:
        description: Client not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute("DELETE FROM fitness_coach WHERE coach_id = %s", (client_id,))
        cursor.execute("DELETE FROM nutrition_coach WHERE coach_id = %s", (client_id,))
        cursor.execute("DELETE FROM coach_applications WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM coach_request WHERE client_id = %s OR coach_id = %s", (client_id, client_id))
        cursor.execute("DELETE FROM coach WHERE coach_id = %s", (client_id,))
        cursor.execute("DELETE FROM payment_method WHERE client_id = %s", (client_id,))
        cursor.execute("DELETE FROM client WHERE client_id = %s", (client_id,))
        conn.commit()

        if cursor.rowcount == 0:
            return jsonify({"error": "Client not found"}), 404

        return jsonify({"message": "Client account deleted"}), 200

    except Exception as e:
      print("Delete client error:", e)
      conn.rollback()
      return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@clients_bp.route("/", methods=["GET"])
def get_all_clients():
    """
    Get all clients sorted by last name.
    ---
    tags:
      - Clients
    responses:
      200:
        description: List of all clients
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT client_id, first_name, last_name, dob, weight, height,
                   gender, coach_id, subscription, role, email, phone_number, signup_date
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
    """
    Assign a coach to a client (one coach per client).
    ---
    tags:
      - Clients
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - coach_id
          properties:
            coach_id:
              type: string
    responses:
      200:
        description: Coach assigned successfully
      400:
        description: coach_id required or client already has a coach
      404:
        description: Client or coach not found
      500:
        description: Server error
    """
    data = request.get_json()
    new_coach_id = data.get("coach_id")

    if not new_coach_id:
        return jsonify({"error": "coach_id is required"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT client_id, coach_id FROM client WHERE client_id = %s", (client_id,))
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        cursor.execute("SELECT coach_id FROM coach WHERE coach_id = %s", (new_coach_id,))
        coach = cursor.fetchone()

        if not coach:
            return jsonify({"error": "Coach not found"}), 404

        if client["coach_id"] is not None:
            return jsonify({"error": "Client already has a coach"}), 400

        cursor.execute("UPDATE client SET coach_id = %s WHERE client_id = %s", (new_coach_id, client_id))

        conn.commit()
        return jsonify({"message": "Coach assigned successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@clients_bp.route("/coach/<string:coach_id>", methods=["GET"])
def get_coach_clients(coach_id):
    """
    Get all clients assigned to a specific coach.
    ---
    tags:
      - Clients
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
    responses:
      200:
        description: List of clients for the coach
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT client_id, first_name, last_name, email, weight, height, gender, signup_date
            FROM client
            WHERE coach_id = %s
            ORDER BY last_name, first_name
        """, (coach_id,))

        clients = cursor.fetchall()

        return jsonify(clients), 200

    except Exception as e:
        print(f"Error fetching coach roster: {e}")
        return jsonify({"error": "Internal Server Error"}), 500

    finally:
        cursor.close()
        conn.close()
