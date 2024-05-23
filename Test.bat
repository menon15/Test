@echo off
setlocal enabledelayedexpansion
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO "Entered the script for scanning the code"
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO Running script by %Username%
setlocal enabledelayedexpansion
:: check whether the latest air gap zip already exisits with the user
IF EXIST "C:\Users\%Username%\Desktop\Blackduck_Workspace\synopsys-detect-latest-air-gap.zip" (
  ::ren synopsys-detect-*.jar synopsys-detect-latest.jar
  cd C:\Users\%Username%\Desktop\Blackduck_Workspace\
  curl -I https://artifactory.analog.com:443/artifactory/see-generic/adi/see/blackduck/synopsys-detect-latest-air-gap.zip > new_header_file.json
  )
  for /f "delims=" %%A in ('certutil -hashfile synopsys-detect-latest-air-gap.zip MD5 ^| find /v ":"') do set "current_zip_checksum=%%A"
  set "new_header_file_checksum="
  for /f "tokens=2" %%A in ('findstr /c:"Md5" C:\Users\%Username%\Desktop\Blackduck_Workspace\new_header_file.json') do set "new_header_file_checksum=%%A"
  
  
  if "!current_zip_checksum!" == "!new_header_file_checksum!" do( 
		echo !current_zip_checksum!
		echo !new_header_file_checksum!
		goto executeBlackduckCommands
    )
  ) ELSE (
 :: Make a directory if it doesnt exist
  mkdir C:\Users\%Username%\Desktop\Blackduck_Workspace
  :: change to the required directory
  cd C:\Users\%Username%\Desktop\Blackduck_Workspace
  :: Fetch the latest header json file from artifactory
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
--detect.source.path="C:\Users\%Username%\Desktop\Test" ^
--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING ^
--detect.blackduck.signature.scanner.individual.file.matching=BINARY ^
--detect.blackduck.signature.scanner.license.search=true ^
--detect.blackduck.signature.scanner.copyright.search=true ^
--detect.excluded.detector.types=GIT ^
--detect.detector.search.depth=5 ^
--detect.detector.search.continue=true
goto Reports

:Reports
cd C:\Users\%Username%\Desktop\Blackduck_Workspace
git clone https://%Username%:%BitToken%@bitbucket.analog.com/scm/dte-inf/bd-cli.git
cd bd-cli/
(
    echo {
    echo. "baseUrl": "https://analog.app.blackduck.com",
    echo. "api_token": "%BlackduckToken%"
	echo }
) >.restconfig.json

python -m venv .venv
call .venv\Scripts\activate
.venv\Scripts\pip.exe install -r requirements.txt
mkdir C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents
::cd C:\Users\%Username%\Desktop\Blackduck_Workspace\Reports\

if "%env.BRANCH_NAME%"=="develop" if "%currentBuild.currentResult%"=="SUCCESS" (
        GOTO executeBlackduckReportCommandsForDevelopBranch
)
if "%env.BRANCH_NAME%"=="release" if "%currentBuild.currentResult%"=="SUCCESS" (
        GOTO executeBlackduckReportCommandsForReleaseBranch
)
if "%env.BRANCH_NAME%"=="release" if "%currentBuild.currentResult%"=="FAILURE" (
		GOTO error
)

:executeBlackduckReportCommandsForDevelopBranch
echo "inside develop branch$$$$$$$"
echo %GIT_URL%
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py --build develop generate-bom %ProjectName% %ProjectVersion: =% --out %ProjectName: =%.json --recursive --custom-fields --include-hidden-comps
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py cof-appendix %ProjectName: =%.json --docx %ProjectName: =%-appendix-a.docx --html %ProjectName: =%-appendix-a.html
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py cof-review %ProjectName: =%.json --html %ProjectName: =%-cof-review.html
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py  legal-review  %ProjectName: =%.json --html %ProjectName: =%-legal-review.html
call python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py license-file %ProjectName: =%.json --notice
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%.json C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\"%ProductName: =%".json
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%-appendix-a.docx C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\appendix-a_"%ProductName: =%".docx
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%-appendix-a.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\appendix-a_"%ProductName: =%".html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%-cof-review.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\cof-review_"%ProductName: =%".html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%-legal-review.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\legal-review_"%ProductName: =%".html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\NOTICE C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\NOTICE
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\LICENSE C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\LICENSE
exit/b

:executeBlackduckReportCommandsForReleaseBranch 
echo "inside release branch$$$$$$$"
echo %GIT_URL%
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py --build release generate-bom %ProjectName% %ProjectVersion: =% --out %ProjectName: =%.json --recursive --custom-fields --include-hidden-comps
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py cof-appendix %ProjectName: =%.json --docx %ProjectName: =%-appendix-a.docx --html %ProjectName: =%-appendix-a.html
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py cof-review %ProjectName: =%.json --html %ProjectName: =%-cof-review.html
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py  legal-review  %ProjectName: =%.json --html %ProjectName: =%-legal-review.html
python C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\bd_cli.py license-file %ProjectName: =%.json --notice
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%.json C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\"%ProductName: =%".json
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%-appendix-a.docx C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\appendix-a_"%ProductName: =%".docx
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%-appendix-a.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\appendix-a_"%ProductName: =%".html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%-cof-review.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\cof-review_"%ProductName: =%".html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\%ProjectName: =%-legal-review.html C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\legal-review_"%ProductName: =%".html
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\NOTICE C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\NOTICE
echo f | xcopy /f /y C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\LICENSE C:\Users\%Username%\Desktop\Blackduck_Workspace\bd-cli\Reports\Initial_Review_Documents\"%ProductName: =%"-all-documents\LICENSE
exit/b

:error
echo "Please resolve the rule violation first"
exit/b

:endOfBatch
