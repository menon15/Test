@echo off
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO "Entered the script for scanning the code"
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
::mkdir C:\Users\smenon\Desktop\Blackduck_Workspace
cd C:\Users\smenon\Desktop\Blackduck_Workspace
::curl.exe -sO https://artifactory.analog.com:443/artifactory/see-generic/adi/see/blackduck/synopsys-detect-9.0.0-air-gap.zip
::tar -xf synopsys-detect-9.0.0-air-gap.zip
java -jar C:\Users\smenon\Desktop\Blackduck_Workspace\synopsys-detect-9.0.0.jar ^
--blackduck.url=https://analog.app.blackduck.com ^
--blackduck.api.token=NzlkMmFjZDItZDk5Ny00YTIxLTk5ODctZDVkNWEzYTYzNjY0OjQ5M2Y3OTY0LWFlMmEtNGExNy1hY2FiLWFmYjUyMmQ2MDM3NQ== ^
--detect.project.name="OSPO_Test-Sankalpa-4-4-2024" ^
--detect.project.version.name=main ^
--detect.source.path="C:\Users\SMenon\Desktop\Test" ^
--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING ^
--detect.blackduck.signature.scanner.individual.file.matching=BINARY ^
--detect.blackduck.signature.scanner.license.search=true ^
--detect.blackduck.signature.scanner.copyright.search=true ^
--detect.excluded.detector.types=GIT ^
--detect.detector.search.depth=5 ^
--detect.detector.search.continue=true
exit 0
