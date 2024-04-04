!/bin/sh
echo "Entered the script for scanning the code"
java -jar /opt/osposcan/jenkins_home/tools/com.synopsys.integration.jenkins.detect.extensions.tool.DetectAirGapInstallation/synopsys_detect/synopsys-detect-9.0.0.jar \
--detect.project.name="OSPO_Test-Sankalpa-4-4-2024" \
--detect.project.version.name=master \
--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING \
--detect.blackduck.signature.scanner.individual.file.matching=BINARY \
--detect.blackduck.signature.scanner.license.search=true \
--detect.blackduck.signature.scanner.copyright.search=true \
--detect.excluded.detector.types=GIT \
--detect.detector.search.depth=5 \
--detect.detector.search.continue=true \
