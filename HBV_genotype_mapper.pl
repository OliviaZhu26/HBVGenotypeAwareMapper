use warnings;
use strict;
##Author: ZHU O. Yuan 2017
##Script name: HBV_genotype_mapper.pl
##Hepatitis B mapper mapper launch script called upon by mapHBV.sh (main function is to simplify and modify filenames)
##Usage: perl genotype_mapper.pl genotype_caller.out REF_PATH
##Calls upon: HBV_genotype_mapper.sh

my%reference=("\|ref_HBVA\|"=>"GenotypeA.fasta","\|ref_HBVB_non-ambiguous\|"=>"GenotypeB_non-ambiguous.fasta","\|ref_HBVC\|"=>"GenotypeC.fasta","\|ref_HBVD\|"=>"GenotypeD.fasta","\|ref_HBVE\|"=>"GenotypeE.fasta","\|ref_HBVF\|"=>"GenotypeF.fasta","\|ref_HBVG\|"=>"GenotypeG.fasta","\|ref_HBVH\|"=>"GenotypeH.fasta");
my%HEAD=("GenotypeA.fasta"=>"A","GenotypeB_non-ambiguous.fasta"=>"B","GenotypeC.fasta"=>"C","GenotypeD.fasta"=>"D","GenotypeE.fasta"=>"E","GenotypeF.fasta"=>"F","GenotypeG.fasta"=>"G","GenotypeH.fasta"=>"H");
my%submitted=();

open (TXT, "$ARGV[0]") or die;
while (my $line = <TXT>) {
    chomp $line;
    my@data=split('\t',$line);
    if(($data[0] =~ /.fastq.gz/)&&($data[0] =~ /R1/)){
    	#simplifying the naming system of fastq files
	my@prename=split('-',$data[0]);
	my@name=split('_',$prename[0]);
	my$header=$name[0]."_".$HEAD{$reference{$data[1]}};
	#modify the above 3 lines if incompatible
	my$file1=$data[0];
	$data[0] =~ s/R1/R2/g;
	my$file2=$data[0];
	my$filebam=$header."\.bam";
	if(!defined $submitted{$header}){
	    if(-e $filebam){}
	    else{
		system("HBV_genotype_mapper.sh $reference{$data[1]} $file1 $file2 $header $ARGV[1]");
		print "HBV_genotype_mapper.sh $reference{$data[1]} $file1 $file2 $header $ARGV[1]";
		$submitted{$header}=1;
	    }
	}
    }
}close (TXT);
