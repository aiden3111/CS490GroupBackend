from flask import Blueprint, request, jsonify
from db import get_conn

landing_page_bp = Blueprint("landing_page", __name__)

#Client landing page to display top coaches and client trackers
@landing_page_bp.route("/<string:client_id>", methods=["GET"])
def get_landing_page(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        # Get top coaches based on average rating
        cursor.execute("""
            SELECT 
                c.coach_id,
                c.first_name,
                c.last_name,
                c.specialty,
                COALESCE(AVG(r.rating), 0) AS average_rating
            FROM coach c
            LEFT JOIN reviews r ON c.coach_id = r.coach_id
            GROUP BY c.coach_id
            ORDER BY average_rating DESC
            LIMIT 5
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
            FROM mood_logs
            WHERE client_id = %s
            ORDER BY created_at DESC
        """, (client_id,))
        trackers = cursor.fetchall()

        return jsonify({
            "top_coaches": top_coaches,
            "trackers": trackers
        }), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()
