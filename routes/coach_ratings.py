from flask import Blueprint, request, jsonify
from db import get_conn
from routes.notify import push_notification

coach_ratings_bp = Blueprint("coach_ratings", __name__)

#let a client give the coach a rating and review
@coach_ratings_bp.route("/<string:coach_id>/rate", methods=["POST"])
def rate_coach(coach_id):
    """
    Submit a rating and review for a coach (clients can only review their assigned coach).
    ---
    tags:
      - Coach
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
        description: Coach ID to review
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - rating
            - client_id
          properties:
            rating:
              type: integer
              minimum: 1
              maximum: 5
              description: Rating from 1-5
            comment:
              type: string
              description: Optional review comment
            client_id:
              type: string
              description: Client ID submitting the review
    responses:
      200:
        description: Review submitted successfully
      400:
        description: Missing required fields
      403:
        description: Can only review assigned coach
      404:
        description: Client not found
      500:
        description: Server error
    """
    data = request.get_json()
    rating = data.get("rating")
    comment = data.get("comment")
    client_id = data.get("client_id")

    if not all([rating, client_id]):
        return jsonify({"error": "Rating and client_id are required"}), 400

    conn = get_conn()
    cursor = conn.cursor()
    try:
        cursor.execute("SELECT coach_id FROM client WHERE client_id = %s", (client_id,))
        row = cursor.fetchone()
        if not row:
            return jsonify({"error": "Client not found"}), 404
        if str(row[0]) != str(coach_id):
            return jsonify({"error": "You can only review your assigned coach"}), 403

        cursor.execute("INSERT INTO reviews (coach_id, client_id, rating, comment) VALUES (%s, %s, %s, %s)", (coach_id, client_id, rating, comment))

        # Notify the coach of the new review
        cursor2 = conn.cursor(dictionary=True)
        cursor2.execute("SELECT first_name, last_name FROM client WHERE client_id = %s", (client_id,))
        client_row = cursor2.fetchone()
        cursor2.close()
        client_name = f"{client_row['first_name']} {client_row['last_name']}" if client_row else "A client"
        push_notification(
            cursor,
            coach_id,
            "review",
            "New Review",
            f"{client_name} left you a {rating}-star review.",
            send_email=True,
        )

        conn.commit()
        return jsonify({"message": "Review submitted successfully"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()
