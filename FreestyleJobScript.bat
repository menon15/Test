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
--blackduck.api.token=%BlackduckToken% ^
--detect.project.name=%ProjectName% ^
--detect.project.version.name=%ProjectVersion% ^
--detect.source.path="C:\Users\SMenon\Desktop\Test" ^
--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING ^
--detect.blackduck.signature.scanner.individual.file.matching=BINARY ^
--detect.blackduck.signature.scanner.license.search=true ^
--detect.blackduck.signature.scanner.copyright.search=true ^
--detect.excluded.detector.types=GIT ^
--detect.detector.search.depth=5 ^
--detect.detector.search.continue=true
goto Reports

:Reports
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO "Entered the script for generating the Blackduck Reports "
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
:: Change to the directory created for scanning using Blackduck
cd C:\Users\%Username%\Desktop\Blackduck_Workspace
:: Clone the BD-CLI to generate reports
git clone https://%Username%:%BitToken%@bitbucket.analog.com/scm/dte-inf/bd-cli.git
:: Change to the directory created for generating reports using Blackduck rest api
cd bd-cli/
:: create a .restconfig.json file
(
    echo {
    echo. "baseUrl": "https://analog.app.blackduck.com",
    echo. "api_token": "%BlackduckToken%"
	echo }
) >.restconfig.json
:: create a virtual enviornemnt
python -m venv .venv
:: Activate the virtual enviornment
call .venv\Scripts\activate
:: install the requirements on virtual enviornment
.venv\Scripts\pip.exe install -r requirements.txt
:: create a directory accooring to OSPO working style
mkdir C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents
:: check if the branch name 
if ("%env.BRANCH_NAME%"=="release" OR "%env.TAG_NAME%") AND "%currentBuild.currentResult%"=="SUCCESS" (
  	goto executeBlackduckReportCommandsForReleaseBranch
    ) else if "%env.BRANCH_NAME%"=="release" AND "%currentBuild.currentResult%"=="FAILURE" (echo "Please fix the rule violations first")
) else ( 
goto executeBlackduckReportCommandsForDevlopBranch
  )
:: Blackduck command for develop branch
:executeBlackduckReportCommandsForDevlopBranch
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py --build develop generate-bom %ProjectName% %ProjectVersion% --out %projectName%.json --recursive --custom-fields --include-hidden-comps
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py cof-appendix %ProjectName%.json --docx %ProjectName%-appendix-a.docx --html %ProjectName%-appendix-a.html
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py cof-review %ProjectName%.json --html %ProjectName%-cof-review.html
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py  legal-review  %ProjectName%.json --html %ProjectName%-legal-review.html
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py license-file %ProjectName%.json --notice
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%projectName%.json C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\%ProductName%.json
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName%-appendix-a.docx C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\appendix-a_%ProductName%.docx
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName%-appendix-a.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\appendix-a_%ProductName%.html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName%-cof-review.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\cof-review_%ProductName%.html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName%-legal-review.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\legal-review_%ProductName%.html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\NOTICE C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\NOTICE
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\LICENSE C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\LICENSE
:: Blackduck commands for release branch
:executeBlackduckReportCommandsForReleaseBranch
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py --build release generate-bom %ProjectName% %ProjectVersion% --out %projectName%.json --recursive --custom-fields --include-hidden-comps
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py cof-appendix %ProjectName%.json --docx %ProjectName%-appendix-a.docx --html %ProjectName%-appendix-a.html
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py cof-review %ProjectName%.json --html %ProjectName%-cof-review.html
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py  legal-review  %ProjectName%.json --html %ProjectName%-legal-review.html
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py license-file %ProjectName%.json --notice
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%projectName%.json C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\%ProductName%.json
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName%-appendix-a.docx C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\appendix-a_%ProductName%.docx
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName%-appendix-a.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\appendix-a_%ProductName%.html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName%-cof-review.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\cof-review_%ProductName%.html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName%-legal-review.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\legal-review_%ProductName%.html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\NOTICE C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\NOTICE
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\LICENSE C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\%ProductName%-all-documents\LICENSE
:endOfBatch
