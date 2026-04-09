from flask import Blueprint, request, jsonify
from db import get_conn

nutrition_plan_modifications_bp = Blueprint("nutrition_plan_modifications", __name__)

#Let the coach view all their clients and their nutrition plans
@nutrition_plan_modifications_bp.route('/<string:coach_id>', methods=['GET'])
def get_clients_nutrition_plans(coach_id):
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    try:
        # Verify the coach exists
        cursor.execute("SELECT coach_id FROM nutrition_coach WHERE coach_id = %s", (coach_id,))
        if not cursor.fetchone():
            return jsonify({"error": "Coach not found"}), 404

        query = '''
                SELECT c.client_id, c.first_name, c.last_name, np.nutrition_plan_id, np.created_by
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