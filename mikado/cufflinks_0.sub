#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=16
#SBATCH -t 96:00:00
#SBATCH -J cufflinks_0
#SBATCH -o cufflinks_0.o%j
#SBATCH -e cufflinks_0.e%j
#SBATCH --mail-user=arnstrm@gmail.com
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
cd $SLURM_SUBMIT_DIR
ulimit -s unlimited
module use /work/GIF/software/modules
module use /work/GIF/software/modules
module use /opt/rit/spack-modules/lmod/linux-rhel7-x86_64/Core
module use /opt/rit/spack-modules/lmod/linux-rhel7-x86_64/gcc

module load samtools
module load cufflinks
cufflinks -o merged_better_and_best -p 16 --multi-read-correct --frag-bias-correct TAIR10_chr_all.fas merged_better_and_best.bam
scontrol show job $SLURM_JOB_ID
