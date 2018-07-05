use warnings;
use strict;
#perl genotype_mapper.pl genotype_caller.out

my%reference=("\|ref_HBVA\|"=>"GenotypeA.fasta","\|ref_HBVB_non-ambiguous\|"=>"GenotypeB_non-ambiguous.fasta","\|ref_HBVC\|"=>"GenotypeC.fasta","\|ref_HBVD\|"=>"GenotypeD.fasta","\|ref_HBVE\|"=>"GenotypeE.fasta","\|ref_HBVF\|"=>"GenotypeF.fasta","\|ref_HBVG\|"=>"GenotypeG.fasta","\|ref_HBVH\|"=>"GenotypeH.fasta");
my%HEAD=("GenotypeA.fasta"=>"A","GenotypeB_non-ambiguous.fasta"=>"B","GenotypeC.fasta"=>"C","GenotypeD.fasta"=>"D","GenotypeE.fasta"=>"E","GenotypeF.fasta"=>"F","GenotypeG.fasta"=>"G","GenotypeH.fasta"=>"H");
my%submitted=();
#open(NOUT, '>>', $ARGV[2]);
print "OK\n";

open (SAM, "$ARGV[0]") or die;
while (my $line = <SAM>) {
    chomp $line;
    my@data=split('\t',$line);
    if(($data[0] =~ /.fastq.gz/)&&($data[0] =~ /R1/)){
	my@prename=split('-',$data[0]);
	my@name=split('_',$prename[0]);
	my$header=$name[0]."_".$HEAD{$reference{$data[1]}};
	my$file1=$data[0];
	$data[0] =~ s/R1/R2/g;
	my$file2=$data[0];
	my$filebam=$header."\.bam";
	#print "$data[1]\n";
	if(!defined $submitted{$header}){
	    if(-e $filebam){}
	    else{
		#system("bash genotype_mapper.sh $reference{$data[1]} $file1 $file2 $header");
		system("qsub -pe OpenMP 8 -l mem_free=32G,h_rt=48:00:00 -cwd -V -b y HBV_genotype_mapper.sh $reference{$data[1]} $file1 $file2 $header");
		print "HBV_genotype_mapper.sh $reference{$data[1]} $file1 $file2 $header";
		#system("HBV_genotype_mapper.sh $reference{$data[1]} $file1 $file2 $header");
		$submitted{$header}=1;
	    }
	}
    }
}close (SAM);
