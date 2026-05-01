from flask import Blueprint, jsonify
from db import get_conn

review_bp = Blueprint("review", __name__)

@review_bp.route("/coach/<string:coach_id>", methods=["GET"])
def get_reviews(coach_id):
    """
    Get all reviews for a coach.
    ---
    tags:
      - Reviews
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
        description: Coach ID
    responses:
      200:
        description: List of coach reviews
        schema:
          type: array
          items:
            type: object
            properties:
              client_id:
                type: string
              rating:
                type: integer
                minimum: 1
                maximum: 5
              comment:
                type: string
              created_at:
                type: string
                format: date-time
              first_name:
                type: string
              last_name:
                type: string
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT 
                r.client_id, 
                r.rating, 
                r.comment, 
                CAST(r.created_at AS CHAR) AS created_at,
                cl.first_name, 
                cl.last_name
            FROM reviews r
            JOIN client cl ON r.client_id = cl.client_id
            WHERE r.coach_id = %s
            ORDER BY r.created_at DESC
        """, (coach_id,))

        reviews = cursor.fetchall()
        return jsonify(reviews), 200
    
    finally:
        cursor.close()
        conn.close()