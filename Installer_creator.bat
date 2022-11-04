@echo off
setlocal enableextensions disabledelayedexpansion


set /p "name=Enter name: "
set /p "py_script=Path to script: "
set /p "req_file=Path to requirements.txt: "

echo @echo off > installer_%name%.bat
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
del del script_encoded_echo_mod.txt

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
echo pause^>nul^|set/p =Instalation finnished, press any key to exit... >> installer_%name%.bat