from pyrpipe.sra import SRA
from pyrpipe.mapping import Hisat2
from class2_pyrpipe import Class2

run='SRR971778'
wd='testout'

Hisat2._valid_args=None
hisat2=Hisat2(index='reference_data/TAIR10_chr_all')#,**{'--dta-cufflinks':''})

class2=Class2()

SRA(run,wd).align(hisat2).assemble(class2)


