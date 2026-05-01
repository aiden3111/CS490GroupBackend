import pytest
import os
os.environ["TESTING"] = "true"

from app import app

# ─── Fixture ────────────────────────────────────────────────────────────────
@pytest.fixture
def client():
    app.config["TESTING"] = True
    with app.test_client() as client:
        yield client

# ─── Home ────────────────────────────────────────────────────────────────────
def test_home(client):
    res = client.get("/")
    assert res.status_code == 200
    data = res.get_json()
    assert "message" in data

# ─── Login ───────────────────────────────────────────────────────────────────
def test_login_missing_fields(client):
    res = client.post("/api/login/", json={})
    assert res.status_code == 400

def test_login_wrong_credentials(client):
    res = client.post("/api/login/", json={
        "clientEmail": "fake@fake.com",
        "password": "wrongpassword"
    })
    assert res.status_code == 401

def test_login_success(client):
    res = client.post("/api/login/", json={
        "clientEmail": "frank.torres@fitapp.com",
        "password": "pass123"
    })
    assert res.status_code == 200
    data = res.get_json()
    assert "client_id" in data or "email" in data

def test_login_admin_success(client):
    res = client.post("/api/login/", json={
        "clientEmail": "alice.admin@fitapp.com",
        "password": "adminpass"
    })
    assert res.status_code == 200
    data = res.get_json()
    assert data.get("role") == "admin"

# ─── Register ────────────────────────────────────────────────────────────────
def test_register_missing_fields(client):
    res = client.post("/api/register/", json={})
    assert res.status_code == 400

def test_register_duplicate_email(client):
    res = client.post("/api/register/", json={
        "email": "frank.torres@fitapp.com",
        "password": "pass123",
        "first_name": "Frank",
        "last_name": "Torres",
        "dob": "2001-05-12",
        "gender": "Male"
    })
    assert res.status_code == 409 or res.status_code == 400

# ─── Clients ─────────────────────────────────────────────────────────────────
def test_get_all_clients(client):
    res = client.get("/api/clients/")
    assert res.status_code == 200

def test_get_client_by_id(client):
    res = client.get("/api/clients/cl001")
    assert res.status_code == 200
    data = res.get_json()
    assert data.get("client_id") == "cl001"

def test_get_client_not_found(client):
    res = client.get("/api/clients/nonexistent999")
    assert res.status_code == 404

def test_get_clients_by_coach(client):
    res = client.get("/api/clients/coach/cl017")
    assert res.status_code == 200

def test_update_client(client):
    res = client.put("/api/clients/cl001", json={
        "first_name": "Frank",
        "last_name": "Torres",
        "phone_number": "9735551001",
        "email": "frank.torres@fitapp.com"
    })
    assert res.status_code == 200

# ─── Landing Page ─────────────────────────────────────────────────────────────
def test_landing_page(client):
    res = client.get("/api/landing_page/cl001")
    assert res.status_code == 200
    data = res.get_json()
    assert "top_coaches" in data
    assert "trackers" in data

# ─── Coach Search ─────────────────────────────────────────────────────────────
def test_search_all_coaches(client):
    res = client.get("/api/coaches_search/")
    assert res.status_code == 200
    data = res.get_json()
    assert isinstance(data, list)

def test_search_coaches_by_name(client):
    res = client.get("/api/coaches_search/?search=Daniel")
    assert res.status_code == 200

def test_search_coaches_by_price(client):
    res = client.get("/api/coaches_search/?min_price=80&max_price=100")
    assert res.status_code == 200

def test_search_coaches_by_availability(client):
    res = client.get("/api/coaches_search/?availability=Mon")
    assert res.status_code == 200

def test_search_coaches_sort_price_asc(client):
    res = client.get("/api/coaches_search/?sort=price_asc")
    assert res.status_code == 200

# ─── Coach Landing Page ───────────────────────────────────────────────────────
def test_get_coach_profile(client):
    res = client.get("/api/coach/cl017")
    assert res.status_code == 200
    data = res.get_json()
    assert "coach_id" in data

def test_get_coach_not_found(client):
    res = client.get("/api/coach/nonexistent999")
    assert res.status_code == 404

def test_send_hire_request_missing_client(client):
    res = client.post("/api/coach/cl017/request", json={})
    assert res.status_code == 400

def test_send_hire_request_success(client):
    res = client.post("/api/coach/cl020/request", json={
        "client_id": "cl003",
        "payment_id": 1
    })

    assert res.status_code in [201, 400, 409]

# ─── My Coach ─────────────────────────────────────────────────────────────────
def test_get_my_coach(client):
    res = client.get("/api/my_coach/cl001")
    assert res.status_code == 200

def test_get_my_coach_no_coach(client):
    # cl017 is a coach, coaches don't have coaches
    res = client.get("/api/my_coach/cl017")
    assert res.status_code in [200, 404]

# ─── Coach Requests ──────────────────────────────────────────────────────────
def test_get_coach_requests(client):
    res = client.get("/api/coach/cl017/requests")
    assert res.status_code == 200

# ─── Coach Applications ───────────────────────────────────────────────────────
def test_get_all_coach_applications(client):
    res = client.get("/api/coach_applications/")
    assert res.status_code == 200

def test_apply_missing_client_id(client):
    res = client.post("/api/coach_applications/apply", json={})
    assert res.status_code == 400

def test_apply_already_coach(client):
    res = client.post("/api/coach_applications/apply", json={
        "client_id": "cl017",
        "specialty": "fitness",
        "certifications": "NASM",
        "bio": "Test bio",
        "pricing": 99.99
    })
    assert res.status_code == 400

# ─── Exercises ────────────────────────────────────────────────────────────────
def test_get_all_exercises(client):
    res = client.get("/api/exercises/")
    assert res.status_code == 200
    data = res.get_json()
    assert isinstance(data, list)

def test_get_exercise_by_id(client):
    res = client.get("/api/exercises/1")
    assert res.status_code == 200

def test_get_exercise_not_found(client):
    res = client.get("/api/exercises/99999")
    assert res.status_code == 404

def test_create_exercise_missing_fields(client):
    res = client.post("/api/exercises/", json={})
    assert res.status_code == 400

# ─── My Exercises ─────────────────────────────────────────────────────────────
def test_get_my_exercises(client):
    res = client.get("/api/my_exercises/")
    assert res.status_code == 200

# ─── Workout Plans ────────────────────────────────────────────────────────────
def test_get_client_workout_plans(client):
    res = client.get("/api/workoutPlansPage/client/cl001")
    assert res.status_code == 200
    data = res.get_json()
    assert "workout_plans" in data

def test_get_workout_plan_by_id(client):
    res = client.get("/api/workoutPlansPage/1")
    assert res.status_code == 200

def test_get_workout_plan_not_found(client):
    res = client.get("/api/workoutPlansPage/99999")
    assert res.status_code == 404

def test_create_workout_plan_missing_fields(client):
    res = client.post("/api/workoutPlansPage/", json={})
    assert res.status_code == 400

def test_create_workout_plan_success(client):
    res = client.post("/api/workoutPlansPage/", json={
        "client_id": "cl001",
        "created_by": "cl001",
        "frequency": "3x/week",
        "difficulty": "Beginner",
        "is_draft": 1
    })
    assert res.status_code == 201

# ─── Workout Log ─────────────────────────────────────────────────────────────
def test_get_workout_history(client):
    res = client.get("/api/workoutLogPage/history/cl001")
    assert res.status_code == 200
    data = res.get_json()
    assert "workout_history" in data

def test_log_workout_missing_fields(client):
    res = client.post("/api/workoutLogPage", json={})
    assert res.status_code == 400

def test_log_workout_success(client):
    res = client.post("/api/workoutLogPage", json={
        "client_id": "cl001",
        "log_date": "2026-04-30",
        "exercise_id": 1,
        "sets": 3,
        "reps": 10,
        "weight": 135
    })
    assert res.status_code == 200

# ─── Mood ────────────────────────────────────────────────────────────────────
def test_get_mood_logs(client):
    res = client.get("/api/mood/cl001")
    assert res.status_code == 200
    data = res.get_json()
    assert isinstance(data, list)

def test_get_mood_no_data(client):
    res = client.get("/api/mood/cl999")
    assert res.status_code == 200
    data = res.get_json()
    assert data == []

def test_log_mood_success(client):
    res = client.post("/api/mood/", json={
        "client_id": "cl001",
        "mood_score": 4,
        "mood_label": "Good",
        "notes": "Feeling great"
    })
    assert res.status_code == 201

# ─── Calorie Graph ───────────────────────────────────────────────────────────
def test_get_calorie_graph(client):
    res = client.get("/api/calorie_graph/cl001")
    assert res.status_code == 200

# ─── Steps Graph ─────────────────────────────────────────────────────────────
def test_get_steps_graph(client):
    res = client.get("/api/steps_graph/cl001")
    assert res.status_code == 200

# ─── Logging ─────────────────────────────────────────────────────────────────
def test_log_steps_success(client):
    res = client.post("/api/logging/", json={
        "client_id": "cl001",
        "log_date": "2026-04-30",
        "steps": 8000,
        "calories": 2200
    })
    assert res.status_code in [200, 201]

# ─── Nutrition Plan ──────────────────────────────────────────────────────────
def test_get_nutrition_plan(client):
    res = client.get("/api/nutrition_plan/cl001")
    assert res.status_code == 200

def test_get_nutrition_plan_meals(client):
    res = client.get("/api/nutrition_plan/cl001/1")
    assert res.status_code in [200, 404]

def test_log_meal_missing_fields(client):
    res = client.post("/api/nutrition_plan/log", json={})
    assert res.status_code in [400, 500]

# ─── Messaging ───────────────────────────────────────────────────────────────
def test_get_messages(client):
    res = client.get("/api/messaging/cl001/cl017")
    assert res.status_code == 200
    data = res.get_json()
    assert isinstance(data, list)

def test_get_conversations(client):
    res = client.get("/api/messaging/conversations/cl001")
    assert res.status_code == 200
    data = res.get_json()
    assert isinstance(data, list)

def test_get_conversations_no_messages(client):
    res = client.get("/api/messaging/conversations/cl999")
    assert res.status_code == 200

# ─── Profile ─────────────────────────────────────────────────────────────────
def test_get_goals(client):
    res = client.get("/api/profile/goals/cl001")
    assert res.status_code == 200

def test_get_coach_profile(client):
    res = client.get("/api/profile/coach/cl017")
    assert res.status_code == 200

def test_get_fitness_coach_profile(client):
    res = client.get("/api/profile/fitness_coach/cl017")
    assert res.status_code == 200

def test_get_nutrition_coach_profile(client):
    res = client.get("/api/profile/nutrition_coach/cl018")
    assert res.status_code == 200

# ─── Notifications ───────────────────────────────────────────────────────────
def test_get_notifications(client):
    res = client.get("/api/notifications/cl001")
    assert res.status_code == 200

def test_get_unread_count(client):
    res = client.get("/api/notifications/unread-count/cl001")
    assert res.status_code == 200

# ─── Notification Preferences ────────────────────────────────────────────────
def test_get_notification_preferences(client):
    res = client.get("/api/notification_preferences/cl001")
    assert res.status_code in [200, 404]

# ─── Coach Ratings ───────────────────────────────────────────────────────────
def test_rate_coach_missing_fields(client):
    res = client.post("/api/coach_ratings/cl017/rate", json={})
    assert res.status_code == 400

def test_rate_coach_success(client):
    res = client.post("/api/coach_ratings/cl017/rate", json={
        "client_id": "cl001",
        "rating": 5,
        "comment": "Great coach!"
    })
    assert res.status_code in [200, 201, 400]

# ─── Reviews ─────────────────────────────────────────────────────────────────
def test_get_reviews(client):
    res = client.get("/api/review/coach/cl017")
    assert res.status_code == 200

# ─── Reports ─────────────────────────────────────────────────────────────────
def test_submit_report_missing_fields(client):
    res = client.post("/api/reports/", json={})
    assert res.status_code == 400

def test_submit_report_success(client):
    res = client.post("/api/reports/", json={
        "reporter_id": "cl001",
        "reported_user_id": "cl002",
        "reason": "Spam",
        "details": "Sending repeated off-topic messages"
    })
    assert res.status_code in [200, 201]

# ─── Admin ───────────────────────────────────────────────────────────────────
def test_admin_get_all_accounts(client):
    res = client.get("/api/admin/accounts")
    assert res.status_code == 200
    data = res.get_json()
    assert "clients" in data

def test_admin_get_active_accounts(client):
    res = client.get("/api/admin/accounts/active")
    assert res.status_code == 200

def test_admin_get_disabled_accounts(client):
    res = client.get("/api/admin/accounts/disabled")
    assert res.status_code == 200

def test_admin_get_new_accounts(client):
    res = client.get("/api/admin/accounts/new")
    assert res.status_code == 200

def test_admin_search_accounts(client):
    res = client.get("/api/admin/accounts?q=frank")
    assert res.status_code == 200

def test_admin_get_stats(client):
    res = client.get("/api/admin/stats")
    assert res.status_code == 200
    data = res.get_json()
    assert "total_users" in data
    assert "active_users" in data

def test_admin_active_users_week(client):
    res = client.get("/api/admin/active_users?period=week")
    assert res.status_code == 200
    data = res.get_json()
    assert "total_active_users" in data

def test_admin_active_users_month(client):
    res = client.get("/api/admin/active_users?period=month")
    assert res.status_code == 200

def test_admin_get_reports(client):
    res = client.get("/api/admin/reports")
    assert res.status_code == 200
    data = res.get_json()
    assert "reports" in data

def test_admin_get_single_report(client):
    res = client.get("/api/admin/reports/1")
    assert res.status_code in [200, 404]

def test_admin_disable_user_missing_fields(client):
    res = client.patch("/api/admin/disable_user", json={})
    assert res.status_code == 400

def test_admin_disable_user_success(client):
    res = client.patch("/api/admin/disable_user", json={
        "admin_id": 1,
        "client_id": "cl016"
    })
    assert res.status_code == 200

def test_admin_reactivate_user_success(client):
    res = client.patch("/api/admin/reactivate_user", json={
        "admin_id": 1,
        "client_id": "cl016"
    })
    assert res.status_code == 200

def test_admin_check_status(client):
    res = client.get("/api/admin/check_status/cl001")
    assert res.status_code == 200

# ─── Survey ──────────────────────────────────────────────────────────────────
def test_submit_survey_missing_fields(client):
    res = client.post("/api/surveys/", json={})
    assert res.status_code == 400

# ─── Invoice ─────────────────────────────────────────────────────────────────
def test_get_invoices(client):
    res = client.get("/api/invoice/cl001")
    assert res.status_code == 200

# ─── Payment ─────────────────────────────────────────────────────────────────
def test_get_payment_methods(client):
    res = client.get("/api/payment/client/cl001")
    assert res.status_code == 200

def test_add_payment_missing_fields(client):
    res = client.post("/api/payment/add", json={})
    assert res.status_code == 400

# ─── Coach Progress ──────────────────────────────────────────────────────────
def test_get_client_progress(client):
    res = client.get("/api/coach/client_progress/cl001")
    assert res.status_code == 200
