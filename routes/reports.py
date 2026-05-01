from flask import Blueprint, request, jsonify
from db import get_conn

reports_bp = Blueprint("reports", __name__)


@reports_bp.route("/", methods=["POST"])
def create_report():
    """
    Submit a report against another user.
    ---
    tags:
      - Reports
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - reporter_id
            - reported_user_id
            - reason
          properties:
            reporter_id:
              type: string
              description: ID of the user submitting the report
            reported_user_id:
              type: string
              description: ID of the user being reported
            reason:
              type: string
              description: Reason for the report
            details:
              type: string
              description: Additional details about the report
    responses:
      201:
        description: Report submitted successfully
        schema:
          type: object
          properties:
            message:
              type: string
            report_id:
              type: integer
            status:
              type: string
      400:
        description: Missing required fields
      404:
        description: Reporter or reported user not found
      409:
        description: Open report already exists against this user
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "Request body is required"}), 400

        reporter_id = data.get("reporter_id")
        reported_user_id = data.get("reported_user_id")
        reason = data.get("reason")
        details = data.get("details")

        if not reporter_id or not reported_user_id or not reason:
            return jsonify({
                "error": "reporter_id, reported_user_id, and reason are required"
            }), 400

        if reporter_id == reported_user_id:
            return jsonify({"error": "Users cannot report themselves"}), 400

        # Check reporter exists
        cursor.execute("""
            SELECT client_id, role
            FROM client
            WHERE client_id = %s
        """, (reporter_id,))
        reporter = cursor.fetchone()

        if not reporter:
            return jsonify({"error": "Reporter not found"}), 404

        # Check reported user exists
        cursor.execute("""
            SELECT client_id, role
            FROM client
            WHERE client_id = %s
        """, (reported_user_id,))
        reported_user = cursor.fetchone()

        if not reported_user:
            return jsonify({"error": "Reported user not found"}), 404

        # Optional: prevent duplicate open reports from same reporter against same user
        cursor.execute("""
            SELECT report_id
            FROM reports
            WHERE reporter_id = %s
              AND reported_user_id = %s
              AND status = 'open'
        """, (reporter_id, reported_user_id))
        existing_open_report = cursor.fetchone()

        if existing_open_report:
            return jsonify({
                "error": "You already have an open report against this user"
            }), 409

        cursor.execute("""
            INSERT INTO reports (reporter_id, reported_user_id, reason, details)
            VALUES (%s, %s, %s, %s)
        """, (reporter_id, reported_user_id, reason, details))

        report_id = cursor.lastrowid
        conn.commit()

        return jsonify({
            "message": "Report submitted successfully",
            "report_id": report_id,
            "status": "open"
        }), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()