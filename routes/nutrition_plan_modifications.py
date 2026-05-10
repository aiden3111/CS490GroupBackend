from flask import Blueprint, request, jsonify
from db import get_conn
from routes.notify import push_notification

nutrition_plan_modifications_bp = Blueprint("nutrition_plan_modifications", __name__)

#Let the coach view all their clients and their nutrition plans
@nutrition_plan_modifications_bp.route('/<string:coach_id>', methods=['GET'])
def get_clients_nutrition_plans(coach_id):
    """
    Get all nutrition plans created by a coach for their clients.
    ---
    tags:
      - Nutrition
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
        description: Coach ID
    responses:
      200:
        description: List of clients and their nutrition plans
        schema:
          type: array
          items:
            type: object
            properties:
              client_id:
                type: string
              first_name:
                type: string
              last_name:
                type: string
              nutrition_plan_id:
                type: string
              category:
                type: string
              created_by:
                type: string
      404:
        description: Coach not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        # Verify the coach exists
        cursor.execute("SELECT coach_id FROM nutrition_coach WHERE coach_id = %s", (coach_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Coach not found"}), 404

        query = '''
                SELECT c.client_id, c.first_name, c.last_name, np.nutrition_plan_id, np. category, np.created_by
                FROM client c
                JOIN nutrition_plan np ON c.client_id = np.client_id
                WHERE np.created_by = %s
            '''
        cursor.execute(query, (coach_id,))
        clients_nutrition_plans = cursor.fetchall()
        return jsonify(clients_nutrition_plans), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

#let the coach edit a specific nutrition plan for a specific client
@nutrition_plan_modifications_bp.route('/<string:coach_id>/<string:client_id>/<string:nutrition_plan_id>', methods=['PUT'])
def update_nutrition_plan(coach_id, client_id, nutrition_plan_id):
    """
    Update meals in a nutrition plan (coach only).
    ---
    tags:
      - Nutrition
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
        description: Coach ID (must own the plan)
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
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - meals
          properties:
            meals:
              type: array
              items:
                type: object
                properties:
                  meal_id:
                    type: integer
                  meal_name:
                    type: string
                  calories:
                    type: number
                  time_of_day:
                    type: string
                  description:
                    type: string
                  protein:
                    type: number
                  carbs:
                    type: number
                  fats:
                    type: number
                  day_number:
                    type: integer
    responses:
      200:
        description: Nutrition plan updated successfully
      403:
        description: Unauthorized (not the coach for this plan)
      500:
        description: Server error
    """
    data = request.get_json()
    meals = data.get('meals')
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        # Verify this coach owns the nutrition plan
        cursor.execute(
            "SELECT nutrition_plan_id FROM nutrition_plan WHERE nutrition_plan_id = %s AND client_id = %s AND created_by = %s",
            (nutrition_plan_id, client_id, coach_id)
        )
        if not cursor.fetchone():
            return jsonify({"error": "Unauthorized: you are not the coach for this nutrition plan"}), 403

        cursor.close()
        cursor = conn.cursor()
        for meal in meals:
            query = '''
                    UPDATE meals
                    SET meal_name = %s, calories = %s, time_of_day = %s, description = %s, protein = %s, carbs = %s, fats = %s, day_number = %s
                    WHERE nutrition_plan_id = %s AND meal_id = %s
                '''
            cursor.execute(query, (meal['meal_name'], meal['calories'], meal['time_of_day'], meal['description'], meal['protein'], meal['carbs'], meal['fats'], meal['day_number'], nutrition_plan_id, meal['meal_id']))

        # Notify the client that their nutrition plan was updated
        push_notification(
            cursor,
            client_id,
            "nutrition",
            "Meal Plan Updated",
            "Your nutrition plan has been updated by your coach.",
            send_email=True,
        )

        conn.commit()
        return jsonify({"message": "Nutrition plan updated successfully"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

#let the coach create meals for a client
@nutrition_plan_modifications_bp.route('/<string:coach_id>/<string:client_id>/<string:nutrition_plan_id>/meals', methods=['POST'])
def add_meals_to_nutrition_plan(coach_id, client_id, nutrition_plan_id):
    """
    Add meals to a nutrition plan (coach only).
    ---
    tags:
      - Nutrition
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
        description: Coach ID (must own the plan)
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
      - in: body
        name: body
        required: true
        schema:
          type: object
          required:
            - meals
          properties:
            meals:
              type: array
              items:
                type: object
                properties:
                  meal_name:
                    type: string
                  calories:
                    type: number
                  time_of_day:
                    type: string
                  description:
                    type: string
                  protein:
                    type: number
                  carbs:
                    type: number
                  fats:
                    type: number
                  day_number:
                    type: integer
    responses:
      201:
        description: Meals added successfully
      403:
        description: Unauthorized (not the coach for this plan)
      500:
        description: Server error
    """
    data = request.get_json()
    meals = data.get('meals')
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        # Verify this coach owns the nutrition plan
        cursor.execute(
            "SELECT nutrition_plan_id, category FROM nutrition_plan WHERE nutrition_plan_id = %s AND client_id = %s AND created_by = %s",
            (nutrition_plan_id, client_id, coach_id)
        )
        if not cursor.fetchone():
            return jsonify({"error": "Unauthorized"}), 403

        cursor.close()
        cursor = conn.cursor()
        for meal in meals:
            query = '''
                    INSERT INTO meals (meal_name, calories, time_of_day, description, protein, carbs, fats, day_number, nutrition_plan_id)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
                '''
            cursor.execute(query, (meal['meal_name'], meal['calories'], meal['time_of_day'], meal['description'], meal['protein'], meal['carbs'], meal['fats'], meal['day_number'], nutrition_plan_id))
        conn.commit()
        return jsonify({"message": "Meals added to nutrition plan successfully"}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

#let the coach delete a meal from a nutrition plan
@nutrition_plan_modifications_bp.route('/<string:coach_id>/<string:client_id>/<string:nutrition_plan_id>/meals/<string:meal_id>', methods=['DELETE'])
def delete_meal_from_nutrition_plan(coach_id, client_id, nutrition_plan_id, meal_id):
    """
    Delete a meal from a nutrition plan (coach only).
    ---
    tags:
      - Nutrition
    parameters:
      - name: coach_id
        in: path
        required: true
        type: string
        description: Coach ID (must own the plan)
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
      - name: meal_id
        in: path
        required: true
        type: string
        description: Meal ID
    responses:
      200:
        description: Meal deleted successfully
      403:
        description: Unauthorized (not the coach for this plan)
      404:
        description: Meal not found
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        # Verify this coach owns the nutrition plan
        cursor.execute(
            "SELECT nutrition_plan_id FROM nutrition_plan WHERE nutrition_plan_id = %s AND client_id = %s AND created_by = %s",
            (nutrition_plan_id, client_id, coach_id)
        )
        if not cursor.fetchone():
            return jsonify({"error": "Unauthorized"}), 403

        cursor.close()
        cursor = conn.cursor()
        query = '''
                DELETE FROM meals
                WHERE nutrition_plan_id = %s AND meal_id = %s
            '''
        cursor.execute(query, (nutrition_plan_id, meal_id))
        if cursor.rowcount == 0:
            return jsonify({"error": "Meal not found"}), 404
        conn.commit()
        return jsonify({"message": "Meal deleted from nutrition plan successfully"}), 200
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()

#Assign/create the meal plan
@nutrition_plan_modifications_bp.route('/create_plan', methods=['POST'])
def create_nutrition_plan_header():
    """
    Create a new nutrition plan header for a client.
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
            - coach_id
            - plan_name
          properties:
            client_id:
              type: string
              description: Client ID
            coach_id:
              type: string
              description: Coach ID creating the plan
            plan_name:
              type: string
              description: Name/category of the nutrition plan
    responses:
      201:
        description: Nutrition plan created successfully
        schema:
          type: object
          properties:
            message:
              type: string
            nutrition_plan_id:
              type: string
      500:
        description: Server error
    """
    data = request.get_json()
    
    client_id = data.get('client_id')
    coach_id = data.get('coach_id')
    category = data.get('plan_name')

    conn = get_conn()
    cursor = conn.cursor()
    try:
        query = '''
            INSERT INTO nutrition_plan (client_id, category, created_by)
            VALUES (%s, %s, %s)
        '''
        cursor.execute(query, (client_id, category, coach_id))
        new_plan_id = cursor.lastrowid

        # Notify client that a new nutrition plan was created for them
        cursor2 = conn.cursor(dictionary=True)
        cursor2.execute("SELECT first_name, last_name FROM client WHERE client_id = %s", (coach_id,))
        coach_row = cursor2.fetchone()
        cursor2.close()
        coach_name = f"{coach_row['first_name']} {coach_row['last_name']}" if coach_row else "Your coach"
        push_notification(
            cursor,
            client_id,
            "nutrition",
            "New Meal Plan",
            f"{coach_name} created a new nutrition plan for you.",
            send_email=True,
        )

        conn.commit()
        return jsonify({"message": "Plan created", "nutrition_plan_id": new_plan_id}), 201
    except Exception as e:
        conn.rollback()
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()



@nutrition_plan_modifications_bp.route('/meals/<int:nutrition_plan_id>', methods=['GET'])
def get_meals_for_plan(nutrition_plan_id):
    """
    Get all meals for a specific nutrition plan.
    ---
    tags:
      - Nutrition
    parameters:
      - name: nutrition_plan_id
        in: path
        required: true
        type: integer
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
              meal_name:
                type: string
              calories:
                type: number
              time_of_day:
                type: string
              description:
                type: string
              protein:
                type: number
              carbs:
                type: number
              fats:
                type: number
              day_number:
                type: integer
              nutrition_plan_id:
                type: integer
      500:
        description: Server error
    """
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        query = "SELECT * FROM meals WHERE nutrition_plan_id = %s"
        cursor.execute(query, (nutrition_plan_id,))
        meals = cursor.fetchall()


        for meal in meals:
            if 'time_of_day' in meal and meal['time_of_day'] is not None:
            
                meal['time_of_day'] = str(meal['time_of_day'])

        return jsonify(meals), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500
    finally:
        cursor.close()
        conn.close()
