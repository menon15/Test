@echo off
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
ECHO "Entered the script for scanning the code"
ECHO ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
curl.exe -sO https://artifactory.analog.com:443/artifactory/see-generic/adi/see/blackduck/synopsys-detect-9.0.0-air-gap.zip
tar -xf synopsys-detect-9.0.0-air-gap.zip
java -jar synopsys-detect-9.0.0.jar \
--detect.project.name="OSPO_Test-Sankalpa-4-4-2024" \
--detect.project.version.name=master \
--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING \
--detect.blackduck.signature.scanner.individual.file.matching=BINARY \
--detect.blackduck.signature.scanner.license.search=true \
--detect.blackduck.signature.scanner.copyright.search=true \
--detect.excluded.detector.types=GIT \
--detect.detector.search.depth=5 \
--detect.detector.search.continue=true \
pause
