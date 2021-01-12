### Running OrthoFinder on your predictions
Once you have protein files, one requires only to save these files in a folder and provide it to OrthoFinder.

### Input files needed:
1. Protein files of the species on which OrthoFinder needs to be run (present in one folder)

### Programs needed:
1. OrthoFinder
2. Other programs specified in the OrthoFinder github page (https://github.com/davidemms/OrthoFinder)

### Methods
```
module load orthofinder
orthofinder -f /path/to/protein_files/ -S diamond
```
### Output

With the above command, the output files will be generated in the folder which contain the protein files. The 'OrthoFinder' folder will be produced, within which a folder 'Results_{Date_of_run}' which contains all the outputs files. For finding the genes that are only present in one of the species, the files are in the folder 'Orthogroups'. Within this folder, the files are 
```
Orthogroups.GeneCount.tsv
Orthogroups_SingleCopyOrthologues.txt
Orthogroups.tsv
Orthogroups.txt
Orthogroups_UnassignedGenes.tsv
```
These files help in deducing the number of orthogroups and the genes that belong to the orthogroups (Orthogroups.tsv, Orthogroups.txt) , the number of genes from each species that belong to each of those orthogroups (Orthogroups.GeneCount.tsv) and the genes that belong only to a particular species (Orthogroups_UnassignedGenes.tsv).

A in house script was used to create a table that has each of the predicted genes in Arabidopsis as rows and the number of orthologs in the seven populations of Arabidopsis as columns (Each column is one population).


