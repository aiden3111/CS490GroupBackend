from flask import Blueprint, request, jsonify
from db import get_conn

landing_page_bp = Blueprint("landing_page", __name__)

#Client landing page to display top coaches and client trackers
@landing_page_bp.route("/<string:client_id>", methods=["GET"])
def get_landing_page(client_id):
    """
    Get landing page data for a client including top coaches and mood trackers.
    ---
    tags:
      - Landing Page
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
    responses:
      200:
        description: Landing page data
        schema:
          type: object
          properties:
            top_coaches:
              type: array
              items:
                type: object
                properties:
                  coach_id:
                    type: string
                  first_name:
                    type: string
                  last_name:
                    type: string
                  average_rating:
                    type: number
                  specialty:
                    type: string
            trackers:
              type: array
              items:
                type: object
                properties:
                  log_date:
                    type: string
                    format: date
                  mood_score:
                    type: integer
                  mood_label:
                    type: string
                  created_at:
                    type: string
                    format: date-time
                  notes:
                    type: string
            user_name:
              type: string
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        # Get top coaches based on average rating
        cursor.execute("""
            SELECT 
                c.coach_id,
                cl.first_name,
                cl.last_name,
                COALESCE(AVG(r.rating), 0) AS average_rating,
                CASE
                    WHEN fc.coach_id IS NOT NULL AND nc.coach_id IS NOT NULL THEN 'Fitness & Nutrition'
                    WHEN fc.coach_id IS NOT NULL THEN 'Fitness'
                    WHEN nc.coach_id IS NOT NULL THEN 'Nutrition'
                    ELSE 'none'
                END AS specialty
            FROM coach c
            JOIN client cl ON c.coach_id = cl.client_id  
            LEFT JOIN reviews r ON c.coach_id = r.coach_id
            LEFT JOIN fitness_coach fc ON c.coach_id = fc.coach_id
            LEFT JOIN nutrition_coach nc ON c.coach_id = nc.coach_id
            GROUP BY c.coach_id, cl.first_name, cl.last_name, fc.coach_id, nc.coach_id
            ORDER BY average_rating DESC
            LIMIT 3
        """)
        top_coaches = cursor.fetchall()

        # Get client's mood tracker
        cursor.execute("""
            SELECT 
                log_date,
                mood_score,
                mood_label,
                created_at,
                notes
            FROM mood_log
            WHERE client_id = %s
            ORDER BY created_at DESC
        """, (client_id,))
        trackers = cursor.fetchall()

        cursor.execute("SELECT first_name FROM client WHERE client_id = %s", (client_id,))
        user_info = cursor.fetchone()
        user_name = user_info['first_name'] if user_info else "User"

        return jsonify({
            "top_coaches": top_coaches,
            "trackers": trackers,
            "user_name": user_name
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()
