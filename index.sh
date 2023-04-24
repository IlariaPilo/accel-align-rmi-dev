#!/bin/bash

# Check if the user has provided an argument
if [ $# -eq 0 ]; then
    echo -e "\n\033[1;35m\tbash index.sh <reference.fna>\033[0m"
    echo -e "Builds a learned index for the <reference.fna> reference string.\n"
    exit
fi
ref_name=$1
echo -e "\n\033[1;35m [index.sh] \033[0mBuilding index on file $ref_name\n"

echo -e "\n\033[1;35m [index.sh] \033[0mCompiling the key_gen program..."
make
echo "DONE"

echo -e "\n\033[1;35m [index.sh] \033[0mRunning key_gen..."
./bin/key_gen $ref_name
echo "DONE"

# The output file will be
keys_name="${ref_name}_keys_uint32"

# Build the index
echo -e "\n\033[1;35m [index.sh] \033[0mBuilding the index..."
cd rmi
cargo run --release -- $keys_name my_first_rmi linear,linear 100
echo "DONE"

