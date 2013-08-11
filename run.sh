#!/bin/bash

rm *.tmp
cat data.txt | ./mapper.R | sort | ./reducer.R
