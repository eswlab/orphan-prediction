import os,sys

orthogroup_freq_filename = sys.argv[1]
orthogroup_filename = sys.argv[2]
mind_bind_filename = sys.argv[3]
single_orthologue_filename = sys.argv[4]

orthogroup_freq_file = open(orthogroup_freq_filename, "r")
orthogroup_file = open(orthogroup_filename, "r")
mind_bind_file = open(mind_bind_filename, "r")
single_orthologue_file = open(single_orthologue_filename, "r")

first_line = orthogroup_freq_file.readline()
first_line_1 = orthogroup_file.readline()
first_line_2 = single_orthologue_file.readline()
fasta_ids = []
for line in mind_bind_file:
    if line[0] != ">":continue
    fasta_id = line.strip().split(">")[1].split()[0].replace("'","")
    #print (fasta_id)
    fasta_ids.append(fasta_id)
#print (fasta_ids)
og_to_genes = {}
for line_1 in orthogroup_file:
    og = line_1.strip().split("\t")[0]
    genes = [elem.strip(',').replace("'","") for elem in line_1.strip().split()[1:]]
    #print (og)
    #print (genes) 
    if og not in og_to_genes:
        og_to_genes[og] = genes
#print (og_to_genes)
        
og_to_freq = {}
for line_2 in orthogroup_freq_file:
    og, an1, c24, cvi, eri1, kyo, ler, sha, col0, total = line_2.strip().split("\t")
    #print (og)
    #if col0 <= 0:continue
    if og not in og_to_freq:
        og_to_freq[og] = [int(an1), int(c24), int(cvi), int(eri1), int(kyo), int(ler), int(sha)]
#print (og_to_freq)

print ("Predicted_genes"+"\t"+"Orthologs in An-1 population"+"\t"+"Orthologs in C24 population"+"\t"+"Orthologs in Cvi population"+"\t"+"Orthologs in Eri1 population"+"\t"+"Orthologs in Kyo population"+"\t"+"Orthologs in Ler population"+"\t"+"Orthologs in Sha population")
for og in og_to_genes:
    for fasta_id in fasta_ids:
        if fasta_id in og_to_genes[og]:
            print (fasta_id+"\t"+"\t".join(map(str,og_to_freq[og])))

single_copy_genes = []
for line_3 in single_orthologue_file:
    genes = line_3.strip()
    single_copy_genes.append(genes)
    print (genes+"\t"+str(0)+"\t"+str(0)+"\t"+str(0)+"\t"+str(0)+"\t"+str(0)+"\t"+str(0)+"\t"+str(0))


    
               
