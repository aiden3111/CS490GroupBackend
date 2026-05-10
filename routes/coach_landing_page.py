from flask import Blueprint, request, jsonify
from db import get_conn
from routes.notify import push_notification

coach_landing_page_bp = Blueprint("coach_landing_page", __name__)

#Display the coaches landing page with all information about the coach
@coach_landing_page_bp.route("/<string:coach_id>", methods=["GET"])
def get_coach_landing_page(coach_id):
    """
    Get a coach's public landing page with info and reviews.
    ---
    tags:
      - Coach
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
    responses:
      200:
        description: Coach profile including specialty, pricing, availability, and reviews
      404:
        description: Coach not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                c.coach_id,
                c.availability,
                c.status,
                c.pricing,
                cl.first_name,
                cl.last_name,
                fc.certifications AS fitness_certifications,
                nc.certifications AS nutrition_certifications,
                CASE
                    WHEN fc.coach_id IS NOT NULL AND nc.coach_id IS NOT NULL THEN 'both'
                    WHEN fc.coach_id IS NOT NULL THEN 'fitness'
                    WHEN nc.coach_id IS NOT NULL THEN 'nutrition'
                    ELSE 'none'
                END AS specialty
            FROM coach c
            JOIN client cl ON c.coach_id = cl.client_id
            LEFT JOIN fitness_coach fc ON c.coach_id = fc.coach_id
            LEFT JOIN nutrition_coach nc ON c.coach_id = nc.coach_id
            WHERE c.coach_id = %s
        """, (coach_id,))
        coach_info = cursor.fetchone()

        if not coach_info:
            return jsonify({"error": "Coach not found"}), 404

        cursor.execute("""
            SELECT review_id, rating, comment, created_at
            FROM reviews
            WHERE coach_id = %s
        """, (coach_id,))
        coach_info["reviews"] = cursor.fetchall()

        return jsonify(coach_info), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


#Send a hire request to the coach
@coach_landing_page_bp.route("/<string:coach_id>/request", methods=["POST"])
def send_hire_request(coach_id):
    """
    Send a hire request to a coach (requires a valid payment method).
    ---
    tags:
      - Coach
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
            - payment_id
          properties:
            client_id:
              type: string
            payment_id:
              type: integer
    responses:
      201:
        description: Hire request sent successfully
      400:
        description: Missing fields or no payment method on file
      404:
        description: Coach not found
      409:
        description: A pending request already exists
      500:
        description: Server error
    """
    data = request.get_json()
    client_id = data.get("client_id") if data else None
    payment_id = data.get("payment_id") if data else None

    if not client_id:
        return jsonify({"error": "client_id is required"}), 400
    if not payment_id:
        return jsonify({"error": "payment_id is required"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        # Check coach exists
        cursor.execute("SELECT coach_id FROM coach WHERE coach_id = %s", (coach_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Coach not found"}), 404

        # Check payment method exists and belongs to client
        cursor.execute(
            "SELECT payment_id FROM payment_method WHERE payment_id = %s AND client_id = %s",
            (payment_id, client_id),
        )
        if not cursor.fetchone():
            # Distinguish "no methods at all" so UI can prompt add-new flow.
            cursor.execute("SELECT 1 FROM payment_method WHERE client_id = %s LIMIT 1", (client_id,))
            if not cursor.fetchone():
                return jsonify({"error": "No payment method on file", "code": "NO_PAYMENT_METHOD"}), 400
            return jsonify({"error": "Invalid payment method", "code": "INVALID_PAYMENT_METHOD"}), 400

        # Check for an existing pending request
        cursor.execute("""
            SELECT request_id FROM coach_request
            WHERE coach_id = %s AND client_id = %s AND status = 'pending'
        """, (coach_id, client_id))
        if cursor.fetchone():
            return jsonify({"error": "A pending request already exists"}), 409

        cursor.execute("""
            INSERT INTO coach_request (coach_id, client_id, status)
            VALUES (%s, %s, 'pending')
        """, (coach_id, client_id))

        # Notify the coach about the new hire request
        cursor.execute("SELECT first_name, last_name FROM client WHERE client_id = %s", (client_id,))
        client_row = cursor.fetchone()
        client_name = f"{client_row['first_name']} {client_row['last_name']}" if client_row else "A client"
        push_notification(cursor, coach_id, "coach", "New Hire Request", f"{client_name} wants to work with you.")

        conn.commit()

        return jsonify({"message": "Hire request sent successfully", "request_id": cursor.lastrowid}), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()
