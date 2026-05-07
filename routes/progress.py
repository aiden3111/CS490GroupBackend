from flask import Blueprint, request, jsonify
from db import get_conn
import os 


progress_bp = Blueprint("progress", __name__)

UPLOAD_FOLDER = "uploads"
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@progress_bp.route("/upload", methods=["POST"])
def upload_photo():
    client_id = request.form.get("client_id")
    photo_type = request.form.get("photo_type") #before/after
    file = request.files.get("image")

    if not all([client_id, photo_type, file]):
        return jsonify({"error": "Missing fields"}), 400
    
    filename = f"{client_id}_{photo_type}_{file.filename}"
    filepath = os.path.join(UPLOAD_FOLDER, filename)

    file.save(filepath)

    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            INSERT INTO progress_photos (client_id, photo_type, image_url)
            VALUES (%s, %s, %s)
        """, (client_id, photo_type, filepath))

        conn.commit()
        return jsonify({"message": "Photo uploaded"}), 201
    except Exception as e:
        
        return jsonify({"deu erro aqui o": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@progress_bp.route("/<string:client_id>", methods=["GET"])
def get_photos(client_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT photo_type, image_url, uploaded_at
            FROM progress_photos
            WHERE client_id = %s
        """, (client_id,))

        photos = cursor.fetchall()
        return jsonify(photos), 200
    
    finally:
        cursor.close()
        conn.close()


