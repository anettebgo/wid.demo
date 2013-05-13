#!/bin/bash

cat data.txt | ./mapper.R | ./reducer.R
