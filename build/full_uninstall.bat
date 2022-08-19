@echo off
echo Administrative permissions required. Detecting permissions...

cd /d %~dp0
echo %cd%

python build.py pdrive -d
python build.py filepatching -d
python build.py arma-setup -d

pause