#!/bin/bash

echo "Setting up virtual environment..."
python3 -m venv venv

echo "Activating virtual environment..."
source venv/bin/activate

echo "Installing dependencies..."
pip install flask flask-cors google-auth-oauthlib google-auth python-dotenv mysql-connector-python

echo ""
echo "Setup complete!"
echo "To activate later, run:"
echo "source venv/bin/activate"
echo ""
echo "Create a .env file with:"
echo "DB_HOST=<Your Database Host>"
echo "DB_USER=<Your Database Username>"
echo "DB_PASSWORD=<Your Database Password>"
echo "DB_NAME=<Your Database Name>"
echo "GOOGLE_CLIENT_ID=<your client id>"
echo "GOOGLE_CLIENT_SECRET=<your client secret>"
