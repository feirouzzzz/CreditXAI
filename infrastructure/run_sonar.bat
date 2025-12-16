@echo off
echo Scanning backend...
cd ..\services\backend
sonar-scanner
echo Backend scan complete.

echo Scanning ML...
cd ..\services\ml
sonar-scanner
echo ML scan complete.

echo SonarQube scan finished for both services.
pause
