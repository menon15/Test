@echo off
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO "Entered the script for scanning the code"
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
::ECHO %Username%
VERSION = (curl "https://artifactory.analog.com/artifactory/api/storage/see-generic/adi/see/blackduck")
ECHO %VERSION%
