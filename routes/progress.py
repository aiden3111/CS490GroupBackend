from flask import Blueprint, request, jsonify
from db import get_conn
import os 
import urllib.parse




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
    
    if not os.path.exists(UPLOAD_FOLDER):
        os.makedirs(UPLOAD_FOLDER)
    
    filename = f"{client_id}_{photo_type}_{file.filename}"
    filepath = os.path.join(UPLOAD_FOLDER, filename)

    file.save(filepath)

    conn = get_conn()
    cursor = conn.cursor()

    try:
        cursor.execute("""
            INSERT INTO progress_photos (client_id, photo_type, image_url)
            VALUES (%s, %s, %s)
        """, (client_id, photo_type, filename))

        conn.commit()
        return jsonify({"message": "Photo uploaded"}), 201
    except Exception as e:
        
        return jsonify({"deu erro aqui o": str(e)}), 500
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
            SELECT photo_type, image_url
            FROM progress_photos
            WHERE client_id = %s
        """, (client_id,))

        photos = cursor.fetchall()
        return jsonify(photos), 200
    
    except Exception as e:
        
        print(f"Erro no GET photos: {e}")
        return jsonify({"error_real": str(e)}), 500
    
    finally:
        if cursor: cursor.close()
        if conn: conn.close()


@progress_bp.route("/delete/<path:filename>", methods=["DELETE"])
def delete_photo(filename):

    decoded_filename = urllib.parse.unquote(filename)
    filepath = os.path.join(UPLOAD_FOLDER, decoded_filename)

   
    if os.path.exists(filepath):
        os.remove(filepath)

    conn = get_conn()
    cursor = conn.cursor()
    try:
       
        cursor.execute("DELETE FROM progress_photos WHERE image_url LIKE %s", (f"%{decoded_filename}%",))
        conn.commit()
        return jsonify({"message": "Photo deleted successfully"}), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()
