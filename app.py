from flask import Flask, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from routes.login import login_bp
from routes.google_login import google_login_bp
from routes.register import register_bp

load_dotenv()

app = Flask(__name__)
app.url_map.strict_slashes = False
CORS(app)

@app.route("/")
def home():
    return jsonify({
        "message": "Api running",
        "endpoints": ["/api/login/", "/api/google-login/", "/api/register/"]
    })

#blueprints for each of the routes, register to app
app.register_blueprint(login_bp, url_prefix="/api/login")
app.register_blueprint(google_login_bp, url_prefix="/api/google-login")
app.register_blueprint(register_bp, url_prefix="/api/register")


if __name__ == "__main__":
    app.run(debug=True)
