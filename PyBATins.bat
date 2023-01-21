:: Created by kbkozlev

@echo off
setlocal enableextensions disabledelayedexpansion 

:: Set encoding and dimensions
chcp 65001 >nul 2>&1 

:: Welcome screen
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
echo ║ The purpose is to bypass EXE blocking and other security measures. ║
echo ║ Optionally the output can be a TXT file so that the sharing of BAT ║
echo ║ files can be avoided.                                              ║
echo ╠════════════════════════════════════════════════════════════════════╣
echo ║           MIT License Copyright (c) 2022, Kaloian Kozlev           ║
echo ╚════════════════════════════════════════════════════════════════════╝
echo. 

:: Get name, script, requirement.txt and perform empty variable check
set /p "name=Enter name: "

if [%name%]==[] (
echo.
echo Please enter a name!
pause
cls
goto START
)

set /p "py_script=Path to script: "

if [%py_script%]==[]  (
echo.
echo Please enter the path to the script!
pause
cls
goto START
)

set /p "req_file=Path to requirements.txt: "
set /p "timer=Do you want to have a timer for this application Y/N? "
set /p "txt=Do you want a text version of this file Y/N? "

echo.
echo Working on it, please wait!

:: Begin writing the installer file
echo ^:^: This code was generated automatically by PyBATins > %name%_installer.bat
echo ^:^: Copyright (c) 2022 Kaloian Kozlev >> %name%_installer.bat
echo. >> %name%_installer.bat
echo @echo off >> %name%_installer.bat
echo. >> %name%_installer.bat

:: Python check/download in the installer file
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

:: Folder check/create in the installer file
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

:: Script check/create in the installer file
echo echo. >> %name%_installer.bat
echo echo ^^^>  Creating Script >> %name%_installer.bat
echo if exist %name%.py ( >> %name%_installer.bat
echo echo -- Script found >> %name%_installer.bat
echo ) else ( >> %name%_installer.bat
echo. >> %name%_installer.bat

:: Create encoded version of script 
certutil -encode %py_script% script_encoded.txt >nul 2>&1

if not errorlevel 0 (
pause > nul|set/p =System cannot find the file specified. Press enter to try again.
del %name%_installer.bat
cls
goto START
)

for /f "tokens=* delims= " %%a in (script_encoded.txt) do (
set /a N+=1
echo echo %%a ^>^> script.txt >> script_encoded_echo_mod.txt
)

:: Write encoded script in the installer file
type script_encoded_echo_mod.txt >> %name%_installer.bat

:: Delete remaining script files
del script_encoded.txt
del script_encoded_echo_mod.txt

:: Write script decode and creation in the installer file
echo. >> %name%_installer.bat
echo certutil -decode script.txt %name%.py ^>nul 2^>^&1 >> %name%_installer.bat
echo del "script.txt" >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo -- Script created >> %name%_installer.bat
echo ) >> %name%_installer.bat

:: Check if requirements.txt is present otherwise skip
if not [%req_file%]==[]  (

:: Requirements txt check/create in the installer file
echo echo. >> %name%_installer.bat
echo echo ^^^>  Creating Requirements >> %name%_installer.bat
echo if exist requirements.txt ( >> %name%_installer.bat
echo echo -- Requirements found >> %name%_installer.bat
echo ^) else ( >> %name%_installer.bat
echo. >> %name%_installer.bat

:: Create encoded version of requirements.txt
certutil -encode %req_file% req_encoded.txt >nul 2>&1

if not errorlevel 0 (
pause > nul|set/p =System cannot find the file specified. Press enter to try again.
del %name%_installer.bat
cls
goto START
)

for /f "tokens=* delims= " %%a in (req_encoded.txt) do (
set /a N+=1
echo echo %%a ^>^> requirements_encoded.txt >> requirements_encoded_echo_mod.txt
)

:: Write encoded requirements.txt in the installer file 
type requirements_encoded_echo_mod.txt >> %name%_installer.bat

:: Delete remaining requirements files
del req_encoded.txt
del requirements_encoded_echo_mod.txt

:: Write requirements decode and creation in the installer file
echo. >> %name%_installer.bat
echo certutil -decode requirements_encoded.txt requirements.txt ^>nul 2^>^&1 >> %name%_installer.bat
echo del "requirements_encoded.txt" >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo -- Requirements created >> %name%_installer.bat
echo echo. >> %name%_installer.bat
echo. >> %name%_installer.bat
echo echo ^^^>  Installing requirements.txt >> %name%_installer.bat
echo pip install -r requirements.txt ^>nul 2^>^&1 >> %name%_installer.bat
echo echo -- requirements.txt installed >> %name%_installer.bat
echo ^) >> %name%_installer.bat
echo. >> %name%_installer.bat
)

:: Write check/create launcher in the installer file
echo echo. >> %name%_installer.bat
echo echo ^^^>  Creating Launcher >> %name%_installer.bat
echo if exist starter.bat ( >> %name%_installer.bat
echo echo -- Launcher found >> %name%_installer.bat
echo ) else ( >> %name%_installer.bat
echo echo python %name%.py ^> starter.bat >> %name%_installer.bat
echo echo -- Launcher created >> %name%_installer.bat
echo ) >> %name%_installer.bat
echo. >> %name%_installer.bat

:: Implement choice of timer

if %timer% == y (

:: Create timer.txt
echo @echo off >> timer.txt
echo. >> timer.txt
echo echo Enter the time to run %name%>> timer.txt
echo echo. >> timer.txt
echo set /p "hour=Enter Hours: " >> timer.txt
echo set /p "min=Enter Minutes: " >> timer.txt
echo set /a total=((hour*60^) + min^)* 60 >> timer.txt
echo. >> timer.txt
echo start "" "C:\Users\%%username%%\AppData\Local\Programs\Python\Python311\python.exe" "%name%.py" >> timer.txt
echo. >> timer.txt
echo TIMEOUT /T %%total%% /nobreak >> timer.txt
echo. >> timer.txt
echo Taskkill /IM python.exe /F ^>nul 2^>^&^1 >> timer.txt

:: Create encoded version of timer.txt
certutil -encode timer.txt timer_encoded.txt >nul 2>&1

for /f "tokens=* delims= " %%a in (timer_encoded.txt) do (
set /a N+=1
echo echo %%a ^>^> timer.txt >> timer_encoded_echo_mod.txt
)

:: Write check/create timer in the installer file
echo echo. >> %name%_installer.bat
echo echo ^^^>  Creating Timer >> %name%_installer.bat
echo if exist %name%_timer.bat ( >> %name%_installer.bat
echo echo -- Timer found >> %name%_installer.bat
echo ^) else ( >> %name%_installer.bat

:: Write encoded timer to installer
type timer_encoded_echo_mod.txt >> %name%_installer.bat

echo certutil -decode timer.txt %name%_timer.bat ^>nul 2^>^&1 >> %name%_installer.bat
echo del timer.txt >> %name%_installer.bat
echo echo -- Timer created >> %name%_installer.bat
echo ^) >> %name%_installer.bat

:: Delete remaining timer files
del timer.txt
del timer_encoded.txt
del timer_encoded_echo_mod.txt
)

:: End of installer
echo echo. >> %name%_installer.bat
echo pause^>nul^|set/p =Instalation finnished, press any key to exit... >> %name%_installer.bat

:: Create txt version
if %txt% == y (
type %name%_installer.bat >> %name%_installer.txt )

pause > nul|set/p =Done, press enter to exit!
