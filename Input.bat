@echo off
setlocal enabledelayedexpansion
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO "Entered the script for scanning the code"
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO Running script by %Username%
:: check whether the latest air gap zip already exisits with the user
IF EXIST "C:\Users\%Username%\Desktop\Blackduck_Workspace\synopsys-detect-latest-air-gap.zip" (
  ren synopsys-detect-*.jar synopsys-detect-latest.jar
  for /f "delims=" %%A in ('certutil -hashfile synopsys-detect-latest-air-gap.zip MD5 ^| find /v ":"') do set "current_zip_checksum=%%A"
  set "file_checksum="
  for /f "tokens=2" %%A in ('findstr /c:"Md5" C:\Users\%Username%\Desktop\Blackduck_Workspace\header_file.json') do (
  set "file_checksum=%%A"
  )
  echo !current_zip_checksum!
  if "!current_zip_checksum!" == "!file_checksum!" do ( 
		goto executeBlackduckCommands
    )
  ) ELSE (
 :: Make a directory if it doesnt exist
  mkdir C:\Users\%Username%\Desktop\Blackduck_Workspace
  :: change to the required directory
  cd C:\Users\%Username%\Desktop\Blackduck_Workspace
  :: Fetch the latest air gap zip from Blackduck from artifactory
  curl -I  https://artifactory.analog.com:443/artifactory/see-generic/adi/see/blackduck/synopsys-detect-latest-air-gap.zip  > header_file.json
  :: Fetch the latest air gap zip from Blackduck from artifactory
  curl -X GET https://artifactory.analog.com:443/artifactory/see-generic/adi/see/blackduck/synopsys-detect-latest-air-gap.zip -o synopsys-detect-latest-air-gap.zip
  :: Extracting the downloaded air gap zip file
  tar -xf synopsys-detect-latest-air-gap.zip
  ren synopsys-detect-*.jar synopsys-detect-latest.jar
  :: find the latest jar from the zip
  :: Running the usual Blackduck commands
  goto executeBlackduckCommands
    )
:executeBlackduckCommands
java -jar C:\Users\%Username%\Desktop\Blackduck_Workspace\synopsys-detect-latest.jar ^
--blackduck.url=https://analog.app.blackduck.com ^
--blackduck.api.token=%Token% ^
--detect.project.name=%Project Name% ^
--detect.project.version.name=%Project Version% ^
--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING ^
--detect.blackduck.signature.scanner.individual.file.matching=BINARY ^
--detect.blackduck.signature.scanner.license.search=true ^
--detect.blackduck.signature.scanner.copyright.search=true ^
--detect.excluded.detector.types=GIT ^
--detect.detector.search.depth=5 ^
--detect.detector.search.continue=true

:endOfBatch
