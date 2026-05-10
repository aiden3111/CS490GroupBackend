from datetime import date
from flask import Blueprint, jsonify, request
from db import get_conn

invoice_bp = Blueprint("invoice", __name__)


def _month_label(value):
    return value.strftime("%B %Y")


def _month_start(value):
    return date(value.year, value.month, 1)


def _next_month(value):
    if value.month == 12:
        return date(value.year + 1, 1, 1)
    return date(value.year, value.month + 1, 1)


def create_mock_invoice(cursor, client_id, amount, billed_on=None, allow_duplicate=False):
    billed_on = billed_on or date.today()
    billing_month = _month_label(billed_on)
    if not allow_duplicate:
        cursor.execute(
            """
            SELECT invoice_id
            FROM invoice
            WHERE client_id = %s AND billing_month = %s
            LIMIT 1
            """,
            (client_id, billing_month),
        )
        if cursor.fetchone():
            return None

    cursor.execute(
        """
        INSERT INTO invoice (client_id, amount, billing_month, created_at)
        VALUES (%s, %s, %s, %s)
        """,
        (client_id, amount, billing_month, _month_start(billed_on)),
    )
    return cursor.lastrowid


def ensure_monthly_mock_invoices(cursor, client_id):
    cursor.execute(
        """
        SELECT c.client_id, c.coach_id, c.signup_date, co.pricing
        FROM client c
        JOIN coach co ON c.coach_id = co.coach_id
        WHERE c.client_id = %s
        """,
        (client_id,),
    )
    subscription = cursor.fetchone()
    if not subscription:
        return

    cursor.execute(
        """
        SELECT MIN(created_at) AS first_invoice_date
        FROM invoice
        WHERE client_id = %s
        """,
        (client_id,),
    )
    first_invoice = cursor.fetchone()
    start_date = (
        first_invoice["first_invoice_date"].date()
        if first_invoice and first_invoice["first_invoice_date"]
        else subscription["signup_date"]
    )

    current_month = _month_start(start_date)
    end_month = _month_start(date.today())
    while current_month <= end_month:
        create_mock_invoice(cursor, client_id, subscription["pricing"], current_month)
        current_month = _next_month(current_month)


@invoice_bp.route("/<string:client_id>", methods=["GET"])
def get_invoices(client_id):
    """
    Get all invoices for a client.
    ---
    tags:
      - Invoices
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
    responses:
      200:
        description: List of client invoices
        schema:
          type: array
          items:
            type: object
            properties:
              invoice_id:
                type: integer
              client_id:
                type: string
              amount:
                type: number
              billing_month:
                type: string
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        ensure_monthly_mock_invoices(cursor, client_id)
        conn.commit()

        cursor.execute("""
            SELECT * FROM invoice
            WHERE client_id = %s
            ORDER BY created_at DESC, invoice_id DESC
        """, (client_id,))

        invoices = cursor.fetchall()
        return jsonify(invoices), 200
    
    finally:
        cursor.close()
        conn.close()

@invoice_bp.route("/mock-charge", methods=["POST"])
def create_manual_mock_charge():
    data = request.get_json() or {}
    client_id = data.get("client_id")
    amount = data.get("amount")

    if not client_id or amount is None:
        return jsonify({"error": "client_id and amount are required"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        invoice_id = create_mock_invoice(cursor, client_id, amount)
        conn.commit()
        return jsonify({
            "message": "Mock card charge recorded.",
            "invoice_id": invoice_id,
        }), 201
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    
    finally:
        cursor.close()
        conn.close()
