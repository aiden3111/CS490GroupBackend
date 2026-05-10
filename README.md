# BitFit Backend

Flask backend for the BitFit fitness coaching app.

## Stack

- Flask
- Flask-CORS
- Flask-SocketIO
- Eventlet
- Gunicorn
- MySQL
- Google OAuth token verification
- Resend email notifications
- Flasgger API docs

## Local Setup

Create and activate a Python virtual environment:

```bash
py -m venv venv
venv\Scripts\activate
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Create a `.env` file in the backend repo root:

```env
DB_HOST=localhost
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_local_mysql_password
DB_NAME=fitappdb

GOOGLE_CLIENT_ID=your_google_oauth_client_id

RESEND_API_KEY=your_resend_api_key
EMAIL_FROM=onboarding@resend.dev
```

Run locally:

```bash
py app.py
```

The app uses Socket.IO, so production should run with the eventlet worker.

## Railway Deployment

Deploy the backend service to Railway from this GitHub repo.

Railway start command is handled by the `Procfile`:

```text
web: gunicorn --worker-class eventlet -w 1 app:app
```

Set these variables on the **backend service**, not the MySQL service:

```env
DB_HOST=mysql.railway.internal
DB_PORT=3306
DB_USER=root
DB_PASSWORD=your_railway_mysql_password
DB_NAME=railway

GOOGLE_CLIENT_ID=your_google_oauth_client_id

RESEND_API_KEY=your_resend_api_key
EMAIL_FROM=onboarding@resend.dev
```

If the Railway MySQL database is in a different Railway project from the backend, `mysql.railway.internal` will not work. Put the backend and MySQL service in the same Railway project, or use Railway's public proxy host/port instead.

## MySQL / Database

The DB connection is defined in `db.py` and reads:

```env
DB_HOST
DB_PORT
DB_USER
DB_PASSWORD
DB_NAME
```

The full schema/mock data dump is in:

```text
databaseStuff/BitFit_FullDBDump.sql
```

To import locally:

```bash
mysql -h 127.0.0.1 -u root -p fitappdb < databaseStuff/BitFit_FullDBDump.sql
```

On Railway, use the Railway MySQL credentials from the MySQL service Variables tab.

## Resend Email Notifications

Email notifications use Resend in `routes/notify.py`.

Required Railway backend variables:

```env
RESEND_API_KEY=your_resend_api_key
EMAIL_FROM=onboarding@resend.dev
```

For the Resend test sender, use:

```env
EMAIL_FROM=onboarding@resend.dev
```

If you verify a real domain in Resend, change it to something like:

```env
EMAIL_FROM=BitFit <noreply@yourdomain.com>
```

Email failures are logged but do not block the main app action. Fake or missing emails will not break coach acceptance, invoices, plans, or in-app notifications.

## Socket.IO / Live Messaging

The backend uses Flask-SocketIO with eventlet:

```python
socketio = SocketIO(app, cors_allowed_origins="*", async_mode="eventlet")
```

Production must run on Railway or another persistent server. Do not deploy this backend to Vercel serverless if live messaging is required.

Frontend `VITE_BACKEND_URL` must point directly to the Railway backend URL for Socket.IO.

## Google Login

The backend verifies Google login tokens using:

```env
GOOGLE_CLIENT_ID=your_google_oauth_client_id
```

The frontend must use the same value as:

```env
VITE_GOOGLE_CLIENT_ID=your_google_oauth_client_id
```

## Tests

GitHub Actions runs tests with MySQL 8 using:

```text
databaseStuff/BitFit_FullDBDump.sql
```

Run tests locally if your local MySQL is configured:

```bash
pip install pytest
pytest tests/ -v
```

## API Groups

Main route groups:

- `/api/login`
- `/api/google-login`
- `/api/register`
- `/api/profile`
- `/api/clients`
- `/api/exercises`
- `/api/coach`
- `/api/coaches_search`
- `/api/coach_applications`
- `/api/landing_page`
- `/api/my_coach`
- `/api/mood`
- `/api/calorie_graph`
- `/api/steps_graph`
- `/api/workoutPlansPage`
- `/api/workoutPlanExercisesPage`
- `/api/workoutLogPage`
- `/api/nutrition_plan`
- `/api/nutrition_plan_modifications`
- `/api/admin`
- `/api/messaging`
- `/api/coach_ratings`
- `/api/reports`
- `/api/notifications`
- `/api/notification-preferences`
- `/api/payment`
- `/api/invoice`
- `/api/review`
- `/api/progress`

## Deployment Checklist

Before deploying:

- Confirm Railway backend variables are set.
- Confirm Railway MySQL is reachable from the backend.
- Confirm `Procfile` uses eventlet.
- Confirm Vercel `vercel.json` points `/api/:path*` to this Railway backend.
- Confirm frontend `VITE_BACKEND_URL` points to this Railway backend.
- Confirm Resend variables are on the backend service.
- Confirm Google OAuth client ID is set on both frontend and backend.
