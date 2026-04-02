from flask import Blueprint, request, jsonify
from db import get_conn

coach_search_bp = Blueprint("coach_search", __name__)

@coach_search_bp.route("/", methods=["GET"])
def search_coaches():
    name_query = request.args.get("search")

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        query = """
            SELECT 
                c.coach_id,
                cl.first_name,
                cl.last_name,
                c.pricing,
                fc.certifications AS fitness_certifications,
                nc.certifications AS nutrition_certifications,
                CASE
                    WHEN fc.coach_id IS NOT NULL AND nc.coach_id IS NOT NULL THEN 'Fitness & Nutrition'
                    WHEN fc.coach_id IS NOT NULL THEN 'Fitness'
                    WHEN nc.coach_id IS NOT NULL THEN 'Nutrition'
                    ELSE 'none'
                END AS specialty
            FROM coach c
            JOIN client cl ON cl.client_id = c.coach_id
            LEFT JOIN fitness_coach fc ON c.coach_id = fc.coach_id
            LEFT JOIN nutrition_coach nc ON c.coach_id = nc.coach_id
            WHERE 1=1
        """
        params = []

        if name_query:
            query += """
                AND (
                    cl.first_name LIKE %s 
                    OR cl.last_name LIKE %s
                    OR CASE
                        WHEN fc.coach_id IS NOT NULL AND nc.coach_id IS NOT NULL THEN 'Fitness & Nutrition'
                        WHEN fc.coach_id IS NOT NULL THEN 'Fitness'
                        WHEN nc.coach_id IS NOT NULL THEN 'Nutrition'
                        ELSE 'none'
                    END LIKE %s
                )
            """
            params.extend([f"%{name_query}%", f"%{name_query}%", f"%{name_query}%"])

        cursor.execute(query, tuple(params))
        coaches = cursor.fetchall()

        return jsonify(coaches), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()