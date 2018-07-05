use warnings;
use strict;
#perl Plot_coverage.pl AHB001_B path_to_vcf

my$ID=$ARGV[0];#sample ID
my$MEAN=0; #average coverage
my$COV=$ARGV[0].".sorted.grouped.realign.coverage"; #coverage file
my$AVECOV=$ARGV[0].".sorted.grouped.realign.coverage.sample_summary"; #coverage summary file
my$VCF=$ARGV[1].$ARGV[0].".sorted.grouped.realign.recal.lofreq.vcf"; #vcf file
my$Rout=$ARGV[0].".sorted.grouped.realign.recal.lofreq.coverage.pdf"; #out pdf
#open(NOUT, '>>', $ARGV[2]);

open (SAM, "$AVECOV") or die; 
while (my $line = <SAM>) {
    chomp $line;
    my@data=split('\t',$line);
    if($data[0] eq $ID){$MEAN=$data[2];}
}close (SAM);

system("Rscript HBV_genotype_coverage.R $ID $MEAN $COV $VCF $Rout");
