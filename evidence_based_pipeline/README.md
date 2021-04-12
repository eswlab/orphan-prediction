# Introduction

This repository contains the Evidence-Based pipeline for transcript assembly.
The whole pipeline is fully automated and the user only needs to provide a list of NCBI-SRA Run Accessions.
The pipeline steps are:

1. Download raw RNA-Seq data from NCBI-SRA
2. Perform transcript assembly using a choice of tools
3. Obtain splice-junctions using portcullis
4. Perform meta-assembly using mikado and use orfipy for identification of ORFs

Steps 1 and 2 are implemented with [pyrpipe](https://github.com/urmi-21/pyrpipe). 
The whole pipline is implemented in snakemake in order to be *parallelized over samples*.

**Minimum required input to the pipeline is a list of NCBI-SRA Run Accessions in the `srrids.txt`**

**Final output of the pipeline is the file `mikado.loci.gff3`, containing the final transcript assembly**


# Setting up tools

Please follow this section to correctly setup an environment to execute the pipeline.

## Setting up conda

1. The pipeline dependencies are available via the [bioconda]() channel. Please install [conda]() if not already present.
2. Make sure conda channels are set up correctly:

```
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

3. Build the conda environment present in the `environment.yaml` file:

```
conda env create -f environment.yaml
``` 

   _Note: Install portcullis seperately if you cannot install it successfully._
    
```
conda install -c bioconda portcullis
```


4. If using `class2` please execute the instructions in the `class2_instructions.sh` to setup `class2`

5. Mikado and orfipy steps are executed in a separate conda environment. This conda environment file is located in the `envs/` directory.

## Setting up pipeline

The main pipeline configuration file is `config.yaml`. Edit this file to change the pipeline behaviour such as reference genome, hisat2 index, output directoy, mikado and orfipy options.

### Prepare Arabidopsis thaliana reference data
If working with Arabidopsis thaliana, execute the script `prepare_data.sh` to download the reference genome and build a hisat2 index:

```
conda activate orphan_prediction
bash prepare_data.sh
```

Above command will create a directory, `reference_data`

Alternatively, you can download genome of your choice and build a hisat2 index. You need to edit `config.yaml` to specify which genome and index to use.

### Tool parameters
Edit the files under `params` directory to specify tools parameters. These files are automatically parsed by `pyrpipe`.
The parameters required by Mikado and orfipy are tunable via the `config.yaml` or the snakemake file.
 
# Executing the pipeline

## Using single node
To execute the pipeline on a single node use the following command:

```
snakemake -j 2 --use-conda --conda-frontend conda
```

Above command will execute the pipeline using 2 cores i.e. the transcript assembly step will run 2 samples in parallel.

## Scaling pipeline on HPC

To execute the pipeline on an HPC with mutiple nodes, execute as

```
snakemake -j 20 --profile snakemake_config/slurm --use-conda --conda-frontend conda
```

Above command will execute the pipeline ans schedule 20 jobs in parallel. 
The snakemake profile, `snakemake_config/slurm` could be modified to fine tune resource usage.
Above command is compatible for `SLURM` job-scheduler, you may need to change the parameters based on the system.
Specifically, edit the `snakemake_config/slurm/config.yaml` and `snakemake_config/slurm/cluster_config.yml`













