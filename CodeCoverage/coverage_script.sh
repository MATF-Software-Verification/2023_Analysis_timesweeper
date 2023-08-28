#!/bin/bash

# Generate Makefile using qmake for TimesweeperUnitTests
qmake -o ../build-TimesweeperUnitTests-Desktop-Release/Makefile ../TimesweeperUnitTests/TimesweeperUnitTests.pro

# Build the project using the generated Makefile
make -C ../build-TimesweeperUnitTests-Desktop-Release

# Make the TimesweeperUnitTests executable
chmod +x ../build-TimesweeperUnitTests-Desktop-Release/TimesweeperUnitTests

# Run the tests
../build-TimesweeperUnitTests-Desktop-Release/TimesweeperUnitTests

# Run lcov on the generated .gcno and .gcda
lcov -d ../build-TimesweeperUnitTests-Desktop-Release/ -c -o coverage_script.info

# Remove all the unnecessary files from the coverage
lcov -r "coverage_script.info" "*Qt*.framework*" "*.h" "*/tests/*" "*Xcode.app*" "*.moc" "*moc_*.cpp" "*/test/*" "*/build*/*" -o "coverage-filtered_script.info"

# Write out the coverage as html
genhtml -o coverage_script_html coverage-filtered_script.info
