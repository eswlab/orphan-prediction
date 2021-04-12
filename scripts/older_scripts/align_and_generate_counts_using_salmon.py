import os

def main():
    all_samples=open("/work/LAS/mash-lab/bhandary/bind_prediction_expression/all_samples_5210","r").read().split("\n")
    i=0

    cmd="salmon "
    cmd+=" index -t /work/LAS/mash-lab/bhandary/bind_prediction_expression/salmon_quant/gentrome.fa "
    cmd+=" -d /work/LAS/mash-lab/bhandary/bind_prediction_expression/salmon_quant/decoys.txt "
    cmd+=" -p 64 "
    cmd+=" -i /work/LAS/mash-lab/bhandary/bind_prediction_expression/salmon_quant/salmon_index "
    cmd+=" --keepDuplicates "
    #print(cmd)
    os.system(cmd)
    
    #return
    while True:
        if i>len(all_samples):break
        open("/work/LAS/mash-lab/bhandary/bind_prediction_expression/all_samples_5210_temp","w").write("\n".join(all_samples[i:i+5]))
        
        for Run in all_samples[i:i+5]:
            
            cmd="salmon quant "
            cmd+=" -i /work/LAS/mash-lab/bhandary/bind_prediction_expression/salmon_quant/salmon_index "
            cmd+=" -l A "
            cmd+=" -p 64 "
            cmd+=" --validateMappings "
            cmd+=" --gcBias "
            cmd+=" --noBiasLengthThreshold "
            cmd+=" -1 /work/LAS/mash-lab/bhandary/bind_prediction_expression/all_sra_samples_final/"+Run+"_1.fastq "
            cmd+=" -2 /work/LAS/mash-lab/bhandary/bind_prediction_expression/all_sra_samples_final/"+Run+"_2.fastq "
            cmd+=" -o /work/LAS/mash-lab/bhandary/bind_prediction_expression/salmon_quant/"+Run+"_salmon "
            cmd+=" 2> "+"/work/LAS/mash-lab/bhandary/old_analysis_regulon_prediction/top_25_SRR/"+Run+"_salmon.error "
            #print (cmd)
            os.system(cmd)
            
        #os.system("rm -rf /work/LAS/mash-lab/bhandary/old_analysis_regulon_prediction/open_reading_frame/"+Run+"_STAR*")
        #os.system("rm "+"/work/LAS/mash-lab/bhandary/old_analysis_regulon_prediction/open_reading_frame/"+Run+"_*fastq ")
        i+=5
    
if __name__ == "__main__":
    main()
