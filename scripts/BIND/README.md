# BIND Prediction

Merge gene predictions of **B**RAKER (`braker-final.gff3`) with gene predictions **IN**ferred **D**irectly (`DI-final.gff3`).

_Note: See the details to generate these two predictions in `brake` and `DirectInf`._

- Consolidate all the transcripts from `braker-final.gff3` and `DI-final.gff3`, and predict potential protein coding sequence by Mikado:

  1. Make a configure file and prepare transcripts 

     You should prepare a `list_BIND.txt` as below to include gtf path (1st column), gtf abbrev (2nd column), stranded-specific or not (3rd column): 
     ```
     braker-final.gff3    br    False
     DI-final.gff3 DI     False
     ```
     
     Then run the script as below:
     ```bash
     ./01_runMikado_round1.sh TAIR10_chr_all.fas junctions.bed list_BIND.txt BIND
     ```

     This will generate `BIND_prepared.fasta` file that will be used for predicting ORFs in the next step.
     
     _Note: `junctions.bed` is the same file generate from DirectInf step._
     
  2. Predict potential CDS from transcripts:
     ```bash
     ./02_runTransDecoder.sh BIND_prepared.fasta
     ```
     
     We will use `BIND_prepared.fasta.transdecoder.bed` in the next step.
     
     _Note: Here we only kept complete CDS for next step. You can revise `02_runTransDecoder.sh` to use both incomplete and complete CDS if you need._
     
  3. Pick best transcripts for each locus and annotate them as gene:
     
     ```
     ./03_runMikado_round2.sh BIND_prepared.fasta.transdecoder.bed BIND
     ```
     This will generate:
     ```
     mikado.metrics.tsv
     mikado.scores.tsv
     BIND.loci.gff3
     ```
     
- Optional: Filter out transcripts with redundant CDS:
  ```
  ./04_rm_redundance.sh BIND.loci.gff3 TAIR10_chr_all.fas
  ```
  
 - Optional: Filter out transcripts whose predicted proteins mapped to transposon elements:
   ```
   ./05_TEsorter.sh filter.pep.fa BIND.loci.gff3
   ```
   
   _Note: `filter.pep.fa` is an output from previous step for removing redundant CDSs. You can also use all protein sequence if you don't want to remove redundant CDSs._
 
   

