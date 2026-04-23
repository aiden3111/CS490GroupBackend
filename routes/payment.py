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
    is_default = bool(data.get("is_default")) if data else False

    if not client_id:
        return jsonify({"error": "client_id is required"}), 400
    if not last4 or len(str(last4)) != 4:
        return jsonify({"error": "last4 is required and must be 4 digits"}), 400

    conn = get_conn()
    cursor = conn.cursor()

    try:
        # If this is the first payment method, make it default automatically.
        cursor.execute("SELECT COUNT(*) FROM payment_method WHERE client_id = %s", (client_id,))
        (existing_count,) = cursor.fetchone()
        if existing_count == 0:
            is_default = True

        # Enforce single default per client.
        if is_default:
            cursor.execute(
                "UPDATE payment_method SET is_default = FALSE WHERE client_id = %s",
                (client_id,),
            )

        cursor.execute("""
                INSERT INTO payment_method
                (client_id, card_type, last4, expiry_month, expiry_year, is_default)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (client_id, card_type, last4, expiry_month, expiry_year, is_default))
        
        conn.commit()

        return jsonify({"message": "Payment method was added", "payment_id": cursor.lastrowid}), 201
    
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
            ORDER BY is_default DESC, created_at DESC, payment_id DESC
        """, (client_id,))

        payments = cursor.fetchall()

        return jsonify(payments), 200
    
    finally:
        cursor.close()
        conn.close()

# update payment method (edit)
@payment_bp.route("/update/<int:payment_id>", methods=["PUT"])
def update_payment(payment_id):
    data = request.get_json() or {}
    card_type = data.get("card_type")
    last4 = data.get("last4")
    expiry_month = data.get("expiry_month")
    expiry_year = data.get("expiry_year")

    if all(v is None for v in [card_type, last4, expiry_month, expiry_year]):
        return jsonify({"error": "Must provide at least one field to update"}), 400
    if last4 is not None and len(str(last4)) != 4:
        return jsonify({"error": "last4 must be 4 digits"}), 400

    conn = get_conn()
    cursor = conn.cursor()

    try:
        fields = []
        values = []
        if card_type is not None:
            fields.append("card_type = %s")
            values.append(card_type)
        if last4 is not None:
            fields.append("last4 = %s")
            values.append(last4)
        if expiry_month is not None:
            fields.append("expiry_month = %s")
            values.append(expiry_month)
        if expiry_year is not None:
            fields.append("expiry_year = %s")
            values.append(expiry_year)

        values.append(payment_id)
        cursor.execute(
            f"UPDATE payment_method SET {', '.join(fields)} WHERE payment_id = %s",
            tuple(values),
        )
        conn.commit()

        if cursor.rowcount == 0:
            return jsonify({"error": "Payment method not found"}), 404

        return jsonify({"message": "Payment method updated"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

# set default payment method
@payment_bp.route("/default/<int:payment_id>", methods=["PUT"])
def set_default_payment(payment_id):
    data = request.get_json() or {}
    client_id = data.get("client_id")
    if not client_id:
        return jsonify({"error": "client_id is required"}), 400

    conn = get_conn()
    cursor = conn.cursor()
    try:
        # Ensure method belongs to client
        cursor.execute(
            "SELECT payment_id FROM payment_method WHERE payment_id = %s AND client_id = %s",
            (payment_id, client_id),
        )
        if not cursor.fetchone():
            return jsonify({"error": "Payment method not found"}), 404

        cursor.execute(
            "UPDATE payment_method SET is_default = FALSE WHERE client_id = %s",
            (client_id,),
        )
        cursor.execute(
            "UPDATE payment_method SET is_default = TRUE WHERE payment_id = %s",
            (payment_id,),
        )
        conn.commit()
        return jsonify({"message": "Default payment method updated"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

#delete payment method
@payment_bp.route("/delete/<int:payment_id>", methods=["DELETE"])
def delete_payment(payment_id):
    conn = get_conn()
    cursor = conn.cursor()

    try: 
        # Find owner to ensure default is preserved after delete
        cursor.execute("SELECT client_id, is_default FROM payment_method WHERE payment_id = %s", (payment_id,))
        row = cursor.fetchone()
        if not row:
            return jsonify({"error": "Payment method not found"}), 404
        client_id, was_default = row[0], bool(row[1])

        cursor.execute("""
            DELETE FROM payment_method
            WHERE payment_id = %s
        """, (payment_id,))

        conn.commit()

        # If we deleted the default, promote the newest remaining method (if any).
        if was_default:
            cursor.execute(
                """
                SELECT payment_id FROM payment_method
                WHERE client_id = %s
                ORDER BY created_at DESC, payment_id DESC
                LIMIT 1
                """,
                (client_id,),
            )
            next_row = cursor.fetchone()
            if next_row:
                (next_payment_id,) = next_row
                cursor.execute(
                    "UPDATE payment_method SET is_default = TRUE WHERE payment_id = %s",
                    (next_payment_id,),
                )
                conn.commit()
        
        return jsonify({"message": "Deleted successfully"}), 200
    
    finally:
        cursor.close()
        conn.close()