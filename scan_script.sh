echo "Entered the script for scanning the code"
RUN --detect.project.name="OSPO_Test-Sankalpa-4-4-2024"
RUN --detect.project.version.name=master
RUN --detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING
RUN --detect.blackduck.signature.scanner.individual.file.matching=BINARY
RUN --detect.blackduck.signature.scanner.license.search=true
RUN --detect.blackduck.signature.scanner.copyright.search=true
RUN --detect.excluded.detector.types=GIT
RUN --detect.detector.search.depth=5
RUN --detect.detector.search.continue=true
