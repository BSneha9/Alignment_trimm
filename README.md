

# Alignemnt_Trimm 
## Remove sequences with gaps from MSA


This script filters sequences from a FASTA file based on the percentage of gaps or ambiguous bases (N, -, or ?). 

It removes sequences with a gap percentage higher than a specified threshold unless the sequence name is in a pre-defined list of names to retain that is listed in the `trimmer.py` script (therefore the gap threhold set would not not apply for these samples listed).

This script can be useful for cleaning up sequence data before further analysis by removing sequences with excessive gaps or poor quality data.
but also whne you would like to retain small fragmented sequences for poor samples. 



## Original code taken from 
    - https://www.biostars.org/p/434389/

## Environemnt
create a conda environemnt and install Biopython
```bash
pip install biopython
```

## File trimmer.py 
```python
## list the sample names (as written in the header on the fasta file) that you want to exclude from the thresholding 
## edit the trimmer.py file to include these sample names
retain_names = ["Zygaena_araxis-shahkuhica_AH4","Zygaena_brizae-brizae_Lep0246"]

```


## File TRIMM.sh

The `TRIMM.sh` script loops through all FASTA files in a given directory that match a specified suffix and performs gap-based sequence trimming using `trimmer.py`. 


### Usage
```bash
qsub TRIMM.sh -i  -o  -t  -n  -g 
```
```
thresh - Set between 0-1!
0.3 --> removes seq with more than 30$ gaps
0.6 --> removes seq with more than 60% gaps
```

### Example
```bash
qsub TRIMM.sh -i /path/to/alignments \     ## path to folder containing input fasta files
              -o /path/to/output \         ## Will make the output dir if not exisitng         
              -t /path/to/trimmer.py \     ## path to timmer.py
              -n _TRIMMED.fasta \          ## Suffix of the alignment files in the input directory
              -g 0.70                      ##  default will be set to 0.7 if not provided
```

#### Or...
```bash
bash TRIMM.sh -i /path/to/alignments \     ## path to folder containing input fasta files
              -o /path/to/output \         ## Will make the output dir if not exisitng         
              -t /path/to/trimmer.py \     ## path to timmer.py
              -n _TRIMMED.fasta \          ## Suffix of the alignment files in the input directory
              -g 0.70                      ## default will be set to 0.7 if not provided
```


