@echo off
setlocal enabledelayedexpansion
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO "Entered the script for scanning the code"
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO Running script by %Username%
:: check whether the latest air gap zip already exisits with the user
IF EXIST "C:\Users\%Username%\Desktop\Blackduck_Workspace\synopsys-detect-latest-air-gap.zip" (
	for /f "delims=" %%A in ('certutil -hashfile synopsys-detect-latest-air-gap.zip MD5 ^| find /v ":"') do set "current_zip_checksum=%%A"
    set "file_checksum="
	for /f "tokens=2" %%A in ('findstr /c:"Md5" C:\Users\%Username%\Desktop\Blackduck_Workspace\header*.json') do (
	set "file_checksum=%%A"
	)
	echo !current_zip_checksum!
	echo ">>>>>>>>>>>>>>>>"
	REM if defined file_checksum (echo !file_checksum!) else (echo file_checksum not found)
	if "!current_zip_checksum!" == "!file_checksum!" do ( 
		echo "inside if condition"
		cd C:\Users\%Username%\Desktop\Blackduck_Workspace
		::ren synopsys-detect-*.jar synopsys-detect-latest.jar
		tar -xf C:\Users\%Username%\Desktop\Blackduck_Workspace\synopsys-detect-latest-air-gap.zip
		ren synopsys-detect-*.jar synopsys-detect-latest.jar
		:: Running the usual Blackduck commands
		java -jar C:\Users\%Username%\Desktop\Blackduck_Workspace\synopsys-detect-latest.jar ^
		--blackduck.url=https://analog.app.blackduck.com ^
		--blackduck.api.token=%Token% ^
		--detect.project.name=%Project Name% ^
		--detect.project.version.name=%Project Version% ^
		--detect.source.path="C:\Users\%Username%\Desktop\Test" ^
		--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING ^
		--detect.blackduck.signature.scanner.individual.file.matching=BINARY ^
		--detect.blackduck.signature.scanner.license.search=true ^
		--detect.blackduck.signature.scanner.copyright.search=true ^
		--detect.excluded.detector.types=GIT ^
		--detect.detector.search.depth=5 ^
		--detect.detector.search.continue=true
		)
	) ELSE
(
	echo "Inside else"
	:: Make a directory if it doesnt exist
	mkdir C:\Users\%Username%\Desktop\Blackduck_Workspace
	:: change to the required directory
	cd C:\Users\%Username%\Desktop\Blackduck_Workspace
	set header_file_DATE=!date:~7,2!_!date:~4,2%_!date:~10,4!
	set header_file_TIME=!time!
	set header_file=header_!header_file_DATE::=!_!header_file_TIME::=!.json
	:: Fetch the latest air gap zip from Blackduck from artifactory
	curl --dump-header %header_file% https://artifactory.analog.com:443/artifactory/see-generic/adi/see/blackduck/synopsys-detect-latest-air-gap.zip -o synopsys-detect-latest-air-gap.zip
	set "file_checksum="
	for /f "tokens=2" %%A in ('findstr /c:"Md5" header*.json') do (
	set "file_checksum=%%A"
	)
	if defined file_checksum (echo !file_checksum!) else echo checksum not found
	:: Extracting the downloaded air gap zip file
	tar -xf synopsys-detect-latest-air-gap.zip
	:: find the latest jar from the zip
	ren synopsys-detect-*.jar synopsys-detect-latest.jar
	:: Running the usual Blackduck commands
	java -jar C:\Users\%Username%\Desktop\Blackduck_Workspace\synopsys-detect-latest.jar ^
	--blackduck.url=https://analog.app.blackduck.com ^
	--blackduck.api.token=%Token% ^
	--detect.project.name=%Project Name% ^
	--detect.project.version.name=%Project Version% ^
	--detect.source.path="C:\Users\%Username%\Desktop\Test" ^
	--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING ^
	--detect.blackduck.signature.scanner.individual.file.matching=BINARY ^
	--detect.blackduck.signature.scanner.license.search=true ^
	--detect.blackduck.signature.scanner.copyright.search=true ^
	--detect.excluded.detector.types=GIT ^
	--detect.detector.search.depth=5 ^
	--detect.detector.search.continue=true
)
Exit 0
