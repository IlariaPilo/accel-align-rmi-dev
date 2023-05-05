#!/bin/bash

################################### INTRO ###################################

# Check if the user has provided an argument
if [ $# -eq 0 ]; then
    echo -e "\n\033[1;35m\tbash index.sh <reference.fna> [<thread_number>]\033[0m"
    echo -e "Builds a learned index for the <reference.fna> reference string.\n"
    echo -e "Use <thread_number> to specify the number of threads to be used. If not specified, it will be set to the number of available CPUs.\n"
    exit
fi

ref_name=$1                                 # ./data/hg37.fna
ref_name=$(realpath $ref_name)
# The output file will be
dir_name=$(dirname $ref_name)               # ./data
base_name=$(basename $ref_name .fna)        # hg37

# Make output directory
OUTPUT_DIR="${dir_name}/${base_name}_index" # hg37_index
OUTPUT_DIR=$(realpath $OUTPUT_DIR)

# TODO - possibly add a prefix
mkdir -p $OUTPUT_DIR

keys_name="${OUTPUT_DIR}/keys_uint32"       # hg37_index/keys_unit32

# Get number of threads
if [ $# -eq 1 ]; then
  # Use default number
  thread_number=$(nproc --all)
else
  thread_number=$2
fi

echo -e "\n\033[1;35m [index.sh] \033[0mBuilding index on file $ref_name"
echo -e "            --- Using $thread_number threads.\n"

################################### KEY_GEN ###################################

echo -e "\n\033[1;35m [index.sh] \033[0mCompiling the key_gen program..."
make bin/key_gen
echo "DONE"

cd $OUTPUT_DIR                             # ----> NOW WE ARE IN hg37_index/keys_unit32

echo -e "\n\033[1;35m [index.sh] \033[0mRunning key_gen..."
if [ ! -e $keys_name ]; then
  # The file does not exist, so execute the command
  #../bin/key_gen $ref_name
  echo LOL
else
  # The file exists, so ask the user before executing
  read -ep $'\033[1;33m [index.sh] \033[0mkey_gen output already exists. Do you want to execute the command anyway? [y/n]' choice
  case "$choice" in 
    y|Y ) 
      ../bin/key_gen $ref_name 
      ;;
    * ) 
      echo -e "\033[1;33m [index.sh] \033[0mcommand not executed" ;;
  esac
fi

echo "DONE"

# keys_name=$(realpath $keys_name)

################################### INDEX ###################################

echo -e "\n\033[1;35m [index.sh] \033[0mBuilding the index..."
# Build the index - if it has not being compiled yet
if [ ! -e ../rmi/target/release/rmi ]; then
  cd ../rmi && cargo build --release
  cd $OUTPUT_DIR
fi

cp ../rmi/target/release/rmi .
echo "DONE"

# Run RMI optimization
./rmi --threads $thread_number --optimize optimizer_out.json ./keys_unit32

