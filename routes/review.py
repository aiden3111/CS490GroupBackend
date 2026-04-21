from flask import Blueprint, jsonify
from db import get_conn

review_bp = Blueprint("review", __name__)

@review_bp.route("/coach/<string:coach_id>", methods=["GET"])
def get_reviews(coach_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT client_id, rating, comment, created_at
            FROM reviews
            WHERE coach_id = %s
        """, (coach_id,))

        reviews = cursor.fetchall()
        return jsonify(reviews), 200
    
    finally:
        cursor.close()
        conn.close()