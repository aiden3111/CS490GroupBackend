from flask import jsonify, request, Blueprint
from db import get_conn

nutrition_plan_bp = Blueprint("nutrition_plan", __name__)

@nutrition_plan_bp.route('/<string:client_id>', methods=['GET'])
def get_nutrition_plan(client_id):
    """
    Get all nutrition plans for a client.
    ---
    tags:
      - Nutrition
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
    responses:
      200:
        description: List of nutrition plans
        schema:
          type: array
          items:
            type: object
            properties:
              nutrition_plan_id:
                type: string
              client_id:
                type: string
              category:
                type: string
              created_by:
                type: string
      500:
        description: Server error
    """
    client_id = request.view_args['client_id']
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM nutrition_plan WHERE client_id = %s", (client_id,))
    nutrition_plan = cursor.fetchall()
    conn.close()
    return jsonify(nutrition_plan)

@nutrition_plan_bp.route('/<string:client_id>/<string:nutrition_plan_id>', methods=['GET'])
def get_nutrition_plan_by_id(client_id, nutrition_plan_id):
    """
    Get all meals for a specific nutrition plan.
    ---
    tags:
      - Nutrition
    parameters:
      - name: client_id
        in: path
        required: true
        type: string
        description: Client ID
      - name: nutrition_plan_id
        in: path
        required: true
        type: string
        description: Nutrition plan ID
    responses:
      200:
        description: List of meals in the nutrition plan
        schema:
          type: array
          items:
            type: object
            properties:
              meal_id:
                type: integer
              nutrition_plan_id:
                type: string
              meal_name:
                type: string
              calories:
                type: number
              time_of_day:
                type: string
                format: time
      404:
        description: Meals not found
      500:
        description: Server error
    """
    client_id = request.view_args['client_id']
    nutrition_plan_id = request.view_args['nutrition_plan_id']
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    query = '''
            SELECT 
                meal_id, 
                nutrition_plan_id, 
                meal_name, 
                calories, 
                TIME_FORMAT(time_of_day, "%H:%i") as time_of_day 
            FROM meals 
            WHERE nutrition_plan_id = %s
            ORDER BY time_of_day ASC
            '''
    cursor.execute(query, (nutrition_plan_id,))
    meals = cursor.fetchall()
    cursor.close()
    conn.close()
   
    if meals:
        return jsonify(meals)
    else:
        return jsonify({"error": "Meals not found"}), 404

@nutrition_plan_bp.route('/log', methods=['POST'])
def log_meal_entry():
    """
    Log a meal entry for a client.
    ---
    tags:
      - Nutrition
    parameters:
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - client_id
            - meal_id
          properties:
            client_id:
              type: string
              description: Client ID
            meal_id:
              type: integer
              description: Meal ID from nutrition plan
            calories:
              type: number
              description: Actual calories consumed
            notes:
              type: string
              description: Optional notes
    responses:
      201:
        description: Meal logged successfully
        schema:
          type: object
          properties:
            message:
              type: string
            meal_id:
              type: integer
      500:
        description: Server error
    """
    data = request.get_json()
    client_id = data.get('client_id')
    meal_id = data.get('meal_id')
    
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    
    try:
        log_query = '''
            INSERT INTO meal_log (client_id, meal_id, log_date, actual_calories, notes)
            VALUES (%s, %s, CURDATE(), %s, %s)
        '''
        cursor.execute(log_query, (
            client_id,
            meal_id,
            data.get('calories'),
            data.get('notes')
        ))

        conn.commit()
        return jsonify({"message": "Meal recorded in library and logged!", "meal_id": meal_id}), 201

    except Exception as e:
        conn.rollback()
        print(f"Server Error: {e}")
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()


from datetime import date

@nutrition_plan_bp.route('/log/<int:meal_log_id>', methods=['DELETE', 'PUT'])
def modify_meal_log(meal_log_id):
    """
    Modify a meal log entry (delete or update). Only today's entries can be modified.
    ---
    tags:
      - Nutrition
    parameters:
      - name: meal_log_id
        in: path
        required: true
        type: integer
        description: Meal log entry ID
      - in: body
        name: body
        description: Required for PUT requests
        schema:
          type: object
          properties:
            calories:
              type: number
              description: Updated calories
            notes:
              type: string
              description: Updated notes
    responses:
      200:
        description: Meal log modified successfully
      403:
        description: Cannot modify logs from previous dates
      404:
        description: Log entry not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    
    try:
        cursor.execute("SELECT log_date FROM meal_log WHERE meal_log_id = %s", (meal_log_id,))
        record = cursor.fetchone()
        
        if not record:
            return jsonify({"error": "Log entry not found"}), 404
            
        today_str = date.today().isoformat()
        if str(record['log_date']) != today_str:
            return jsonify({"error": "Cannot edit or delete logs from previous dates."}), 403

        if request.method == 'DELETE':
            cursor.execute("DELETE FROM meal_log WHERE meal_log_id = %s", (meal_log_id,))
            conn.commit()
            return jsonify({"message": "Log entry deleted successfully"}), 200

        elif request.method == 'PUT':
            data = request.get_json()
            actual_calories = data.get('calories')
            notes = data.get('notes')

            cursor.execute('''
                UPDATE meal_log 
                SET actual_calories = %s, notes = %s 
                WHERE meal_log_id = %s
            ''', (actual_calories, notes, meal_log_id))
            
            conn.commit()
            return jsonify({"message": "Log entry updated successfully"}), 200

    except Exception as e:
        if conn:
            conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        if cursor:
            cursor.close()
        if conn:
            conn.close()