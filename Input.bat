@echo off
set /p projectName = input (
            message: 'What is your project name?', 
            ok: 'Submit')
echo %projectName%
