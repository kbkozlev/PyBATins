:: Created by kbkozlev

@echo off
setlocal enableextensions disabledelayedexpansion

chcp 65001 >nul 2>&1
mode 70, 23
:START
echo ╔════════════════════════════════════════════════════════════════════╗
echo ║                        Welcome to PyBATins!                        ║
echo ╠════════════════════════════════════════════════════════════════════╣
echo ║ This script will take in your Python scripts and the requirements  ║
echo ║ file and turn them into a stand-alone BAT file that can be shared. ║
echo ║                                                                    ║
echo ║ The output BAT file will check for Python and install it, if it is ║
echo ║ missing. After that it will re-create the original Python and      ║
echo ║ requirement.txt files along with a starter and optional timer.     ║
echo ║                                                                    ║
echo ║ The purpose is to bypass EXE and other corporate blocks. Optionally║
echo ║ the output can be in TXT so that the sharing of BAT files can be   ║
echo ║ avoided.                                                           ║
echo ╠════════════════════════════════════════════════════════════════════╣
echo ║           MIT License Copyright (c) 2022, Kaloian Kozlev           ║
echo ╚════════════════════════════════════════════════════════════════════╝
echo. 

set /p "name=Enter name: "
IF [%name%]==[] GOTO ERROR_NAME

set /p "py_script=Path to script: "
IF [%py_script%]==[] GOTO ERROR_SCR

set /p "req_file=Path to requirements.txt: "
IF [%req_file%]==[] GOTO ERROR_REQ

echo ^:^: This code was generated automatically by PyBATins > %name%_installer.bat
echo ^:^: Copyright (c) 2022 Kaloian Kozlev >> %name%_installer.bat
echo. >> %name%_installer.bat
echo @echo off >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo ^^^>  Checking for Python >> %name%_installer.bat
echo. >> %name%_installer.bat
echo python --version ^>nul 2^>^&1 >> %name%_installer.bat
echo. >> %name%_installer.bat
echo if errorlevel 1 ( >> %name%_installer.bat
echo echo -- Python not found, installing python >> %name%_installer.bat
echo start /W /B winget install -e --id Python.Python.3.11 >> %name%_installer.bat
echo ) else ( >> %name%_installer.bat
echo echo -- Python found >> %name%_installer.bat
echo ) >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo. >> %name%_installer.bat
echo echo ^^^>  Creating folder >> %name%_installer.bat
echo. >> %name%_installer.bat
echo dir %name% ^>nul 2^>^&1 >> %name%_installer.bat
echo. >> %name%_installer.bat
echo if errorlevel 1 ( >> %name%_installer.bat
echo mkdir %name% >> %name%_installer.bat
echo echo -- Folder created >> %name%_installer.bat
echo ) else ( >> %name%_installer.bat
echo echo -- Folder found >> %name%_installer.bat
echo ) >> %name%_installer.bat
echo. >> %name%_installer.bat
echo cd %name% >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo. >> %name%_installer.bat
echo echo ^^^>  Creating Script and Requirements >> %name%_installer.bat
echo if exist %name%.py ( >> %name%_installer.bat
echo echo -- Script found >> %name%_installer.bat
echo ) else ( >> %name%_installer.bat
echo. >> %name%_installer.bat

certutil -encode %py_script% script_encoded.txt >nul 2>&1

for /f "tokens=* delims= " %%a in (script_encoded.txt) do (
set /a N+=1
echo echo %%a ^>^> script.txt >> script_encoded_echo_mod.txt
)
type script_encoded_echo_mod.txt >> %name%_installer.bat

del script_encoded.txt
del script_encoded_echo_mod.txt

echo. >> %name%_installer.bat
echo certutil -decode script.txt %name%.py ^>nul 2^>^&1 >> %name%_installer.bat
echo del "script.txt" >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo -- Script created >> %name%_installer.bat
echo ) >> %name%_installer.bat

echo. >> %name%_installer.bat
echo if exist requirements.txt ( >> %name%_installer.bat
echo echo -- Requirements found >> %name%_installer.bat
echo ) else ( >> %name%_installer.bat
echo. >> %name%_installer.bat

certutil -encode %req_file% req_encoded.txt >nul 2>&1

for /f "tokens=* delims= " %%a in (req_encoded.txt) do (
set /a N+=1
echo echo %%a ^>^> requirements_encoded.txt >> requirements_encoded_echo_mod.txt
)
type requirements_encoded_echo_mod.txt >> %name%_installer.bat

del req_encoded.txt
del requirements_encoded_echo_mod.txt

echo. >> %name%_installer.bat
echo certutil -decode requirements_encoded.txt requirements.txt ^>nul 2^>^&1 >> %name%_installer.bat
echo del "requirements_encoded.txt" >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo -- Requirements created >> %name%_installer.bat

echo echo. >> %name%_installer.bat
echo echo ^^^>  Installing requirements.txt >> %name%_installer.bat
echo pip install -r requirements.txt ^>nul 2^>^&1 >> %name%_installer.bat
echo echo -- requirements.txt installed >> %name%_installer.bat
echo ) >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo. >> %name%_installer.bat
echo echo ^^^>  Creating Launcher >> %name%_installer.bat
echo if exist starter.bat ( >> %name%_installer.bat
echo echo -- Launcher found >> %name%_installer.bat
echo ) else ( >> %name%_installer.bat
echo echo python %name%.py ^> starter.bat >> %name%_installer.bat
echo echo -- Launcher created >> %name%_installer.bat
echo ) >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo. >> %name%_installer.bat

set /p "timer=Do you want to have a timer for this application Y/N? "

if %timer% == y (

echo @echo off >> timer.txt
echo. >> timer.txt
echo echo Enter the time to run %name%>> timer.txt
echo echo. >> timer.txt
echo set /p "hour=Enter Hours: " >> timer.txt
echo set /p "min=Enter Minutes: " >> timer.txt
echo set /a total=((hour*60^) + min^)* 60 >> timer.txt
echo. >> timer.txt
echo start "" "C:\Users\^%username^%\AppData\Local\Programs\Python\Python311\python.exe" "%name%.py" >> timer.txt
echo. >> timer.txt
echo TIMEOUT /T^%total^%/nobreak >> timer.txt
echo. >> timer.txt
echo Taskkill /IM python.exe /F ^>nul 2^>^&^1 >> timer.txt

certutil -encode timer.txt timer_encoded.txt >nul 2>&1

for /f "tokens=* delims= " %%a in (timer_encoded.txt) do (
set /a N+=1
echo echo %%a ^>^> timer.txt >> timer_encoded_echo_mod.txt
)

type timer_encoded_echo_mod.txt >> %name%_installer.bat

del timer.txt
del timer_encoded.txt
del timer_encoded_echo_mod.txt


echo certutil -decode timer.txt %name%_timer.bat ^>nul 2^>^&1 >> %name%_installer.bat

echo del timer.txt >> %name%_installer.bat

echo pause^>nul^|set/p =Instalation finnished, press any key to exit... >> %name%_installer.bat

)


set /p "txt=Do you want a text version of this file Y/N? "

if %txt% == y (
type %name%_installer.bat >> installer_%name%.txt )

goto :EOF

:ERROR_NAME
echo.
echo Please enter a name!
pause
cls
goto START

:ERROR_SCR
echo.
echo Please enter the path to the script!
pause
cls
goto START

:ERROR_REQ
echo.
echo Please enter the path to the requirements file!
pause
cls
goto START