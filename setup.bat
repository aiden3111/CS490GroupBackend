@echo off
echo Setting up virtual environment...
py -m venv venv

echo Activating virtual environment...
call venv\Scripts\activate

echo Installing dependencies...
py -m pip install flask flask-cors google-auth-oauthlib google-auth

echo.
echo Setup complete! To start developing, activate the venv with:
echo    source venv\Scripts\activate
echo	Please create your own .env file as well with the following information:
echo	DB_HOST=<Your Database Host>
echo	DB_USER=<Your Database Username>
echo 	DB_PASSWORD=<Your Database Password>
echo	DB_NAME=<Your Database Name>
echo	GOOGLE_CLIENT_ID=<our client id>
echo 	GOOGLE_CLIENT_SECRET=<our client secret>
pause