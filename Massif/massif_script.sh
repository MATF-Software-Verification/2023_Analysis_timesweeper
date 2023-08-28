#!/bin/bash

# Generate Makefile using qmake for timesweeper
qmake -o ../06-timesweeper/build-timesweeper-Desktop-Release/Makefile ../06-timesweeper/timesweeper/timesweeper.pro

# Build the project using the generated Makefile
make -C ../06-timesweeper/build-timesweeper-Desktop-Release


# Run massif for heap on timesweeper
valgrind --tool=massif --massif-out-file=massif_script_heap.out ../06-timesweeper/build-timesweeper-Desktop-Release/timesweeper

# Format the massif output
ms_print massif_script_heap.out > massif_script_heap.txt

# Run massif for stack on timesweeper
valgrind --tool=massif --stacks=yes --massif-out-file=massif_script_stack.out ../06-timesweeper/build-timesweeper-Desktop-Release/timesweeper

# Format the massif output
ms_print massif_script_stack.out > massif_script_stack.txt