!/bin/sh
Echo "Entered the script for scanning the code"
--detect.project.name="OSPO_Test-Sankalpa-4-4-2024"
--detect.project.version.name=master
--detect.blackduck.signature.scanner.snippet.matching=SNIPPET_MATCHING
--detect.blackduck.signature.scanner.individual.file.matching=BINARY
--detect.blackduck.signature.scanner.license.search=true
--detect.blackduck.signature.scanner.copyright.search=true
--detect.excluded.detector.types=GIT
--detect.detector.search.depth=5
--detect.detector.search.continue=true
