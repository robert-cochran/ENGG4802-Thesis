#!/bin/bash
FILES=./*
for f in $FILES
do
  echo "$f"
  # take action on each file. $f store current file name
  file_name = ${f:2:4}
  sub_dir = "./$file_name/$file_name"
  mkdir sub_dir
  #mv $f ${f:2:4}

done
