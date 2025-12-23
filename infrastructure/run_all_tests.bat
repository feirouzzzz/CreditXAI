@echo off
echo ============================================
echo 🔥 RUNNING ALL TESTS (Backend + ML + Selenium)
echo ============================================

REM ========================
REM 1. ACTIVER ENV PYTHON
REM ========================
echo 📌 Activating virtual environment...
call venv\Scripts\activate

REM ========================
REM 2. TESTS BACKEND
REM ========================
echo --------------------------------------------
echo 🧪 Running backend unit tests...
cd ..\services\backend
pytest --disable-warnings --maxfail=1 --cov=app --cov-report=xml

echo ✔ Backend tests completed.

REM ========================
REM 3. TESTS ML
REM ========================
echo --------------------------------------------
echo 🤖 Running ML unit tests...
cd ..\ml
pytest --disable-warnings --maxfail=1 --cov=app --cov-report=xml

echo ✔ ML tests completed.

REM ========================
REM 4. SELENIUM TESTS
REM ========================
echo --------------------------------------------
echo 🌐 Running Selenium UI tests...
cd ..\..\infrastructure\tests\selenium
pytest --disable-warnings --maxfail=1

echo ✔ Selenium tests completed.

REM ========================
REM 5. SONAR BACKEND
REM ========================
echo --------------------------------------------
echo 🔍 Running SonarScanner for Backend...
cd ..\..\..\services\backend
sonar-scanner

REM ========================
REM 6. SONAR ML
REM ========================
echo --------------------------------------------
echo 🔍 Running SonarScanner for ML...
cd ..\ml
sonar-scanner

echo ============================================
echo 🎉 ALL TESTS SUCCESSFULLY EXECUTED!
echo ============================================
pause
