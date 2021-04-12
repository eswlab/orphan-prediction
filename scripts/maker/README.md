# Run MAKER 

- To simplify handling of files, combine all the forward reads to one file and all the reverse reads to another.
```bash
cat *_1.fastq.gz >> forward_reads.fq.gz
cat *_2.fastq.gz >> reverse_reads.fq.gz
```

- Run trinity to predict transcripts and their potential proteins from RNA-Seq alignment:

  1. Run trinity for _de novo_ transcriptome assembly:
     ```bash
     ./01_runTrinity.sh forward_reads.fq.gz reverse_reads.fq.gz 
     ```
     _Note: You will get the transcripts fasta file in trinity_run folder._

  2. Predict CDSs from transcriptome:
     ```bash
     ./02_runTransDecoder.sh trinity.fasta
     ```
     _Note: You will get the protein sequence (trinity.fasta.transdecoder.pep) in working directory._
  
- Run maker by five steps:

  1. Generate the CTL files:
     ```
     module load GIF/maker
     module rm perl/5.22.1
     maker -CTL
     ```
     This will generate 3 CTL files (`maker_opts.ctl`, `maker_bopts.ctl` and `maker_exe.ctl`), you will need to edit them to make changes to the MAKER run. For the first round, change these lines in `maker_opts.ctl` file:
     ```
     genome=TAIR10_chr_all.fas
     est=trinity.fasta
     protein=trinity-swissprot-pep.fasta
     est2genome=1
     protein2genome=1
     TMP=/dev/shm
     ```
     
  2. Execute MAKER ([03_maker_start.sh](03_maker_start.sh)) in a slurm file.  It is essential to request more than 1 node with multiple processors to run this efficiently.
     ```
     # Define a base name for maker output folder as the first argument.
     ./03_maker_start.sh maker_case
     ```
   
   3. Upon completion, train SNAP and AUGUSTUS:
      ```   
      Use the same base name as previous step for first argument.
      ./04_maker_process.sh maker_case
      ```
    
   4. Train GeneMark with genome sequence:
      ```bash
      05_runGeneMark.sh TAIR10_chr_all.fas
      ```
      
   5. Once complete, modify the following lines in `maker_opts.ctl` file:
      ```
      snaphmm=maker.snap.hmm
      gmhmm=gmhmm.mod
      # Define a species as you want, but the name should not be existing in the augustus/config/species folder.
      augustus_species=maker_20171103
      ```
     
      Then, run ([03_maker_start.sh](03_maker_start.sh)) again:
      ```
      # Use the same base name as previous step for first argument.
      ./03_maker_start.sh maker_case
      ```

   6. Finalize predictions: 
      ```bash
      06_maker_finalize.sh maker_case
      ```
      You will get the predicted gene models (`maker_case.gff`), protein sequences (`maker_case.maker.proteins.fasta`) and transcript sequence (`maker_case.maker.transcripts.fasta`) in the working directory.
