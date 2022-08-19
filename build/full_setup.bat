@echo off
echo Administrative permissions required. Detecting permissions...

net session >nul 2>&1
if %errorLevel% == 0 (
	echo Success: Administrative permissions confirmed.
) else (
	echo Failure: Current permissions inadequate. 
	EXIT \B 0
)

cd /d %~dp0
echo %cd%

python build.py pdrive
python build.py filepatching
python build.py arma-setup

pause