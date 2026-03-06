@echo off
echo Setting up virtual environment...
py -m venv venv

echo Activating virtual environment...
call venv\Scripts\activate

echo Installing dependencies...
py -m pip install flask flask-cors

echo Saving dependencies to requirements.txt...
py -m pip freeze > requirements.txt

echo Adding venv to .gitignore...
echo venv/ >> .gitignore

echo.
echo Setup complete! To start developing, activate the venv with:
echo    venv\Scripts\activate
pause