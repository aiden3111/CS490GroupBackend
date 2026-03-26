from flask import Blueprint, request, jsonify
from db import get_conn

# display all a coaches client requests and be able to accept or deny them
coach_request_bp = Blueprint("coach_request", __name__)

@coach_request_bp.route("/<string:coach_id>/requests", methods=["GET"])
def get_coach_requests(coach_id):
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
    data = request.get_json()
    status = data.get("status") if data else None
    client_id = data.get("client_id")

    if status not in ("accepted", "denied", "pending"):
        return jsonify({"error": "Status must be 'accepted', 'denied', or 'pending'"}), 400

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
