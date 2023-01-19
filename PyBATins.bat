:: Created by kbkozlev

@echo off
setlocal enableextensions disabledelayedexpansion

:START
echo  _______________________________________________
echo ^|                                               ^|
echo ^|             Welcome to PyBATins!              ^|
echo ^|             --------------------              ^|
echo ^|                                               ^|
echo ^| This script will take in your Python scripts  ^|
echo ^| and the requirements file and turn them into  ^|
echo ^| a self-contained BAT file that can be shared; ^|
echo ^|                                               ^|
echo ^| The output BAT file will check for Python and ^|
echo ^| install it if its missing, after that it will ^|
echo ^| re-create the original Python and Req. files  ^|
echo ^| along with a starter and optional timer file; ^|
echo ^|                                               ^|
echo ^| The purpose is to bypass EXE and other corp.  ^|
echo ^| blocks; Optionally the output can be in TXT   ^|
echo ^| so that sharing of BAT files can be avoided.  ^| 
echo ^|                                               ^|
echo ^| MIT License Copyright (c) 2022, Kaloian Kozlev^|
echo ^|_______________________________________________^|
echo.

set /p "name=Enter name: "
IF [%name%]==[] GOTO ERROR_NAME

:SCRIPT
set /p "py_script=Path to script: "
IF [%py_script%]==[] GOTO ERROR_SCR

:REQUIREMENTS
set /p "req_file=Path to requirements.txt: "
IF [%req_file%]==[] GOTO ERROR_REQ

echo ^:^: This code was generated automatically by a software developed by kbkozlev > installer_%name%.bat
echo. >> installer_%name%.bat
echo @echo off >> installer_%name%.bat
echo. >> installer_%name%.bat
echo echo ^^^>  Checking for Python >> installer_%name%.bat
echo. >> installer_%name%.bat
echo python --version ^>nul 2^>^&1 >> installer_%name%.bat
echo. >> installer_%name%.bat
echo if errorlevel 1 ( >> installer_%name%.bat
echo echo -- Python not found, installing python >> installer_%name%.bat
echo start /W /B winget install -e --id Python.Python.3.11 >> installer_%name%.bat
echo ) else ( >> installer_%name%.bat
echo echo -- Python found >> installer_%name%.bat
echo ) >> installer_%name%.bat
echo. >> installer_%name%.bat
echo echo. >> installer_%name%.bat
echo echo ^^^>  Creating folder >> installer_%name%.bat
echo. >> installer_%name%.bat
echo dir %name% ^>nul 2^>^&1 >> installer_%name%.bat
echo. >> installer_%name%.bat
echo if errorlevel 1 ( >> installer_%name%.bat
echo mkdir %name% >> installer_%name%.bat
echo echo -- Folder created >> installer_%name%.bat
echo ) else ( >> installer_%name%.bat
echo echo -- Folder found >> installer_%name%.bat
echo ) >> installer_%name%.bat
echo. >> installer_%name%.bat
echo cd %name% >> installer_%name%.bat
echo. >> installer_%name%.bat
echo echo. >> installer_%name%.bat
echo echo ^^^>  Creating Script and Requirements >> installer_%name%.bat
echo if exist %name%.py ( >> installer_%name%.bat
echo echo -- Script found >> installer_%name%.bat
echo ) else ( >> installer_%name%.bat
echo. >> installer_%name%.bat

certutil -encode %py_script% script_encoded.txt >nul 2>&1

for /f "tokens=* delims= " %%a in (script_encoded.txt) do (
set /a N+=1
echo echo %%a ^>^> script.txt >> script_encoded_echo_mod.txt
)
type script_encoded_echo_mod.txt >> installer_%name%.bat

del script_encoded.txt
del script_encoded_echo_mod.txt

echo. >> installer_%name%.bat
echo certutil -decode script.txt %name%.py ^>nul 2^>^&1 >> installer_%name%.bat
echo del "script.txt" >> installer_%name%.bat
echo. >> installer_%name%.bat
echo echo -- Script created >> installer_%name%.bat
echo ) >> installer_%name%.bat

echo. >> installer_%name%.bat
echo if exist requirements.txt ( >> installer_%name%.bat
echo echo -- Requirements found >> installer_%name%.bat
echo ) else ( >> installer_%name%.bat
echo. >> installer_%name%.bat

certutil -encode %req_file% req_encoded.txt >nul 2>&1

for /f "tokens=* delims= " %%a in (req_encoded.txt) do (
set /a N+=1
echo echo %%a ^>^> requirements_encoded.txt >> requirements_encoded_echo_mod.txt
)
type requirements_encoded_echo_mod.txt >> installer_%name%.bat

del req_encoded.txt
del requirements_encoded_echo_mod.txt

echo. >> installer_%name%.bat
echo certutil -decode requirements_encoded.txt requirements.txt ^>nul 2^>^&1 >> installer_%name%.bat
echo del "requirements_encoded.txt" >> installer_%name%.bat
echo. >> installer_%name%.bat
echo echo -- Requirements created >> installer_%name%.bat

echo echo. >> installer_%name%.bat
echo echo ^^^>  Installing requirements.txt >> installer_%name%.bat
echo pip install -r requirements.txt ^>nul 2^>^&1 >> installer_%name%.bat
echo echo -- requirements.txt installed >> installer_%name%.bat
echo ) >> installer_%name%.bat
echo. >> installer_%name%.bat
echo echo. >> installer_%name%.bat
echo echo ^^^>  Creating Launcher >> installer_%name%.bat
echo if exist starter.bat ( >> installer_%name%.bat
echo echo -- Launcher found >> installer_%name%.bat
echo ) else ( >> installer_%name%.bat
echo echo python %name%.py ^> starter.bat >> installer_%name%.bat
echo echo -- Launcher created >> installer_%name%.bat
echo ) >> installer_%name%.bat
echo. >> installer_%name%.bat
echo echo. >> installer_%name%.bat

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

type timer_encoded_echo_mod.txt >> installer_%name%.bat

del timer.txt
del timer_encoded.txt
del timer_encoded_echo_mod.txt


echo certutil -decode timer.txt %name%_timer.bat ^>nul 2^>^&1 >> installer_%name%.bat

echo del timer.txt >> installer_%name%.bat

echo pause^>nul^|set/p =Instalation finnished, press any key to exit... >> installer_%name%.bat

)


set /p "txt=Do you want a text version of this file Y/N? "

if %txt% == y (
type installer_%name%.bat >> installer_%name%.txt )

goto :eof

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
goto SCRIPT

:ERROR_REQ
echo.
echo Please enter the path to the requirements file!
pause
cls
goto REQUIREMENTS