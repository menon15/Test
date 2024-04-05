@echo off
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO "Entered the script for scanning the code"
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
mkdir C:\Users\smenon\Desktop\Blackduck_Workspace
cd C:\Users\smenon\Desktop\Blackduck_Workspace
curl.exe -sO https://artifactory.analog.com:443/artifactory/see-generic/adi/see/blackduck/synopsys-detect-9.0.0-air-gap.zip
tar -xf synopsys-detect-9.0.0-air-gap.zip
C:\Program Files\Eclipse Adoptium\jdk-17.0.10.7-hotspot\bin\java.exe -jar C:\Users\smenon\Desktop\Blackduck_Workspace\synopsys-detect-9.0.0.jar \
--detect.project.name="OSPO_Test-Sankalpa-4-4-2024" \
--detect.project.version.name=master \
--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING \
--detect.blackduck.signature.scanner.individual.file.matching=BINARY \
--detect.blackduck.signature.scanner.license.search=true \
--detect.blackduck.signature.scanner.copyright.search=true \
--detect.excluded.detector.types=GIT \
--detect.detector.search.depth=5 \
--detect.detector.search.continue=true \
