from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import datetime

coach_applications_bp = Blueprint("coach_applications", __name__)

@coach_applications_bp.route("/", methods=["GET"])
def list_coach_applications():
    status = (request.args.get("status") or "").strip().lower()
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        q = """
            SELECT
                ca.application_id,
                ca.client_id,
                cl.first_name,
                cl.last_name,
                cl.email,
                ca.specialty,
                ca.certifications,
                ca.bio,
                ca.pricing,
                ca.status,
                ca.submitted_at,
                ca.reviewed_by,
                ca.reviewed_at
            FROM coach_applications ca
            JOIN client cl ON ca.client_id = cl.client_id
        """
        params = []
        if status:
            q += " WHERE ca.status = %s"
            params.append(status)
        q += " ORDER BY ca.submitted_at DESC, ca.application_id DESC"
        cursor.execute(q, tuple(params))
        return jsonify({"applications": cursor.fetchall()}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@coach_applications_bp.route("/apply", methods=["POST"])
def apply_to_become_coach():
    data = request.get_json()

    client_id = data.get("client_id")
    bio = data.get("bio")
    specialty = data.get("specialty")
    certifications = data.get("certifications")
    pricing = data.get("pricing")

    if not client_id:
        return jsonify({"error": "client_id is required"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT client_id, role
            FROM client
            WHERE client_id = %s
        """, (client_id,))
        client = cursor.fetchone()

        if not client:
            return jsonify({"error": "Client not found"}), 404

        if client["role"] == "coach":
            return jsonify({"error": "User is already a coach"}), 400

        cursor.execute("""
            SELECT application_id
            FROM coach_applications
            WHERE client_id = %s AND status = 'pending'
        """, (client_id,))
        existing_application = cursor.fetchone()

        if existing_application:
            return jsonify({"error": "You already have a pending application"}), 400

        cursor.execute("""
            INSERT INTO coach_applications (
                client_id,
                bio,
                specialty,
                certifications,
                pricing,
                status,
                submitted_at,
                reviewed_by,
                reviewed_at
            )
            VALUES (%s, %s, %s, %s, %s, 'pending', NOW(), NULL, NULL)
        """, (client_id, bio, specialty, certifications, pricing))

        conn.commit()
        return jsonify({"message": "Coach application submitted successfully"}), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


@coach_applications_bp.route("/review", methods=["PUT"])
def review_coach_application():
    data = request.get_json()

    application_id = data.get("application_id")
    action = data.get("action")
    reviewed_by = data.get("reviewed_by")

    if not application_id or not action or not reviewed_by:
        return jsonify({"error": "application_id, action, and reviewed_by are required"}), 400

    if action not in ["approve", "decline"]:
        return jsonify({"error": "Invalid action"}), 400

    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute(
            "SELECT client_id FROM coach_applications WHERE application_id = %s",
            (application_id,)
        )
        app = cursor.fetchone()

        if not app:
            return jsonify({"error": "Application not found"}), 404

        client_id = app[0]

        new_status = "approved" if action == "approve" else "declined"

        cursor.execute(
            """
            UPDATE coach_applications
            SET status = %s, reviewed_by = %s, reviewed_at = %s
            WHERE application_id = %s
            """,
            (new_status, reviewed_by, datetime.now(), application_id)
        )

        if action == "approve":
            cursor.execute(
                "UPDATE client SET role = 'coach' WHERE client_id = %s",
                (client_id,)
            )

            cursor.execute(
                "SELECT coach_id FROM coach WHERE coach_id = %s",
                (client_id,)
            )
            existing_coach = cursor.fetchone()

            if not existing_coach:
                cursor.execute(
                    "INSERT INTO coach (coach_id) VALUES (%s)",
                    (client_id,)
                )

            # get specialty and certifications from application
            cursor.execute(
                "SELECT specialty, certifications FROM coach_applications WHERE application_id = %s",
                (application_id,)
            )
            app_details = cursor.fetchone()
            specialty = app_details[0]
            certifications = app_details[1]

            if specialty in ("fitness", "both"):
                cursor.execute(
                    "SELECT coach_id FROM fitness_coach WHERE coach_id = %s", (client_id,)
                )
                if not cursor.fetchone():
                    cursor.execute(
                        "INSERT INTO fitness_coach (coach_id, certifications) VALUES (%s, %s)",
                        (client_id, certifications)
                    )

            if specialty in ("nutrition", "both"):
                cursor.execute(
                    "SELECT coach_id FROM nutrition_coach WHERE coach_id = %s", (client_id,)
                )
                if not cursor.fetchone():
                    cursor.execute(
                        "INSERT INTO nutrition_coach (coach_id, certifications) VALUES (%s, %s)",
                        (client_id, certifications)
                    )

        conn.commit()
        return jsonify({"message": f"Application {new_status}"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()