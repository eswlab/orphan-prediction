# Run MAKER 

- Run trinity to predict transcripts from RNA-Seq alignment:
- 

For running MAKER, you will need:


1. Genome assembly in fasta format, eg: `TAIR10_chr_all.fas `
2. Trinity assembled transcripts form the SRA datasets, eg: `trinity.fasta`
3. Trinity transcripts translated to proteins, combined with curated proteins dataset, eg:`trinity-swissprot-pep.fasta`

Here are the steps in detail. generate the CTL files:

```
module load GIF/maker
module rm perl/5.22.1
maker -CTL
```

This will generate 3 CTL files (`maker_opts.ctl`, `maker_bopts.ctl` and `maker_exe.ctl`), you will need to edit them to make changes to the MAKER run.
For the first round, change these lines in `maker_opts.ctl` file:

```
genome=TAIR10_chr_all.fas
est=trinity.fasta
protein=trinity-swissprot-pep.fasta
est2genome=1
protein2genome=1
TMP=/dev/shm
```

Execute MAKER in a slurm file as shown.  It is essential to request more than 1 node with multiple processors to run this efficiently.

```
mpiexec \
	-n 64 \
	/work/GIF/software/programs/maker/2.31.9/bin/maker \
	-base maker \
	-fix_nucleotides
```

Upon completion, train SNAP, AUGUSTUS and Pre-trained GeneMark to run the second round using [script](scripts/maker_process.sh)

```bash
# process first round results and train SNAP/AUGUSTUS
maker_process.sh maker
# train GeneMark
runGeneMark.sh TAIR10_chr_all.fas
```


Once complete, the second round of MAKER is run by modifying the following lines in `maker_opts.ctl` file:


```
snaphmm=maker.snap.hmm
gmhmm=gmhmm.mod
augustus_species=maker_20171103
```

and run MAKER as:

```bash
mpiexec \
	-n 64
	/work/GIF/software/programs/maker/2.31.9/bin/maker \
	-base maker \
	-fix_nucleotides
```

finalize predictions using [`maker_finalize.sh`](scripts/maker_finalize.sh) script.

```bash
maker_finalize.sh maker
```
