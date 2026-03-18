from flask import Blueprint, request, jsonify
from db import get_conn

coach_search_bp = Blueprint("coach_search", __name__)

#display all coaches and be to search by name or specialty
@coach_search_bp.route("/", methods=["GET"])
def search_coaches():
    name_query = request.args.get("name")
    specialty_query = request.args.get("specialty")

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        query = """
            SELECT 
                coach_id,
                first_name,
                last_name,
                specialty
            FROM coach
            WHERE 1=1
        """
        params = []

        if name_query:
            query += " AND (first_name LIKE %s OR last_name LIKE %s)"
            params.extend([f"%{name_query}%", f"%{name_query}%"])

        if specialty_query:
            query += " AND specialty LIKE %s"
            params.append(f"%{specialty_query}%")

        cursor.execute(query, tuple(params))
        coaches = cursor.fetchall()

        return jsonify(coaches), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()