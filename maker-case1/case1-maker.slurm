#!/bin/bash
#SBATCH -J case1
#SBATCH -N 4
#SBATCH --ntasks=64
#SBATCH -t 24:00:00
#SBATCH -o maker.o%j
#SBATCH -e maker.e%j
#SBATCH --mail-user=arnstrm@gmail.com
#SBATCH --mail-type=begin
#SBATCH --mail-type=end
cd $SLURM_SUBMIT_DIR
ulimit -s unlimited
module unuse /shared/software/GIF/modules
module purge
module load GIF/maker
module rm perl/5.22.1
/work/GIF/software/programs/mpich2/3.2/bin/mpiexec -n 64 /work/GIF/software/programs/maker/2.31.9/bin/maker -base case1 -fix_nucleotides

