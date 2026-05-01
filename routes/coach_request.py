from flask import Blueprint, request, jsonify
from db import get_conn

# display all a coaches client requests and be able to accept or deny them
coach_request_bp = Blueprint("coach_request", __name__)

@coach_request_bp.route("/<string:coach_id>/requests", methods=["GET"])
def get_coach_requests(coach_id):
    """
    Get all client requests for a coach.
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
        description: List of coach requests with client info
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT 
                r.request_id,
                r.client_id,
                r.status,
                c.first_name,
                c.last_name
            FROM coach_request r
            JOIN client c ON r.client_id = c.client_id
            WHERE r.coach_id = %s
        """, (coach_id,))
        
        requests = cursor.fetchall()

        return jsonify(requests), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@coach_request_bp.route("/<string:coach_id>/requests/<int:request_id>", methods=["PUT"])
def update_coach_request(coach_id, request_id):
    """
    Update the status of a coach request (accept, reject, or pending).
    ---
    tags:
      - Coach
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
      - name: request_id
        in: path
        required: true
        type: integer
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - status
          properties:
            status:
              type: string
              enum: [accepted, rejected, pending]
            client_id:
              type: string
              description: Required when accepting to assign the coach
    responses:
      200:
        description: Request status updated
      400:
        description: Invalid status or client already has a coach
      404:
        description: Request or client not found
      500:
        description: Server error
    """
    data = request.get_json()
    status = data.get("status") if data else None
    client_id = data.get("client_id")

    if status not in ("accepted", "rejected", "pending"):
        return jsonify({"error": "Status must be 'accepted', 'rejected', or 'pending'"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:

        if status == "accepted":
            cursor.execute("SELECT coach_id FROM client WHERE client_id = %s", (client_id,))
            client_record = cursor.fetchone()

            if not client_record:
                return jsonify({"error": "Client not found"}), 404
            
            if client_record['coach_id'] is not None:
                return jsonify({
                    "error": "This client already has an active coach."
                }), 400


        cursor.execute("""
            UPDATE coach_request
            SET status = %s
            WHERE request_id = %s AND coach_id = %s
        """, (status, request_id, coach_id))

        if status == "accepted" and client_id:
            cursor.execute("""
                UPDATE client
                SET coach_id = %s
                WHERE client_id = %s
            """, (coach_id, client_id))
        conn.commit()

        if cursor.rowcount == 0:
            return jsonify({"error": "Request not found"}), 404

        return jsonify({"message": f"Request {status}"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()
