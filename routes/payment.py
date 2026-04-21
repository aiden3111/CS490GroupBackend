from flask import Blueprint, request, jsonify
from db import get_conn

payment_bp = Blueprint("payment", __name__)

# payment method -- Aiden
@payment_bp.route("/add", methods=["POST"])
def add_payment():
    data = request.get_json()

    client_id = data.get("client_id")
    card_type = data.get("card_type")
    last4 = data.get("last4")
    expiry_month = data.get("expiry_month")
    expiry_year = data.get("expiry_year")

    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute("""
                INSERT INTO payment_method
                (client_id, card_type, last4, expiry_month, expiry_year)
                VALUES (%s, %s, %s, %s, %s)
            """, (client_id, card_type, last4, expiry_month, expiry_year))
        
        conn.commit()

        return jsonify({"message": "Payment method was added"}), 201
    
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    
    finally:
        cursor.close()
        conn.close()

# get payment methods -- aiden
@payment_bp.route("/client/<string:client_id>", methods=["GET"])
def get_payments(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT * FROM payment_method
            WHERE client_id = %s
        """, (client_id,))

        payments = cursor.fetchall()

        return jsonify(payments), 200
    
    finally:
        cursor.close()
        conn.close()

#delete payment method
@payment_bp.route("/delete/<int:payment_id>", methods=["DELETE"])
def delete_payment(payment_id):
    conn = get_conn()
    cursor = conn.cursor()

    try: 
        cursor.execute("""
            DELETE FROM payment_method
            WHERE payment_id = %s
        """, (payment_id,))

        conn.commit()

        if cursor.rowcount == 0:
            return jsonify({"error": "Payment method not found"}), 404
        
        return jsonify({"message": "Deleted successfully"}), 200
    
    finally:
        cursor.close()
        conn.close()