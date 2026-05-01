from flask import Blueprint, request, jsonify
from db import get_conn


admin_bp = Blueprint("admin", __name__)
#allow an admin to view all accounts and be able to delete any account
@admin_bp.route('/accounts', methods=['GET'])
def get_all_accounts():
    """
    Get all client accounts with optional search filtering.
    ---
    tags:
      - Admin
    parameters:
      - name: q
        in: query
        type: string
        description: Search query for client ID, email, first name, or last name
    responses:
      200:
        description: List of client accounts
        schema:
          type: object
          properties:
            clients:
              type: array
              items:
                type: object
                properties:
                  client_id:
                    type: string
                  first_name:
                    type: string
                  last_name:
                    type: string
                  email:
                    type: string
                  role:
                    type: string
                  status:
                    type: string
      500:
        description: Server error
    """
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
    """
    Delete a client account permanently.
    ---
    tags:
      - Admin
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: The client ID to delete
    responses:
      200:
        description: Client deleted successfully
      404:
        description: Client not found
      500:
        description: Server error
    """
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
    """
    Get all user reports with optional status filtering.
    ---
    tags:
      - Admin
    parameters:
      - name: status
        in: query
        type: string
        enum: [pending, reviewed, resolved, dismissed]
        description: Filter reports by status
    responses:
      200:
        description: List of reports
        schema:
          type: object
          properties:
            reports:
              type: array
              items:
                type: object
                properties:
                  report_id:
                    type: integer
                  reporter_id:
                    type: string
                  reporter_name:
                    type: string
                  reported_user_id:
                    type: string
                  reported_user_name:
                    type: string
                  reason:
                    type: string
                  details:
                    type: string
                  status:
                    type: string
                  created_at:
                    type: string
                    format: date-time
                  reviewed_by:
                    type: string
                  reviewed_by_name:
                    type: string
                  resolved_at:
                    type: string
                    format: date-time
      500:
        description: Server error
    """
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
    """
    Get detailed information for a specific report.
    ---
    tags:
      - Admin
    parameters:
      - name: report_id
        in: path
        required: true
        type: integer
        description: The report ID
    responses:
      200:
        description: Report details
        schema:
          type: object
          properties:
            report:
              type: object
              properties:
                report_id:
                  type: integer
                reporter_id:
                  type: string
                reporter_name:
                  type: string
                reporter_email:
                  type: string
                reported_user_id:
                  type: string
                reported_user_name:
                  type: string
                reported_user_email:
                  type: string
                reason:
                  type: string
                details:
                  type: string
                status:
                  type: string
                created_at:
                  type: string
                  format: date-time
                reviewed_by:
                  type: string
                reviewed_by_name:
                  type: string
                resolved_at:
                  type: string
                  format: date-time
      404:
        description: Report not found
      500:
        description: Server error
    """
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
    """
    Review and update the status of a report.
    ---
    tags:
      - Admin
    parameters:
      - name: report_id
        in: path
        required: true
        type: integer
        description: The report ID
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - admin_id
            - status
          properties:
            admin_id:
              type: string
              description: Admin ID performing the review
            status:
              type: string
              enum: [reviewed, resolved, dismissed]
              description: New status for the report
    responses:
      200:
        description: Report updated successfully
        schema:
          type: object
          properties:
            message:
              type: string
            report_id:
              type: integer
            new_status:
              type: string
            reviewed_by:
              type: string
      400:
        description: Invalid request data or status
      404:
        description: Report or admin not found
      500:
        description: Server error
    """
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
    """
    Disable a client or suspend a coach account.
    ---
    tags:
      - Admin
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - admin_id
          properties:
            admin_id:
              type: string
              description: Admin ID performing the action
            client_id:
              type: string
              description: Client ID to disable (mutually exclusive with coach_id)
            coach_id:
              type: string
              description: Coach ID to suspend (mutually exclusive with client_id)
    responses:
      200:
        description: User disabled/suspended successfully
      400:
        description: Missing required fields or invalid combination
      404:
        description: Admin or user not found
      500:
        description: Server error
    """
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
    """
    Reactivate a disabled client or suspended coach account.
    ---
    tags:
      - Admin
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - admin_id
          properties:
            admin_id:
              type: string
              description: Admin ID performing the action
            client_id:
              type: string
              description: Client ID to reactivate (mutually exclusive with coach_id)
            coach_id:
              type: string
              description: Coach ID to reactivate (mutually exclusive with client_id)
    responses:
      200:
        description: User reactivated successfully
      400:
        description: Missing required fields or invalid combination
      404:
        description: Admin or user not found
      500:
        description: Server error
    """
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

# View only active accounts
@admin_bp.route('/accounts/active', methods=['GET'])
def get_active_accounts():
    """
    Get all active client accounts.
    ---
    tags:
      - Admin
    responses:
      200:
        description: List of active client accounts
        schema:
          type: object
          properties:
            clients:
              type: array
              items:
                type: object
                properties:
                  client_id:
                    type: string
                  first_name:
                    type: string
                  last_name:
                    type: string
                  email:
                    type: string
                  role:
                    type: string
                  status:
                    type: string
                  signup_date:
                    type: string
                    format: date
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT client_id, first_name, last_name, email, role, status, signup_date
            FROM client
            WHERE status = 'active'
            ORDER BY last_name ASC, first_name ASC
        """)
        clients = cursor.fetchall()
        return jsonify({"clients": clients}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


# View only disabled/suspended accounts
@admin_bp.route('/accounts/disabled', methods=['GET'])
def get_disabled_accounts():
    """
    Get all disabled client accounts.
    ---
    tags:
      - Admin
    responses:
      200:
        description: List of disabled client accounts
        schema:
          type: object
          properties:
            clients:
              type: array
              items:
                type: object
                properties:
                  client_id:
                    type: string
                  first_name:
                    type: string
                  last_name:
                    type: string
                  email:
                    type: string
                  role:
                    type: string
                  status:
                    type: string
                  signup_date:
                    type: string
                    format: date
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT client_id, first_name, last_name, email, role, status, signup_date
            FROM client
            WHERE status = 'disabled'
            ORDER BY last_name ASC, first_name ASC
        """)
        clients = cursor.fetchall()
        return jsonify({"clients": clients}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


# View new accounts — defaults to last 7 days, use ?days=30 for last 30 days
@admin_bp.route('/accounts/new', methods=['GET'])
def get_new_accounts():
    """
    Get recently created accounts within a specified number of days.
    ---
    tags:
      - Admin
    parameters:
      - name: days
        in: query
        type: integer
        default: 7
        description: Number of days to look back
    responses:
      200:
        description: List of new client accounts
        schema:
          type: object
          properties:
            clients:
              type: array
              items:
                type: object
                properties:
                  client_id:
                    type: string
                  first_name:
                    type: string
                  last_name:
                    type: string
                  email:
                    type: string
                  role:
                    type: string
                  status:
                    type: string
                  signup_date:
                    type: string
                    format: date
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        days = request.args.get("days", 7)
        cursor.execute("""
            SELECT client_id, first_name, last_name, email, role, status, signup_date
            FROM client
            WHERE signup_date >= DATE_SUB(CURDATE(), INTERVAL %s DAY)
            ORDER BY signup_date DESC
        """, (days,))
        clients = cursor.fetchall()
        return jsonify({"clients": clients}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


# User stats — totals, new signups by period
@admin_bp.route('/stats', methods=['GET'])
def get_user_stats():
    """
    Get user statistics including totals and recent signups.
    ---
    tags:
      - Admin
    responses:
      200:
        description: User statistics
        schema:
          type: object
          properties:
            total_users:
              type: integer
            active_users:
              type: integer
            deactivated_users:
              type: integer
            total_coaches:
              type: integer
            total_clients:
              type: integer
            new_today:
              type: integer
            new_this_week:
              type: integer
            new_this_month:
              type: integer
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        cursor.execute("""
            SELECT 
                COUNT(*) AS total_users,
                SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END) AS active_users,
                SUM(CASE WHEN status = 'disabled' THEN 1 ELSE 0 END) AS deactivated_users,
                SUM(CASE WHEN role = 'coach' THEN 1 ELSE 0 END) AS total_coaches,
                SUM(CASE WHEN role = 'client' THEN 1 ELSE 0 END) AS total_clients
            FROM client
        """)
        totals = cursor.fetchone()

        cursor.execute("SELECT COUNT(*) AS new_today FROM client WHERE DATE(signup_date) = CURDATE()")
        totals["new_today"] = cursor.fetchone()["new_today"]

        cursor.execute("SELECT COUNT(*) AS new_this_week FROM client WHERE signup_date >= DATE_SUB(CURDATE(), INTERVAL 7 DAY)")
        totals["new_this_week"] = cursor.fetchone()["new_this_week"]

        cursor.execute("SELECT COUNT(*) AS new_this_month FROM client WHERE signup_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)")
        totals["new_this_month"] = cursor.fetchone()["new_this_month"]

        return jsonify(totals), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


# Active user reports by day/week/month based on logging activity
@admin_bp.route('/active_users', methods=['GET'])
def get_active_users():
    """
    Get active user statistics based on logging activity.
    ---
    tags:
      - Admin
    parameters:
      - name: period
        in: query
        type: string
        enum: [day, week, month]
        default: week
        description: Time period for activity analysis
    responses:
      200:
        description: Active user statistics
        schema:
          type: object
          properties:
            period:
              type: string
            total_active_users:
              type: integer
            daily_breakdown:
              type: array
              items:
                type: object
                properties:
                  active_users:
                    type: integer
                  date:
                    type: string
                    format: date
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        period = request.args.get("period", "week")

        if period == "day":
            interval = "INTERVAL 1 DAY"
        elif period == "month":
            interval = "INTERVAL 30 DAY"
        else:
            interval = "INTERVAL 7 DAY"

        cursor.execute(f"""
            SELECT 
                COUNT(DISTINCT l.client_id) AS active_users,
                DATE(l.log_date) AS date
            FROM logging l
            JOIN client c ON l.client_id = c.client_id
            WHERE l.log_date >= DATE_SUB(CURDATE(), {interval})
            GROUP BY DATE(l.log_date)
            ORDER BY date ASC
        """)
        activity = cursor.fetchall()

        cursor.execute(f"SELECT COUNT(DISTINCT client_id) AS total_active FROM logging WHERE log_date >= DATE_SUB(CURDATE(), {interval})")
        total = cursor.fetchone()["total_active"]

        return jsonify({
            "period": period,
            "total_active_users": total,
            "daily_breakdown": activity
        }), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()    

@admin_bp.route('/check_status/<string:user_id>', methods=['GET'])
def check_status(user_id):
    """
    Check the status of a user (coach or client).
    ---
    tags:
      - Admin
    parameters:
      - name: user_id
        in: path
        required: true
        type: string
        description: The user ID to check
    responses:
      200:
        description: User status
        schema:
          type: object
          properties:
            status:
              type: string
              example: active
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("SELECT status FROM coach WHERE coach_id = %s", (user_id,))
        res = cursor.fetchone()
        
        if not res:
            cursor.execute("SELECT status FROM client WHERE client_id = %s", (user_id,))
            res = cursor.fetchone()

        if res:
            status_value = res['status'] if res.get('status') else "active"
        else:
            status_value = "active"

        return jsonify({"status": status_value.lower()}), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()    
