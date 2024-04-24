@echo off
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO "Entered the script for scanning the code"
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO Running script by %Username%
:: check whether the latest air gap zip already exisits with the user
IF EXIST "C:\Users\%Username%\Desktop\Blackduck_Workspace\synopsys-detect-latest-air-gap.zip" (
  ::ren synopsys-detect-*.jar synopsys-detect-latest.jar
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
) ELSE (
 :: Make a directory if it doesnt exist
  mkdir C:\Users\%Username%\Desktop\Blackduck_Workspace
  :: change to the required directory
  cd C:\Users\%Username%\Desktop\Blackduck_Workspace
  :: Fetch the latest air gap zip from Blackduck from artifactory
  curl -X GET https://artifactory.analog.com:443/artifactory/see-generic/adi/see/blackduck/synopsys-detect-latest-air-gap.zip -o synopsys-detect-latest-air-gap.zip
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

