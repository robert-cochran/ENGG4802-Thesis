#!/bin/bash
FILES=./*
for f in $FILES
do
  echo "$f"
  # take action on each file. $f store current file name
  #file_name = ${f:2:4} # starts at 2 character and goes for 4 long
  #sub_dir = "./$file_name/$file_name"
  mkdir "./${f:2}/${f:2}"
  mv "./$f/$f.wav" "./$f/$f"

done
