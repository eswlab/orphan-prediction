# Running Mikado

## Map RNAseq reads

Map RNAseq reads using HiSat2 [`runHisat2.sh`](../scripts/runHisat2.sh)
  

## Assemble transcritps

Assemble transcritps using all the transcript assemblers as described in the main-page.

        - [`runTrinity-gg.sh`](../scripts/runTrinity-gg.sh)
        - [`runClass2.sh`](../scripts/runClass2.sh)
        - [`runCufflinks.sh`](../scripts/runCufflinks.sh)
        - [`runStringtie.sh`](../scripts/runStringtie.sh)

## Run Portcullis

From the mapped bam files, run PortCullis: [`runPortCullis.sh`](scripts/runPortCullis.sh)

## Run Mikado configure and prepare:

```bash
#!/bin/bash
export PATH="/home/aseethar/miniconda3/bin:$PATH"
source activate mikado
list=list.txt
genome=TAIR10_chr_all.fas
junctions=portcullis_filtered.pass.junctions.bed

mikado configure \
   --list $list \
   --reference $genome \
   --mode permissive \
   --scoring plants.yaml \
   --copy-scoring plants.yaml \
   --junctions $junctions configuration2.yaml

mikado prepare \
   --json-conf configuration2.yaml

```

## Run BLAST

The prepared mikado transcritps can now be used to run BLAST against the genome using [`runBLASTx.sh`](../scripts/runBLASTx.sh) script

## Run TransDecoder

The prepared mikado transcritps can also be used to run TransDecoder to predict ORFs using [`runTransDecoder.sh`](../scripts/runTransDecoder.sh) script


## Run Mikado pick

The `plants.yaml` and `configuration.yaml` is updated and mikado Pick is ran as follows:

```bash
#!/bin/bash
export PATH="/home/aseethar/miniconda3/bin:$PATH"
source activate mikado
list=list.txt
genome=TAIR10_chr_all.fas
junctions=portcullis_filtered.pass.junctions.bed
orfs=mikado_prepared.fasta.transdecoder.bed
blastxml=mikado.blast.xml

mikado serialise \
   --start-method spawn \
   --procs 28 \
   --blast_targets ${genome} \
   --json-conf configuration2.yaml \
   --xml ${blastxml} \
   --orfs ${orfs}

mikado pick \
   --start-method spawn \
   --procs 28 \
   --json-conf configuration2.yaml \
   --subloci_out mikado.subloci.gff3
```
