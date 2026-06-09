#!/bin/bash

usage() {
    echo ""
    echo "Usage: $0 -i <alignment_dir> -o <out_dir> -t <trimmer.py> -n <suffix> -g <thresh_gap>"
    echo ""
    echo "  -i  Directory containing input fasta files"
    echo "  -o  Output directory for trimmed files"
    echo "  -t  Path to trimmer.py script"
    echo "  -n  Suffix of input files (e.g. _TRIMMED.fasta)"
    echo "  -g  Gap threshold (0-1, default: 0.70)"
    echo ""
    exit 1
}

# default thresh
thresh_gap=0.70

# --- Parse arguments ---
while getopts "i:o:t:n:g:" opt; do
    case $opt in
        i) alignment_dir="$OPTARG" ;;
        o) out_dir="$OPTARG" ;;
        t) trimmer="$OPTARG" ;;
        n) suffix="$OPTARG" ;;
        g) thresh_gap="$OPTARG" ;;
        *) usage ;;
    esac
done

# check arguments
if [ -z "$alignment_dir" ] || [ -z "$out_dir" ] || [ -z "$trimmer" ] || [ -z "$suffix" ]; then
    echo "ERROR! Need to provide -i, -o, -t, and -n parameters"
    usage
fi


# make out dir if it does not exist
mkdir -p "$out_dir"


# get file names
files=()
for f in "$alignment_dir"/*"$suffix"; do
    base=$(basename "$f" "$suffix")
    files+=("$base")
done


# Main loop
for ((i = 0; i < ${#files[@]}; i++)); do
    input_file="$alignment_dir/${files[i]}${suffix}"
    output_file="$out_dir/${files[i]}_TRIMMED_new.fasta"

    if [ -e "$input_file" ]; then
        echo "Working on: ${files[i]}"
        python3 "$trimmer" "$input_file" "$output_file" "$thresh_gap"
        echo "Trimming completed for: ${files[i]}"
    else
        echo "Input file not found for: ${files[i]}. Skipping."
    fi
done

## Puts all sequence in fasat file in one line - 
cd "$out_dir"
for f in "$out_dir"/*.fasta; do
    seqtk seq -A $f > ${f}_TRIMMED_2.fasta
    rm $f
done
