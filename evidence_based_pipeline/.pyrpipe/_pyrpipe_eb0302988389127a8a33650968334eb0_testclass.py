from pyrpipe.sra import SRA
from pyrpipe.mapping import Hisat2
from class2_pyrpipe import Class2

run='SRR976159'
wd='testout'

hisat2=Hisat2(index='reference_data/TAIR10_chr_all')

class2=Class2()

SRA(run,wd).align(hisat2).assemble()


