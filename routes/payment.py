from flask import Blueprint, request, jsonify
from db import get_conn

payment_bp = Blueprint("payment", __name__)

# payment method -- Aiden
@payment_bp.route("/add", methods=["POST"])
def add_payment():
    """
    Add a new payment method for a client.
    ---
    tags:
      - Payment
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
            - last4
          properties:
            client_id:
              type: string
              description: Client ID
            card_type:
              type: string
              example: Visa
            last4:
              type: string
              example: "1234"
              description: Last 4 digits of card
            expiry_month:
              type: integer
              minimum: 1
              maximum: 12
            expiry_year:
              type: integer
            is_default:
              type: boolean
              default: false
    responses:
      201:
        description: Payment method added successfully
        schema:
          type: object
          properties:
            message:
              type: string
            payment_id:
              type: integer
      400:
        description: Missing required fields or invalid data
      500:
        description: Server error
    """
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
    """
    Get all payment methods for a client.
    ---
    tags:
      - Payment
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
    responses:
      200:
        description: List of payment methods
        schema:
          type: array
          items:
            type: object
            properties:
              payment_id:
                type: integer
              client_id:
                type: string
              card_type:
                type: string
              last4:
                type: string
              expiry_month:
                type: integer
              expiry_year:
                type: integer
              is_default:
                type: boolean
              created_at:
                type: string
                format: date-time
      500:
        description: Server error
    """
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
    """
    Update an existing payment method.
    ---
    tags:
      - Payment
    parameters:
      - name: payment_id
        in: path
        required: true
        type: integer
        description: Payment method ID
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            card_type:
              type: string
            last4:
              type: string
              description: Last 4 digits (must be 4 digits)
            expiry_month:
              type: integer
              minimum: 1
              maximum: 12
            expiry_year:
              type: integer
    responses:
      200:
        description: Payment method updated successfully
      400:
        description: No fields to update or invalid data
      404:
        description: Payment method not found
      500:
        description: Server error
    """
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
    """
    Set a payment method as the default for a client.
    ---
    tags:
      - Payment
    parameters:
      - name: payment_id
        in: path
        required: true
        type: integer
        description: Payment method ID
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
          properties:
            client_id:
              type: string
              description: Client ID (must own the payment method)
    responses:
      200:
        description: Default payment method updated successfully
      400:
        description: client_id is required
      404:
        description: Payment method not found
      500:
        description: Server error
    """
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
    """
    Delete a payment method.
    ---
    tags:
      - Payment
    parameters:
      - name: payment_id
        in: path
        required: true
        type: integer
        description: Payment method ID
    responses:
      200:
        description: Payment method deleted successfully
      404:
        description: Payment method not found
      500:
        description: Server error
    """
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