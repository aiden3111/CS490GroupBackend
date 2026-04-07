from flask import Flask, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from routes.login import login_bp
from routes.google_login import google_login_bp
from routes.register import register_bp
from routes.profile import profile_bp   # add profile -- Aiden
from routes.clients import clients_bp 
from routes.survey import survey_bp 
from routes.exercises import exercises_bp
from routes.coach import coach_bp
from routes.coach_search import coach_search_bp
from routes.coach_landing_page import coach_landing_page_bp
from routes.coach_request import coach_request_bp
from routes.coach_applications import coach_applications_bp
from routes.landing_page import landing_page_bp 
from routes.my_coach import my_coach_bp 
from routes.mood import mood_bp 
from routes.calorie_graph import calorie_graph_bp
from routes.workoutPlans import workoutPlansPage
from routes.workoutPlanExercises import workoutPlanExercisesPage
from routes.workoutLogPage import workoutLogPage
from routes.steps_graph import steps_graph_bp
from routes.my_exercises import my_exercises_bp
from routes.logging import logging_bp
from routes.nutrition_plan import nutrition_plan_bp
from routes.nutrition_plan_modifications import nutrition_plan_modifications_bp
from routes.admin import admin_bp
load_dotenv()

app = Flask(__name__)
app.url_map.strict_slashes = False
CORS(app)

@app.route("/")
def home():
    return jsonify({
        "message": "Api running",

        "endpoints": ["/api/login/", "/api/google-login/", "/api/register/", "/api/profile", "/api/client", "/api/exercises", "/api/coach", "/api/coach_search",
                      "/api/coach/<int:coach_id>", "/api/coach/<int:coach_id>/requests", "/api/coach_applications/", "/api/workoutPlansPage/", "/api/workoutPlansExercisesPage", "/api/workoutLogPage/",  "/api/workoutLogPage/<log_id>",
                      "/api/workoutLogPage/history/<client_id>", "/api/nutrition_plan/<string:client_id>", "/api/nutrition_plan/<string:client_id>/<string:nutrition_plan_id>", "/api/nutrition_plan_modifications/<string:coach_id>/<string:client_id>/<string:nutrition_plan_id>", 
                      "/api/nutrition_plan_modifications/<string:coach_id>/<string:client_id>/<string:nutrition_plan_id>/meals", "/api/calorie_graph/<string:client_id>", "/api/steps_graph/<string:client_id>", "/api/my_exercises/<string:client_id>", "/api/admin/accounts", 
                      "/api/admin/accounts/<string:client_id>"]
            })



#blueprints for each of the routes, register to app
app.register_blueprint(login_bp, url_prefix="/api/login")
app.register_blueprint(google_login_bp, url_prefix="/api/google-login")
app.register_blueprint(register_bp, url_prefix="/api/register")
app.register_blueprint(profile_bp, url_prefix="/api/profile") # add profile to registers -- Aiden
app.register_blueprint(clients_bp, url_prefix="/api/clients")
app.register_blueprint(survey_bp, url_prefix="/api/surveys") # add surveys to registers 
app.register_blueprint(exercises_bp, url_prefix="/api/exercises")
app.register_blueprint(coach_bp, url_prefix="/api/coach")
app.register_blueprint(coach_search_bp, url_prefix="/api/coaches_search") 
app.register_blueprint(coach_landing_page_bp, url_prefix="/api/coach")
app.register_blueprint(coach_request_bp, url_prefix="/api/coach")
app.register_blueprint(coach_applications_bp, url_prefix="/api/coach_applications")
app.register_blueprint(landing_page_bp, url_prefix="/api/landing_page")
app.register_blueprint(my_coach_bp, url_prefix="/api/my_coach")
app.register_blueprint(mood_bp, url_prefix="/api/mood")
app.register_blueprint(calorie_graph_bp, url_prefix="/api/calorie_graph")
app.register_blueprint(workoutPlansPage, url_prefix="/api/workoutPlansPage")
app.register_blueprint(workoutPlanExercisesPage, url_prefix="/api/workoutPlanExercisesPage")
app.register_blueprint(workoutLogPage, url_prefix="/api/workoutLogPage")
app.register_blueprint(steps_graph_bp, url_prefix="/api/steps_graph")
app.register_blueprint(my_exercises_bp, url_prefix='/api/my_exercises')
app.register_blueprint(logging_bp, url_prefix="/api/logging")
app.register_blueprint(nutrition_plan_bp, url_prefix="/api/nutrition_plan")
app.register_blueprint(nutrition_plan_modifications_bp, url_prefix="/api/nutrition_plan_modifications")
app.register_blueprint(admin_bp, url_prefix="/api/admin")
if __name__ == "__main__":
        app.run(debug=True)
