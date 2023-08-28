#!/bin/bash

# Generate Makefile using qmake for timesweeper
qmake -o ../06-timesweeper/build-timesweeper-Desktop-Release/Makefile ../06-timesweeper/timesweeper/timesweeper.pro

# Build the project using the generated Makefile
make -C ../06-timesweeper/build-timesweeper-Desktop-Release


# Run memcheck on timesweeper
valgrind --leak-check=full --track-origins=yes --log-file=memcheck_output_script.txt ../06-timesweeper/build-timesweeper-Desktop-Release/timesweeper
