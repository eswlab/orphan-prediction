# Running MAKER


Generate the CTL files:

```
module load GIF/maker
module rm perl/5.22.1
maker -CTL
```

Edit them to make changes. For the first round, change these lines in `maker_opts.ctl` file:

```
genome=TAIR10_chr_all.fas #genome sequence (fasta file or fasta embeded in GFF3 file)
est=minimal_transcripts.fasta
protein=minimal_transcripts.fasta.transdecoder.pep
est2genome=1 #infer gene predictions directly from ESTs, 1 = yes, 0 = no
protein2genome=1 #infer predictions from protein homology, 1 = yes, 0 = no
TMP=/dev/shm #specify a directory other than the system default temporary directory for temporary files
```

Execute MAKER in a slurm file as shown [here](case6-maker.slurm).

```
/work/GIF/software/programs/mpich2/3.2/bin/mpiexec -n 64 /work/GIF/software/programs/maker/2.31.9/bin/maker -base case1 -fix_nucleotides
```

Upon completion, train SNAP, AUGUSUTS and Pre-trained GeneMark to run the second round using [script](../scripts/maker_process.sh)

```bash
/maker_process.sh case6
```

Once compelte, second round MAKER is run by modifying these lines in `maker_opts.ctl` file:


```
#-----Gene Prediction
snaphmm=case6.snap.hmm #SNAP HMM file
gmhmm=/work/LAS/mash-lab/arnstrm/20170320_ArabidopsosGenePrediction_as/04_maker/common_files/gmhmm.mod #GeneMark HMM file
augustus_species=case6_20171103  #Augustus gene prediction species model
```

and run MAKER as:

```bash
/work/GIF/software/programs/mpich2/3.2/bin/mpiexec -n 64 /work/GIF/software/programs/maker/2.31.9/bin/maker -base case6 -fix_nucleotides
```

finalize perdictions using [`maker_finalize.sh`](../scripts/maker_finalize.sh) script.

```bash
maker_finalize.sh case6
```
