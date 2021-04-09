"""
This module implements class2 as a pyrpipe assembler class
"""
from pyrpipe.assembly import Assembly
from pyrpipe import pyrpipe_utils as pu
import os
from pyrpipe import _dryrun

class Class2(Assembly):
    """This class represents Stringtie program for transcript assembly.
        
        Parameters
        ----------
        
        threads: int
            number of threads
        guide: str
            Reference annotation gtf/gff to use as guide
            
        """
    def __init__(self,*args,threads=None,guide=None,**kwargs):
        super().__init__(*args,**kwargs)
        self._command='class2_wrapper'
        self._deps=['perl']
        self._param_yaml='class2.yaml'
        #self._valid_args=valid_args._args_STRINGTIE
        
        #resolve threads to use
        self.resolve_parameter("-p",threads,'8','_threads')
        

                         
    def perform_assembly(self,bam_file,out_dir=None,out_suffix="_class2",objectid="NA"):
        """Function to run class2 using a bam file.
                
        Parameters
        ----------
        
        bam_file: string
            path to the bam file
        out_dir: string
            Path to out file
        out_suffix: string
            Suffix for the output gtf file
        objectid: str
            Provide an id to attach with this command e.g. the SRR accession. This is useful for debugging, benchmarking and reports.
        :return: Returns the path to output GTF file
        :rtype: string
        """
        
        #create path to output file
        fname=pu.get_file_basename(bam_file)
        
        if not out_dir:
            out_dir=pu.get_file_directory(bam_file)
        
        if not pu.check_paths_exist(out_dir):
            pu.mkdir(out_dir)
            
        out_gtf_file=os.path.join(out_dir,fname+out_suffix+".gtf")

        #Add output file name and input bam
        internal_args=('--clean',)
        internal_kwargs={"-a":bam_file,"-o":out_gtf_file}
        #add positional args
        internal_kwargs['--']=internal_args

        #call stringtie
        status=self.run(None,objectid=objectid,target=out_gtf_file,**internal_kwargs)
        
        if status:
            #check if sam file is present in the location directory of sraOb
            if not pu.check_files_exist(out_gtf_file) and not _dryrun:
                return ""
            return out_gtf_file
        
        return ""
