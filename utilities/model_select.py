import json
import sys
import pandas as pd
import numpy as np

# Warning - this script is not supposed to be used alone, but just in the index pipeline process !
# Usage: model_select.py <optimizer_out path> <-p if we want to print the table>

def print_table_fn(configs):
    keys = ['layers', 'branching factor', 'namespace', 'size', 'average log2 error', 'binary']

    # Print the table header
    print ("{:<4} {:<22} {:<18} {:<11} {:<20}".format('IDX', 'layers', 'branching factor', 'size (KB)', 'average log2 error'))
    len = 4+22+18+11+20
    print ("-"*len)

    # Print the table rows
    i = 0
    for item in configs:
        layer, bf, size, avg_log2 = item[keys[0]], item[keys[1]], item[keys[3]], item[keys[4]]
        print ("{:<4} {:<22} {:<18} {:<11} {:<20}".format(i, layer, bf, round(size/(1024*8)), avg_log2))
        i += 1

def heuristic(df_configs):
    avg_err = df_configs['average log2 error']
    size_kb = df_configs['size']/(1024*8)
    # Look fot the lower error
    min_err = (avg_err)
    # Give each model a score
    
    return


# Get arguments
optimizer_path = sys.argv[1]
if optimizer_path == sys.argv[-1]:
    print_table = False
else:
    print_table = True

# Load the JSON data from the file
with open(optimizer_path, 'r') as f:
    data = json.load(f)

if print_table:
    print_table_fn(data['configs'])

df = pd.DataFrame(data['configs'])

# Ask user which model do they want to build




# If nothing is provided, use heuristic







print(np.floor(df['average log2 error'])*np.log10(df['size']))
print(50331680/1024)