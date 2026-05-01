from flask import Blueprint, request, jsonify
from db import get_conn

exercises_bp = Blueprint("exercises", __name__)


# Get all exercises
@exercises_bp.route("/", methods=["GET"])
def get_exercises():
    """
    Get all exercises with optional search filtering.
    ---
    tags:
      - Exercises
    parameters:
      - name: search
        in: query
        type: string
        description: Search term to filter exercises by name, muscle group, category, or equipment
    responses:
      200:
        description: List of exercises
        schema:
          type: array
          items:
            type: object
            properties:
              exercise_id:
                type: integer
              exercise_name:
                type: string
              equipment:
                type: string
              muscle_group:
                type: string
              category:
                type: string
              example_video:
                type: string
              is_custom:
                type: boolean
              created_by:
                type: string
      500:
        description: Server error
    """

    search_term = request.args.get("search")
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        if search_term: 
            query = """
                SELECT
                    exercise_id,
                    exercise_name,
                    equipment,
                    muscle_group,
                    category,
                    example_video,
                    is_custom,
                    created_by
                FROM exercises
                WHERE exercise_name LIKE %s 
                    OR muscle_group LIKE %s
                    OR category LIKE %s
                    OR equipment LIKE %s
                ORDER BY exercise_name ASC
            """
            cursor.execute(query, (f"%{search_term}%", f"%{search_term}%", f"%{search_term}%", f"%{search_term}%")) 
            # added "WHERE exercise_name LIKE %s and such" to the query and passed the search term as a parameter -- Aiden
        else: 
            cursor.execute("SELECT * FROM exercises ORDER BY exercise_name ASC")

        exercises = cursor.fetchall()
        return jsonify(exercises), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# Get one exercise by id
@exercises_bp.route("/<int:exercise_id>", methods=["GET"])
def get_exercise(exercise_id):
    """
    Get a single exercise by ID.
    ---
    tags:
      - Exercises
    parameters:
      - name: exercise_id
        in: path
        required: true
        type: integer
        description: The exercise ID
    responses:
      200:
        description: Exercise data
        schema:
          type: object
          properties:
            exercise_id:
              type: integer
            exercise_name:
              type: string
            equipment:
              type: string
            muscle_group:
              type: string
            category:
              type: string
            example_video:
              type: string
            is_custom:
              type: boolean
            created_by:
              type: string
      404:
        description: Exercise not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT
                exercise_id,
                exercise_name,
                equipment,
                muscle_group,
                category,
                example_video,
                is_custom,
                created_by
            FROM exercises
            WHERE exercise_id = %s
        """, (exercise_id,))
        exercise = cursor.fetchone()

        if not exercise:
            return jsonify({"error": "Exercise not found"}), 404

        return jsonify(exercise), 200

    except Exception as e:
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# Create a new exercise
@exercises_bp.route("/", methods=["POST"])
def create_exercise():
    """
    Create a new exercise.
    ---
    tags:
      - Exercises
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - exercise_name
          properties:
            exercise_name:
              type: string
              example: Push-ups
            equipment:
              type: string
              example: Bodyweight
            muscle_group:
              type: string
              example: Chest
            category:
              type: string
              example: Strength
            example_video:
              type: string
              example: https://example.com/video
            is_custom:
              type: boolean
              default: true
            created_by:
              type: string
              description: Client ID of the creator
    responses:
      201:
        description: Exercise created successfully
        schema:
          type: object
          properties:
            message:
              type: string
            exercise_id:
              type: integer
      400:
        description: Request body required or exercise_name missing
      500:
        description: Server error
    """
    data = request.get_json()

    if not data:
        return jsonify({"error": "Request body is required"}), 400

    exercise_name = data.get("exercise_name")
    equipment = data.get("equipment")
    muscle_group = data.get("muscle_group")
    category = data.get("category")
    example_video = data.get("example_video")
    is_custom = data.get("is_custom", 1)
    created_by = data.get("created_by")

    if not exercise_name:
        return jsonify({"error": "exercise_name is required"}), 400

    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            INSERT INTO exercises (
                exercise_name,
                equipment,
                muscle_group,
                category,
                example_video,
                is_custom,
                created_by
            )
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            exercise_name,
            equipment,
            muscle_group,
            category,
            example_video,
            is_custom,
            created_by
        ))

        conn.commit()

        return jsonify({
            "message": "Exercise created successfully",
            "exercise_id": cursor.lastrowid
        }), 201

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()


# Update an exercise
@exercises_bp.route("/<int:exercise_id>", methods=["PUT"])
def update_exercise(exercise_id):
    """
    Update an existing exercise.
    ---
    tags:
      - Exercises
    parameters:
      - name: exercise_id
        in: path
        required: true
        type: integer
        description: The exercise ID
      - in: body
        name: body
        required: true
        schema:
          type: object
          properties:
            exercise_name:
              type: string
            equipment:
              type: string
            muscle_group:
              type: string
            category:
              type: string
            example_video:
              type: string
            created_by:
              type: string
              description: Client ID of the creator
    responses:
      200:
        description: Exercise updated successfully
      500:
        description: Server error
    """
    data = request.get_json()
    
  
    exercise_name = data.get("exercise_name")
    equipment= data.get("equipment")
    muscle_group = data.get("muscle_group")
    category = data.get("category")
    example_video = data.get("example_video")
    client_id = data.get("created_by") # fixed here because the exercise table has a "created_by" column that references the client_id of the user who created the exercise BUT NO client_id -- Aiden

    conn = get_conn()
    cursor = conn.cursor()

    try:
        query = """
            UPDATE exercises 
            SET exercise_name=%s, equipment=%s, muscle_group=%s, 
                category=%s, example_video=%s, created_by=%s
            WHERE exercise_id=%s
        """
       
        cursor.execute(query, (exercise_name, equipment, muscle_group, category, example_video, client_id, exercise_id))
        conn.commit()
        return jsonify({"message": "Updated"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
   
    finally:
        cursor.close()
        conn.close()


# Delete an exercise
@exercises_bp.route("/<int:exercise_id>", methods=["DELETE"])
def delete_exercise(exercise_id):
    """
    Delete an exercise by ID.
    ---
    tags:
      - Exercises
    parameters:
      - name: exercise_id
        in: path
        required: true
        type: integer
        description: The exercise ID
    responses:
      200:
        description: Exercise deleted successfully
      404:
        description: Exercise not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)

    try:
        cursor.execute("""
            SELECT exercise_id
            FROM exercises
            WHERE exercise_id = %s
        """, (exercise_id,))
        exercise = cursor.fetchone()

        if not exercise:
            return jsonify({"error": "Exercise not found"}), 404

        cursor.execute("""
            DELETE FROM exercises
            WHERE exercise_id = %s
        """, (exercise_id,))

        conn.commit()
        return jsonify({"message": "Exercise deleted successfully"}), 200

    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500

    finally:
        cursor.close()
        conn.close()