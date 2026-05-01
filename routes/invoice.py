from flask import Blueprint, jsonify, Response
from db import get_conn

invoice_bp = Blueprint("invoice", __name__)

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
    """
    Download an invoice as a text file.
    ---
    tags:
      - Invoices
    parameters:
      - name: invoice_id
        in: path
        required: true
        type: integer
        description: Invoice ID to download
    responses:
      200:
        description: Invoice text file download
        schema:
          type: file
      404:
        description: Invoice not found
    """
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