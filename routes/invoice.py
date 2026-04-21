from flask import Blueprint, jsonify, Response
from db import get_conn

invoice_bp = Blueprint("invoice", __name__)

@invoice_bp.route("/<string:client_id>", methods=["GET"])
def get_invoices(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT * FROM invoice
            WHERE client_id = %s
        """, (client_id,))

        invoices = cursor.fetchall()
        return jsonify(invoices), 200
    
    finally:
        cursor.close()
        conn.close()

@invoice_bp.route("/download/<int:invoice_id>", methods=["GET"])
def download_invoice(invoice_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT * FROM invoice
            WHERE invoice_id = %s
        """, (invoice_id,))

        invoice = cursor.fetchone()

        if not invoice:
            return {"error": "Invoice not found"}, 404
        
        #simple txt file response -- aiden

        content = f"""
Invoice ID: {invoice['invoice_id']}
Client ID: {invoice['client_id']}
Amount: ${invoice['amount']}
Month: {invoice['billing_month']}
"""
        
        return Response(
            content,
            mimetype="text/plain",
            headers={
                "Content-Disposition": f"attachment;filename=invoice_{invoice_id}.txt"
            }
        )
    
    finally:
        cursor.close()
        conn.close()