from flask import Blueprint, request, jsonify
from db import get_conn


admin_bp = Blueprint("admin", __name__)
#allow an admin to view all accounts and be able to delete any account
@admin_bp.route('/accounts', methods=['GET'])
def get_all_accounts():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        q = (request.args.get("q") or "").strip()
        base = """
            SELECT client_id, first_name, last_name, email, role, status
            FROM client
        """
        params = []
        if q:
            base += """
            WHERE client_id LIKE %s
               OR email LIKE %s
               OR first_name LIKE %s
               OR last_name LIKE %s
            """
            like = f"%{q}%"
            params = [like, like, like, like]
        base += " ORDER BY last_name ASC, first_name ASC"
        cursor.execute(base, tuple(params))
        clients = cursor.fetchall()
        return jsonify({"clients": clients}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

@admin_bp.route('/accounts/<string:client_id>', methods=['DELETE'])
def delete_account(client_id):
    conn = get_conn()
    cursor = conn.cursor()
    try:
        cursor.execute("DELETE FROM client WHERE client_id = %s", (client_id,))
        if cursor.rowcount == 0:
            return jsonify({"error": "Client not found"}), 404
        conn.commit()
        return jsonify({"message": "Client deleted successfully"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# This is used when the admin wants to see a list of all submitted reports.
@admin_bp.route('/reports', methods=['GET'])
def get_all_reports():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        status = request.args.get("status")  # optional filter

        base_query = """
            SELECT
                r.report_id,
                r.reporter_id,
                CONCAT(rep.first_name, ' ', rep.last_name) AS reporter_name,
                r.reported_user_id,
                CONCAT(reported.first_name, ' ', reported.last_name) AS reported_user_name,
                r.reason,
                r.details,
                r.status,
                r.created_at,
                r.reviewed_by,
                CASE
                    WHEN a.admin_id IS NOT NULL THEN CONCAT(a.first_name, ' ', a.last_name)
                    ELSE NULL
                END AS reviewed_by_name,
                r.resolved_at
            FROM reports r
            JOIN client rep ON r.reporter_id = rep.client_id
            JOIN client reported ON r.reported_user_id = reported.client_id
            LEFT JOIN admin a ON r.reviewed_by = a.admin_id
        """

        params = []
        if status:
            base_query += " WHERE r.status = %s"
            params.append(status)

        base_query += " ORDER BY r.created_at DESC"

        cursor.execute(base_query, tuple(params))
        reports = cursor.fetchall()

        return jsonify({"reports": reports}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

# This is used when the admin clicks on one specific report and wants to see the full details.
@admin_bp.route('/reports/<int:report_id>', methods=['GET'])
def get_single_report(report_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                r.report_id,
                r.reporter_id,
                CONCAT(rep.first_name, ' ', rep.last_name) AS reporter_name,
                rep.email AS reporter_email,
                r.reported_user_id,
                CONCAT(reported.first_name, ' ', reported.last_name) AS reported_user_name,
                reported.email AS reported_user_email,
                r.reason,
                r.details,
                r.status,
                r.created_at,
                r.reviewed_by,
                CASE
                    WHEN a.admin_id IS NOT NULL THEN CONCAT(a.first_name, ' ', a.last_name)
                    ELSE NULL
                END AS reviewed_by_name,
                r.resolved_at
            FROM reports r
            JOIN client rep ON r.reporter_id = rep.client_id
            JOIN client reported ON r.reported_user_id = reported.client_id
            LEFT JOIN admin a ON r.reviewed_by = a.admin_id
            WHERE r.report_id = %s
        """, (report_id,))

        report = cursor.fetchone()

        if not report:
            return jsonify({"error": "Report not found"}), 404

        return jsonify({"report": report}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# This is the route the admin uses to take action on a report.
@admin_bp.route('/reports/<int:report_id>/review', methods=['PATCH'])
def review_report(report_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        data = request.get_json()

        if not data:
            return jsonify({"error": "Request body is required"}), 400

        admin_id = data.get("admin_id")
        new_status = data.get("status")

        allowed_statuses = {"reviewed", "resolved", "dismissed"}

        if not admin_id:
            return jsonify({"error": "admin_id is required"}), 400

        if not new_status:
            return jsonify({"error": "status is required"}), 400

        if new_status not in allowed_statuses:
            return jsonify({
                "error": f"Invalid status. Allowed values: {', '.join(sorted(allowed_statuses))}"
            }), 400

        # Validate admin exists
        cursor.execute("SELECT admin_id FROM admin WHERE admin_id = %s", (admin_id,))
        admin = cursor.fetchone()

        if not admin:
            return jsonify({"error": "Admin not found"}), 404

        # Validate report exists
        cursor.execute("SELECT report_id, status FROM reports WHERE report_id = %s", (report_id,))
        report = cursor.fetchone()

        if not report:
            return jsonify({"error": "Report not found"}), 404

        # resolved/dismissed should set resolved_at
        if new_status in {"resolved", "dismissed"}:
            cursor.execute("""
                UPDATE reports
                SET status = %s,
                    reviewed_by = %s,
                    resolved_at = NOW()
                WHERE report_id = %s
            """, (new_status, admin_id, report_id))
        else:
            # reviewed should not necessarily mark resolved_at
            cursor.execute("""
                UPDATE reports
                SET status = %s,
                    reviewed_by = %s,
                    resolved_at = NULL
                WHERE report_id = %s
            """, (new_status, admin_id, report_id))

        conn.commit()

        return jsonify({
            "message": "Report updated successfully",
            "report_id": report_id,
            "new_status": new_status,
            "reviewed_by": admin_id
        }), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@admin_bp.route('/disable_user', methods=['PATCH'])
def disable_user():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        data = request.get_json()

        admin_id = data.get("admin_id")
        client_id = data.get("client_id")
        coach_id = data.get("coach_id")

        if not admin_id:
            return jsonify({"error": "admin_id is required"}), 400

        # Validate admin exists
        cursor.execute("SELECT admin_id FROM admin WHERE admin_id = %s", (admin_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Admin not found"}), 404

        # Disable CLIENT
        if client_id:
            cursor.execute("SELECT client_id FROM client WHERE client_id = %s", (client_id,))
            if not cursor.fetchone():
                return jsonify({"error": "Client not found"}), 404

            cursor.execute("""
                UPDATE client
                SET status = 'disabled'
                WHERE client_id = %s
            """, (client_id,))

            conn.commit()
            return jsonify({"message": "Client disabled successfully"}), 200

        # Disable COACH
        elif coach_id:
            cursor.execute("SELECT coach_id FROM coach WHERE coach_id = %s", (coach_id,))
            if not cursor.fetchone():
                return jsonify({"error": "Coach not found"}), 404

            cursor.execute("""
                UPDATE coach
                SET status = 'suspended'
                WHERE coach_id = %s
            """, (coach_id,))

            conn.commit()
            return jsonify({"message": "Coach suspended successfully"}), 200

        else:
            return jsonify({"error": "client_id or coach_id is required"}), 400

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()

@admin_bp.route('/reactivate_user', methods=['PATCH'])
def reactivate_user():
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        data = request.get_json()

        admin_id = data.get("admin_id")
        client_id = data.get("client_id")
        coach_id = data.get("coach_id")

        if not admin_id:
            return jsonify({"error": "admin_id is required"}), 400

        # Validate admin exists -- aiden
        cursor.execute("SELECT admin_id FROM admin WHERE admin_id = %s", (admin_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Admin not found"}), 404

        # Reactivate CLIENT -- aiden
        if client_id:
            cursor.execute("SELECT client_id FROM client WHERE client_id = %s", (client_id,))
            if not cursor.fetchone():
                return jsonify({"error": "Client not found"}), 404

            cursor.execute("""
                UPDATE client
                SET status = 'active'
                WHERE client_id = %s
            """, (client_id,))

            conn.commit()
            return jsonify({"message": "Client reactivated successfully"}), 200

        # Reactivate COACH
        elif coach_id:
            cursor.execute("SELECT coach_id FROM coach WHERE coach_id = %s", (coach_id,))
            if not cursor.fetchone():
                return jsonify({"error": "Coach not found"}), 404

            cursor.execute("""
                UPDATE coach
                SET status = 'active'
                WHERE coach_id = %s
            """, (coach_id,))

            conn.commit()
            return jsonify({"message": "Coach reactivated successfully"}), 200

        else:
            return jsonify({"error": "client_id or coach_id is required"}), 400

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()