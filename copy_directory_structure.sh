#!/bin/bash

old_ifs=${IFS}
IFS=$'\n'

for directory in $( find . -maxdepth 3 -type d ); do
  new_directory=$( echo ${directory} | sed "s%\./%/home/mmeier/new/%" )
  echo "mkdir -p \"${new_directory}\""
  mkdir -p "${new_directory}"
done

IFS=${old_ifs}

exit 0

