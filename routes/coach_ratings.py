from flask import Blueprint, request, jsonify
from db import get_conn

coach_ratings_bp = Blueprint("coach_ratings", __name__)

#let a client give the coach a rating and review
@coach_ratings_bp.route("/<string:coach_id>/rate", methods=["POST"])
def rate_coach(coach_id):
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
        conn.commit()
        return jsonify({"message": "Review submitted successfully"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()