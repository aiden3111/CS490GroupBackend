from flask import Blueprint, request, jsonify
from db import get_conn
import os 
import urllib.parse




progress_bp = Blueprint("progress", __name__)

UPLOAD_FOLDER = "uploads"
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

@progress_bp.route("/upload/<int:client_id>", methods=["POST"])
def upload_photo(client_id):
    
    data = request.json 
    photo_type = data.get("photo_type") # before/after
    image_url = data.get("image_url") 

    if not all([photo_type, image_url]):
        return jsonify({"error": "Missing fields"}), 400
    
    conn = get_conn()
    cursor = conn.cursor()

    try:
       
        cursor.execute("""
            INSERT INTO progress_photos (client_id, photo_type, image_url)
            VALUES (%s, %s, %s)
        """, (client_id, photo_type, image_url))

        conn.commit()
        return jsonify({"message": "Cloudinary URL saved permanently"}), 201
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


@progress_bp.route("/<string:client_id>", methods=["GET"])
def get_photos(client_id):
    conn = None
    cursor = None
    try:
        conn = get_conn() 
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("""
            SELECT photo_id, photo_type, image_url
            FROM progress_photos
            WHERE client_id = %s
        """, (client_id,))

        photos = cursor.fetchall()
        return jsonify(photos), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor: cursor.close()
        if conn: conn.close()


@progress_bp.route("/delete/<path:identifier>", methods=["DELETE"])
def delete_photo(identifier):
   
    decoded_id = urllib.parse.unquote(identifier)

    conn = get_conn()
    cursor = conn.cursor()
    try:

        cursor.execute("DELETE FROM progress_photos WHERE image_url = %s OR image_url LIKE %s", 
                       (decoded_id, f"%{decoded_id}%"))
        conn.commit()
        return jsonify({"message": "Photo record deleted"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()
