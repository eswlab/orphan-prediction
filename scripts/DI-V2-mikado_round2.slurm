  
#!/bin/bash
#SBATCH -N 1
#SBATCH --ntasks-per-node=96
#SBATCH -t 500:00:00
#SBATCH --partition=biocrunch
#SBATCH -J mikado_2
#SBATCH -o mikado_2.o%j
#SBATCH -e mikado_2.e%j

source ~/.bashrc
source /path/to/bin/Anaconda3/etc/profile.d/conda.sh
conda activate mikado2

# complete.cds.bed is the output from transdecoder
mikado serialise \
   --start-method spawn \
   --procs 96 \
   --json-conf configuration.yaml \
   --orfs complete.cds.bed \
   -mr 1 \
   -od DI-V2



mikado pick \
   --start-method spawn \
   --procs 96 \
   --json-conf configuration.yaml \
   --subloci-out mikado.subloci.gff3 \
   --pad \
   -od DI-V2
