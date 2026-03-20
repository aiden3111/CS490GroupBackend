from flask import Blueprint, request, jsonify
from db import get_conn

coach_search_bp = Blueprint("coach_search", __name__)

#display all coaches and be to search by name or specialty
@coach_search_bp.route("/", methods=["GET"])
def search_coaches():
    #name_query = request.args.get("name")
    name_query = request.args.get("search")
    #specialty_query = request.args.get("specialty")
    #I need to do a couple of changes, the search was returning all the coaches and not the only
    #searched term

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
#I need the pricing and certification for the profile - maiury
    try:
        query = """
            SELECT 
                coach.coach_id,
                client.first_name,
                client.last_name,
                coach.specialty,
                coach.pricing,
                coach.certifications  
            FROM coach
            JOIN client ON client.client_id = coach.coach_id
            WHERE 1=1
        """
        params = []
        '''
        if name_query:
            query += " AND (first_name LIKE %s OR last_name LIKE %s)"
            params.extend([f"%{name_query}%", f"%{name_query}%"])

        if specialty_query:
            query += " AND specialty LIKE %s"
            params.append(f"%{specialty_query}%")

        '''
        if name_query:
            query += " AND (client.first_name LIKE %s OR client.last_name LIKE %s OR coach.specialty LIKE %s)"
            params.extend([f"%{name_query}%", f"%{name_query}%", f"%{name_query}%"])

        '''
        if specialty_query:
            query += " AND specialty LIKE %s"
            params.append(f"%{specialty_query}%")
        '''
        
        cursor.execute(query, tuple(params))
        coaches = cursor.fetchall()

        return jsonify(coaches), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()
