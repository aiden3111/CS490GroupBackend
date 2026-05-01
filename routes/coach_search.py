from flask import Blueprint, request, jsonify
from db import get_conn

coach_search_bp = Blueprint("coach_search", __name__)

@coach_search_bp.route("/", methods=["GET"])
def search_coaches():
    """
    Search and filter coaches by name, price, availability, or specialty.
    ---
    tags:
      - Coach
    parameters:
      - name: search
        in: query
        type: string
        description: Search by name, specialty, or availability
      - name: sort
        in: query
        type: string
        enum: [price_asc, price_desc]
      - name: min_price
        in: query
        type: number
      - name: max_price
        in: query
        type: number
      - name: availability
        in: query
        type: string
    responses:
      200:
        description: List of matching coaches
      500:
        description: Server error
    """
    name_query = request.args.get("search")
    sort_order = request.args.get("sort")
    min_price = request.args.get("min_price")
    max_price = request.args.get("max_price")
    availability = request.args.get("availability")

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        query = """
            SELECT 
                c.coach_id,
                cl.first_name,
                cl.last_name,
                c.pricing,
                c.availability,
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
                    OR c.availability LIKE %s
                    OR CASE
                        WHEN fc.coach_id IS NOT NULL AND nc.coach_id IS NOT NULL THEN 'Fitness & Nutrition'
                        WHEN fc.coach_id IS NOT NULL THEN 'Fitness'
                        WHEN nc.coach_id IS NOT NULL THEN 'Nutrition'
                        ELSE 'none'
                    END LIKE %s
                )
            """
            params.extend([f"%{name_query}%", f"%{name_query}%", f"%{name_query}%", f"%{name_query}%"])

        if min_price:
            query += " AND c.pricing >= %s"
            params.append(float(min_price))

        if max_price:
            query += " AND c.pricing <= %s"
            params.append(float(max_price))

        if availability:
            query += " AND c.availability LIKE %s"
            params.append(f"%{availability}%")

        if sort_order == 'price_asc':
            query += " ORDER BY c.pricing ASC"
        elif sort_order == 'price_desc':
            query += " ORDER BY c.pricing DESC"

        cursor.execute(query, tuple(params))
        coaches = cursor.fetchall()

        return jsonify(coaches), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()