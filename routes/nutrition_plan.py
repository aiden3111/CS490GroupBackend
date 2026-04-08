from flask import jsonify, request, Blueprint
from db import get_conn

nutrition_plan_bp = Blueprint("nutrition_plan", __name__)

@nutrition_plan_bp.route('/<string:client_id>', methods=['GET'])
def get_nutrition_plan(client_id):
    client_id = request.view_args['client_id']
    conn = get_conn()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM nutrition_plan WHERE client_id = %s", (client_id,))
    nutrition_plan = cursor.fetchall()
    conn.close()
    return jsonify(nutrition_plan)

@nutrition_plan_bp.route('/<string:client_id>/<string:nutrition_plan_id>', methods=['GET'])
def get_nutrition_plan_by_id(client_id, nutrition_plan_id):
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