#!/bin/bash

# Check if the user has provided an argument
if [ $# -eq 0 ]; then
    echo -e "\n\033[1;35m\tbash index.sh <reference.fna>\033[0m"
    echo -e "Builds a learned index for the <reference.fna> reference string.\n"
    exit
fi

ref_name=$1
# The output file will be
base_name=$(basename $ref_name .fna)
keys_name="${base_name}_keys_uint32"

echo -e "\n\033[1;35m [index.sh] \033[0mBuilding index on file $ref_name\n"

echo -e "\n\033[1;35m [index.sh] \033[0mCompiling the key_gen program..."
make
echo "DONE"

echo -e "\n\033[1;35m [index.sh] \033[0mRunning key_gen..."
if [ ! -e $keys_name ]; then
  # The file does not exist, so execute the command
  ./bin/key_gen $ref_name
else
  # The file exists, so ask the user before executing
  read -p "\033[1;33m [index.sh] \033[0mkey_gen output already exists. Do you want to execute the command anyway? [y/n]" choice
  case "$choice" in 
    y|Y ) 
      ./bin/key_gen $ref_name ;;
    * ) 
      echo "\033[1;33m [index.sh] \033[0mcommand not executed" ;;
  esac
fi

echo "DONE"

# Build the index
echo -e "\n\033[1;35m [index.sh] \033[0mBuilding the index..."
cd rmi
cargo run --release -- $keys_name my_first_rmi linear,linear 100
echo "DONE"

