import os, glob, sys

run_filename = sys.argv[1]
salmon_converged_filename = sys.argv[2]
run_file = open(run_filename, "r")
salmon_converged_file = open(salmon_converged_filename, "w")
gene_to_count = {}
run_list = []
for line in run_file:
    run = line.strip()
    run_list.append(run)
    salmon_quant_file = open("/work/LAS/mash-lab/bhandary/bind_prediction_expression/salmon_quant/"+run+"_salmon/quant.sf")
    first_line = salmon_quant_file.readline()
    for line_1 in salmon_quant_file:
        #if "TPM" in line:continue
        gene = line_1.strip().split("\t")[0]
        tpm = line_1.strip().split("\t")[3]
        if gene not in gene_to_count:
            gene_to_count[gene] = []
        gene_to_count[gene].append(tpm)
        

salmon_converged_file.write("Gene"+"\t"+"\t".join(run_list)+"\n")
for gene in gene_to_count:
    salmon_converged_file.write(gene+"\t"+"\t".join(gene_to_count[gene])+"\n")
