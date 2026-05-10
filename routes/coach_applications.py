from flask import Blueprint, request, jsonify
from db import get_conn
from datetime import datetime
from routes.notify import push_notification

coach_applications_bp = Blueprint("coach_applications", __name__)


@coach_applications_bp.route("/", methods=["GET"])
def list_coach_applications():
    """
    List coach applications with optional status filter.
    ---
    tags:
      - Coach Applications
    parameters:
      - name: status
        in: query
        type: string
        enum: [pending, approved, declined]
        description: Filter applications by status
    responses:
      200:
        description: List of coach applications
        schema:
          type: object
          properties:
            applications:
              type: array
              items:
                type: object
                properties:
                  application_id:
                    type: integer
                  client_id:
                    type: string
                  first_name:
                    type: string
                  last_name:
                    type: string
                  email:
                    type: string
                  specialty:
                    type: string
                  certifications:
                    type: string
                  bio:
                    type: string
                  pricing:
                    type: number
                  availability:
                    type: string
                  status:
                    type: string
                  submitted_at:
                    type: string
                    format: date-time
                  reviewed_by:
                    type: string
                  reviewed_at:
                    type: string
                    format: date-time
      500:
        description: Server error
    """
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
                ca.availability,
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
    """
    Submit an application to become a coach.
    ---
    tags:
      - Coach Applications
    parameters:
      - name: application_data
        in: body
        required: true
        schema:
          type: object
          required:
            - client_id
          properties:
            client_id:
              type: string
              description: Client ID of the applicant
            bio:
              type: string
              description: Coach biography
            specialty:
              type: string
              enum: [fitness, nutrition, both]
              description: Coaching specialty
            certifications:
              type: string
              description: Coach certifications
            pricing:
              type: number
              description: Coaching pricing
            availability:
              type: string
              description: Coach availability
              example: "Mondays and Wednesdays 6 PM - 9 PM"
    responses:
      201:
        description: Application submitted successfully
        schema:
          type: object
          properties:
            message:
              type: string
      400:
        description: Invalid request or already applied
      404:
        description: Client not found
      500:
        description: Server error
    """
    data = request.get_json()

    client_id = data.get("client_id")
    bio = data.get("bio")
    specialty = data.get("specialty")
    certifications = data.get("certifications")
    pricing = data.get("pricing")
    availability = data.get("availability")

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
                availability,
                status,
                submitted_at,
                reviewed_by,
                reviewed_at
            )
            VALUES (%s, %s, %s, %s, %s, %s, 'pending', NOW(), NULL, NULL)
        """, (client_id, bio, specialty, certifications, pricing, availability))

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
    """
    Review and approve/decline a coach application.
    ---
    tags:
      - Coach Applications
    parameters:
      - name: review_data
        in: body
        required: true
        schema:
          type: object
          required:
            - application_id
            - action
            - reviewed_by
          properties:
            application_id:
              type: integer
              description: Application ID to review
            action:
              type: string
              enum: [approve, decline]
              description: Review action
            reviewed_by:
              type: string
              description: Admin/coach ID performing the review
    responses:
      200:
        description: Application reviewed successfully
        schema:
          type: object
          properties:
            message:
              type: string
      400:
        description: Invalid request data
      404:
        description: Application not found
      500:
        description: Server error
    """
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
            """
            SELECT client_id, specialty, certifications, pricing, availability
            FROM coach_applications
            WHERE application_id = %s
            """,
            (application_id,)
        )
        app = cursor.fetchone()

        if not app:
            return jsonify({"error": "Application not found"}), 404

        client_id = app[0]
        specialty = app[1]
        certifications = app[2]
        pricing = app[3]
        availability = app[4]

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
                    """
                    INSERT INTO coach (
                        coach_id,
                        status,
                        pricing,
                        availability,
                        specialty
                    )
                    VALUES (%s, %s, %s, %s, %s)
                    """,
                    (client_id, "active", pricing, availability, specialty)
                )
            else:
                cursor.execute(
                    """
                    UPDATE coach
                    SET status = %s,
                        pricing = %s,
                        availability = %s,
                        specialty = %s
                    WHERE coach_id = %s
                    """,
                    ("active", pricing, availability, specialty, client_id)
                )

            if specialty in ("fitness", "both"):
                cursor.execute(
                    "SELECT coach_id FROM fitness_coach WHERE coach_id = %s",
                    (client_id,)
                )
                if not cursor.fetchone():
                    cursor.execute(
                        """
                        INSERT INTO fitness_coach (coach_id, certifications)
                        VALUES (%s, %s)
                        """,
                        (client_id, certifications)
                    )

            if specialty in ("nutrition", "both"):
                cursor.execute(
                    "SELECT coach_id FROM nutrition_coach WHERE coach_id = %s",
                    (client_id,)
                )
                if not cursor.fetchone():
                    cursor.execute(
                        """
                        INSERT INTO nutrition_coach (coach_id, certifications)
                        VALUES (%s, %s)
                        """,
                        (client_id, certifications)
                    )

        # Notify the applicant of the decision
        if action == "approve":
            push_notification(
                cursor, client_id, "system",
                "Application Approved",
                "Congratulations! Your coach application has been approved. You can now accept clients.",
            )
        else:
            push_notification(
                cursor, client_id, "system",
                "Application Declined",
                "Your coach application was not approved at this time.",
            )

        conn.commit()
        return jsonify({"message": f"Application {new_status}"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()