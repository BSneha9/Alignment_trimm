import sys
from Bio import SeqIO

FastaFile = open(sys.argv[1], 'r')
FastaDroppedFile = open(sys.argv[2], 'w')
drop_cutoff = float(sys.argv[3])

## List of specific names to retain (unless gap count is 100%)
## Picked these samples comparativel less they had less than ~50 genes found
retain_names = []

if (drop_cutoff > 1) or (drop_cutoff < 0):
    print('\n Sequence drop cutoff must be in 0-1 range!\n')
    sys.exit(1)

for seqs in SeqIO.parse(FastaFile, 'fasta'):
    name = seqs.id
    seq = seqs.seq
    seqLen = len(seqs)
    gap_count = 0
    
    for z in range(seqLen):
        if seq[z] == '-':
            gap_count += 1
        if seq[z] == 'Ns':
            gap_count += 1
        if seq[z] == '?':
            gap_count += 1
    
    gap_per = gap_count / float(seqLen)
    
    # Check if the name is in the list
    if name in retain_names:
        # Retain unless gap count is 100% is gap
        if gap_per < 1.0:
            SeqIO.write(seqs, FastaDroppedFile, 'fasta')
            print(f' {name} was retained due to specific name match.')
        else:
            print(f' {name} was removed due to 100% gaps.')
    elif gap_per >= drop_cutoff:
        print(f' {name} was removed. Gap count = {gap_per}')
    else:
        SeqIO.write(seqs, FastaDroppedFile, 'fasta')

FastaFile.close()
FastaDroppedFile.close()
