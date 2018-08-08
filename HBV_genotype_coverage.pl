use warnings;
use strict;

##Author: ZHU O. Yuan 2017
##Script name: HBV_genotype_coverage.pl
##Coverage plot generating script called upon by HBV_genotype_mapper.sh
##Usage: perl Plot_coverage.pl AHB001_B path_to_vcf
##Calls: Rscript HBV_genotype_coverage.R

my$ID=$ARGV[0];#sample ID
my$MEAN=0; #average coverage
my$COV=$ARGV[0].".sorted.grouped.realign.coverage"; #coverage file
my$AVECOV=$ARGV[0].".sorted.grouped.realign.coverage.sample_summary"; #coverage summary file
my$VCF=$ARGV[1].$ARGV[0].".sorted.grouped.realign.recal.lofreq.vcf"; #vcf file
my$Rout=$ARGV[0].".sorted.grouped.realign.recal.lofreq.coverage.pdf"; #out pdf

#calculates average coverage across genome for input into R script
open (SAM, "$AVECOV") or die; 
while (my $line = <SAM>) {
    chomp $line;
    my@data=split('\t',$line);
    if($data[0] eq $ID){$MEAN=$data[2];}
}close (SAM);

#calls R script to generate coverage plot
system("Rscript HBV_genotype_coverage.R $ID $MEAN $COV $VCF $Rout");
