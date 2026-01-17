@echo off
REM HCP CRM Setup Script for Windows
REM Run this script to automatically set up both backend and frontend

echo.
echo ================================
echo HCP CRM - AI-First CRM Setup
echo ================================
echo.

REM Check Python
echo Checking Python installation...
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed. Please install Python 3.9+
    pause
    exit /b 1
)
for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo OK: Python %PYTHON_VERSION% found
echo.

REM Check Node.js
echo Checking Node.js installation...
node --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Node.js is not installed. Please install Node.js 16+
    pause
    exit /b 1
)
for /f "tokens=*" %%i in ('node --version') do set NODE_VERSION=%%i
echo OK: Node.js %NODE_VERSION% found
echo.

REM Backend Setup
echo Setting up Backend...
cd backend

REM Create virtual environment
echo Creating virtual environment...
python -m venv venv

REM Activate virtual environment
call venv\Scripts\activate

REM Install dependencies
echo Installing dependencies...
pip install -r requirements.txt

REM Setup environment
if not exist .env (
    copy .env.example .env
    echo Created .env file. Please edit it and add your Groq API key:
    echo GROQ_API_KEY=your_actual_key_here
)

echo OK: Backend setup complete!
echo.

REM Frontend Setup
echo Setting up Frontend...
cd ..\frontend

REM Install dependencies
echo Installing dependencies...
call npm install

REM Setup environment
if not exist .env (
    copy .env.example .env
    echo Created .env file with default settings
)

echo OK: Frontend setup complete!
echo.

REM Summary
echo ================================
echo Setup Complete!
echo ================================
echo.
echo Next steps:
echo.
echo 1. Get your Groq API Key:
echo    - Visit https://console.groq.com
echo    - Create a new API key
echo    - Edit backend\.env and add: GROQ_API_KEY=your_key
echo.
echo 2. Start Backend (in one terminal):
echo    cd backend
echo    venv\Scripts\activate
echo    uvicorn app.main:app --reload
echo    Backend will run on http://localhost:8000
echo.
echo 3. Start Frontend (in another terminal):
echo    cd frontend
echo    npm start
echo    Frontend will run on http://localhost:3000
echo.
echo 4. Test the system:
echo    - Open http://localhost:3000
echo    - Try the Form Interface
echo    - Try the Chat Interface
echo    - View Dashboard and Interactions List
echo.
echo 5. View API Documentation:
echo    http://localhost:8000/docs (Swagger)
echo    http://localhost:8000/redoc (ReDoc)
echo.
echo For more details, see QUICKSTART.md
echo.
pause
